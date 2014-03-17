package sszt.scene.data.types
{
	public class PlayerHangupType
	{
		/**
		 * 不挂机，不攻击
		 */		
		public static const NONE:int = 0;
		/**
		 * 持续攻击一个对象
		 */		
		public static const ATTACKONE:int  = 1;
		/**
		 * 挂机
		 */		
		public static const HANGUP:int = 2;
		/**
		 * 挂机去捡道具
		 */		
		public static const HANGUPTOPICK:int = 3;
		
		/**
		 * 是否正在挂机，包括挂机和挂机捡道具
		 * @param type
		 * @return 
		 * 
		 */		
		public static function inHangup(type:int):Boolean
		{
			return type == HANGUP || type == HANGUPTOPICK;
		}
		
		/**
		 * 攻击一只
		 * @param type
		 * @return 
		 * 
		 */		
		public static function isHangupOne(type:int):Boolean
		{
			return type == ATTACKONE;
		}
		
		/**
		 * 挂机攻击中
		 * @param type
		 * @return 
		 * 
		 */		
		public static function isHangupAttack(type:int):Boolean
		{
			return type == HANGUP;
		}
		
		/**
		 * 挂机捡道具中
		 * @param type
		 * @return 
		 * 
		 */		
		public static function isHangupPickup(type:int):Boolean
		{
			return type == HANGUPTOPICK;
		}
		
		/**
		 * 
		 * @param type
		 * @return 
		 * 
		 */		
		public static function hangupNone(type:int):Boolean
		{
			return type == NONE;
		}
	}
}