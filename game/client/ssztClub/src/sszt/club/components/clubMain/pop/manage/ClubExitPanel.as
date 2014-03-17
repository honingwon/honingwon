package sszt.club.components.clubMain.pop.manage
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubExitSocketHandler;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.club.ClubTitleAsset;
	
	public class ClubExitPanel extends MPanel
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _okBtn:MCacheAssetBtn1,_cancelBtn:MCacheAssetBtn1;
		private var _textfield:TextField;
		
		public function ClubExitPanel(mediator:ClubMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1("",new Bitmap(new ClubTitleAsset())),true,-1);
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			setContentSize(286,130);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(12,3,262,81)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(111,47,125,22)),
			]);
			addContent(_bg as DisplayObject);
			
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.club.carefulExitClub"),[new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),14,0xFFFFFF),new GlowFilter(0x1D250E,1,4,4,4.5)]);
			label1.move(28,22);
			addContent(label1);
			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.club.inputCharacter"),MAssetLabel.LABEL_TYPE_TAG);
			label2.move(50,51);
			addContent(label2);
			
			_okBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.sure"));
			_okBtn.move(79,90);
			addContent(_okBtn);
			_cancelBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.cannel"));
			_cancelBtn.move(144,90);
			addContent(_cancelBtn);
			
			_textfield = new TextField();
			_textfield.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
			_textfield.width = 144;
			_textfield.height = 20;
			_textfield.x = 115;
			_textfield.y = 51;
			_textfield.maxChars = 10;
			_textfield.type = TextFieldType.INPUT;
			_textfield.multiline = false;
			addContent(_textfield);
		}
		
		private function initEvent():void
		{
			_okBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function removeEvent():void
		{
			_okBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			switch(e.currentTarget)
			{
				case _okBtn:
					if(_textfield.text == "" || _textfield.text != "exit")
					{
						MAlert.show(LanguageManager.getWord("ssztl.club.exitClubFail"),LanguageManager.getWord("ssztl.common.alertTitle"));
						return;
					}
					ClubExitSocketHandler.send();
					dispose();
					break;
				case _cancelBtn:
					dispose();
					break;
			}
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
			if(_cancelBtn)
			{
				_cancelBtn.dispose();
				_cancelBtn = null;
			}
			_mediator = null;
		}
	}
}