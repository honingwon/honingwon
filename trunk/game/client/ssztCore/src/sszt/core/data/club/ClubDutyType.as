package sszt.core.data.club
{
	import sszt.core.manager.LanguageManager;

	public class ClubDutyType
	{
		/**
		 * 无职务
		 */		
		public static const NULL:int = 0;
		/**
		 * 帮主
		 */		
		public static const MASTER:int = 1;
		/**
		 * 副帮主
		 */		
		public static const VICEMASTER:int = 2;
		/**
		 * 长老
		 */		
		public static const HONOR:int = 3;
		/**
		 * 帮众
		 */		
		public static const PREPARE:int = 4;
		
		public function ClubDutyType()
		{
		}
		
		public static function getDutyName(duty:int):String
		{
			switch(duty)
			{	
				case NULL:return LanguageManager.getWord("ssztl.common.none");
				case MASTER:return LanguageManager.getWord("ssztl.common.clubLeader");
				case VICEMASTER:return LanguageManager.getWord("ssztl.common.subClubLeader");
				case HONOR:return LanguageManager.getWord("ssztl.common.zhanglao");
				case PREPARE:return LanguageManager.getWord("ssztl.common.crowd");
			}
			return "";
		}
		
		/**
		 * 帮主
		 * @param duty
		 * @return 
		 * 
		 */		
		public static function getIsMaster(duty:int):Boolean
		{
			return duty == MASTER;
		}
		
		/**
		 * 判断权限是否大于等于副帮主
		 * @param duty
		 * @return 
		 * 
		 */		
		public static function getIsOverViceMaster(duty:int):Boolean
		{
			return duty == MASTER || duty == VICEMASTER;
		}
		
		/**
		 * 判断权限是否大于等于长老
		 */		
		public static function getIsOverHonor(duty:int):Boolean
		{
			return duty == MASTER || duty == VICEMASTER || duty == HONOR;
		}
	}
}