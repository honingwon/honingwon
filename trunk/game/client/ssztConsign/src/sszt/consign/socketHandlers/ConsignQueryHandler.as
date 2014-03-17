package sszt.consign.socketHandlers
{
	import sszt.consign.ConsignModule;
	import sszt.consign.data.Item.SearchItemInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ConsignQueryHandler extends BaseSocketHandler
	{
		public function ConsignQueryHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CONSIGN_QUERY;
		}
		
		override public function handlePackage():void
		{
			consignModule.consignInfo.clearSearchItemList();
			var tmpTotal:int = _data.readInt();
			if(tmpTotal == 0)
			{
				consignModule.consignInfo.setPage(0,1);
				return;
			}
			var tmpCurrentPage:int = _data.readInt();
			consignModule.consignInfo.setPage(tmpTotal,tmpCurrentPage);
			var len:int = _data.readInt();
			for(var i:int = 0;i<len;i++)
			{
				var tmpItemInfo:ItemInfo = new ItemInfo();
				var tmpSearchItem:SearchItemInfo = new SearchItemInfo();
				tmpSearchItem.listId = _data.readNumber();//id
				tmpSearchItem.consignType = _data.readInt();//读取寄售类型；1：物品 2：铜币 3：金币
				tmpSearchItem.total = _data.readInt();//读取数量
				tmpSearchItem.consignPrice = _data.readInt();//读取寄售价格
				tmpSearchItem.priceType = _data.readInt();//读取价格的单位
				
				if(tmpSearchItem.consignType == 1)
				{
					PackageUtil.readItem(tmpItemInfo,_data);
					tmpSearchItem.itemInfo = tmpItemInfo;
					
				}
				consignModule.consignInfo.addToSearchItemList(tmpSearchItem);
			}
			
			handComplete();
		}
		
//		public static function sendQuery(type:int,argCareer:int,argQuality:int,argMinLevel:int,argMaxLevel:int,argTypeVector:Vector.<int>,argKeyWord:String,argCurrentPage:int):void
		public static function sendQuery(type:int,argCareer:int,argQuality:int,argMinLevel:int,argMaxLevel:int,argTypeVector:Array,argKeyWord:String,argCurrentPage:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CONSIGN_QUERY);
			pkg.writeInt(type);
			pkg.writeInt(argCareer);
			pkg.writeInt(argQuality);
			pkg.writeInt(argMinLevel);
			pkg.writeInt(argMaxLevel);
			pkg.writeString(argKeyWord);
			pkg.writeInt(argTypeVector.length);
			for(var i:int = 0;i < argTypeVector.length;i++)
			{
				pkg.writeInt(argTypeVector[i]);
			}
			pkg.writeInt(argCurrentPage);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get consignModule():ConsignModule
		{
			return _handlerData as ConsignModule;
		}
	}
}