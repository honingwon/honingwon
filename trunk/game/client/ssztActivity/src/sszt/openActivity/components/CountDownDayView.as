package sszt.openActivity.components
{
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.DateUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MSprite;
	
	public class CountDownDayView extends MSprite implements ITick
	{
		protected var _textField:TextField;
		public var _countdonwinfo:CountDownInfo;
		protected var _updateTime:int;
		
		private var _isChangeColor:Boolean;
		private var _count:int = 0;
		private var _type:Boolean = false;
		
		public function CountDownDayView(colorChange:Boolean = false)
		{
			_isChangeColor = colorChange;
			super();
			if(colorChange) _textField.textColor = 0xEDDB60;
		}
		
		override protected function configUI():void
		{
			_textField = new TextField();
			_textField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
			_textField.filters = [new GlowFilter(0x1D250E,1,2,2,6)];
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
//						return;
					}
				}
				if(_countdonwinfo)_textField.text = getIntToString(_countdonwinfo.days,0) + getIntToString(_countdonwinfo.hours,1) + getIntToString(_countdonwinfo.minutes,2) + getIntToString(_countdonwinfo.seconds,3);
				_updateTime = getTimer();
				if(_countdonwinfo == null)return;
				if( _countdonwinfo.minutes == 0 && _countdonwinfo.hours == 0 && _countdonwinfo.seconds == 3) dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function getTimeToString():String
		{
			return getIntToString(_countdonwinfo.days,0) + getIntToString(_countdonwinfo.hours,1) + getIntToString(_countdonwinfo.minutes,2) + getIntToString(_countdonwinfo.seconds,3);
		}
		
		public function getTimeToInt():int
		{
			if(_countdonwinfo == null)
			{
				return 0;
			}
			else
			{
				return _countdonwinfo.hours * 3600 + _countdonwinfo.minutes * 60 + _countdonwinfo.seconds;
			}
		}
		
		protected function getIntToString(value:int,type:int=0):String
		{
			var result:String = "";
			switch(type)
			{
				case 0:
					value > 0 ? result = LanguageManager.getWord("ssztl.common.dayValue",value) : "";
					break;
				case 1:
					value > 0 ? result = LanguageManager.getWord("ssztl.common.hour",value): "";
					break;
				case 2:
					value > 0 ? result = LanguageManager.getWord("ssztl.common.minuteValue",value) : "";
					break;
				case 3:
					value > 0 ? result = LanguageManager.getWord("ssztl.common.secondValue",value) : "";
					break;
			}
//			if(value > 9)return String(value);
//			return "0" + value;
			
			return result;
		}
		
		public function start(seconds:Number):void
		{
			_countdonwinfo = DateUtil.getCountDownByDay(GlobalData.systemDate.getSystemDate().valueOf(),seconds * 1000);
			_textField.text = getIntToString(_countdonwinfo.days,0) + getIntToString(_countdonwinfo.hours,1) + getIntToString(_countdonwinfo.minutes,2) + getIntToString(_countdonwinfo.seconds,3);
			_updateTime = getTimer();
			GlobalAPI.tickManager.addTick(this);
		}
		public function stop():void
		{
			GlobalAPI.tickManager.removeTick(this);
		}
		public function run():void
		{
			GlobalAPI.tickManager.addTick(this);
		}
		public function setColor(color:uint):void
		{
			//_textField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,color)
			_textField.textColor = color;
		}
		public function setLabelType(tf:TextFormat):void
		{
			_textField.defaultTextFormat = tf;
		}
		override public function setSize(width:Number,height:Number):void
		{
			_textField.width = width;
			_textField.height = height;
		}
		
		override public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			_countdonwinfo = null;
			super.dispose();
		}

		public function get textField():TextField
		{
			return _textField;
		}

		public function set textField(value:TextField):void
		{
			_textField = value;
		}

	}
}