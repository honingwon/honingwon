package sszt.core.data.shop
{
	import flash.utils.ByteArray;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.MoneyChecker;
	
	/**
	 * 商城item项数据
	 * @author Administrator
	 * 
	 */	
	public class ShopItemInfo
	{
		public var id:int;
		/**
		 * 1推荐
		 * 2新品
		 * 3折扣
		 */		
		public var state:int;
		public var templateId:int;
		/**
		 * 0：铜币（优先使用绑定铜币） 1：元宝 2：绑定元宝 3：铜币（非绑定）  8：贡献
		 */		
		public var payType:int;
		public var price:int;           //现价
		public var originalPrice:int;  //原价
		public var saleNum:int;		//可出售个数
		
		private var _template:ItemTemplateInfo;
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			state = data.readByte();
			templateId = data.readInt();
			payType = data.readByte();
			price = data.readInt();
			originalPrice = data.readInt();
			saleNum = data.readInt();
		}
		
		public function get template():ItemTemplateInfo
		{
			if(!_template)
				_template = ItemTemplateList.getTemplate(templateId);
			return _template;
		}
		
		public function get categoryId():int
		{
			return template.categoryId;
		}
		
		public function get needSex():int
		{
			return template.needSex;
		}
		
		public function get needCareer():int
		{
			return template.needCareer;
		}
		
//		public function getPrice():int
//		{
//			if(payType == 0)
//			{
//				return template.copper;
//			}
//			else if(payType == 1)
//			{
//				return template.yuanbao;
//			}
//			return 0;
//		}
		
		public function getPriceTypeString():String
		{
			switch(payType)
			{
				case 0:return LanguageManager.getWord("ssztl.common.copper2");
				case 1:return LanguageManager.getWord("ssztl.common.yuanBao2");
				case 2:return LanguageManager.getWord("ssztl.common.bindYuanBao2");
				case 3:return LanguageManager.getWord("ssztl.common.copper2");
				case 4:return LanguageManager.getWord("ssztl.common.bindCopper2");
				case 5:return LanguageManager.getWord("ssztl.common.liftExp3");
				case 6:return LanguageManager.getWord("ssztl.common.honorValue");
				case 7:return LanguageManager.getWord("ssztl.common.credit");
				case 8:return LanguageManager.getWord("ssztl.common.contribute");
				case 9:return LanguageManager.getWord("ssztl.common.pvpExploit");
				case 100:return LanguageManager.getWord("ssztl.common.storeShenMu");
				case 101:return LanguageManager.getWord("ssztl.common.storeCansi");
				case 102:return LanguageManager.getWord("ssztl.common.moonCake");
			}
			return "";
		}
		
		public function priceEnough(count:int):String
		{
			return MoneyChecker.priceEnough(count,price,payType);
		}
		
		public function bagHasEmpty(count:int):Boolean
		{
			var left:int =  GlobalData.selfPlayer.bagMaxCount - GlobalData.bagInfo.currentSize;
			if(left == 0) return false;
			if(left <count && template.maxCount*left < count)
			{
				return false;
			}
			return true;
		}
	}
}