package sszt.scene.socketHandlers.transport
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class TransportQualityInitHandler extends BaseSocketHandler
	{
		public function TransportQualityInitHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var quality:int = _data.readByte();
			sceneModule.facade.sendNotification(SceneMediatorEvent.SHOW_ACCEPT_TRANSPORT_PANEL,quality);
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TRANSPORT_QUALITY_INIT);
			GlobalAPI.socketManager.send(pkg);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRANSPORT_QUALITY_INIT;
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}