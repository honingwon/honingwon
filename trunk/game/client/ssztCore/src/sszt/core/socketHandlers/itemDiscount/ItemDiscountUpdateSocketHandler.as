package sszt.core.socketHandlers.itemDiscount
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.itemDiscount.CheapItem;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;

	public class ItemDiscountUpdateSocketHandler extends BaseSocketHandler
	{
		public function ItemDiscountUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_DISCOUNT_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var id:int = _data.readInt();
			var count:int = _data.readInt();
			var limitCount:int = _data.readByte();
			var item:CheapItem = GlobalData.cheapInfo.getItem(id);
			if(item) item.updateCount(count,limitCount);
			handComplete();
		}
		
		public static function send(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_DISCOUNT_UPDATE);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}	
	}
}