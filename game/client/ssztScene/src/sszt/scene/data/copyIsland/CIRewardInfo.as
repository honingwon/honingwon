package sszt.scene.data.copyIsland
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.events.SceneCopyIslandUpdateEvent;
	
	public class CIRewardInfo extends EventDispatcher
	{
		public var currentExp:int;
		public var allExp:int;
		public var currentLifeExp:int;
		public var allLifeExp:int;
		public function CIRewardInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function update():void
		{
//			dispatchEvent(new SceneCopyIslandUpdateEvent(SceneCopyIslandUpdateEvent.COPY_ISLAND_REWARDS_UPDATE));
		}
	}
}