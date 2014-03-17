package sszt.scene.data.copyIsland.beforeEnter
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.events.SceneCopyIslandUpdateEvent;
	
	public class CIBeforeItemInfo extends EventDispatcher
	{
		public var tag:int;//1 同意  2拒绝  3条件不符合
		public var name:String;
		
		public function CIBeforeItemInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}