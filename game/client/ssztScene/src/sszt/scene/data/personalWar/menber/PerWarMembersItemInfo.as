package sszt.scene.data.personalWar.menber
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class PerWarMembersItemInfo extends EventDispatcher
	{
		public var serverId:int;
		public var userId:Number;
		public var isOnline:int;
		public var rankingNum:int;
		public var playerNick:String;
		public var camp:int;
		public var level:int;
		public var clubName:String;
		public var careerId:int;
		public var awardState:int;
		public var attackPepNum:int;
		public var score:int;
		
		public function PerWarMembersItemInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}