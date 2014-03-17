package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	
	public class PlayerPKValueChangeSocketHandler extends BaseSocketHandler
	{
		public function PlayerPKValueChangeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_PK_VALUE_CHANGE;
		}
		
		override public function handlePackage():void
		{
			var playerId:Number = _data.readNumber();
			var pkValue:int = _data.readInt();
			var player:BaseScenePlayerInfo = sceneModule.sceneInfo.playerList.getPlayer(playerId);
			if(player)player.info.PKValue = pkValue;
			if(playerId == GlobalData.selfPlayer.userId)GlobalData.selfPlayer.PKValue = pkValue;
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}