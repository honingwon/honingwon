package sszt.core.data.shop
{
	import flash.utils.ByteArray;
	
	import sszt.core.utils.PackageUtil;
	import sszt.interfaces.socket.IPackageIn;

	public class ShopTemplateInfo
	{
		/**
		 * 商店ID 
		 */		
		public var type:int;  
		/**
		 * 商店名
		 */		
		public var name:String;
		/**
		 * 种类名
		 */		
//		public var categoryNames:Vector.<String>;
		public var categoryNames:Array;
		/**
		 * 物品ID(shopItemInfo.id)
		 */		
//		public var shopItemInfos:Vector.<Vector.<ShopItemInfo>>;
		public var shopItemInfos:Array;
		
//		public function getItems(pageSize:int,page:int,type:int):Vector.<ShopItemInfo>
		public function getItems(pageSize:int,page:int,type:int):Array
		{
//			var list:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
			var list:Array = [];
			var startIndex:int;
			var endIndex:int;
			startIndex = pageSize * page;
			endIndex= pageSize * (page+1);
			if(startIndex>=shopItemInfos[type].length) return list;			
			if(startIndex < shopItemInfos[type].length && endIndex >= shopItemInfos[type].length)
			{
				endIndex = shopItemInfos[type].length;
			}
			for(var i:int = startIndex;i<endIndex;i++)
			{
				list.push(shopItemInfos[type][i]);
			}
			return list;
		}
		
		public function getItem(id:int):ShopItemInfo
		{
			var result:ShopItemInfo = null;
			for(var i:int = 0;i<shopItemInfos.length;i++)
			{
				for(var j:int = 0 ;j<shopItemInfos[i].length;j++)
				{
					if(id == shopItemInfos[i][j].templateId && shopItemInfos[i][j].payType == 1)
						return shopItemInfos[i][j];
					else if(id == shopItemInfos[i][j].templateId)
						result = shopItemInfos[i][j];
				}
			}
			return result;
		}
		
		public function parseData(data:ByteArray):void
		{
//			categoryNames = new Vector.<String>();
			categoryNames = [];
//			shopItemInfos = new Vector.<Vector.<ShopItemInfo>>();
			shopItemInfos = [];
			type = data.readByte();
			name = data.readUTF();
			var categoryLen:int = data.readByte();
			for(var i:int = 0; i < categoryLen; i++)
			{
				var str:String = data.readUTF();
				categoryNames.push(str);
//				var shopItemInfotmp:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
				var shopItemInfotmp:Array = [];
				shopItemInfos.push(shopItemInfotmp);
				var itemLen:int = data.readShort();
				for(var j:int = 0; j < itemLen; j++)
				{
					var item:ShopItemInfo = new ShopItemInfo();
					item.parseData(data);
					shopItemInfotmp.push(item);
				}
			}
		}
		//副本商店更新可购买数量
		public function updateSaleNum(data:IPackageIn):void
		{
			var itemLen:int = data.readInt();
			for(var j:int = 0; j < itemLen; j++)
			{
				updateSaleNum1(data.readInt(),data.readInt());
			}
		}
		public function buySaleNum(id:int, num:int):void
		{
			updateSaleNum1(id, num);
		}
		private function updateSaleNum1(id:int, num:int):void
		{
			for(var i:int = 0;i<shopItemInfos.length;i++)
			{
				for(var n:int = 0 ;n<shopItemInfos[i].length;n++)
				{
					if(shopItemInfos[i][n].id == id)
					{
						shopItemInfos[i][n].saleNum = num;
						return;
					}
				}
			}
		}
		
	}
}