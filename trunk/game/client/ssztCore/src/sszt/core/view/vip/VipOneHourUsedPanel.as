package sszt.core.view.vip
{
	import fl.controls.CheckBox;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToMountsData;
	import sszt.core.data.module.changeInfos.ToVipData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.bag.BagExtendSocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.core.utils.SetModuleUtils;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.BtnAssetClose;
	import ssztui.ui.WinTitleHintAsset;
	
	
	public class VipOneHourUsedPanel extends Sprite  implements ITick
	{
		private static var _instance:VipOneHourUsedPanel;
		
		private var _bg:IMovieWrapper;
		private var _content:MAssetLabel;
		private var _txtGet:MCacheAssetBtn1;
		private var _closeBtn:MAssetButton1;
		private var _canShow:Boolean = true;
//		private var _content2:MAssetLabel;
		
		public function VipOneHourUsedPanel()
		{
//			super(new MCacheTitle1("",new Bitmap(new WinTitleHintAsset())),true,-1,true,false);
//			move(CommonConfig.GAME_WIDTH - 325,CommonConfig.GAME_HEIGHT);
			init();
		}
		
		public static function getInstance():VipOneHourUsedPanel
		{
			if (_instance == null){
				_instance = new VipOneHourUsedPanel();
			};
			return (_instance);
		}
		
		public function show():void{
			if (!parent && _canShow)
			{
				_canShow = false;
//				GlobalAPI.layerManager.addPanel(this);
				GlobalAPI.layerManager.getPopLayer().addChild(this);
			};
			this.addEventListener(Event.ENTER_FRAME,addTickHandler);
			
		}
		
		private function addTickHandler(e:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME,addTickHandler);
			GlobalAPI.tickManager.addTick(this);
		}
		
		private function init():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_10, new Rectangle(0,0,301,115)),
//				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(101,82,40,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.nopromptToday"),MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT)),
			]);
			addChild(_bg as DisplayObject);
			
			var imageBtmp:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.PromptImageAsset"))
			{
				imageBtmp = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.PromptImageAsset") as Class)());
				imageBtmp.x = -20;
				imageBtmp.y = -36;
			}
			if(imageBtmp) addChild(imageBtmp);
			
			_closeBtn = new MAssetButton1(new BtnAssetClose());
			_closeBtn.move(275,4);
			addChild(_closeBtn);
			
			_content = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,'left');
			_content.setLabelType([new TextFormat("Microsoft YaHei",12,0xfffccc)]);
			_content.move(82,18);
			addChild(_content);
			_content.setHtmlValue(LanguageManager.getWord('ssztl.vip.vipOneHourUserd'));
			
//			_txtGet = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,"left");
//			_txtGet.move(94,72);
//			_txtGet.setHtmlValue("<a href=\'event:0\'><u>"+LanguageManager.getWord("ssztl.vip.getWelFare")+"</u></a>");
//			addChild(_txtGet);
//			_txtGet.mouseEnabled = true;
			
			_txtGet = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.vip.getWelFare"));
			_txtGet.move(146,75);
			addChild(_txtGet);
			
			this.x = CommonConfig.GAME_WIDTH - 325;
			this.y = CommonConfig.GAME_HEIGHT;
			
			show();
			initEvents();
		}
		
		private function initEvents():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
			_txtGet.addEventListener(MouseEvent.CLICK, getAward);
		}
		
		private function removeEvents():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_closeBtn.removeEventListener(MouseEvent.CLICK,closeHandler);
			_txtGet.removeEventListener(MouseEvent.CLICK, getAward);
		}
		
		private function getAward(e:Event):void
		{
			SetModuleUtils.addVip(new ToVipData(0));
			hide();
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			GlobalAPI.tickManager.removeTick(this);
			x = CommonConfig.GAME_WIDTH - 325;
			y = CommonConfig.GAME_HEIGHT - 210;
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(y <= CommonConfig.GAME_HEIGHT - 210)
			{
				GlobalAPI.tickManager.removeTick(this);
			}
			else
			{
				y -= 5;
			}
		}
		private function closeHandler(evt:MouseEvent):void
		{
			hide();	
		}
		public function hide():void
		{
			removeEvents();
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}