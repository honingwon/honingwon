package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.dutyInfo.ClubDutyManageInfo;
	import sszt.club.datas.dutyInfo.ClubMemberDutyInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.club.memberInfo.ClubMemberInfo;
	import sszt.core.data.club.memberInfo.ClubMemberInfoUpdateEvent;
	import sszt.core.data.club.memberInfo.ClubMemberItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubDutyUpdateSocketHandler extends BaseSocketHandler
	{
		public function ClubDutyUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_DUTY_UPDATE;
		}
		
		public function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		override public function handlePackage():void
		{
			if(clubModule.clubInfo.clubDutyInfo == null)
			{
				clubModule.clubInfo.initDutyInfo();
			}
//			if(clubModule.clubInfo.clubMemberInfo == null)
//			{
//				clubModule.clubInfo.initMemeberInfo();
//			}
			
			var info:ClubMemberInfo = GlobalData.clubMemberInfo;
			info.currentViceMaster = _data.readByte();
			info.currentHonor = _data.readByte();
			info.currentMember = _data.readByte();
			var useId:int = _data.readNumber();
			var duty:int = _data.readByte();
			var member:ClubMemberItemInfo = info.getClubMember(useId);
			if(member != null)
			{
				member.duty = duty;
				member.update();
			}
			if(GlobalData.selfPlayer.userId == useId)
			{
				GlobalData.selfPlayer.clubDuty = duty;
			}
			info.dispatchEvent(new ClubMemberInfoUpdateEvent(ClubMemberInfoUpdateEvent.MEMBER_DUTY_UPDATE));
			
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_DUTY_UPDATE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}