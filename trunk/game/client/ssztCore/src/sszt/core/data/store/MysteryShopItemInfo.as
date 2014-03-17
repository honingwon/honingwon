/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-8-22 下午4:21:19 
 * 
 */ 
package sszt.core.data.store
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.MoneyChecker;

	public class MysteryShopItemInfo
	{
		public function MysteryShopItemInfo()
		{
		}
		/**
		 * 位置 
		 */		
		public var place:int;
		
		public var templateId:int;
		
		/**
		 * 价格 
		 */		
		public var price:int;
		
		/**
		 * 数量 
		 */		
		public var num:int;
		
		/**
		 * 支付类型 
		 */		
		public var payType:int;
		
		/**
		 * 是否存在 
		 */		
		public var isExist:Boolean;
		
		
		public function get template():ItemTemplateInfo
		{
			return ItemTemplateList.getTemplate(templateId);
		}
		
		public function priceEnough():String
		{
			return MoneyChecker.priceEnough(1,price,payType);
		}
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
			}
			return "";
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