package sszt.scene.socketHandlers.spa
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class SpaSceneEnterSocketHandler extends BaseSocketHandler
	{
		public function SpaSceneEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SPA_ENTER;
		}
		
		public static function sendEnter():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.SPA_ENTER);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}