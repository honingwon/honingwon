package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class MapUserRemoveSocketHandler extends BaseSocketHandler
	{
		public function MapUserRemoveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MAP_USER_REMOVE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readShort();
			for(var i:int = 0; i < len; i++)
			{
				var id:Number = _data.readNumber();
				if(id == GlobalData.selfPlayer.userId)
				{
					continue;
				}
				sceneModule.sceneInfo.playerList.removePlayer(id);
				var petId:Number = _data.readNumber();
				if(petId > 0)
				{
					sceneModule.sceneInfo.petList.removeScenePet(petId);
				}
				sceneModule.sceneInfo.carList.removeSceneCar(id);
				if(sceneModule.sceneInfo.teamData.getPlayer(id) != null)
					sceneModule.sceneInfo.teamData.getPlayer(id).isNearby = false;
			}
			
			handComplete();
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}