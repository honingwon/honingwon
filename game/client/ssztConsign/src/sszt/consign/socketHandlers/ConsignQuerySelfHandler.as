package sszt.consign.socketHandlers
{
	import sszt.consign.ConsignModule;
	import sszt.consign.data.Item.MyItemInfo;
	import sszt.consign.data.Item.SearchItemInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ConsignQuerySelfHandler extends BaseSocketHandler
	{
		public function ConsignQuerySelfHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CONSIGN_QUERY_SELF;
		}
		
		override public function handlePackage():void
		{	
			consignModule.consignInfo.clearMyItemList();
			var tmpTotal:int = _data.readInt();
			if(tmpTotal == 0)return;
			var tmpCurrentPage:int = _data.readInt();
			consignModule.consignInfo.setMyConsignPage(tmpTotal,tmpCurrentPage);
			var len:int = _data.readInt();
			for(var i:int = 0;i<len;i++)
			{
				var tmpItemInfo:ItemInfo = new ItemInfo();
				var myItem:MyItemInfo = new MyItemInfo();
				myItem.listId = _data.readNumber();//id
				myItem.consignType = _data.readInt();//读取寄售类型；1：物品 2：铜币 3：金币
				myItem.total = _data.readInt();//读取数量
				myItem.consignPrice = _data.readInt();//读取寄售价格
				myItem.priceType = _data.readInt();//读取价格的单位
//				myItem.leftTime = _data.readDate();
				myItem.leftTime = _data.readInt();
				if(myItem.consignType == 1)
				{
					PackageUtil.readItem(tmpItemInfo,_data);
					myItem.itemInfo = tmpItemInfo;
				}
				consignModule.consignInfo.addToMyItemList(myItem);
			}
			
			handComplete();
		}
		
		public static function sendQuery(argCurrentPage:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CONSIGN_QUERY_SELF);
			pkg.writeInt(argCurrentPage);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get consignModule():ConsignModule
		{
			return _handlerData as ConsignModule;
		}
		
	}
}