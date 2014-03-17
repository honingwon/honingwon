package sszt.core.view.countDownView
{
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.utils.DateUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MSprite;
	
	public class CountUpView extends MSprite implements ITick
	{
		protected var _textField:TextField;
		protected var _countupinfo:CountDownInfo;
		protected var _initInfo:CountDownInfo;
		protected var _updateTime:int;
		
		private var _isChangeColor:Boolean;
		private var _count:int = 0;
		private var _type:Boolean = false;
		
		public function CountUpView(colorChange:Boolean = false)
		{
			_isChangeColor = colorChange;
			super();
			if(colorChange) _textField.textColor = 0xEDDB60;
		}
		
		override protected function configUI():void
		{
			_textField = new TextField();
			_textField.defaultTextFormat = new TextFormat("宋体",12,0xFFFFFF);
			_textField.filters = [new GlowFilter(0x1D250E,1,4,4,4.5)];
			_textField.mouseEnabled = _textField.mouseWheelEnabled = false;
			_textField.width = 60;
			_textField.height = 20;
			addChild(_textField);
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			_count++;
			if(_isChangeColor)
			{
				if(_count >= 75)
				{
					if(_type) _textField.textColor = 0xEDDB60;
					else _textField.textColor = 0x00ff00;
					_type = !_type;
					_count = 0;
				}
			}
			if(getTimer() - _updateTime >= 1000)
			{
				if(_countupinfo == null)return;
				if(_countupinfo.getToInt() >= _initInfo.getToInt())
				{
					_countupinfo.hours = _initInfo.hours;
					_countupinfo.minutes = _initInfo.minutes;
					_countupinfo.seconds = _initInfo.seconds;
					GlobalAPI.tickManager.removeTick(this);
					dispatchEvent(new Event(Event.COMPLETE));
				}
				_countupinfo.seconds += Math.floor((getTimer() - _updateTime) / 1000);
				if(_countupinfo.seconds >59)
				{
					if(_countupinfo.minutes < 59)
					{
						_countupinfo.minutes++;
						_countupinfo.seconds = 0;
					}
					else if(_countupinfo.hours < 59)
					{
						_countupinfo.hours ++;
						_countupinfo.seconds = 0;
						_countupinfo.minutes = 0;
					}
				}
				if(_countupinfo)_textField.text = getIntToString(_countupinfo.hours) + ":" + getIntToString(_countupinfo.minutes) + ":" + getIntToString(_countupinfo.seconds);
				_updateTime = getTimer();
				if(_countupinfo == null)return;
//				if( _countupinfo.minutes == 0 && _countupinfo.hours == 0 && _countupinfo.seconds == 3) dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function getTimeToString():String
		{
			return getIntToString(_countupinfo.hours) + ":" + getIntToString(_countupinfo.minutes) + ":" + getIntToString(_countupinfo.seconds);
		}
		
		public function getTimeToInt():int
		{
			if(_countupinfo == null)
			{
				return 0;
			}
			else
			{
				return _countupinfo.hours * 3600 + _countupinfo.minutes * 60 + _countupinfo.seconds;
			}
		}
		
		protected function getIntToString(value:int):String
		{
			if(value > 9)return String(value);
			return "0" + value;
		}
		
		public function start(seconds:Number):void
		{
			_initInfo = DateUtil.getCountDownByHour(0,seconds * 1000);
			_countupinfo = new CountDownInfo();
			_textField.text = "00:00:00";
			_updateTime = getTimer();
			GlobalAPI.tickManager.addTick(this);
		}
		public function setStartTime(start:Number):void
		{
			_countupinfo = DateUtil.getCountDownByHour(0,start * 1000);
			_textField.text = getIntToString(_countupinfo.hours) + ":" + getIntToString(_countupinfo.minutes) + ":" + getIntToString(_countupinfo.seconds);
		}
		public function stop():void
		{
			GlobalAPI.tickManager.removeTick(this);
		}
		
		public function setColor(color:uint):void
		{
			_textField.defaultTextFormat = new TextFormat("宋体",12,color)
		}
		
		override public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			_countupinfo = null;
			_initInfo = null;
			super.dispose();
		}
	}
}