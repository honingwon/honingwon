package sszt.scene.components.elementInfoView
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.DateUtil;
	import sszt.interfaces.tick.ITick;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.ui.ProgressBarGreen;
	
	public class PetUpgradeCountView extends Sprite implements ITick
	{
		private var _textField:TextField;
		private var _progressBar:ProgressBar;
		private var _updateTime:Number;
		private var _currentTime:int;
		private var _countdonwinfo:CountDownInfo;
		
		public function PetUpgradeCountView()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_progressBar = new ProgressBar(new ProgressBarGreen(),0,100,96,8,false,false);
			addChild(_progressBar);
			
			_textField = new TextField();
			_textField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
			_textField.filters = [new GlowFilter(0x1D250E,1,4,4,4.5)];
			_textField.mouseEnabled = _textField.mouseWheelEnabled = false;
			_textField.width = 60;
			_textField.height = 20;
			_textField.x = 30;
			_textField.y = -3;
			addChild(_textField);
		}
		
		public function update(times:int, dt:Number=0.04):void
		{
			if(getTimer() - _updateTime >= 1000)
			{
				if(_countdonwinfo == null)return;
				_countdonwinfo.seconds -= Math.floor((getTimer() - _updateTime) / 1000);
				if(_countdonwinfo.seconds < 0)
				{
					if(_countdonwinfo.minutes > 0)
					{
						_countdonwinfo.minutes--;
						_countdonwinfo.seconds = 59;
					}
					else if(_countdonwinfo.hours > 0)
					{
						_countdonwinfo.hours --;
						_countdonwinfo.seconds = 59;
						_countdonwinfo.minutes = 59;
					}
					else
					{
						_countdonwinfo.hours = _countdonwinfo.minutes = _countdonwinfo.seconds = 0;
						GlobalAPI.tickManager.removeTick(this);
						dispatchEvent(new Event(Event.COMPLETE));
					}
				}
				_currentTime ++;
				_updateTime = getTimer();
			}
//			if(_countdonwinfo)_textField.text = getIntToString(_countdonwinfo.hours) + ":" + getIntToString(_countdonwinfo.minutes) + ":" + getIntToString(_countdonwinfo.seconds);
			if(_countdonwinfo)_textField.text = getIntToString(_countdonwinfo.hours) + ":" + getIntToString(_countdonwinfo.minutes);
			_progressBar.setCurrentValue(_currentTime);
		}
		
		protected function getIntToString(value:int):String
		{
			if(value > 9)return String(value);
			return "0" + value;
		}
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function start(currentTime:int,totalTime:int):void
		{
			_countdonwinfo = DateUtil.getCountDownByHour(0,(totalTime - currentTime) * 1000);
			_progressBar.setValue(totalTime,currentTime);
//			_textField.text = getIntToString(_countdonwinfo.hours) + ":" + getIntToString(_countdonwinfo.minutes) + ":" + getIntToString(_countdonwinfo.seconds);
			_textField.text = getIntToString(_countdonwinfo.hours) + ":" + getIntToString(_countdonwinfo.minutes);
			_currentTime = currentTime;
			_updateTime = getTimer();
			GlobalAPI.tickManager.addTick(this);
		}

		public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			if(_progressBar)
			{
				_progressBar.dispose();
				_progressBar = null;
			}
			if(parent) parent.removeChild(this);
		}
	}
}