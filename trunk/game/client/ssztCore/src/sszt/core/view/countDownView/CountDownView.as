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
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.DateUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MSprite;
	
	public class CountDownView extends MSprite implements ITick
	{
		protected var _textField:TextField;
		protected var _countdonwinfo:CountDownInfo;
		protected var _updateTime:int;
		
		private var _isChangeColor:Boolean;
		private var _count:int = 0;
		private var _type:Boolean = false;
		private var _tempTime:Number = 0;
		private var _countDonwTime:Number = 0;
		
		public function CountDownView(colorChange:Boolean = false)
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
			_textField.width = 68;
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
			if(_countdonwinfo == null) return;
			var temp:Number = getTimer() - _updateTime;
			if(temp >= _countDonwTime)
			{
				_countdonwinfo.days = _countdonwinfo.hours = _countdonwinfo.minutes = _countdonwinfo.seconds = 0;
				_tempTime = 0;
				GlobalAPI.tickManager.removeTick(this);				
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else if(temp - _tempTime >= 1000)
			{
				_countdonwinfo = DateUtil.getCountDownByEndDay(_countDonwTime - temp);
				if(_countdonwinfo)_textField.text = getTimeToString();
				_tempTime = temp;
				if(_countdonwinfo == null)return;
				if( _countdonwinfo.minutes == 0 && _countdonwinfo.hours == 0 && _countdonwinfo.seconds == 0 && _countdonwinfo.days==0) dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function getTimeToString():String
		{
//			if(_countdonwinfo.days>0)
//			{
//				return LanguageManager.getWord("ssztl.common.dayValue",_countdonwinfo.days);
//			}
//			else
//			{				
				return getIntToString(_countdonwinfo.days * 24 + _countdonwinfo.hours) + ":" + getIntToString(_countdonwinfo.minutes) + ":" + getIntToString(_countdonwinfo.seconds);
//			}
		}
		
		public function getTimeToInt():int
		{
			if(_countdonwinfo == null)
			{
				return 0;
			}
			else
			{
				return _countdonwinfo.days * 3600*24 + _countdonwinfo.hours * 3600 + _countdonwinfo.minutes * 60 + _countdonwinfo.seconds;
			}
		}
		
		protected function getIntToString(value:int):String
		{
			if(value > 9)return String(value);
			return "0" + value;
		}
		
		public function start(seconds:Number):void
		{
			_countDonwTime = seconds * 1000;
			_countdonwinfo = DateUtil.getCountDownByEndDay(_countDonwTime);
			_textField.text = getTimeToString();
			_tempTime = 0;
			_updateTime = getTimer();
			GlobalAPI.tickManager.addTick(this);
		}
		public function stop():void
		{
			GlobalAPI.tickManager.removeTick(this);
			_countDonwTime = getTimeToInt() * 1000;
			_tempTime = 0;
		}
		public function run():void
		{
			GlobalAPI.tickManager.addTick(this);
			_updateTime = getTimer();
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