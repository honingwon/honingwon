package sszt.stall.socketHandlers.stallShopSocketHandlers
{
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.bag.StallShopBuySaleInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.stall.StallModule;
	
	import mx.messaging.channels.AMFChannel;
	
	public class StallShopBuySocketHandler extends BaseSocketHandler
	{
		public function StallShopBuySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				stallModule.stallShopInfo.buySuccessUpdate();
			}
			else
			{
				MAlert.show("购买失败！");
			}
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.STALL_ITEM_BUY;
		}
		
//		public static function sendShopBuy(targetUserId:Number,shoppingBuyVector:Vector.<StallShopBuySaleInfo>):void
		public static function sendShopBuy(targetUserId:Number,shoppingBuyVector:Array):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.STALL_ITEM_BUY);
			pkg.writeNumber(targetUserId);
			pkg.writeInt(shoppingBuyVector.length);
			for each(var i:StallShopBuySaleInfo in shoppingBuyVector)
			{
				pkg.writeInt(i.itemInfo.place);
				pkg.writeInt(i.count);
			}
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get stallModule():StallModule
		{
			return _handlerData as StallModule;
		}
	}
}