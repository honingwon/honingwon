package sszt.stall.socketHandlers.stallShopSocketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.stall.StallBuyCellInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.stall.StallModule;
	
	public class StallShopDataSocketHandler extends BaseSocketHandler
	{
		public function StallShopDataSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.STALL_QUERY;
		}
		
		override public function handlePackage():void
		{
			var tmpItemInfo:ItemInfo;
			var tmpSaleCount:int = _data.readInt();
			for(var i:int = 0;i<tmpSaleCount;i++)
			{
				tmpItemInfo = new ItemInfo();
				PackageUtil.readItem(tmpItemInfo,_data);
				_data.readInt();
				stallModule.stallShopInfo.addToStallBegSaleVector(tmpItemInfo);
			} 
			
			var tmpStallBuyCellInfo:StallBuyCellInfo;
			var tmpBuyCount:int = _data.readInt();
			for(var j:int = 0;j<tmpBuyCount;j++)
			{
				var tmpTemplateId:int = _data.readInt();
				var tmpPrice:int = _data.readInt();
				var tmpNum:int = _data.readInt();
				tmpStallBuyCellInfo = new StallBuyCellInfo(tmpTemplateId,tmpPrice,tmpNum);
				stallModule.stallShopInfo.addToStallBegBuyVector(tmpStallBuyCellInfo); 
			}
			
			handComplete();
		}
		
		private function get stallModule():StallModule
		{
			return _handlerData as StallModule;
		}
		
		public static function sendInitialData(userId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.STALL_QUERY);
			pkg.writeNumber(userId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}