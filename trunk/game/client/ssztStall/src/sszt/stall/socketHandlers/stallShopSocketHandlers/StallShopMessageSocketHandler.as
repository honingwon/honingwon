package sszt.stall.socketHandlers.stallShopSocketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class StallShopMessageSocketHandler extends BaseSocketHandler
	{
		public function StallShopMessageSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.STALL_MESSAGE;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function sendStallShopMessage(shopKeeperId:Number,MessageContent:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.STALL_MESSAGE);
			pkg.writeNumber(shopKeeperId);
			pkg.writeString(MessageContent);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}