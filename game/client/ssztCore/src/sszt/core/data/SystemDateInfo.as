package sszt.core.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import sszt.core.utils.DateUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	
	public class SystemDateInfo extends EventDispatcher implements ITick
	{
		private var _serverDate:Date;
		private var _timeWhenSynch:Number;
		private var _preday:int;
		private var _dtCount:Number = 0;
		
		public function SystemDateInfo()
		{
			_serverDate = new Date();
			_preday = -1;
			
		}
		
		public function syncSystemDataBy(n:Number):void
		{
			if(_serverDate != null)return;
			_serverDate = new Date();
			_serverDate.time = n;
			_timeWhenSynch = n;
			GlobalAPI.tickManager.addTick(this);
		}
		
		public function syncSystemDate(d:Date):void
		{
//			if(_serverDate != null)return;
			_serverDate = d;
			_timeWhenSynch = getTimer();
			GlobalAPI.tickManager.addTick(this);
		}
		
		public function getSystemDate():Date
		{
			var d:Date = new Date(_serverDate.getTime());
			d.milliseconds += (getTimer() - _timeWhenSynch);
			return d;
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			_dtCount += dt * times;
			if(_dtCount >= 1)
			{
				_dtCount = 0;
				if(_serverDate == null)return;
				var t:Date = getSystemDate();
				if(t.getHours() == 18 && t.getMinutes() == 0 && t.getSeconds() == 0)
				{
					GlobalData.selfPlayer.clearClubEnemyList();
				}
				if(_preday != -1)
				{
					if(_preday != t.day)
					{
						ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.DATETIME_UPDATE));
					}
				}
				_preday = t.day;
			}
		}
	}
}
