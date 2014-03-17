package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class TargetRepelSocketHandler extends BaseSocketHandler
	{
		public function TargetRepelSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TARGET_REPEL;
		}
		
		override public function handlePackage():void
		{
			var type:int = _data.readByte();
			var id:Number = _data.readNumber();
			var player:BaseRoleInfo = sceneModule.sceneInfo.getRoleInfo(type,id);
			if(player)
			{
				if(id == GlobalData.selfPlayer.userId)
				{
					GlobalData.selfPlayer.scenePath = null;
					GlobalData.selfPlayer.scenePathTarget = null;
					GlobalData.selfPlayer.scenePathCallback = null;
					sceneModule.sceneInit.playerListController.getSelf().stopMoving();
				}
				player.setScenePos(_data.readInt(),_data.readInt());
			}
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}