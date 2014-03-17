package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class TradeLockSocketHandler extends BaseSocketHandler
	{
		public function TradeLockSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRADE_LOCK;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function sendLock():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TRADE_LOCK);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}