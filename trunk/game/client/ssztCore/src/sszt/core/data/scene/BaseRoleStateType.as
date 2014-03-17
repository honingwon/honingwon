package sszt.core.data.scene
{
	/**
	 * 角色状态
	 * @author Administrator
	 * 
	 */	
	public class BaseRoleStateType
	{
		/**
		 * 通常状态
		 */		
		public static const COMMON:int = 1;
		/**
		 * 战斗状态
		 */		
		public static const FIGHT:int = 2;
		/**
		 * 死亡状态
		 */		
		public static const DEAD:int = 3;
		
		/**
		 * 吟唱状态
		 */		
		public static const READYFORPOWER:int = 4;
		/**
		 * 击倒
		 */		
		public static const HITDOWN:int = 5;
		
		
		/**
		 * 能否走动
		 * @param type
		 * @return 
		 * 
		 */		
		public static function canWalk(type:int):Boolean
		{
			return type != READYFORPOWER && type != DEAD;
		}
	}
}