package sszt.core.utils
{
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;

	public class MoneyChecker
	{
		/**
		 * 
		 * @param count 数量
		 * @param price 价格
		 * @param payType 付款类型
		 * @return 
		 * 
		 */		
		public static function priceEnough(count:int,price:int,payType:int):String
		{
			var result:String = "";
			var total:int = price * count;
			switch(payType)
			{
				case 0:
					if(total > (GlobalData.selfPlayer.userMoney.bindCopper + GlobalData.selfPlayer.userMoney.copper))
					{
						result = LanguageManager.getWord("ssztl.common.copperNotEnoughShort");
					}
					break;
				case 1:
					if(total > GlobalData.selfPlayer.userMoney.yuanBao)
					{
						result = LanguageManager.getWord("ssztl.common.yuanBaoNotEnoughShort");
					}
					break;
				case 2:
					if(total > GlobalData.selfPlayer.userMoney.bindYuanBao)
					{
						result = LanguageManager.getWord("ssztl.common.bindYuanBaoNotEnoughShort");
					}
					break;
				case 3:
					if(total > GlobalData.selfPlayer.userMoney.copper)
					{
						result = LanguageManager.getWord("ssztl.common.copperNotEnoughShort");
					}
					break;
				case 4:
					if(total > GlobalData.selfPlayer.userMoney.bindCopper)
					{
						result = LanguageManager.getWord("ssztl.common.bindCopperNotEnoughShort");
					}
					break;
				case 5:
					if(total > GlobalData.selfPlayer.lifeExperiences)
					{
						result = LanguageManager.getWord("ssztl.common.lifeExpNotEnoughShort");
					}
					break;
				case 6:
					if(total > GlobalData.selfPlayer.honor)
					{
						result = LanguageManager.getWord("ssztl.common.honorNotEnoughShort");
					}
					break;
				case 8: //帮会贡献兑换物品
					if(total > GlobalData.selfPlayer.selfExploit)
					{
						result = LanguageManager.getWord("ssztl.common.clubexploitNotEnoughShort");
					}
					break;
				case 9: //功勋兑换物品
//					if(total > GlobalData.selfPlayer.yuanBaoScore)
//					{
//						result = LanguageManager.getWord("ssztl.common.scoreNotEnoughShort");
//					}
					if(total > GlobalData.pvpInfo.exploit)
					{
						result = LanguageManager.getWord("ssztl.common.exploitNotEnoughShort");
					}
					break;
				case 100: //神木
					if(total > GlobalData.bagInfo.getItemCountById(203019))
					{
						result = LanguageManager.getWord("ssztl.common.shenmuNotEnoughShort");
					}
					break;
				case 101: //蚕丝
					if(total > GlobalData.bagInfo.getItemCountById(203016))
					{
						result = LanguageManager.getWord("ssztl.common.cansiNotEnoughShort");
					}
					break;
				case 102: //蚕丝
					if(total > GlobalData.bagInfo.getItemCountById(300000))
					{
						result = LanguageManager.getWord("ssztl.common.mooncakeNotEnoughShort");
					}
					break;
			}
			return result;
		}
	}
}