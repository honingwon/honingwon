package sszt.core.data.task
{
	import sszt.core.manager.LanguageManager;

	public class TaskType
	{
		/**
		 * 主线
		 */		
		public static const MAINLINE:uint = 1;
		/**
		 * 支线
		 */		
		public static const BRANCHLINE:uint = 2;
		/**
		 * 循环
		 */		
		public static const COPYLINE:uint = 3;
		/**
		 * 帮会
		 */		
		public static const CLUB:uint = 4;
		/**
		 * 师门
		 */		
		public static const MASTER:uint = 5;
		/**
		 * 修炼
		 */		
		public static const TRAIN:uint = 6;
		/**
		 * 活动 
		 */		
		public static const ACTIVITY:uint = 10;
		/**
		 * 江湖令
		 */	
		public static const TOKEN:uint = 11;
		
		public static function getTaskTypes():Array
		{
			return [MAINLINE,BRANCHLINE,COPYLINE,CLUB,MASTER,TRAIN,TOKEN];
		}
		
		/**
		 * 可委托任务类型
		 * @return 
		 * 
		 */		
		public static function getEntrustTaskTypes():Array
		{
			return [TRAIN];
		}
		
		public static function getNameByType(type:int):String
		{
			switch(type)
			{	
				case MAINLINE:
					return LanguageManager.getWord("ssztl.common.mainLineTask");
				case BRANCHLINE:
					return LanguageManager.getWord("ssztl.common.branchLineTask");
				case COPYLINE:
					return LanguageManager.getWord("ssztl.common.cycleTask");
				case CLUB:
					return LanguageManager.getWord("ssztl.common.clubTask");
				case MASTER:
					return LanguageManager.getWord("ssztl.common.masterTask");
				case TRAIN:
					return LanguageManager.getWord("ssztl.common.trainTask");
				case TOKEN:
					return LanguageManager.getWord("ssztl.common.tokenTask");
			}
			return "";
		}
		
		public static function getNameByType2(type:int):String
		{
			switch(type)
			{
				case MAINLINE:
					return LanguageManager.getWord("ssztl.common.mainLine");
				case BRANCHLINE:
					return LanguageManager.getWord("ssztl.common.branchLine");
				case COPYLINE:
					return LanguageManager.getWord("ssztl.common.cycle");
				case CLUB:
					return LanguageManager.getWord("ssztl.common.club2");
				case MASTER:
					return LanguageManager.getWord("ssztl.common.master");
				case TRAIN:
					return LanguageManager.getWord("ssztl.common.train");
				case TOKEN:
					return LanguageManager.getWord("ssztl.common.token");
			}
			return "";
		}
		
		public static function showState(type:int):Boolean
		{
			switch(type)
			{
				case MASTER:
				case TRAIN:
				case CLUB:
					return true;
			}
			return false;
		}
	}
}