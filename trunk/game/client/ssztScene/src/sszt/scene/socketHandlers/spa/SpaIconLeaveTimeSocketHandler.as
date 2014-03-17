package sszt.scene.socketHandlers.spa
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class SpaIconLeaveTimeSocketHandler extends BaseSocketHandler
	{
		public function SpaIconLeaveTimeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SPA_ICON_TIME;
		}
		
		override public function handlePackage():void
		{
			module.facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SPA_ICON,_data.readInt());
			handComplete();
		}
		
		private function get module():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
	}
}