package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	
	public class CopyInfoSocketHandler extends BaseSocketHandler
	{
		public function CopyInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		override public function getCode():int
		{
			return ProtocolType.COPY_INFO;
		}
		
		override public function handlePackage():void
		{
			
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.UPDATE_COPY_INFO,_data));
			
			handComplete();
		}
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_INFO);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}