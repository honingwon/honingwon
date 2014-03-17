package sszt.core.socketHandlers.itemDiscount
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.itemDiscount.CheapItem;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ItemDiscountBuySocketHandler extends BaseSocketHandler
	{
		public function ItemDiscountBuySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_DISCOUNT_BUY;
		}
		
		override public function handlePackage():void
		{
			var value:Boolean = _data.readBoolean();
			if(value)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.buySuccess"));
			}else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.buyFail"));
			}
			var id:int = _data.readInt();
			var count:int = _data.readInt();
			var count1:int = _data.readByte();
			var item:CheapItem = GlobalData.cheapInfo.getItem(id);
			if(value && item) item.updateCount(count,count1);
			handComplete();
		}
		
		public static function send(id:int,count:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_DISCOUNT_BUY);
			pkg.writeInt(id);
			pkg.writeInt(count);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}