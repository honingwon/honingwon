package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.data.roles.TeamScenePlayerInfo;
	
	public class TeamBattleInfoSocketHandler extends BaseSocketHandler
	{
		public function TeamBattleInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TEAM_BATTLEINFO;
		}
		
		override public function handlePackage():void
		{
			var playerId:Number = _data.readNumber();
			if(playerId == GlobalData.selfPlayer.userId)return;
			var player:TeamScenePlayerInfo = sceneModule.sceneInfo.teamData.getPlayer(playerId);
			if(player)
			{
				player.currentHp = _data.readInt();
				player.currentMp = _data.readInt();
			}
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}