package sszt.core.view.enthral
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.constData.PlatType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.JSUtils;
	
	public class EnthralInPanel extends MPanel
	{
		private var _writeBtn:MCacheAsset1Btn;
		private var _youngBtn:MCacheAsset1Btn;
		private static var instance:EnthralInPanel;
		private var _message:TextField;
		private var _timer:Timer;
		
		public function EnthralInPanel()
		{
			super(new MCacheTitle1("",new Bitmap(AssetUtil.getAsset("mhsm.common.EnthralTitle2Asset",BitmapData) as BitmapData)),true,0.5,false);
		}
		
		public static function getInstance():EnthralInPanel
		{
			if(instance == null)
			{
				instance = new EnthralInPanel();
			}
			return instance;
		}
		
		public function show():void
		{
			if(parent) return;
			if(GlobalData.isEnthral) return;
			GlobalAPI.layerManager.addPanel(this);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(249,93);
			
			_message = new TextField();
			_message.mouseEnabled = _message.mouseWheelEnabled = false;
			_message.textColor = 0xffffff;
			_message.multiline = true;
			_message.wordWrap = true;
			_message.width = 220;
			_message.height = 50;
			_message.x = 10;
			_message.y = 10;
			_message.text = LanguageManager.getWord("ssztl.core.isWritePersonalMsg");
			addContent(_message);
			
			_writeBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.input"));
			_writeBtn.move(31,65);
			addContent(_writeBtn);
			
			_youngBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.underAge"));
			_youngBtn.move(130,65);
			addContent(_youngBtn);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_writeBtn.addEventListener(MouseEvent.CLICK,writeHandler);
			_youngBtn.addEventListener(MouseEvent.CLICK,youngHandler);
		}
		
		private function removeEvent():void
		{
			_writeBtn.removeEventListener(MouseEvent.CLICK,writeHandler);
			_youngBtn.removeEventListener(MouseEvent.CLICK,youngHandler);
		}
		
		private function writeHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
//			if(GlobalData.PLAT == PlatType.PLAT_BAIDU || GlobalData.PLAT == PlatType.PLAT_9377)
//			{
//				JSUtils.gotoPage(GlobalAPI.pathManager.getAdlsPath());
//			}
//			else
//			{
//				EnthralPanel.getInstance().show();
//			}
			dispose();
		}
		
		private function youngHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			MAlert.show(LanguageManager.getWord("ssztl.core.unpassEnthral"),LanguageManager.getWord("ssztl.common.alertTitle"));
			dispose();
			_timer = new Timer(1200000,1);
			_timer.addEventListener(TimerEvent.TIMER,timerHandler);
			_timer.start();
		}
		
		private function timerHandler(evt:TimerEvent):void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
			show();
		}
		
		override protected function draw():void
		{
			super.draw();
		}
		
		override public function dispose():void
		{
			if(parent) parent.removeChild(this);
		}
	}
}