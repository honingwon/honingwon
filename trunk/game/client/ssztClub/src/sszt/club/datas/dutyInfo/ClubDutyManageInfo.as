package sszt.club.datas.dutyInfo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.club.events.ClubDutyInfoUpdateEvent;
	
	public class ClubDutyManageInfo extends EventDispatcher
	{
//		public var totalMaster:int;
//		public var currentViceMaster:int;
//		public var totalHonor:int;
//		public var currentHonor:int;
//		public var totalNormal:int;
//		public var currentNormal:int;
//		public var totalPrepare:int;
//		public var currentPrepare:int;
		
//		public var memberList:Vector.<ClubMemberDutyInfo>;
		public var memberUpdated:ClubMemberDutyInfo;
		
		public function ClubDutyManageInfo(target:IEventDispatcher=null)
		{
//			memberList = new Vector.<ClubMemberDutyInfo>();
//			memberList = [];
			super(target);
		}
		
//		public function setList(list:Vector.<ClubMemberDutyInfo>):void
		public function setInfo(info:ClubMemberDutyInfo):void
		{
			memberUpdated = info;
		}
		
		public function update():void
		{
			
			dispatchEvent(new ClubDutyInfoUpdateEvent(ClubDutyInfoUpdateEvent.CLUB_DUTYINFO_UPDATE));
		}
		
		public function dispose():void
		{
//			memberList = null;
		}
	}
}