package sszt.core.data.systemMessage
{
	public class ErrorCode
	{
		/**
		 * 拾取成功
		 */		
		public static const DropItemSuccess:int = 401;
		/**
		 * 无物品
		 */		
		public static const DropItemNoItem:int = 402;
		/**
		 * 距离太远
		 */		
		public static const DropItemToFar:int = 403;
		/**
		 * 不属于
		 */		
		public static const DropItemNoOwn:int = 404;
		/**
		 * 无空间
		 */		
		public static const DropItemNoEnough:int = 405;
		/**
		 * 不能自己和自己创建队伍
		 */		
		public static const TeamSamePlayer:int = 601;
		/**
		 * 双方都有队伍，不能组队
		 */		
		public static const TeamBothHaveTeam:int = 602;
		
	}
}