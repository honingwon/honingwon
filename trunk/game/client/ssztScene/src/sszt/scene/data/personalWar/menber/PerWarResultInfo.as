package sszt.scene.data.personalWar.menber
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.events.ScenePerWarUpdateEvent;
	
	public class PerWarResultInfo extends EventDispatcher
	{
		public var shenWinNum:int;
		public var moWinNum:int;
		public function PerWarResultInfo()
		{
		}
		
		public function update():void
		{
			dispatchEvent(new ScenePerWarUpdateEvent(ScenePerWarUpdateEvent.PERWAR_RESULT_UPDATE));
		}
	}
}