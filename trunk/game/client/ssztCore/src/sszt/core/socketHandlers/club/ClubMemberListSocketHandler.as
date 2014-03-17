package sszt.core.socketHandlers.club
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.data.club.memberInfo.ClubMemberItemInfo;
	import sszt.core.data.club.memberInfo.ClubMemberInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubMemberListSocketHandler extends BaseSocketHandler
	{
		public function ClubMemberListSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_MEMBER_LIST;
		}
		
		override public function handlePackage():void
		{
			var info:ClubMemberInfo = GlobalData.clubMemberInfo;
			
			info.currentViceMaster = _data.readInt();
			
			info.currentHonor = _data.readInt();
			info.currentMember = _data.readInt();
			
			var len:int = _data.readInt();
			var player:ClubMemberItemInfo;
			var members:Array = [];
			for(var i:int = 0; i < len; i++)
			{
				player = new ClubMemberItemInfo();
				player.id = _data.readNumber();
				player.name = _data.readString();
				player.vipType = _data.readByte();
				
				player.duty = _data.readByte();
				player.career = _data.readByte();
				player.sex = _data.readBoolean();
				player.level = _data.readByte();
				
				player.currentExploit = _data.readInt();
				player.totalExploit = _data.readInt();
				player.outTime = _data.readDate();
				player.fightCapacity = _data.readInt();
				player.isOnline = _data.readBoolean();
				
				members.push(player);
			}
			info.setList(members);
			handComplete();
		}
		
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_MEMBER_LIST);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}