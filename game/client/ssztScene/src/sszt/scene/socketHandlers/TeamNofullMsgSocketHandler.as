package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.team.BaseTeamInfo;
	import sszt.scene.data.team.UnteamPlayerInfo;
	
	public class TeamNofullMsgSocketHandler extends BaseSocketHandler
	{
		public function TeamNofullMsgSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TEAM_NOFULL_MSG;
		}
		
		override public function handlePackage():void
		{
			var count:int = _data.readInt();
			var i:int = 0;
			var teams:Array = [];
			for(i = 0; i < count; i++)
			{
				var team:BaseTeamInfo = new BaseTeamInfo();
//				team.serverId = _data.readShort();
				team.leadId = _data.readNumber();
				team.name = _data.readString();
				team.level = _data.readInt();
				team.emptyPos = _data.readByte();
				team.isAutoIn = _data.readBoolean();
				teams.push(team);
			}
			count = _data.readInt();
			var unteamPlayer:Array = [];
			for(i = 0; i < count; i++)
			{
				var player:UnteamPlayerInfo = new UnteamPlayerInfo();
//				player.serverId = _data.readShort();
				player.id = _data.readNumber();
				player.name = _data.readString();
				player.level = _data.readInt();			
				unteamPlayer.push(player);
			}
			sceneMoudle.sceneInfo.nearData.setData(teams,unteamPlayer);
			
			handComplete();
			
			
//			GSTCPPacket pkg = new GSTCPPacket((short)ePackageType.TEAM_NOFULL_MSG);
//			pkg.WriteInt(10); //队伍数
//			for (int i = 0; i < 10; i++)
//			{
//				pkg.WriteLong(1); //队长id
//				pkg.WriteString("xx");//队长名
//				pkg.WriteByte(1); //人数
//				pkg.WriteBoolean(true); //是否自动入队
//			}
//			pkg.WriteInt(10); //附近人数
//			for (int i = 0; i < 10; i++)
//			{
//				pkg.WriteLong(1); //人物id
//				pkg.WriteString("xx");//人物名
//			}
		}
		
		public function get sceneMoudle():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TEAM_NOFULL_MSG);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}