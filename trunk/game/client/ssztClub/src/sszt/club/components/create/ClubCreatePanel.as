package sszt.club.components.create
{
	import fl.controls.RadioButton;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.club.mediators.ClubCreateMediator;
	import sszt.club.mediators.ClubMediator;
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.WordFilterUtils;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.club.ClubTitleCJAsset;
	
	public class ClubCreatePanel extends MPanel
	{
		private var _mediator:ClubCreateMediator;
		private var _bg:IMovieWrapper;
		private var _okBtn:MCacheAssetBtn1;
		private var _nameValueField:TextField;
		private var _declearField:TextField;
		private var _radioBtn1:RadioButton;
		private var _radioBtn2:RadioButton;
		
		public function ClubCreatePanel(mediator:ClubCreateMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1("",new Bitmap(new ClubTitleCJAsset())),true,-1);
//			super(new MCacheTitle1(LanguageManager.getWord("ssztl.club.createClub")),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(255,315);
			
			_bg = BackgroundUtils.setBackground([
//				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,3,249,302)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,2,255,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,202,255,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(28,31,199,24)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(28,75,199,65))
			]);
			addContent(_bg as DisplayObject);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(100,13,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubName")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(100,57,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.clubWord")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
//			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(24,166,124,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.createClubMethod"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			
			var label1:TextField = new TextField();
			label1.selectable = false;
			label1.defaultTextFormat = new TextFormat("SimSun",12,0xe4c68e,null,null,null,null,null,null,null,null,null,4);
			label1.text = LanguageManager.getWord("ssztl.club.jionClubPrompt");
			label1.wordWrap = true;
			label1.width = 225;
			label1.x = 16;
			label1.y = 213;
			addContent(label1);
			
			_nameValueField = new TextField();
			_nameValueField.defaultTextFormat = new TextFormat("SimSun",12,0xFFFCCC);
			_nameValueField.x = 32;
			_nameValueField.y = 35;
			_nameValueField.width = 190;
			_nameValueField.height = 20;
			_nameValueField.textColor = 0xffffff;
			_nameValueField.type = TextFieldType.INPUT;
			_nameValueField.maxChars = 14;
			addContent(_nameValueField);
			
			_declearField = new TextField();
			_declearField.defaultTextFormat = new TextFormat("SimSun",12,0xFFFCCC,null,null,null,null,null,null,null,null,null,4);
			_declearField.x = 32;
			_declearField.y = 80;
			_declearField.width = 190;
			_declearField.height = 60;
			_declearField.wordWrap = true;
			_declearField.textColor = 0xffffff;
			_declearField.type = TextFieldType.INPUT;
			_declearField.maxChars = 50;
			addContent(_declearField);
			
			_radioBtn1 = new RadioButton();
			_radioBtn1.label = LanguageManager.getWord("ssztl.club.createlevel2Club");
			_radioBtn1.setSize(190,18);
			_radioBtn1.move(32,150);
			addContent(_radioBtn1);
			_radioBtn1.selected = true;
			
			_radioBtn2 = new RadioButton();
			_radioBtn2.label = LanguageManager.getWord("ssztl.club.createlevel1Club");
			_radioBtn2.setSize(190,18);
			_radioBtn2.move(32,172);
			addContent(_radioBtn2);
			
			_okBtn = new MCacheAssetBtn1(0,4,LanguageManager.getWord("ssztl.club.create"));
			_okBtn.move(69,274);
			addContent(_okBtn);

			
			initEvent();
		}
		
		private function initEvent():void
		{
			_okBtn.addEventListener(MouseEvent.CLICK,okClickHandler);
		}
		
		private function removeEvent():void
		{
			_okBtn.removeEventListener(MouseEvent.CLICK,okClickHandler);
		}
		
		private function okClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(GlobalData.selfPlayer.clubId != 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.hasClub"));
			}
			else if(_nameValueField.text == "")
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.inputClubName"));
			}
			else if(GlobalData.selfPlayer.level < 30)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.levelLower30"));
			}
			else if(_radioBtn2.selected && GlobalData.selfPlayer.userMoney.copper < 250000)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.copperNotEnough"));
			}
			else if(_radioBtn1.selected && GlobalData.bagInfo.getItemById(CategoryType.CLUB_CREATE_ID).length == 0)
			{
				MAlert.show(LanguageManager.getWord("ssztl.club.clubLingNotEnough"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,alertHandler);
				function alertHandler(evt:CloseEvent):void
				{
					if(evt.detail == MAlert.OK)
					{
						BuyPanel.getInstance().show([CategoryType.CLUB_CREATE_ID],new ToStoreData(ShopID.QUICK_BUY));
					}
				}
			}
			else if(WordFilterUtils.checkLen(_nameValueField.text) > 14)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.clubNameTooLong"));
			}
			else if(WordFilterUtils.checkNameAllow(_nameValueField.text) == false)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.clubNameIncludeillegal"));
			}
			else
			{
				_mediator.sendCreate(_nameValueField.text,_declearField.text,_radioBtn1.selected ? 1:2);
				dispose();
			}
		}
		private function cancelClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			dispose();
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
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
			_mediator = null;
		}
	}
}