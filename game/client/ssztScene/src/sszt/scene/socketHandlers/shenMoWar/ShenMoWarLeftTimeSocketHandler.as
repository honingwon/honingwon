package sszt.scene.socketHandlers.shenMoWar
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.components.shenMoWar.shenMoIcon.ShenMoIconView;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class ShenMoWarLeftTimeSocketHandler extends BaseSocketHandler
	{
		public function ShenMoWarLeftTimeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SHENMO_WARTIME_UPDATE;
		}
		
		override public function handlePackage():void
		{
//			sceneModule.facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMOICON,_data.readInt());
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
	}
}