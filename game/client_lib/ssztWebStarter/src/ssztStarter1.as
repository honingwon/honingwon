package
{
	import com.adobe.crypto.MD5;
	import com.demonsters.debugger.MonsterDebugger;
	
	import fl.controls.ComboBox;
	import fl.controls.TextInput;
	import fl.managers.StyleManager;
	
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.setInterval;
	
	import net.hires.debug.Stats;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.utils.LineUtils;
	import sszt.core.view.timerEffect.TimerEffect;
	import sszt.ui.UIManager;
	
	[SWF(backgroundColor=6699051,frameRate=25,width=1200,height=600)]
	public class ssztStarter1 extends Sprite
	{
		public var backgroundColor:uint = 16677215;
		private var _nameInput:TextField;
		private var _portInput:TextField;
		private var _ipInput:TextField;
		private var _isYellowVipInput:TextField;
		private var _isYellowYearVipInput:TextField;
		private var _yellowVipLevelInput:TextField;
		private var _isYellowHighVipInput:TextField;
		public function ssztStarter1()
		{
			
			super();
			MonsterDebugger.initialize(this);
			stage.stageFocusRect = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.HIGH;
			stage.align = StageAlign.TOP_LEFT;
			
			//			GlobalData.debugField.width = GlobalData.debugField.height = 100;
			//			GlobalData.debugField.y = 300;
			//			GlobalData.debugField.multiline = true;
			//			addChild(GlobalData.debugField);			
			//			调试输入
			var _nameInput:TextField = new TextField();
			_nameInput.type = TextFieldType.INPUT; 
			_nameInput.border = true;
			_nameInput.text = "test";
			_nameInput.multiline = false;
			_nameInput.x = 450;
			_nameInput.y = 280;
			addChild(_nameInput);
			_ipInput = new TextField();
			_ipInput.type = TextFieldType.INPUT;
			_ipInput.border = true;
			_ipInput.x = 450;
			_ipInput.y = 220;
			_ipInput.text = "s22.app100722626.qqopenapp.com";
			_ipInput.height = 20;
			addChild(_ipInput);
			_portInput = new TextField();
			_portInput.type = TextFieldType.INPUT;
			_portInput.border = true;
			_portInput.x = 550;
			_portInput.y = 220;
			_portInput.text = "8001";
			_portInput.height = 20;
			addChild(_portInput);
			
			_isYellowVipInput = new TextField();
			_isYellowVipInput.type = TextFieldType.INPUT;
			_isYellowVipInput.border = true;
			_isYellowVipInput.width = 50
			_isYellowVipInput.x = 450;
			_isYellowVipInput.y = 250;
			_isYellowVipInput.text = "0";
			_isYellowVipInput.height = 20;
			addChild(_isYellowVipInput);
			
			_isYellowYearVipInput = new TextField();
			_isYellowYearVipInput.type = TextFieldType.INPUT;
			_isYellowYearVipInput.border = true;
			_isYellowYearVipInput.width = 50
			_isYellowYearVipInput.x = 500;
			_isYellowYearVipInput.y = 250;
			_isYellowYearVipInput.text = "0";
			_isYellowYearVipInput.height = 20;
			addChild(_isYellowYearVipInput);
			
			_yellowVipLevelInput = new TextField();
			_yellowVipLevelInput.type = TextFieldType.INPUT;
			_yellowVipLevelInput.border = true;
			_yellowVipLevelInput.width = 50
			_yellowVipLevelInput.x = 550;
			_yellowVipLevelInput.y = 250;
			_yellowVipLevelInput.text = "0";
			_yellowVipLevelInput.height = 20;
			addChild(_yellowVipLevelInput);
			
			_isYellowHighVipInput = new TextField();
			_isYellowHighVipInput.type = TextFieldType.INPUT;
			_isYellowHighVipInput.border = true;
			_isYellowHighVipInput.width = 50
			_isYellowHighVipInput.x = 600;
			_isYellowHighVipInput.y = 250;
			_isYellowHighVipInput.text = "0";
			_isYellowHighVipInput.height = 20;
			addChild(_isYellowHighVipInput);
			
			
			_nameInput.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			
			function keyUpHandler(evt:KeyboardEvent):void
			{
				if(evt.keyCode == Keyboard.ENTER)
				{
					_nameInput.removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
					var site:String = "sszt";
					var time:String = String(int(new Date().getTime() / 1000));
					var tick:String = time + "|" + _isYellowVipInput.text+ "|" + _isYellowYearVipInput.text+ "|" + _yellowVipLevelInput.text+ "|" + _isYellowHighVipInput.text+ "|" + "1";
					var server:int = 11;
					ssztPrepare(_nameInput.text, site,server,tick,_isYellowVipInput.text,_isYellowYearVipInput.text,_yellowVipLevelInput.text,_isYellowHighVipInput.text, MD5.hash(_nameInput.text + site +server+ tick + "qq-zone-7101545-911-cm"));
					_nameInput.parent.removeChild(_nameInput);
					_nameInput = null;
					_ipInput.parent.removeChild(_ipInput);
					_ipInput = null;
					_portInput.parent.removeChild(_portInput);
					_portInput = null;
					_isYellowVipInput.parent.removeChild(_isYellowVipInput);
					_isYellowVipInput = null;
					_isYellowYearVipInput.parent.removeChild(_isYellowYearVipInput);
					_isYellowYearVipInput = null;
					_yellowVipLevelInput.parent.removeChild(_yellowVipLevelInput);
					_yellowVipLevelInput = null;
					_isYellowHighVipInput.parent.removeChild(_isYellowHighVipInput);
					_isYellowHighVipInput = null;
				}
			}
			
			var t:Declear = new Declear();
			
			//			var p:Array = LineUtils.checkPath([new Point(500,500),new Point(903,47)],new Point(600,380));
			//			trace(p);
			//			p = LineUtils.checkPath([new Point(500,500),new Point(903,47)],new Point(780,164));
			//			trace(p);
			//			p = LineUtils.checkPath([new Point(500,500),new Point(903,47)],new Point(893,52));
			//			trace(p);
		}
		
		private function ssztPrepare(user:String,site:String,serverid:int,tick:String,isYellowVipInput:String,isYellowYearVipInput:String,yellowVipLevelInput:String,isYellowHighVipInput:String,sign:String):void
		{
			var t:SsztPrepare = new SsztPrepare(user,site,serverid,tick,sign,"1","","","",0,"",_ipInput.text,int(_portInput.text),"0",int(isYellowVipInput),int(isYellowYearVipInput),int(yellowVipLevelInput),int(isYellowHighVipInput),prepareComplete);
			t.setup(this);
		}
		
		private function prepareComplete(param:Object):void
		{
			SocketProxy.close();
			var t:ssztGame = new ssztGame();
			t.preSetup(param);
			addChild(t);
			t.setup();
			//			addChild(GlobalData.debugField);
			var s:Stats = new Stats();
			s.y = 300;
			addChild(s);
		}
		
		private function declear():void
		{
		}
	}
}