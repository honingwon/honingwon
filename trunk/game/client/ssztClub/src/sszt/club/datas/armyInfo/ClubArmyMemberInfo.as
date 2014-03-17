package sszt.club.datas.armyInfo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.club.events.ClubArmyInfoUpdateEvent;
	
	public class ClubArmyMemberInfo extends EventDispatcher
	{
		public var userId:Number;
		public var name:String;
		public var armyDuty:int;
		
		public function ClubArmyMemberInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}