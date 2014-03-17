package sszt.core.data.im
{
	import sszt.core.manager.LanguageManager;

	public class ImSysMessageType
	{
		
		public function ImSysMessageType()
		{
		}
		
		public static function getMessageByType(type:int):String
		{
			switch (type)
			{
				case 1:
					return LanguageManager.getWord("ssztl.common.noAddSelf");
					break;
				case 2:
					return LanguageManager.getWord("ssztl.common.friendNotExist");
					break;
				case 3:
					return LanguageManager.getWord("ssztl.common.beRefused");
					break;
				case 11:
					return LanguageManager.getWord("ssztl.common.friendExist");
					break;
				case 12: 
					return LanguageManager.getWord("ssztl.common.blackListExist");
					break;
				case 13:
					return LanguageManager.getWord("ssztl.common.enemyExist");
					break;
				case 14:
					return LanguageManager.getWord("ssztl.common.notOnline");
					break;
				case 21:
					return LanguageManager.getWord("ssztl.common.friendAchieveMax");
					break;
				case 22:
					return LanguageManager.getWord("ssztl.common.blackListAchieveMax");
					break;
			}
			return "";
		}
	}
}