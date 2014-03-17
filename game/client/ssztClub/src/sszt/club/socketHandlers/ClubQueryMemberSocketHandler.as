package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.club.memberInfo.ClubMemberItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubQueryMemberSocketHandler extends BaseSocketHandler
	{
		public function ClubQueryMemberSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_QUERYMEMBER;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readShort();
			var player:ClubMemberItemInfo;
			var members:Array = [];
			for(var i:int = 0; i < len; i++)
			{
				player = new ClubMemberItemInfo();
				player.serverId = _data.readShort();
				player.id = _data.readNumber();
				player.name = _data.readString();
				player.duty = _data.readByte();
				player.career = _data.readByte();
				player.level = _data.readByte();
				player.army = _data.readString();
//				player.contribute = _data.readInt();
//				player.exploit = _data.readInt();
//				player.exploitToday = _data.readInt();
				player.isOnline = _data.readBoolean();
				members.push(player);
			}
		 	GlobalData.clubMemberInfo.setList(members);
			
			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send(clubId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_QUERYMEMBER);
			pkg.writeNumber(clubId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}