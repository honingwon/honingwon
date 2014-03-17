package sszt.constData
{
	/**
	 * 人物动作类型值，区别于characterActionType
	 * 比如这里多个攻击，characterActionType只有一个攻击
	 * @author Administrator
	 * 
	 */	
	public class PlayerActionType
	{
		/**
		 * 站
		 */		
		public static const STAND1:int = 0;
		/**
		 * 走
		 */		
		public static const WALK1:int = 1;
		/**
		 * 攻击
		 */		
		public static const ATTACK1:int = 2;
		/**
		 * 被攻击
		 */		
		public static const BEATTACK1:int = 3;
		/**
		 * 死
		 */		
		public static const DEAD1:int = 4;
	}
}