package sszt.stall.socketHandlers.stallShopSocketHandlers
{
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.bag.StallShopBuySaleInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.stall.StallModule;
	
	public class StallShopSaleSocketHandler extends BaseSocketHandler
	{
		public function StallShopSaleSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.STALL_ITEM_SALE;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				stallModule.stallShopInfo.saleSuccessUpdate();
			}
			else
			{
				MAlert.show("出售失败!","警告");
			}
			handComplete();
		}
		
//		public static function sendShopSale(targetUserId:Number,stallShoppingSaleVector:Vector.<StallShopBuySaleInfo>):void
		public static function sendShopSale(targetUserId:Number,stallShoppingSaleVector:Array):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.STALL_ITEM_SALE);
			pkg.writeNumber(targetUserId);
			pkg.writeInt(stallShoppingSaleVector.length);
			for each(var i:StallShopBuySaleInfo in stallShoppingSaleVector)
			{
				pkg.writeInt(i.itemInfo.place);
				pkg.writeInt(i.count);
			}
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get stallModule():StallModule
		{
			return _handlerData as StallModule;
		}
	}
}