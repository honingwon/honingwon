package sszt.core.data.shop
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.charts.AreaChart;
	
	import sszt.ui.container.MAlert;

	public class ShopTemplateList
	{
		public static var shopList:Dictionary = new Dictionary();
		
		public static function parseData(data:ByteArray):void
		{
//			if(data.readBoolean())
//			{
//				data.readUTF();
//			}
//			else
//			{
//				MAlert.show(data.readUTF());
//				return;
//			}
			var shopLen:int = data.readByte();
			for(var i:int = 0; i < shopLen; i++)
			{
				var shop:ShopTemplateInfo = new ShopTemplateInfo();
				shop.parseData(data);
				shopList[shop.type] = shop;
			}
		}
		
		public static function getShop(type:int):ShopTemplateInfo
		{
			return shopList[type];
		}
		
		public static function getShopByCareer(type:int,career:int):ShopTemplateInfo
		{
			var shop:ShopTemplateInfo = shopList[type];
			var shopItemInfos:Array = shop.shopItemInfos;
			var result:ShopTemplateInfo = new ShopTemplateInfo();
			var shopItemInfotmp:Array = [];
			var shopItemInfos1:Array = [];
			result.shopItemInfos = shopItemInfos1;
			shopItemInfos1.push(shopItemInfotmp);
			for(var i:int = 0;i<shopItemInfos.length;i++)
			{
				for(var j:int = 0 ;j<shopItemInfos[i].length;j++)
				{
					if( (shopItemInfos[i][j] as ShopItemInfo).needCareer ==0 || (shopItemInfos[i][j] as ShopItemInfo).needCareer == career )
						shopItemInfotmp.push(shopItemInfos[i][j]);
						 
				}
			}
			return result;
		}
	}
}