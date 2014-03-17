package sszt.store.component
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Mouse;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.store.datas.AuctionItem;
	import sszt.store.mediator.StoreMediator;
	
	public class AuctionPanel extends MPanel
	{
		private var _mediator:StoreMediator;
		private var _bg:IMovieWrapper;
		private var _okBtn:MCacheAsset1Btn;
		private var _cancelBtn:MCacheAsset1Btn;
		private var _input:TextField;
		private var _auctionItem:AuctionItem;
		
		public function AuctionPanel(mediator:StoreMediator,auctionItem:AuctionItem)
		{
			_mediator = mediator;
			_auctionItem = auctionItem;
			super(new MCacheTitle1(LanguageManager.getWord("ssztl.common.alertTitle")),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(278,174);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,278,174)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(6,5,267,120)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(67,66,184,19))
				]);
			addContent(_bg as DisplayObject);
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(28,31,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.store.inputPrice"),MAssetLabel.LABELTYPE1)));
			var str:String = "";

			if(_auctionItem.type == 1) str = LanguageManager.getWord("ssztl.common.yuanBao2") + "：";
			else str =  LanguageManager.getWord("ssztl.common.copper2") + "：";
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(29,68,40,16),new MAssetLabel(str,MAssetLabel.LABELTYPE2)));
			
			_input = new TextField();
			_input.type = TextFieldType.INPUT;
			_input.x = 67;
			_input.y = 66;
			_input.width = 184;
			_input.height = 19;
			addContent(_input);
			var t:TextFormat = new TextFormat("",12,0xffffff,null,null,null,null,null,null,null,null,null,TextFormatAlign.CENTER);
			_input.defaultTextFormat = t;
			_input.setTextFormat(t);
			
			_okBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.sure"));
			_okBtn.move(31,134);
			addContent(_okBtn);
			
			_cancelBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.cannel"));
			_cancelBtn.move(180,134);
			addContent(_cancelBtn);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_okBtn.addEventListener(MouseEvent.CLICK,okClickHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,cancelClickHandler);
		}
		
		private function removeEvent():void
		{
			_okBtn.removeEventListener(MouseEvent.CLICK,okClickHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,cancelClickHandler);
		}
		
		private function okClickHandler(evt:MouseEvent):void
		{
			var price:int = int(_input.text);
			if(price <= _auctionItem.highPrice)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.store.lowerMaxPrice"));
				return;
			}
			if(_auctionItem.type == 1 && GlobalData.selfPlayer.userMoney.yuanBao < price)
			{
				//MAlert.show(LanguageManager.getWord("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,closeHandler);
				QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnough'));
				return;
				function closeHandler(evt:CloseEvent):void
				{
					if(evt.detail == MAlert.YES)
					{
						JSUtils.gotoFill();
					}
				}
			}
			if(_auctionItem.type == 2 && GlobalData.selfPlayer.userMoney.copper < price)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough2"));
				return;
			}
//			ShopAuctionSocketHandler.send(_auctionItem.auctionId,price);
			dispose();
		}
		
		private function cancelClickHandler(evt:MouseEvent):void
		{
			dispose();
		}
		
		override public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_okBtn)
			{
				_okBtn.dispose();
				_okBtn = null;
			}
			if(_cancelBtn)
			{
				_cancelBtn.dispose();
				_cancelBtn = null;
			}
			_input = null;
			_auctionItem = null;
			super.dispose();
		}
	}
}