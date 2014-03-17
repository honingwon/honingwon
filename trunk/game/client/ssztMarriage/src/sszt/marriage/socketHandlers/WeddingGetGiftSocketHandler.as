package sszt.marriage.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class WeddingGetGiftSocketHandler extends BaseSocketHandler
	{
		public function WeddingGetGiftSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.WEDDING_GET_CASH_GIFT;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.WEDDING_GET_CASH_GIFT);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}