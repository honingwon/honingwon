package sszt.common.vip.component.sec
{
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.DateUtil;
	import sszt.core.view.countDownView.CountDownView;
	
	public class VipCountDownView extends CountDownView
	{
		public function VipCountDownView(colorChange:Boolean=false)
		{
			super(colorChange);
		}
		
		override public function update(times:int, dt:Number=0.04):void
		{
			if(getTimer() - _updateTime >= 1000)
			{
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
					else if(_countdonwinfo.days > 0)
					{
						_countdonwinfo.days --;
						_countdonwinfo.hours = 24;
						_countdonwinfo.minutes = _countdonwinfo.seconds = 0;
					}else
					{
						_countdonwinfo.days = _countdonwinfo.hours = _countdonwinfo.minutes = _countdonwinfo.seconds = 0;
						GlobalAPI.tickManager.removeTick(this);
						dispatchEvent(new Event(Event.COMPLETE));
					}
				}
				if(_countdonwinfo)
				{
//					_textField.text = _countdonwinfo.days + LanguageManager.getWord("ssztl.common.day") + getIntToString(_countdonwinfo.hours) + ":" + getIntToString(_countdonwinfo.minutes) + ":" + getIntToString(_countdonwinfo.seconds);
					if(_countdonwinfo.days >0 )
						_textField.text = _countdonwinfo.days +  LanguageManager.getWord("ssztl.common.day");
					else
						_textField.text = getIntToString(_countdonwinfo.hours) + ":" + getIntToString(_countdonwinfo.minutes) + ":" + getIntToString(_countdonwinfo.seconds);
				}
				_updateTime = getTimer();
			}
		}
		
		override public function start(seconds:Number):void
		{
			_textField.width = 100;
			_countdonwinfo = DateUtil.getCountDownByDay(0,seconds * 1000);
			if(_countdonwinfo.days >0 )
				_textField.text = _countdonwinfo.days +  LanguageManager.getWord("ssztl.common.day");
			else
				_textField.text = getIntToString(_countdonwinfo.hours) + ":" + getIntToString(_countdonwinfo.minutes) + ":" + getIntToString(_countdonwinfo.seconds);
			_updateTime = getTimer();
			GlobalAPI.tickManager.addTick(this);
		}
	}
}