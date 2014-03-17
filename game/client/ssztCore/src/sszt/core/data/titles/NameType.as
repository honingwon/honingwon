package sszt.core.data.titles
{
	import sszt.core.manager.LanguageManager;

	public class NameType
	{
		public static const CAMP_NAME:int = 1;
		public static const CLUB_NAME:int = 2;
		public static const COUPLES_NAME:int = 5;
		public static const EQUIP_NAME:int = 4;
		public static const LEVEL_NAME:int = 3;
		
		public static const ATTACK:int = 1;
		public static const DEFENSE:int = 2;
		public static const HP:int = 3;
		public static const MP:int = 4;
		public static const FAR_HURT:int = 5;
		
		public static const QUALITY1:int = 1;
		public static const QUALITY2:int = 2;
		public static const QUALITY3:int = 3;
		public static const QUALITY4:int = 4;
		public static const QUALITY5:int = 5;
		
		
		public static function getGroupName(typeId:int):String
		{
			switch(typeId)
			{
				case CAMP_NAME:return LanguageManager.getWord("ssztl.common.cmpTitle");break;
				case CLUB_NAME:return LanguageManager.getWord("ssztl.common.clubTitle");break;
				case COUPLES_NAME:return LanguageManager.getWord("ssztl.common.consortTitle");break;
				case EQUIP_NAME:return LanguageManager.getWord("ssztl.common.equipTitle");break;
				case LEVEL_NAME:return LanguageManager.getWord("ssztl.common.levelTitle");break;
			}
			return "";
		}
		
		public static function getPropertyName(propertyId:int):String
		{
			switch(propertyId)
			{
				case ATTACK:return LanguageManager.getWord("ssztl.common.attack");break;
				case DEFENSE:return LanguageManager.getWord("ssztl.common.defense");break;
				case HP:return LanguageManager.getWord("ssztl.common.hp");break;
				case MP:return LanguageManager.getWord("ssztl.common.mp");break;
				case FAR_HURT:return LanguageManager.getWord("ssztl.common.farAttack");break;
			}
			return "";
		}
		
		public static function getNameColor(qualityId:int):uint
		{
			switch(qualityId)
			{
				case QUALITY1:
					return 0x00ff00;
					break;
				case QUALITY2:
					return 0x00D2FF;
				break ;
				case QUALITY3:
					return 0xF100D7;					
				break;
				case QUALITY4:
					return 0xFFC500;
				break;
				case QUALITY5:
					return 0xF100D7;
				break;
			}
			return 0;
		}
			
	}
}