package sszt.core.socketHandlers.bag
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ItemRetrieveSocketHandler extends BaseSocketHandler
	{
		public function ItemRetrieveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
	        return ProtocolType.ITEM_RETRIEVE;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function sendRetrieve(place:int,count:int):void
		{
			var pkg:IPackageOut= GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_RETRIEVE);
			pkg.writeInt(place);
			pkg.writeInt(count);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}