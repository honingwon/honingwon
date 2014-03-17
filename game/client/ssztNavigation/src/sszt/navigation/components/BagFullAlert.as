package sszt.navigation.components
{
	import fl.controls.CheckBox;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
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
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.WinTitleHintAsset;

	
	public class BagFullAlert extends MPanel  implements ITick
	{
		private static var _instance:BagFullAlert;
		private var _tipBtns:Array;
		private var _sellBtn:MCacheAssetBtn1;
		private var _vipBtn:MCacheAssetBtn1;
		private var _feedBtn:MCacheAssetBtn1;
		private var _addBtn:MCacheAssetBtn1;
		private var _contentTxt:TextField;
		private var _bg:IMovieWrapper;
		private var _checkBox:CheckBox;
		
		public function BagFullAlert()
		{
			super(new MCacheTitle1("",new Bitmap(new WinTitleHintAsset())),true,-1,true,false);
			move(CommonConfig.GAME_WIDTH - 325,CommonConfig.GAME_HEIGHT);
		}
		
		public static function getInstance():BagFullAlert{
			if (_instance == null){
				_instance = new (BagFullAlert)();
			};
			return (_instance);
		}
		
		public function show():void{
			if(_checkBox.selected) return;
			if (!(parent)){
				GlobalAPI.layerManager.addPanel(this);
			};
			var t:BagFullAlert = this;
			addEventListener(Event.ENTER_FRAME,function():void{
				GlobalAPI.tickManager.addTick( t);
			});
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(305,158);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(11,7,283,108)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(128,90,40,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.nopromptToday"),MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT)),
			]);
			addContent(_bg as DisplayObject);
			
			_contentTxt = new TextField();
			_contentTxt.width = 283;
			_contentTxt.x = 11;
			_contentTxt.y = 17;
			_contentTxt.wordWrap = true;
			_contentTxt.mouseEnabled = _contentTxt.mouseWheelEnabled = false;
			var format:TextFormat = new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,TextFormatAlign.CENTER,null,null,null,4);
			_contentTxt.setTextFormat(format);
			_contentTxt.defaultTextFormat = format;
			addContent(_contentTxt);
			_contentTxt.htmlText = LanguageManager.getWord("ssztl.navigation.bagAlert")
			
			_checkBox = new CheckBox();
			_checkBox.x = 108;
			_checkBox.y = 100;
			addContent(_checkBox);
			
			_vipBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.navigation.bagVip"));
			_vipBtn.move(11,120);
//			addContent(_vipBtn);
			
			_feedBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.navigation.bagFeed"));
			_feedBtn.move(59,120);
			addContent(_feedBtn);
			GlobalData.selfPlayer.mountAvoid==true?_feedBtn.enabled=true:_feedBtn.enabled=false;
			
			_sellBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.navigation.bagSell"));
			_sellBtn.move(130,120);
			addContent(_sellBtn);
			
			_addBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.navigation.bagAdd"));
			_addBtn.move(201,120);
			addContent(_addBtn);
			_tipBtns = [_vipBtn,_feedBtn,_sellBtn,_addBtn];
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_vipBtn.addEventListener(MouseEvent.CLICK,vipHandler);
			_feedBtn.addEventListener(MouseEvent.CLICK,feedHandler);
			_sellBtn.addEventListener(MouseEvent.CLICK,sellHandler);
			_addBtn.addEventListener(MouseEvent.CLICK,addHandler);
			_checkBox.addEventListener(MouseEvent.CLICK,closeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		private function removeEvent():void
		{
			_vipBtn.removeEventListener(MouseEvent.CLICK,vipHandler);
			_feedBtn.removeEventListener(MouseEvent.CLICK,feedHandler);
			_sellBtn.removeEventListener(MouseEvent.CLICK,sellHandler);
			_addBtn.removeEventListener(MouseEvent.CLICK,addHandler);
			_checkBox.removeEventListener(MouseEvent.CLICK,closeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			GlobalAPI.tickManager.removeTick(this);
			x = CommonConfig.GAME_WIDTH - 305;
			y = CommonConfig.GAME_HEIGHT - 158;
		}
		private function closeHandler(e:Event):void
		{
			if(this.parent)this.parent.removeChild(this)
		}
		//购买vip
		private function vipHandler(evt:MouseEvent):void
		{	
			dispose();
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			SetModuleUtils.addVip(new ToVipData(1));
		}
		//喂养
		private function feedHandler(evt:MouseEvent):void
		{	
			dispose();
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			SetModuleUtils.addMounts(new ToMountsData());
			SetModuleUtils.addMounts(new ToMountsData(0,1,0,0));
		}
		//出售
		private function sellHandler(evt:MouseEvent):void
		{	
			dispose();
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			SetModuleUtils.addBag(GlobalAPI.layerManager.getTopPanelRec());
			SetModuleUtils.addBagSell();
		}
		//增加格子
		private function addHandler(evt:MouseEvent):void
		{	
			dispose();
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			SetModuleUtils.addBag(GlobalAPI.layerManager.getTopPanelRec());
			MAlert.show(LanguageManager.getWord("ssztl.bag.BagExtendAlert",48),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,bagExtendCloseHandler);
		}
		
		
		private function bagExtendCloseHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.YES)
			{
				if(GlobalData.selfPlayer.userMoney.yuanBao<48)
				{
					//MAlert.show(LanguageManager.getWord	("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,buyHandler);
					QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnough'));
					return;
				}
				
				BagExtendSocketHandler.sendExtend(1);
			}
		}
		private function buyHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				JSUtils.gotoFill();
			}
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
		
		override public function dispose():void
		{
			validate();
			removeEvent();
			if(_vipBtn)
			{
				_vipBtn.dispose();
				_vipBtn = null;
			}
			if(_feedBtn)
			{
				_feedBtn.dispose();
				_feedBtn = null;
			}
			if(_sellBtn)
			{
				_sellBtn.dispose();
				_sellBtn = null;
			}
			if(_addBtn)
			{
				_addBtn.dispose()
				_addBtn = null;
			}
			_contentTxt = null;
			_instance = null;
			super.dispose();
		}
		
	}
}