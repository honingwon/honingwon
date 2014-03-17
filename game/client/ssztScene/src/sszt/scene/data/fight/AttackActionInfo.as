package sszt.scene.data.fight
{
	import sszt.scene.data.BaseActionInfo;

	public class AttackActionInfo extends BaseActionInfo
	{
		/**
		 * 攻击者
		 */		
		public var actorId:Number;
		public var actorType:int;
		public var actorName:String;
		public var skill:int;
		/**
		 * 技能等级
		 */		
		public var level:int;
		/**
		 * 被攻者
		 */		
		public var targetId:Number;
		public var targetType:int;
		
		public var targetX:Number;
		public var targetY:Number;
		
		/**
		 * 当前HP
		 */		
		public var hp:int;
		/**
		 * hp差值
		 */		
		public var dhp:Array = [];
		/**
		 * 当前mp
		 */		
		public var mp:int;
		/**
		 * mp差值
		 */		
		public var dmp:Array = [];
		/**
		 * 攻击结果类型(attackTargetResultType)
		 */		
		public var attackResultType:int;
		
		
		private static const ACTION_LIST:Array = [];
		private static const MAX_LEN:int = 50;
		
		public function AttackActionInfo()
		{
		}
		
		public function clear() : void
		{
			this.actorId = 0;
			this.actorType = 0;
			this.actorName = null;
			this.skill = 0;
			this.level = 0;
			this.targetId = 0;
			this.targetType = 0;
			this.targetX = 0;
			this.targetY = 0;
			this.hp = 0;
			this.dhp = [];
			this.mp = 0;
			this.dmp = [];
			this.attackResultType =0;
		}
		
		public static function getAttackActionInfo() : AttackActionInfo
		{
			if (ACTION_LIST.length > 0)
			{
				return ACTION_LIST.shift();
			}
			return new AttackActionInfo;
		} 
		
		public static function releaseAttackActionInfo(info:AttackActionInfo) : void
		{
			if (ACTION_LIST.length < MAX_LEN)
			{
			}
			if (ACTION_LIST.indexOf(info) == -1)
			{
				ACTION_LIST.push(info);
				info.clear();
			}
		}
		
		
		
	}
}