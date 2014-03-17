package sszt.scene.socketHandlers.clubFire
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneClubUpdateEvent;
	
	public class ClubFireIconUpdateSocketHandler extends BaseSocketHandler
	{
		public function ClubFireIconUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_FIRE_ICON_LEFT_TIME;
		}
		
		override public function handlePackage():void
		{
			sceneModule.facade.sendNotification(SceneClubUpdateEvent.CLUB_FIRE_ICON_UPDATE,_data.readInt());
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}