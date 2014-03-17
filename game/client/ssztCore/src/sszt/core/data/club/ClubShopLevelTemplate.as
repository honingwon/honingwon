package sszt.core.data.club
{
	import flash.utils.ByteArray;
	
	import sszt.core.manager.LanguageManager;

	public class ClubShopLevelTemplate
	{
		public var shopLevel:int;
		public var needClubLevel:int;
		public var needClubRich:int;
		public var needCopper:int;
		
		public function ClubShopLevelTemplate()
		{
			
		}
		
		public function parseData(data:ByteArray):void
		{
			shopLevel = data.readInt();
			needClubLevel = data.readInt();
			needClubRich = data.readInt();
//			needCopper = data.readInt();
		}
		
		
		public function getCurEffectToString():String
		{			
			return LanguageManager.getWord("ssztl.common.shopLevel",shopLevel);
		}
		
		public function getNextEffectToString():String
		{
			return LanguageManager.getWord("ssztl.common.shopLevelAfterUpgrade",shopLevel);
		}
		
		public function getNeed1ToString():String
		{
			return LanguageManager.getWord("ssztl.common.needClubLevel",needClubLevel);
		}
		
		public function getNeed2ToString():String
		{
			return LanguageManager.getWord("ssztl.common.needClubMoney",needClubRich);
		}
		
		
//		public function getEffectToString():String
//		{
//			return LanguageManager.getWord("ssztl.common.shopLevelAfterUpgrade",shopLevel);
//		}
//		
//		public function getNeedToString():String
//		{
//			return LanguageManager.getWord("ssztl.common.clubAchieveLevel",needClubLevel);
//		}
//		
//		public function getCostToString():String
//		{
//			var result:String = "";
//			if(needClubRich > 0) result = LanguageManager.getWord("ssztl.common.richValue",result + needClubRich);
//			if(needCopper > 0) result = LanguageManager.getWord("ssztl.common.copperValue",result + "，" + needCopper);
//			return result;
//		}
	}
}