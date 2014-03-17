package sszt.core.socketHandlers.itemDiscount
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.itemDiscount.CheapItem;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	/**
	 * 获取优惠商品
	 * */
	public class ItemDiscountSocketHandler extends BaseSocketHandler
	{
		public function ItemDiscountSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_DISCOUNT;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readInt();
//			var list:Vector.<CheapItem> = new Vector.<CheapItem>();
			var list:Array = [];
			for(var i:int =0;i<len;i++)
			{
				var item:CheapItem = new CheapItem();
				item.parseData(_data);
				list.push(item);
			}
			GlobalData.cheapInfo.update(list);
			handComplete();
		}
		
		public static function sendDiscount():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_DISCOUNT);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}