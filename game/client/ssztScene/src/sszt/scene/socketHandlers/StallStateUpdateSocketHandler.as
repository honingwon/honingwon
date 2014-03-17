package sszt.scene.socketHandlers
{
	import sszt.core.data.MapElementType;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.components.sceneObjs.BaseScenePlayer;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	
	public class StallStateUpdateSocketHandler extends BaseSocketHandler
	{
		public function StallStateUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.STALL_STATE_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var player:BaseScenePlayerInfo = sceneModule.sceneInfo.getRoleInfo(MapElementType.PLAYER,_data.readNumber()) as BaseScenePlayerInfo;
			if(player)
			{
				player.info.stallName = _data.readString();
			}
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}