package sszt.core.data.PK
{
	import sszt.core.manager.LanguageManager;

	public class PKType
	{
		/**
		 * 和平
		 */		
		public static const PEACE:int = 0;
		/**
		 * 全体
		 */		
		public static const FREE:int = 1;
		/**
		 * 善恶
		 */		
		public static const GOODNESS:int = 2;
		/**
		 * 队伍
		 */		
		public static const TEAM:int = 3;
		/**
		 * 帮会
		 */		
		public static const CLUB:int  = 4;
		/**
		 * 阵营
		 */		
		public static const CAMP:int = 5;
		
		/**
		 * 模式更改间隔(分钟)
		 */		
		public static const CHANGE_CD:int = 30;
		
		public static function getModeName(type:int):String
		{
			switch(type)
			{
				case PEACE:return LanguageManager.getWord("ssztl.common.peace");
				case FREE:return LanguageManager.getWord("ssztl.common.free");
				case GOODNESS:return LanguageManager.getWord("ssztl.common.goodness");
				case TEAM:return LanguageManager.getWord("ssztl.common.team");
				case CLUB:return LanguageManager.getWord("ssztl.common.club");
				case CAMP:return LanguageManager.getWord("ssztl.common.camp");
			}
			return "";
		}
	}
}