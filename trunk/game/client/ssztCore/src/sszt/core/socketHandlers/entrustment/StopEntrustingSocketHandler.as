package sszt.core.socketHandlers.entrustment
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class StopEntrustingSocketHandler extends BaseSocketHandler
	{
		public function StopEntrustingSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.STOP_ENTRUSTING;
		}
		
		override public function handlePackage():void
		{
			GlobalData.entrustmentInfo.isInEntrusting = false;
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_ENTRUSTMENT_ATTENTION));
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.STOP_ENTRUSTING);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}