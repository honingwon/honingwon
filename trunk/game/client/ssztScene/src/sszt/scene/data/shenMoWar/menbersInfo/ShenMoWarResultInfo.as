package sszt.scene.data.shenMoWar.menbersInfo
{
	import flash.events.EventDispatcher;
	
	import sszt.scene.events.SceneShenMoWarUpdateEvent;

	public class ShenMoWarResultInfo extends EventDispatcher
	{
		public var shenWinNum:int;
		public var moWinNum:int;
		public function ShenMoWarResultInfo()
		{
		}
		
		public function update():void
		{
			dispatchEvent(new SceneShenMoWarUpdateEvent(SceneShenMoWarUpdateEvent.SHENMO_RESULT_UPDATE));
		}
	}
}