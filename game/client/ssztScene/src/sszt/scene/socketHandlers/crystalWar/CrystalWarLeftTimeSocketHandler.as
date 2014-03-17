package sszt.scene.socketHandlers.crystalWar
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneClubPointWarUpdateEvent;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class CrystalWarLeftTimeSocketHandler extends BaseSocketHandler
	{
		public function CrystalWarLeftTimeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CRYSTAL_WAR_TIME;
		}
		
		override public function handlePackage():void
		{
			sceneModule.facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWCRYTSALWARICON,_data.readInt());
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}