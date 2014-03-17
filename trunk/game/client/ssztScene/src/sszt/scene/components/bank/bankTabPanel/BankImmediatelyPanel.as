package sszt.scene.components.bank.bankTabPanel
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.activity.ExchangeSilverMoneySocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MYuanbaoAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class BankImmediatelyPanel extends MSprite  implements IBankTabPanel
	{
		public static const PANEL_WIDTH:int = 601;
		public static const PANEL_HEIGHT:int = 362;
		
		private var _bg:IMovieWrapper;
		private var _bgImg:Bitmap;
		private var _picPath:String;
		
		private var _btn1:MCacheAssetBtn1;
		private var _btn2:MCacheAssetBtn1;
		private var _btn3:MCacheAssetBtn1;
		
		public function BankImmediatelyPanel(mediator:SceneMediator)
		{
//			super(new MCacheTitle1("",new Bitmap(new TitleExchangeAsset())),true,-1,true,true);
			initialView();
			initEvent();
		}
		
		private function initialView():void
		{
//			setContentSize(PANEL_WIDTH,PANEL_HEIGHT);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(3,3,582,335)),
			]);
			addChild(_bg as DisplayObject);
			
			_bgImg = new Bitmap();
			_bgImg.x = _bgImg.y = 4;
			addChild(_bgImg);
			
			_btn1 = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.scene.exchange"));
			_btn1.move(263,169);
			addChild(_btn1);
			_btn1.enabled = !GlobalData.selfPlayer.getExchangeSilverMoneyTypeState(1);
			
			_btn2 = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.scene.exchange"));
			_btn2.move(103,290);
			addChild(_btn2);
			_btn2.enabled = !GlobalData.selfPlayer.getExchangeSilverMoneyTypeState(2);
			
			_btn3 = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.scene.exchange"));
			_btn3.move(423,290);
			addChild(_btn3);
			_btn3.enabled = !GlobalData.selfPlayer.getExchangeSilverMoneyTypeState(3);
			
			_picPath = GlobalAPI.pathManager.getBannerPath("exchangeSilver1.jpg");
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
			
		}
		private function loadAvatarComplete(data:BitmapData):void
		{
			_bgImg.bitmapData = data;
			_bgImg.width = 580;
			_bgImg.height = 333;
		}
		private function initEvent():void
		{
			_btn1.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_btn2.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_btn3.addEventListener(MouseEvent.CLICK,btnClickHandler);
//			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_EXCHANGE_VIEW, exchangeResultHandler)
		}
		
		private function removeEvent():void
		{
			_btn1.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_btn2.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_btn3.removeEventListener(MouseEvent.CLICK,btnClickHandler);
//			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.SHOW_EXCHANGE_VIEW, exchangeResultHandler)
		}
		
		
		private function exchangeResultHandler(e:Event):void
		{
			_btn1.enabled = !GlobalData.selfPlayer.getExchangeSilverMoneyTypeState(1);
			_btn2.enabled = !GlobalData.selfPlayer.getExchangeSilverMoneyTypeState(2);
			_btn3.enabled = !GlobalData.selfPlayer.getExchangeSilverMoneyTypeState(3);
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			var btn:MCacheAssetBtn1 = evt.currentTarget as MCacheAssetBtn1;
			var type:int;
			var limitYuanbaoNum:int;
			switch(btn)
			{
				case _btn1 :
					type = 1;
					limitYuanbaoNum = 88;
					break;
				case _btn2 :
					type = 2;
					limitYuanbaoNum = 288;
					break;
				case _btn3 :
					type = 3;
					limitYuanbaoNum = 588;
					break;
			}
			if(GlobalData.selfPlayer.userMoney.yuanBao < limitYuanbaoNum)
			{
				MAlert.show(LanguageManager.getWord("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,chargeAlertHandler);
				function chargeAlertHandler(evt:CloseEvent):void
				{
					if(evt.detail == MAlert.OK)
					{
						JSUtils.gotoFill();
					}
				}
				return;
			}
			MYuanbaoAlert.show(LanguageManager.getWord("ssztl.activity.exchangeSilverMoneyAlert",limitYuanbaoNum), LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null,confirmMAlertHandler);
			
			function confirmMAlertHandler(evt:CloseEvent):void
			{
				if(evt.detail == MYuanbaoAlert.OK)
				{
					ExchangeSilverMoneySocketHandler.send(type);
				}
			}
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		public function show():void
		{
//			initialData(null);
//			this._pageView.setPageFieldValue();
		}
//		private function dragDownHandler(evt:MouseEvent):void
//		{
//			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - PANEL_WIDTH,parent.stage.stageHeight - PANEL_HEIGHT));
//		}
//		
//		private function dragUpHandler(evt:MouseEvent):void
//		{
//			stopDrag();
//		}
		
//		private function sizeChangeHandler(evt:CommonModuleEvent):void
//		{
//			move(Math.round((CommonConfig.GAME_WIDTH - PANEL_WIDTH)/2),Math.round((CommonConfig.GAME_HEIGHT - PANEL_HEIGHT)/2));
//		}
//		
		override public function dispose():void
		{
			removeEvent();
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
			_bgImg = null;
			super.dispose();
		}
	}
}