package sszt.club.components.clubMain.pop
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.club.datas.detailInfo.ClubDetailInfo;
	import sszt.club.datas.deviceInfo.ClubDeviceInfo;
	import sszt.club.events.ClubDeviceUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubUpdateDeviceInfoSocketHandler;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class ClubDeviceManagePanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:ClubMediator;
		private var _btn1:MCacheAsset3Btn;
		private var _btn2:MCacheAsset1Btn;
		private var _btn3:MCacheAsset1Btn;
		private var _shop1:TextField;
		private var _shop2:TextField;
		private var _shop3:TextField;
		private var _shop4:TextField;
		private var _shop5:TextField;
		private var _furnace:TextField;
		
		public function ClubDeviceManagePanel(mediator:ClubMediator)
		{
			_mediator = mediator;
//			super(new MCacheTitle1("",new Bitmap(new DeviceTitleAsset())),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(271,374);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,271,374)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(5,5,262,284)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(65,52,99,19)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(65,86,99,19)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(65,120,99,19)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(65,154,99,19)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(65,188,99,19)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(65,249,99,19))
				]);
			addContent(_bg as DisplayObject);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(30,31,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubName2") + "：",MAssetLabel.LABELTYPE2)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(30,223,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.clubFurnace2") + "：",MAssetLabel.LABELTYPE2)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(37,53,22,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.level1"),MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(37,87,22,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.level2"),MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(37,121,22,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.level3"),MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(37,155,22,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.level4"),MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(37,189,22,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.level5"),MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(169,53,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.selfAllContribute"),MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(169,87,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.selfAllContribute"),MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(169,121,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.selfAllContribute"),MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(169,155,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.selfAllContribute"),MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(169,189,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.selfAllContribute"),MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(169,250,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.selfAllContribute"),MAssetLabel.LABELTYPE1)));
			//			
			
			var format:TextFormat = new TextFormat();
			format.font = LanguageManager.getWord("ssztl.common.wordType");
			format.color = 0xffffff;
			format.size = 12;
			format.leading = 1;
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.club.clubContributePrompt"),[format,null]);
			label1.move(9,293);
			label1.multiline = label1.wordWrap = true;
			addContent(label1);
			
			_shop1 = new TextField();
			_shop1.textColor = 0xffffff;
			_shop1.type = TextFieldType.INPUT;
			_shop1.width = 99;
			_shop1.height = 19;
			_shop1.x = 65;
			_shop1.y = 52;
			addContent(_shop1);
			_shop2 = new TextField();
			_shop2.textColor = 0xffffff;
			_shop2.type = TextFieldType.INPUT;
			_shop2.width = 99;
			_shop2.height = 19;
			_shop2.x = 65;
			_shop2.y = 86;
			addContent(_shop2);
			_shop3 = new TextField();
			_shop3.textColor = 0xffffff;
			_shop3.type = TextFieldType.INPUT;
			_shop3.width = 99;
			_shop3.height = 19;
			_shop3.x = 65;
			_shop3.y = 120;
			addContent(_shop3);
			_shop4 = new TextField();
			_shop4.textColor = 0xffffff;
			_shop4.type = TextFieldType.INPUT;
			_shop4.width = 99;
			_shop4.height = 19;
			_shop4.x = 65;
			_shop4.y = 154;
			addContent(_shop4);
			_shop5 = new TextField();
			_shop5.textColor = 0xffffff;
			_shop5.type = TextFieldType.INPUT;
			_shop5.width = 99;
			_shop5.height = 19;
			_shop5.x = 65;
			_shop5.y = 188;
			addContent(_shop5);
			_furnace = new TextField();
			_furnace.textColor = 0xffffff;
			_furnace.type = TextFieldType.INPUT;
			_furnace.width = 99;
			_furnace.height = 19;
			_furnace.x = 65;
			_furnace.y = 249;
			addContent(_furnace);
			
			_btn1 = new MCacheAsset3Btn(2,LanguageManager.getWord("ssztl.club.iWantContribute"));
			_btn1.move(186,14);
			addContent(_btn1);
			_btn2 = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.sure"));
			_btn2.move(35,335);
			addContent(_btn2);
			_btn3 = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.cannel"));
			_btn3.move(171,335);
			addContent(_btn3);
			
			if(!ClubDutyType.getIsMaster(GlobalData.selfPlayer.clubDuty)) 
				_shop1.mouseEnabled = _shop2.mouseEnabled = _shop3.mouseEnabled = _shop4.mouseEnabled = _shop5.mouseEnabled = _furnace.mouseEnabled = false;
			initEvent();
			
			initData();
		}
		
		private function initEvent():void
		{
			_btn1.addEventListener(MouseEvent.CLICK,btn1ClickHandler);
			_btn2.addEventListener(MouseEvent.CLICK,btn2ClickHandler);
			_btn3.addEventListener(MouseEvent.CLICK,btn3ClickHandler);
			_mediator.clubInfo.deviceInfo.addEventListener(ClubDeviceUpdateEvent.DEVICE_UPDATE,updateHandler);
		}
		
		private function removeEvent():void
		{
			_btn1.removeEventListener(MouseEvent.CLICK,btn1ClickHandler);
			_btn2.removeEventListener(MouseEvent.CLICK,btn2ClickHandler);
			_btn3.removeEventListener(MouseEvent.CLICK,btn3ClickHandler);
			_mediator.clubInfo.deviceInfo.removeEventListener(ClubDeviceUpdateEvent.DEVICE_UPDATE,updateHandler);
		}
		
		private function updateHandler(evt:ClubDeviceUpdateEvent):void
		{
			initData();
		}
		
		private function initData():void
		{
			var info:ClubDeviceInfo = _mediator.clubInfo.deviceInfo;
			_shop1.text = info.shop1Exploit.toString();
			_shop2.text = info.shop2Exploit.toString();
			_shop3.text = info.shop3Exploit.toString();
			_shop4.text = info.shop4Exploit.toString();
			_shop5.text = info.shop5Exploit.toString();
			_furnace.text = info.furnaceExploit.toString();
		}
		
		private function btn1ClickHandler(evt:MouseEvent):void
		{
			_mediator.showNewContributePanel();
		}
		
		private function btn2ClickHandler(evt:MouseEvent):void
		{
			if(!ClubDutyType.getIsMaster(GlobalData.selfPlayer.clubDuty))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.noAlterQuanXian"));
				return;
			}
			ClubUpdateDeviceInfoSocketHandler.send(int(_shop1.text),int(_shop2.text),int(_shop3.text),int(_shop4.text),int(_shop5.text),int(_furnace.text))
		}
		
		private function btn3ClickHandler(evt:MouseEvent):void
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
			_btn1.dispose();
			_btn1 = null;
			_btn2.dispose();
			_btn2 = null;
			_btn3.dispose();
			_btn3 = null;
			_shop1 = null;
			_shop2 = null;
			_shop3 = null;
			_shop4 = null;
			_shop5 = null;
			_furnace = null;
			super.dispose();
		}
	}
}