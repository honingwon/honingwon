package sszt.core.data.player
{
	import sszt.constData.PropertyType;
	import sszt.core.data.item.PropertyInfo;

	public class DetailPlayerInfo extends FigurePlayerInfo
	{
		/**
		 * 当前血量
		 */		
		public var currentHP:int;
		/**
		 * 当前蓝
		 */		
		private var _currentMP:int;
		public function get currentMP():int
		{
			return _currentMP;
		}
		public function set currentMP(value:int):void
		{
			_currentMP = value;
		}
		/**
		 * 总血量
		 */		
		public var totalHP:int;
		/**
		 * 总蓝
		 */		
		public var totalMP:int;
		/**
		 * 当前帮会贡献
		 */		
		public var currentClubContribute:int;
		/**
		 * 攻
		 */		
		public var attack:int;
		/**
		 * 防
		 */		
		public var defense:int;
		/**
		 * 命中
		 */		
		public var hitTarget:int;
		/**
		 * 闪避
		 */		
		public var duck:int;
		/**
		 * 格挡
		 */		
		public var keepOff:int;
		/**
		 * 暴击
		 */		
		public var powerHit:int;
		/**
		 * 坚韧
		 */		
		public var deligency:int;
		/**
		 * 魔法攻击
		 */		
		public var magicAttack:int;
		/**
		 * 魔法防御
		 */		
		public var magicDefense:int;
		/**
		 * 魔法免伤
		 */		
		public var magicAvoidInHurt:int;
		/**
		 * 远程攻击
		 */	
		public var farAttack:int;
		/**
		 * 远程防御
		 */	
		public var farDefense:int;
		/**
		 * 远程免伤
		 */	
		public var farAvoidInHurt:int;
		/**
		 * 斗气攻击
		 */		
		public var mumpAttack:int;
		/**
		 * 斗气防御
		 */		
		public var mumpDefense:int;
		/**
		 * 斗气免伤
		 */		
		public var mumpAvoidInHurt:int;
		/**
		 *最大体力 
		 */		
		public var maxPhysical:int;
		/**
		 *当前体力 
		 */		
		public var currentPhysical:int;
		/**
		 * 神族声望
		 */		
		public var godRepute:int;
		/**
		 * 魔族声望
		 */		
		public var ghostRepute:int;
		/**
		 * 荣誉值
		 */		
		public var honor:int;
		/**
		 * 历练
		 */		
		public var lifeExperiences:int;
		/**
		 * 总历练
		 */		
		public var totalLifeExperiences:int;
		/**
		 * PK模式更改时间
		 */		
		public var PKModeChangeDate:Date;
		/**攻击压制**/
		public var attackSuppress:int;
		/**防御压制**/
		public var defenseSuppress:int;
		/**
		 *战斗力 
		 */		
		public var fight:int;
		
		/**
		 *伤害
		 */		
		public var damage:int;
		
		/**
		 * 自由属性
		 */		
//		public var freePropertys:Vector.<PropertyInfo> = new Vector.<PropertyInfo>();
		public var freePropertys:Array = [];
		
		public function DetailPlayerInfo()
		{
			super();
		}
		
//		public function setFreePropertys(propertys:Vector.<PropertyInfo>):void
		public function setFreePropertys(propertys:Array):void
		{
			freePropertys = propertys;
			dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.FREE_PROPERTY_UPDATE));
		}
		public function getFreeAttack():int
		{
			for each(var i:PropertyInfo in freePropertys)
			{
				if(i.propertyId == PropertyType.ATTR_ATTACK)
				{
					return i.propertyValue;
				}
			}
			return 0;
		}
		public function getFreeDefense():int
		{
			for each(var i:PropertyInfo in freePropertys)
			{
				if(i.propertyId == PropertyType.ATTR_DEFENSE)
				{
					return i.propertyValue;
				}
			}
			return 0;
		}
		public function getFreeHitTarget():int
		{
			for each(var i:PropertyInfo in freePropertys)
			{
				if(i.propertyId == PropertyType.ATTR_HITTARGET)
				{
					return i.propertyValue;
				}
			}
			return 0;
		}
		public function getFreeDuck():int
		{
			for each(var i:PropertyInfo in freePropertys)
			{
				if(i.propertyId == PropertyType.ATTR_DUCK)
				{
					return i.propertyValue;
				}
			}
			return 0;
		}
		
		public function getPowerHit():int
		{
			for each(var i:PropertyInfo in freePropertys)
			{
				if(i.propertyId == PropertyType.ATTR_POWERHIT)
				{
					return i.propertyValue;
				}
			}
			return 0;
		}
		public function getFreeDeligency():int
		{
			for each(var i:PropertyInfo in freePropertys)
			{
				if(i.propertyId == PropertyType.ATTR_DELIGENCY)
				{
					return i.propertyValue;
				}
			}
			return 0;
		}
		public function getFreePowerHit():int
		{
			for each(var i:PropertyInfo in freePropertys)
			{
				if(i.propertyId == PropertyType.ATTR_POWERHIT)
				{
					return i.propertyValue;
				}
			}
			return 0;
		}
		public function getFreeMumpAttack():int
		{
			for each(var i:PropertyInfo in freePropertys)
			{
				if(i.propertyId == PropertyType.ATTR_MUMPHURTATT)
				{
					return i.propertyValue;
				}
			}
			return 0;
		}
		public function getFreeMumpDefense():int
		{
			for each(var i:PropertyInfo in freePropertys)
			{
				if(i.propertyId == PropertyType.ATTR_MUMPDEFENSE)
				{
					return i.propertyValue;
				}
			}
			return 0;
		}
		public function getFreeMagicDefense():int
		{
			for each(var i:PropertyInfo in freePropertys)
			{
				if(i.propertyId == PropertyType.ATTR_MAGICDEFENCE)
				{
					return i.propertyValue;
				}
			}
			return 0;
		}
		
		public function getAttributeAttack():int
		{
			for each(var i:PropertyInfo in freePropertys)
			{
				if(i.propertyId == PropertyType.ATTRIBUTE_ATTACK)
				{
					return i.propertyValue;
				}
			}
			return 0;
		}
		
		public function getFreeMagicAttack():int
		{
			for each(var i:PropertyInfo in freePropertys)
			{
				if(i.propertyId == PropertyType.ATTR_MAGICHURTATT)
				{
					return i.propertyValue;
				}
			}
			return 0;
		}
		public function getFreeFarDefense():int
		{
			for each(var i:PropertyInfo in freePropertys)
			{
				if(i.propertyId == PropertyType.ATTR_FARDEFENSE)
				{
					return i.propertyValue;
				}
			}
			return 0;
		}
		
		public function getAttackSuppress():int
		{
			for each(var i:PropertyInfo in freePropertys)
			{
				if(i.propertyId == PropertyType.ATTR_SUPPRESSIVE_ATT)
				{
					return i.propertyValue;
				}
			}
			return 0;
		}
		
		public function getDefenseSuppress():int
		{
			for each(var i:PropertyInfo in freePropertys)
			{
				if(i.propertyId == PropertyType.ATTR_SUPPRESSIVE_DEFEN)
				{
					return i.propertyValue;
				}
			}
			return 0;
		}
		
		public function getFreeFarAttack():int
		{
			for each(var i:PropertyInfo in freePropertys)
			{
				if(i.propertyId == PropertyType.ATTR_FARHURTATT)
				{
					return i.propertyValue;
				}
			}
			return 0;
		}
		
		public function updateTotalLifeExperiense(value:int):void
		{
			if(totalLifeExperiences == value)return;
			totalLifeExperiences = value;
			dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.TOTAL_LIFE_EXP_UPDATE));
		}
	}
}
