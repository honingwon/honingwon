package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.data.roles.TeamScenePlayerInfo;
	
	public class TeamLevelUpdateSocketHandler extends BaseSocketHandler
	{
		public function TeamLevelUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TEAM_LEVEL_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var id:int = _data.readNumber();
			var level:int = _data.readInt();
			var player:TeamScenePlayerInfo = sceneModule.sceneInfo.teamData.getPlayer(id);
			if(player) player.setLevel(level);
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}