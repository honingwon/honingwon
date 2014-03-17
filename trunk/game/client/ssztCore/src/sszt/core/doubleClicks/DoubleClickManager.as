package sszt.core.doubleClicks
{
	import sszt.constData.CommonConfig;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class DoubleClickManager
	{
		private static var _clicker:IDoubleClick;
		private static var _timer:Timer;
		
		public static function addClick(clicker:IDoubleClick):void
		{
			if(_clicker == clicker)
			{
				_clicker.doubleClick();
				_clicker = null;
				if(_timer)
					_timer.stop();
			}
			else
			{
				if(_clicker != null)
				{
					_clicker.click();
				}
				_clicker = clicker;
				if(_timer == null)
				{
					_timer = new Timer(CommonConfig.DOUBLE_CLICK_TIME,1);
					_timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
				}
				_timer.reset();
				_timer.start();
			}
		}
		
		private static function timerCompleteHandler(evt:TimerEvent):void
		{
			if(_clicker)
				_clicker.click();
			_clicker = null;
		}
	}
}