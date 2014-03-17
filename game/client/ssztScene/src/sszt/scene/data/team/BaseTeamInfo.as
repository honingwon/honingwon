package sszt.scene.data.team
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class BaseTeamInfo extends EventDispatcher
	{
		public var serverId:int;
		public var name:String;
		public var level:int;
		public var leadId:Number;
		public var isAutoIn:Boolean;
		public var emptyPos:int;
		
		public function BaseTeamInfo()
		{
		}
	}
}