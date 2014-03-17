package sszt.core.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;

	public class GetGameReleaseTimeSocketHandler extends BaseSocketHandler
	{
		public function GetGameReleaseTimeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.GET_RELEASE_TIME;
		}
		
		override public function handlePackage():void
		{
			//秒
			GlobalData.releaseTime = _data.readNumber();
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.RELEASE_TIME_GOT));
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.GET_RELEASE_TIME);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}