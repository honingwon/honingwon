package sszt.ui.container
{
	import fl.controls.Button;
	import fl.managers.StyleManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import sszt.ui.UIManager;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class MTimerAlert extends MAlert
	{
		public static const BTNLABEL_UPDATE:String = "btnlabelUpdate";
		
		private var _time:int;
		private var _defaultButton:uint;
		private var _timer:Timer;
		private var _btnLabel:String;
		
		public function MTimerAlert(time:int, defaultButton:uint,message:String="", title:String="", flags:uint=4, parent:DisplayObjectContainer=null, closeHandler:Function=null, textAlign:String="center", width:Number=-1)
		{
			_time = time;
			_defaultButton = defaultButton;
			_timer = new Timer(1000);
			super(message, title, flags, parent, closeHandler, textAlign, width);
			initEvent();
			_timer.start();
		}
		
		public static function show(time:int, defaultButton:uint,message:String = "", title:String = "", flags:uint = 4, parent:DisplayObjectContainer = null,closeHandler:Function = null,textAlign:String = "center",width:Number = -1):MTimerAlert
		{
			var alert:MTimerAlert = new MTimerAlert(time,defaultButton,message,title,flags,parent,closeHandler,textAlign,width);
			UIManager.PARENT.addChild(alert);
			return alert;
		}
		
		private function drawBtnLabel():void
		{
			if(_defaultButton & MAlert.OK)
			{
				if(_btnLabel == null)
				{
					_btnLabel = MCacheAssetBtn1(_okBtn).labelField.text;
				}
				MCacheAssetBtn1(_okBtn).label = _btnLabel + "(" + String(_time) + ")";
			}
			else if(_defaultButton & MAlert.YES)
			{
				if(_btnLabel == null)
				{
					_btnLabel = MCacheAssetBtn1(_yesBtn).labelField.text;
				}
				MCacheAssetBtn1(_yesBtn).label = _btnLabel + "(" + String(_time) + ")";
			}
			else if(_defaultButton & MAlert.CANCEL)
			{
				if(_btnLabel == null)
				{
					_btnLabel = MCacheAssetBtn1(_cancelBtn).labelField.text;
				}
				MCacheAssetBtn1(_cancelBtn).label = _btnLabel + "(" + String(_time) + ")";
			}
			else if(_defaultButton & MAlert.NO)
			{
				if(_btnLabel == null)
				{
					_btnLabel = MCacheAssetBtn1(_noBtn).labelField.text;
				}
				MCacheAssetBtn1(_noBtn).label = _btnLabel + "(" + String(_time) + ")";
			}
			else if(_defaultButton & MAlert.AGREE)
			{
				if(_btnLabel == null)
				{
					_btnLabel = MCacheAssetBtn1(_agreeBtn).labelField.text;
				}
				MCacheAssetBtn1(_agreeBtn).label = _btnLabel + "(" + String(_time) + ")";
			}
			else if(_defaultButton & MAlert.REFUSE)
			{
				if(_btnLabel == null)
				{
					_btnLabel = MCacheAssetBtn1(_refuseBtn).labelField.text;
				}
				MCacheAssetBtn1(_refuseBtn).label = _btnLabel + "(" + String(_time) + ")";
			}
		}
		
		override protected function draw():void
		{
			if(isInvalid(BTNLABEL_UPDATE))
			{
				drawBtnLabel();
			}
			super.draw();
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_timer.addEventListener(TimerEvent.TIMER,timerHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
		}
		
		private function timerHandler(e:TimerEvent):void
		{
			if(_time == 0)
			{
				_timer.stop();
				super.doCallBack(_defaultButton);
				dispose();
				return;
			}
			_time--;
			invalidate(BTNLABEL_UPDATE);
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			_timer = null;
			if(parent)parent.removeChild(this);
			try
			{
				delete StyleManager.getInstance().classToInstancesDict[StyleManager.getClassDef(this)][this];
			}
			catch(e:Error){}
		}
	}
}