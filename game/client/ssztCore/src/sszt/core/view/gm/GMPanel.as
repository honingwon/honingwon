package sszt.core.view.gm
{
	import fl.controls.RadioButton;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTextArea;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.gm.GMSendMessageSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class GMPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _closeBtn:MCacheAsset1Btn;
		private var _sendBtn:MCacheAsset1Btn;
		private var _titleLabel:TextField;
		private var _textArea:MTextArea;
//		private var _radioBtns:Vector.<RadioButton>;
		private var _radioBtns:Array;
		private static var instance:GMPanel;
		private var _gmQQ:MAssetLabel;
		private var _gameQQ:MAssetLabel;
		
		public function GMPanel()
		{
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("sszt.common.GMTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("sszt.common.GMTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(291,359);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,291,306)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(7,55,277,244)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(45,33,239,19))
				]);
			addContent(_bg as DisplayObject);

			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(7,35,40,16),new MAssetLabel(LanguageManager.getWord("ssztl.core.title"),MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(0,322,42,20),new MAssetLabel(LanguageManager.getWord("ssztl.core.serveQQ"),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(0,344,60,20),new MAssetLabel(GlobalData.GAME_NAME + LanguageManager.getWord("ssztl.core.qqQun"),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT)));
			
			_gmQQ = new MAssetLabel(GlobalData.QQ_SERVER,MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_gmQQ.move(45,322);
			addContent(_gmQQ);
			
			_gameQQ = new MAssetLabel(GlobalData.QQ_GRUOP,MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_gameQQ.move(80,344);
			addContent(_gameQQ);
			
			var labels:Array = [LanguageManager.getWord("ssztl.core.submitBug"),
				LanguageManager.getWord("ssztl.core.complaint"),
				LanguageManager.getWord("ssztl.core.gameSuggestion"),
				LanguageManager.getWord("ssztl.common.other")];
			
//			_radioBtns = new Vector.<RadioButton>();
			_radioBtns = [];
			for(var i:int = 0;i<labels.length;i++)
			{
				var radio:RadioButton = new RadioButton();
				radio.label = labels[i];
				radio.setSize(70,14);
				radio.move(12+i*70,12);
				_radioBtns.push(radio);
				addContent(radio);
			}
			_radioBtns[0].selected = true;
			
			_titleLabel = new TextField();
			_titleLabel.textColor = 0xffffff;
			_titleLabel.x = 46;
			_titleLabel.y = 34;
			_titleLabel.width = 239;
			_titleLabel.height = 19;
			_titleLabel.type = TextFieldType.INPUT;
			addContent(_titleLabel);
			
			_textArea = new MTextArea();
			_textArea.textField.textColor = 0xffffff;
			_textArea.setSize(281,244);
			_textArea.move(7,55);
			addContent(_textArea);
			
			_closeBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.close"));
			_closeBtn.move(156,313);
			addContent(_closeBtn);
			
			_sendBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.core.speak"));
			_sendBtn.move(228,313);
			addContent(_sendBtn);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_sendBtn.addEventListener(MouseEvent.CLICK,sendBtnClickHandler);
			_closeBtn.addEventListener(MouseEvent.CLICK,closeBtnClickHandler);
		}
		
		private function removeEvent():void
		{
			_sendBtn.removeEventListener(MouseEvent.CLICK,sendBtnClickHandler);
			_closeBtn.removeEventListener(MouseEvent.CLICK,closeBtnClickHandler);
		}
		
		private function sendBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var type:int = 0;
			if(_titleLabel.text == "")
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.inputTitle"));
				return ;
			}
			if(_textArea.text == "")
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.inputContent"));
				return ;
			}
			for(var i:int = 0;i<_radioBtns.length;i++)
			{
				if(_radioBtns[i].selected)
				{
					type = i + 1;
					break;
				}
			}
			GMSendMessageSocketHandler.sendMessage(type,_titleLabel.text,_textArea.text);
			dispose();
		}
		
		private function closeBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			dispose();
		}
		
		public static function getInstance():GMPanel
		{
			if(instance == null)
			{
				instance = new GMPanel();
			}
			return instance;
		}
		
		public function show():void
		{
			GlobalAPI.layerManager.addPanel(this);
		}
		
		override public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_closeBtn)
			{
				_closeBtn.dispose();
				_closeBtn = null;
			}
			if(_sendBtn)
			{
				_sendBtn.dispose();
				_sendBtn = null;
			}
			_titleLabel = null;
			if(_textArea)
			{
				_textArea.dispose();
				_textArea = null;
			}
			_radioBtns = null;
			instance = null;
			super.dispose();
		}
	}
}