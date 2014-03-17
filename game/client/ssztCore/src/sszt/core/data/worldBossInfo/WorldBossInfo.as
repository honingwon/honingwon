package sszt.core.data.worldBossInfo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class WorldBossInfo extends EventDispatcher
	{
		private var _remainingNum:int;
		
		public function set remainingNum(num:int):void
		{
			_remainingNum = num;
			dispatchEvent(new WorldBossUpdateEvent(WorldBossUpdateEvent.UPDATE_REMAINING_NUM));
		}
		
		public function get remainingNum():int
		{
			return _remainingNum;
		}
	}
}