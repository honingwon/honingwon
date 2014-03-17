package sszt.core.data
{
	public class MapElementType
	{
		public static const EMPTY:int = 0;
		/**
		 * 玩家
		 */		
		public static const PLAYER:int = 1;
		/**
		 * 自己
		 */		
		public static const SELF_PLAYER:int = 2;
		/**
		 * 怪物
		 */		
		public static const MONSTER:int = 3;
		/**
		 * 宠物
		 */		
		public static const PET:int = 4;
		/**
		 * 掉落
		 */		
		public static const FALL_PROP:int = 5;
		/**
		 * 门
		 */		
		public static const DOOR:int = 6;
		/**
		 * NPC
		 */		
		public static const NPC:int = 7;
		/**
		 * BOSS
		 */		
		public static const BOSS:int = 8;
		/**
		 * 采集点
		 */		
		public static const COLLECT_PROP:int = 9;
		/**
		 * 镖车
		 */		
		public static const CAR:int = 10;
		/**
		 * 我方守护塔
		 */		
		public static const OUR_TOWER:int = 13;
		/**
		 * 是否是玩家
		 * @param type
		 * @return 
		 * 
		 */		
		public static function isPlayer(type:int):Boolean
		{
			return type == PLAYER || type == SELF_PLAYER;
		}
		/**
		 * 是否是怪物
		 * @param type
		 * @return 
		 * 
		 */		
		public static function isMonster(type:int):Boolean
		{
			return type == MONSTER || type == BOSS || type == OUR_TOWER;
		}
		/**
		 * 是否挂机时被选择
		 * @param type
		 * @return 
		 * 
		 */	
		public static function isHangupMonster(type:int):Boolean
		{
			return type == MONSTER || type == BOSS;
		}
		
		/**
		 * 是否宠物 
		 * @param type
		 * @return 
		 * 
		 */		
		public static function isPet(type:int):Boolean
		{
			return type == PET;
		}
		
		public static function attackAble(type:int):Boolean
		{
			return type == MONSTER || type == BOSS || type == PLAYER || type == SELF_PLAYER;
		}
		
	}
}