package sszt.scene.socketHandlers
{
	import flash.geom.Point;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.components.sceneObjs.BaseScenePlayer;
	import sszt.scene.components.sceneObjs.SelfScenePlayer;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	
	public class PlayerPlaceUpdateSocketHandler extends BaseSocketHandler
	{
		public function PlayerPlaceUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_PLACE_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			var player:BaseScenePlayer = sceneModule.sceneInit.playerListController.getPlayer(id);
			if(player && player.scene)
			{
				var p:Point = new Point(_data.readInt(),_data.readInt())
				player.scene.move(player,p);
				if(id == GlobalData.selfPlayer.userId)
				{
					(player as SelfScenePlayer).stopMoving();
					player.scene.getViewPort().focusPoint = p;
					sceneModule.sceneInfo.dispatchRender();
				}
			}
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}