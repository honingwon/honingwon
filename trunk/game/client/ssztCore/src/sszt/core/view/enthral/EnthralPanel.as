package sszt.core.view.enthral
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.enthral.EnthralSubmitSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class EnthralPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _submitBtn:MCacheAsset1Btn;
		private var _laterBtn:MCacheAsset1Btn;
		private var _nameInput:TextField;
		private var _idInput:TextField;
		private var _alertText:TextField;
		
		private static var instance:EnthralPanel;
		private var timer:Timer;
		
		public function EnthralPanel()
		{
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("sszt.common.EnthralTitle1Asset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("sszt.common.EnthralTitle1Asset") as Class)());
			}
			super(new MCacheTitle1("",title), true, -1);
		}
		
		public static function getInstance():EnthralPanel
		{
			if(instance == null)
			{
				instance = new EnthralPanel();
			}
			return instance;
		}
		
		public function show():void
		{
			if(parent) return;
			if(GlobalData.isEnthral == true) return;
//			_nameInput.text = "";
//			_idInput.text = "";
			GlobalAPI.layerManager.addPanel(this);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(589,348);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,589,348)),
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(7,7,575,294)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(18,257,554,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(76,268,146,22)),
				new BackgroundInfo(BackgroundType.BAR_6, new Rectangle(303,268,267,22)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(30,272,40,16),new MAssetLabel("姓名：",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(253,272,40,16),new MAssetLabel("身份证",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT))
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(30,272,40,16),new MAssetLabel(LanguageManager.getWord("ssztl.core.name"),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(253,272,40,16),new MAssetLabel(LanguageManager.getWord("ssztl.core.idNumber"),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT))
			]);
			addContent(_bg as DisplayObject);
			
			_submitBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.core.submitCheck"));
			_submitBtn.move(215,309);
			addContent(_submitBtn);
			
			_laterBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.core.fillInLater"));
			_laterBtn.move(306,309);
			addContent(_laterBtn);
			
			_nameInput = new TextField();
			_nameInput.textColor = 0xffffff;
			_nameInput.maxChars = 15;
			_nameInput.type = TextFieldType.INPUT;
			_nameInput.x = 77;
			_nameInput.y = 269;
			_nameInput.width = 146;
			_nameInput.height = 20;
			addContent(_nameInput);
			
			_idInput = new TextField();
			_idInput.restrict = "0123456789xX";
			_idInput.textColor = 0xffffff;
			_idInput.maxChars = 18;
			_idInput.type = TextFieldType.INPUT;
			_idInput.x = 304;
			_idInput.y = 269;
			_idInput.width = 267;
			_idInput.height = 20;
			addContent(_idInput);
			
			_alertText = new TextField();
			_alertText.x = 16;
			_alertText.y = 23;
			_alertText.wordWrap = true;
			_alertText.mouseEnabled = _alertText.mouseWheelEnabled = false;
			_alertText.width = 558;
			_alertText.height = 234;
			addContent(_alertText);	
			_alertText.htmlText = LanguageManager.getWord("ssztl.core.enthralExplain",GlobalData.GAME_NAME); 
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_submitBtn.addEventListener(MouseEvent.CLICK,submitClickHandler);
			_laterBtn.addEventListener(MouseEvent.CLICK,laterClickHandler);
		}
		
		private function removeEvent():void
		{
			_submitBtn.removeEventListener(MouseEvent.CLICK,submitClickHandler);
			_laterBtn.removeEventListener(MouseEvent.CLICK,laterClickHandler);
		}
		
		private function submitClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_nameInput.text == ""||_idInput.text == "")
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.nameMsgError"));
				return;
			}
			if(_idInput.text.length != 15 && _idInput.text.length != 18)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.nameMsgError"));
				return;
			}
			EnthralSubmitSocketHandler.sendSubmit(_nameInput.text,_idInput.text);
			dispose();
		}
		
		private function laterClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			dispose();
		}
		
		private function timerHandler(evt:TimerEvent):void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER,timerHandler);
			if(parent) return;
			EnthralInPanel.getInstance().show();
		}
		
		override public function dispose():void
		{
			if(parent) parent.removeChild(this);
			if(GlobalData.isEnthral == false)
			{
				timer = new Timer(1200000,1);
				timer.addEventListener(TimerEvent.TIMER,timerHandler);
				timer.start();
			}
		}
	}
}