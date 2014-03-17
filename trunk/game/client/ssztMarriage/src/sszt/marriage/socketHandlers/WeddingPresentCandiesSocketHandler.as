package sszt.marriage.socketHandlers
{
	import sszt.constData.WeddingCandiesType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.socketHandlers.marriage.WeddingInfoUpdateSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class WeddingPresentCandiesSocketHandler extends BaseSocketHandler
	{
		public function WeddingPresentCandiesSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.WEDDING_SEND_CANDY;
		}
		
		override public function handlePackage():void
		{
			//剩余次数为0则不发，否则发。
			var success:Boolean = _data.readBoolean();
			var type:int = _data.readShort();
			if(success && type == WeddingCandiesType.FREE)
			{
				GlobalData.weddingInfo.freeNum = GlobalData.weddingInfo.freeNum - 1;
			}
			handComplete();
		}
		
		public static function send(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.WEDDING_SEND_CANDY);
			pkg.writeShort(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}