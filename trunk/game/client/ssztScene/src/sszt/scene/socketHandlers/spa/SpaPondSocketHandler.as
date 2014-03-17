package sszt.scene.socketHandlers.spa
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class SpaPondSocketHandler extends BaseSocketHandler
	{
		public function SpaPondSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SPA_POND;
		}
		
		override public function handlePackage():void
		{
			
			
			handComplete();
		}
		
		public static function send(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.SPA_POND);
			pkg.writeByte(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}