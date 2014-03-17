package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.data.roles.TeamScenePlayerInfo;
	import sszt.scene.mediators.SceneMediator;
	
	public class TeamUpdateMsgSocketHandler extends BaseSocketHandler
	{
		public function TeamUpdateMsgSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TEAM_UPDATE_MSG;
		}
		
		override public function handlePackage():void
		{
			var selfTeamPos:int = -1;
			var teamId:int = _data.readInt();
			var leaderId:Number = _data.readNumber();
			sceneModule.sceneInfo.teamData.setLeader(leaderId);
			var teamCount:int = _data.readInt();
			for(var i:int =0;i<teamCount;i++)
			{
				var playerId:Number = _data.readNumber();
				var player:TeamScenePlayerInfo = sceneModule.sceneInfo.teamData.getPlayer(playerId);
				var add:Boolean = false;
				if(player == null)
				{
					player = new TeamScenePlayerInfo();
					player.setObjId(playerId);
					add = true;
				}
//				player.setServerId(_data.readShort());
				player.totalHp = _data.readInt();
				player.currentHp = _data.readInt();
				player.totalMp = _data.readInt();
				player.currentMp = _data.readInt();
				player.teamPos = _data.readShort();
				player.setName(_data.readString());
				player.sex = _data.readBoolean();
				player.setLevel(_data.readByte());
				player.career = _data.readByte();
				player.cloth = _data.readInt();
				player.weapon = _data.readInt();
				player.mount = _data.readInt();
				player.wing = _data.readInt();
				player.strengthLevel = _data.readInt();
				player.mountsStrengthLevel = _data.readInt();
				player.hideWeapon = _data.readBoolean();
				player.hideSuit = _data.readBoolean();
//				_data.readInt();
//				_data.readByte();
				if(sceneModule.sceneInfo.playerList.getPlayer(playerId) == null)
					player.isNearby = false;
				else
					player.isNearby = true;
				if(playerId == GlobalData.selfPlayer.userId)
				{
					selfTeamPos = player.teamPos;
				}
				
				if(add)
				{
					sceneModule.sceneInfo.teamData.addPlayer(player);
				}
			}
			var outCount:int = _data.readInt();
			for(var j:int = 0;j<outCount;j++)
			{
				var id:Number = _data.readNumber();
				if(id != GlobalData.selfPlayer.userId)
					sceneModule.sceneInfo.teamData.removePlayer(id);
				else
					sceneModule.sceneInfo.teamData.teamDisband();
			}
			handComplete();
			//setFollow
//			var list:Vector.<TeamScenePlayerInfo> = sceneModule.sceneInfo.teamData.teamPlayers;
//			for each(var info:TeamScenePlayerInfo in list)
//			{
//				if(info.teamPos == selfTeamPos - 1)
//				{
//					var tPlayer:BaseScenePlayerInfo = sceneModule.sceneInfo.playerList.getPlayer(info.getObjId());
//					if(tPlayer)
//					{
//						sceneModule.sceneInfo.playerList.self.setFollower(tPlayer);
//					}
//					break;
//				}
//			}
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}