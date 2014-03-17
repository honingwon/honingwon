package sszt.core.data.copy
{
	import sszt.core.manager.LanguageManager;

	public class CopyType
	{
		public static const EXPCOPY:int = 1;
		public static const EQUIPCOPY:int = 2;
		public static const MATIALCOPY:int = 3;
		public static const FUNCOPY:int = 4;
		public static const ACTIVITYCOPY:int = 5;
		public static const PVPCOPY:int = 6;
		
		public function CopyType()
		{
			
		}
		
		public static function getNameByType(type:int):String
		{
			var result:String = "";
			switch (type)
			{
				case EXPCOPY:
					result = LanguageManager.getWord("ssztl.common.expCopy");
					break;
				case EQUIPCOPY:
					result = LanguageManager.getWord("ssztl.common.equipCopy")
					break;
				case MATIALCOPY:
					result = LanguageManager.getWord("ssztl.common.materialCopy")
					break;
				case FUNCOPY:
					result = LanguageManager.getWord("ssztl.common.funnyCopy")
					break;
				case ACTIVITYCOPY:
					result = LanguageManager.getWord("ssztl.common.activityCopy")
					break;
				case PVPCOPY:
					result = LanguageManager.getWord("ssztl.common.pvpCopy")
					break;
			}
			return result;
		}
		
		public static function getActivityNameByType(type:int):String
		{
			var result:String = "";
			switch (type)
			{
				case EXPCOPY:
					result = LanguageManager.getWord("ssztl.common.experience2")
					break;
				case EQUIPCOPY:
					result = LanguageManager.getWord("ssztl.common.equip2")
					break;
				case MATIALCOPY:
					result = LanguageManager.getWord("ssztl.common.material")
					break;
				case FUNCOPY:
				case ACTIVITYCOPY:
				case PVPCOPY:
					result = LanguageManager.getWord("ssztl.common.suggest")
					break;
			}
			return result;
		}
		
		public static function getRecommondByType(type:int):String
		{
			var result:String = "";
			switch (type)
			{
				case 1:
					result = LanguageManager.getWord("ssztl.common.suggest");
					break;
				case 2:
					result = LanguageManager.getWord("ssztl.common.powerSuggest")
					break;
				case 3:
					result = LanguageManager.getWord("ssztl.common.furySuggest")
					break;	
			}
			return result;
		}
	}
}