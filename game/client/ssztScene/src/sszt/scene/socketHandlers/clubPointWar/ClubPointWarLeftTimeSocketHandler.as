package sszt.scene.socketHandlers.clubPointWar
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneClubPointWarUpdateEvent;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class ClubPointWarLeftTimeSocketHandler extends BaseSocketHandler
	{
		public function ClubPointWarLeftTimeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_POINT_TIME;
		}
		
		override public function handlePackage():void
		{
			sceneModule.facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWCLUBPOINTWARICON,_data.readInt());
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}