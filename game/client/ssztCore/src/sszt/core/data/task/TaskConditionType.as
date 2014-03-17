package sszt.core.data.task
{
	/**
	 * 任务完成要求的类型
	 */
	public class TaskConditionType
	{
		/**
		 * 对话
		 */		
		public static const DIALOG:int = 1;
		/**
		 * 运镖
		 */		
		public static const TRANSPORT:int = 2;
		/**
		 * 充值任务
		 */		
		public static const FILL:int = 3;
		/**
		 * 收集(非绑定物品)
		 */		
		public static const BUY_UNBIND:int = 4;
		/**
		 * 加入帮会
		 */		
		public static const JOIN_CLUB:int = 20;
		/**
		 * 杀怪
		 */		
		public static const KILLMONSTER:int = 21;
		/**
		 * 杀怪掉落(无任务物品)
		 */		
		public static const DROP_MONSTER:int = 22;
		/**
		 * 客户端控制
		 */		
		public static const CLIENT_CONTROL:int = 31;
		/**
		 * 收集(NPC)
		 */		
		public static const COLLECT_NPC:int = 40;
		/**
		 * 收集(怪物)
		 */		
		public static const COLLECT_MONSTER:int = 41;
		/**
		 * 采集
		 */		
		public static const COLLECT_ITEM:int = 42;
		/**
		 * 副本杀怪
		 */		
		public static const COPY_KILLMONSTER:int = 50;
		/**
		 * 副本对话
		 */		
		public static const COPY_DIALOG:int = 51;
		/**
		 * 副本收集
		 */		
		public static const COPY_COLLECT:int = 52;
		/**
		 * 副本采集
		 */		
		public static const COPY_COLLECT_ITEM:int = 53;
		/**
		 * 神魔令任务
		 */
		public static const SHENMOLING:int = 60;
		/**
		 * 红名采集
		 */		
		public static const HONGMING_COLLECT:int = 61;
		/**
		 * 红名杀怪
		 */		
		public static const HONGMING_KILLMONSTER:int = 62;
		
		/**
		 * 是否显示剩余数量
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getShowRequireCount(type:int):Boolean
		{
			switch(type)
			{
				case KILLMONSTER:
				case DROP_MONSTER:
				case COLLECT_MONSTER:
				case COLLECT_NPC:
				case COLLECT_ITEM:
				case COPY_KILLMONSTER:
				case COPY_COLLECT:
				case COPY_COLLECT_ITEM:
				case BUY_UNBIND:
				case HONGMING_COLLECT:
				case HONGMING_KILLMONSTER:
					return true;
			}
			return false;
		}
		
		/**
		 * 判断是不是收集任务
		 * @param type
		 * @return  
		 * 
		 */		
		public static function getIsCollectTask(type:int):Boolean
		{
			switch(type)
			{
				case COLLECT_MONSTER:
				case COLLECT_NPC:
				case BUY_UNBIND:
				case COPY_COLLECT:
					return true;
			}
			return false;
		}
		
		/**
		 * 是否杀怪任务
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getIsKillMonster(type:int):Boolean
		{
			switch(type)
			{
				case COLLECT_MONSTER:
				case KILLMONSTER:
				case DROP_MONSTER:
				case COPY_KILLMONSTER:
				case HONGMING_KILLMONSTER:
					return true;
			}
			return false;
		}
		
		/**
		 * 是否找NPC任务
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getIsFindNpc(type:int):Boolean
		{
			switch(type)
			{
				case DIALOG:
				case TRANSPORT:
				case CLIENT_CONTROL:
				case COLLECT_NPC:
				case FILL:
				case COPY_DIALOG:
					return true;
			}
			return false;
		}
		/**
		 * 是否采集任务
		 * @return 
		 * 
		 */		
		public static function getIsCollectItemTask(type:int):Boolean
		{
			switch(type)
			{
				case COLLECT_ITEM:
				case COPY_COLLECT_ITEM:
				case HONGMING_COLLECT:
					return true;
			}
			return false;
		}
		
		public static function showInFollow(type:int):Boolean
		{
			switch(type)
			{
				case SHENMOLING:
				case HONGMING_COLLECT:
				case HONGMING_KILLMONSTER:
					return false;
			}
			return true;
		}
	}
}