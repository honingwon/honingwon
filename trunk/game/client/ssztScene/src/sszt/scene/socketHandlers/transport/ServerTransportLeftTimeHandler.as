package sszt.scene.socketHandlers.transport
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class ServerTransportLeftTimeHandler extends BaseSocketHandler
	{
		public function ServerTransportLeftTimeHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			module.facade.sendNotification(SceneMediatorEvent.INIT_SERVER_TRANSPORT_TIME,_data.readInt());
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.ALLSERVICE_TRANSPORT_TIME;
		}
		
		public function get module():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}