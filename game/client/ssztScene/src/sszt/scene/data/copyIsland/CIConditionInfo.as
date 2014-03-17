package sszt.scene.data.copyIsland
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.events.SceneCopyIslandUpdateEvent;
	
	public class CIConditionInfo extends EventDispatcher
	{
		public var leftTime:int;
		public function CIConditionInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function update():void
		{
//			dispatchEvent(new SceneCopyIslandUpdateEvent(SceneCopyIslandUpdateEvent.COPY_ISLAND_CONDITION_UPDATE));
		}
	}
}