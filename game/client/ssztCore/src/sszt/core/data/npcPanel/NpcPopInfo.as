package sszt.core.data.npcPanel
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.deploys.DeployItemInfo;
	
	public class NpcPopInfo extends EventDispatcher
	{
		public var npcId:int;
		public var descript:String;
//		public var deployList:Vector.<DeployItemInfo>;
		public var deployList:Array;
		
		public function NpcPopInfo(target:IEventDispatcher=null)
		{
			deployList = [];
			super(target);
		}
	}
}