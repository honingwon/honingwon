package sszt.core.data.club
{
	import flash.utils.ByteArray;
	
	import sszt.core.manager.LanguageManager;

	public class ClubLevelTemplate
	{
		public var clubLevel:int;
		public var needRich:int;
		public var needCopper:int;
		public var viceMaster:int
		public var hornor:int;
		public var total:int;
		
		public var maintainFee:int;
		public var requestsNumber:int;
		public var totalMails:int;
		public var dailyCost:int;
		
		public function ClubLevelTemplate()
		{
			
		}
		
		public function parseData(data:ByteArray):void
		{
			
			clubLevel = data.readInt();
			needRich = data.readInt();
			viceMaster = data.readInt();
			hornor = data.readInt();
			total = data.readInt();
			maintainFee = data.readInt();
			requestsNumber = data.readInt();
			totalMails = data.readInt();
//			dailyCost = data.readInt();
		}
		
		
		
		public function getCurEffectToString():String
		{
			return LanguageManager.getWord("ssztl.common.clubMemberIncrease",viceMaster,hornor,total,requestsNumber);
		}
		
		public function getNextEffectToString():String
		{
			return LanguageManager.getWord("ssztl.common.clubMemberIncrease1",viceMaster,hornor,total,requestsNumber);
		}
		
		public function getNeed1ToString():String
		{
			return LanguageManager.getWord("ssztl.common.needClubLevel",clubLevel);
		}
		
		public function getNeed2ToString():String
		{
			return LanguageManager.getWord("ssztl.common.needClubMoney",needRich);
		}
		
		
//		public function getCostToString():String
//		{
//			var result:String = "";
//			if(needRich > 0) result = LanguageManager.getWord("ssztl.common.richValue",result + needRich);
//			if(needCopper > 0) result = LanguageManager.getWord("ssztl.common.copperValue",result + "，" + needCopper);
//			return result;
//		}
	}
}