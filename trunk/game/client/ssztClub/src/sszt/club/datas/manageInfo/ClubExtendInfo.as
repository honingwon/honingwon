package sszt.club.datas.manageInfo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.club.events.ClubManageInfoUpdateEvent;
	
	public class ClubExtendInfo extends EventDispatcher
	{
		public var total:int;
		public var currentHonor:int;
		public var currentNormal:int;
		public var currentPrepare:int;
		public var leftHonor:int;
		public var leftNormal:int;
		public var leftPrepare:int;
		
		public function ClubExtendInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function update():void
		{
			dispatchEvent(new ClubManageInfoUpdateEvent(ClubManageInfoUpdateEvent.EXTEND_INFO_UPDATE));
		}
	}
}