package sszt.scene.socketHandlers.spa
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class SpaSceneLeaveSocketHandler extends BaseSocketHandler
	{
		public function SpaSceneLeaveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SPA_LEAVE;
		}
		
		override public function handlePackage():void
		{
			
			handComplete();
		}
		
		public static function sendLeave():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.SPA_LEAVE);
			GlobalAPI.socketManager.send(pkg);
		}
			
	}
}