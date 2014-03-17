package sszt.constData
{
	import mx.rpc.Fault;

	public class PropertyType
	{
		/**
		 * 战斗力
		 */	
		public static const ATTR_SWORD:int = 0;
		/**
		 * 普通攻击
		 */		
		public static const ATTR_ATTACK:int = 1; 
		/**
		 * 普通防御
		 */
		public static const ATTR_DEFENSE:int = 2;
		/**
		 * 普通伤害
		 */
		public static const ATTR_DAMAGE:int = 3;
		/**
		 * 外攻攻击
		 */
		public static const ATTR_MUMPHURTATT:int = 4;
		/**
		 * 内攻攻击
		 */
		public static const ATTR_MAGICHURTATT:int = 5;
		/**
		 * 远程攻击
		 */		
		public static const ATTR_FARHURTATT:int = 6;
		/**
		 * 外攻防御
		 */		
		public static const ATTR_MUMPDEFENSE:int = 7;
		/**
		 * 内攻防御
		 */		
		public static const ATTR_MAGICDEFENCE:int = 8;
		/**
		 * 远程防御
		 */		
		public static const ATTR_FARDEFENSE:int = 9;
		/**
		 * 外攻伤害
		 */		
		public static const ATTR_MUMPHURT:int = 10;
		/**
		 * 内攻伤害
		 */		
		public static const ATTR_MAGICHURT:int = 11;
		/**
		 * 远程伤害
		 */		
		public static const ATTR_FARHURT:int = 12;
		/**
		 * 生命
		 */		
		public static const ATTR_HP:int = 13;
		/**
		 * 法力
		 */		
		public static const ATTR_MP:int = 14;
		/**
		 * 暴击
		 */		
		public static const ATTR_POWERHIT:int = 15;
		/**
		 * 坚韧
		 */		
		public static const ATTR_DELIGENCY:int = 16;
		/**
		 * 命中
		 */		
		public static const ATTR_HITTARGET:int = 17;
		/**
		 * 闪避
		 */		
		public static const ATTR_DUCK:int =  18;
		/**
		 * 外攻伤害减免
		 */		
		public static const ATTR_MUMPAVOIDINHURT:int = 19;
		/**
		 * 远程伤害减免
		 */		
		public static const ATTR_FARAVOIDINHURT:int = 20;
		/**
		 * 内攻伤害减免
		 */		
		public static const ATTR_MAGICAVOIDINHURT:int = 21;
		/**
		 * 攻击压制
		 */		
		public static const ATTR_SUPPRESSIVE_ATT:int = 22;
		/**
		 * 防御压制
		 */		
		public static const ATTR_SUPPRESSIVE_DEFEN:int = 23;
		/**
		 * 生命回复速度
		 */		
		public static const ATTR_RESUME_HP_SPEED:int = 24;
		/**
		 * 法力回复速度
		 */		
		public static const ATTR_RESUME_MP_SPEED:int = 25;
		/**
		 * 对人种族怪物攻击力
		 */		
		public static const ATTR_HUMAN_ATTACK:int = 26;
		/**
		 * 对兽种族怪物攻击力
		 */		
		public static const ATTR_ORC_ATTACK:int = 27;
		/**
		 * 对魔种族怪物攻击力
		 */		
		public static const ATTR_NIGHTMARE_ATTACK:int = 28;
		/**
		 * 对妖种族怪物攻击力
		 */		
		public static const ATTR_EVILKIND_ATTACK:int = 29;
		/**
		 * 对人种族怪物防御力
		 */		
		public static const ATTR_HUMAN_DEFENSE:int = 30;
		/**
		 * 对兽种族怪物防御力
		 */		
		public static const ATTR_ORC_DEFENSE:int = 31;
		/**
		 * 对魔种族怪物防御力
		 */		
		public static const ATTR_NIGHTMARE_DEFENSE:int = 32;
		/**
		 * 对妖种族怪物防御力
		 */		
		public static const ATTR_EVILKIND_DEFENSE:int = 33;
		/**
		 * 对人种族怪物伤害
		 */		
		public static const ATTR_HUMAN_DEMAGE:int = 34;
		/**
		 * 对兽种族怪物伤害
		 */	
		public static const ATTR_ORC_DEMAGE:int = 35;
		/**
		 * 对魔种族怪物伤害
		 */		
		public static const ATTR_NIGHTMARE_DEMAGE:int = 36;
		/**
		 * 对妖种族怪物伤害
		 */		
		public static const ATTR_EVILKIND_DEMAGE:int = 37;
		/**
		 * 针对尚武伤害
		 */		
		public static const ATTR_DEMAGE_TO_SHANGWU:int = 38;
		/**
		 * 针对逍遥伤害
		 */		
		public static const ATTR_DEMAGE_TO_XIAOYAO:int = 39;
		/**
		 * 针对流星伤害
		 */		
		public static const ATTR_DEMAGE_TO_LIUXING:int = 40;
		/**
		 * 受到尚武伤害
		 */		
		public static const ATTR_DEMAGE_FROM_SHANGWU:int = 41;
		/**
		 * 受到逍遥伤害
		 */		
		public static const ATTR_DEMAGE_FROM_XIAOYAO:int = 42;
		/**
		 * 受到流星伤害
		 */		
		public static const ATTR_DEMAGE_FROM_LIUXING:int = 43;
		/**
		 *属性攻 
		 */		
		public static const ATTRIBUTE_ATTACK:int = 61;
		
		public static function getName(type:int):String
		{
			switch(type)
			{
				case ATTR_ATTACK:return "攻击"; 
				case ATTR_DEFENSE:return "防御"; 
				case ATTR_DAMAGE:return "绝对伤害"; 
				case ATTR_MUMPHURTATT:return "外功攻击"; 
				case ATTR_MAGICHURTATT:return "内力攻击"; 
				case ATTR_FARHURTATT:return "远程攻击"; 
				case ATTR_MUMPDEFENSE:return "外功防御"; 
				case ATTR_MAGICDEFENCE:return "内力防御"; 
				case ATTR_FARDEFENSE:return "远程防御"; 
				case ATTR_MUMPHURT:return "外功伤害"; 
				case ATTR_MAGICHURT:return "内力伤害"; 
				case ATTR_FARHURT:return "远程伤害"; 
				case ATTR_HP:return "生命"; 
				case ATTR_MP:return "法力"; 
				case ATTR_POWERHIT:return "暴击"; 
				case ATTR_DELIGENCY:return "坚韧"; 
				case ATTR_HITTARGET:return "命中"; 
				case ATTR_DUCK:return "闪避";  
				case ATTR_MUMPAVOIDINHURT:return "外功伤害减免"; 
				case ATTR_FARAVOIDINHURT:return "远程伤害减免"; 
				case ATTR_MAGICAVOIDINHURT:return "内力伤害减免"; 
				case ATTR_SUPPRESSIVE_ATT:return "攻击压制"; 
				case ATTR_SUPPRESSIVE_DEFEN:return "防御压制"; 
				case ATTR_RESUME_HP_SPEED:return "生命回复速度"; 
				case ATTR_RESUME_MP_SPEED:return "法力回复速度"; 
				case ATTR_HUMAN_ATTACK:return "对人种族怪物攻击力"; 
				case ATTR_ORC_ATTACK:return "对兽种族怪物攻击力"; 
				case ATTR_NIGHTMARE_ATTACK:return "对魔种族怪物攻击力"; 
				case ATTR_EVILKIND_ATTACK:return "对妖种族怪物攻击力"; 
				case ATTR_HUMAN_DEFENSE:return "对人种族怪物防御力"; 
				case ATTR_ORC_DEFENSE:return "对兽种族怪物防御力"; 
				case ATTR_NIGHTMARE_DEFENSE:return "对魔种族怪物防御力"; 
				case ATTR_EVILKIND_DEFENSE:return "对妖种族怪物防御力"; 
				case ATTR_HUMAN_DEMAGE:return "对人种族怪物伤害"; 
				case ATTR_ORC_DEMAGE:return "对兽种族怪物伤害"; 
				case ATTR_NIGHTMARE_DEMAGE:return "对魔种族怪物伤害"; 
				case ATTR_EVILKIND_DEMAGE:return "对妖种族怪物伤害"; 
				case ATTR_DEMAGE_TO_SHANGWU:return "针对尚武伤害"; 
				case ATTR_DEMAGE_TO_XIAOYAO:return "针对逍遥伤害"; 
				case ATTR_DEMAGE_TO_LIUXING:return "针对流星伤害"; 
				case ATTR_DEMAGE_FROM_SHANGWU:return "受到尚武伤害"; 
				case ATTR_DEMAGE_FROM_XIAOYAO:return "受到逍遥伤害"; 
				case ATTR_DEMAGE_FROM_LIUXING:return "受到流星伤害";
			}
			return "";
		}
		
		public static function getAttributeFight(type:int, value:int):Number
		{
			switch(type)
			{
				case ATTR_ATTACK:return value; 
				case ATTR_DEFENSE:return value; 
//				case ATTR_DAMAGE:return value; 
				case ATTR_MUMPHURTATT:return value * 1.5; 
				case ATTR_MAGICHURTATT:return value * 1.5; 
				case ATTR_FARHURTATT:return value * 1.5; 
				case ATTR_MUMPDEFENSE:return value * 0.5; 
				case ATTR_MAGICDEFENCE:return value * 0.5; 
				case ATTR_FARDEFENSE:return value * 0.5; 
//				case ATTR_MUMPHURT:return value; 
//				case ATTR_MAGICHURT:return value; 
//				case ATTR_FARHURT:return value; 
				case ATTR_HP:return value * 0.2; 
				case ATTR_MP:return 0; 
				case ATTR_POWERHIT:return value * 5; 
				case ATTR_DELIGENCY:return value * 5; 
				case ATTR_HITTARGET:return value * 5; 
				case ATTR_DUCK:return value * 5;  
//				case ATTR_MUMPAVOIDINHURT:return "外攻伤害减免"; 
//				case ATTR_FARAVOIDINHURT:return "远程伤害减免"; 
//				case ATTR_MAGICAVOIDINHURT:return "内攻伤害减免"; 
//				case ATTR_SUPPRESSIVE_ATT:return "攻击压制"; 
//				case ATTR_SUPPRESSIVE_DEFEN:return "防御压制"; 
//				case ATTR_RESUME_HP_SPEED:return "生命回复速度"; 
//				case ATTR_RESUME_MP_SPEED:return "法力回复速度"; 
//				case ATTR_HUMAN_ATTACK:return "对人种族怪物攻击力"; 
//				case ATTR_ORC_ATTACK:return "对兽种族怪物攻击力"; 
//				case ATTR_NIGHTMARE_ATTACK:return "对魔种族怪物攻击力"; 
//				case ATTR_EVILKIND_ATTACK:return "对妖种族怪物攻击力"; 
//				case ATTR_HUMAN_DEFENSE:return "对人种族怪物防御力"; 
//				case ATTR_ORC_DEFENSE:return "对兽种族怪物防御力"; 
//				case ATTR_NIGHTMARE_DEFENSE:return "对魔种族怪物防御力"; 
//				case ATTR_EVILKIND_DEFENSE:return "对妖种族怪物防御力"; 
//				case ATTR_HUMAN_DEMAGE:return "对人种族怪物伤害"; 
//				case ATTR_ORC_DEMAGE:return "对兽种族怪物伤害"; 
//				case ATTR_NIGHTMARE_DEMAGE:return "对魔种族怪物伤害"; 
//				case ATTR_EVILKIND_DEMAGE:return "对妖种族怪物伤害"; 
//				case ATTR_DEMAGE_TO_SHANGWU:return "针对尚武伤害"; 
//				case ATTR_DEMAGE_TO_XIAOYAO:return "针对逍遥伤害"; 
//				case ATTR_DEMAGE_TO_LIUXING:return "针对流星伤害"; 
//				case ATTR_DEMAGE_FROM_SHANGWU:return "受到尚武伤害"; 
//				case ATTR_DEMAGE_FROM_XIAOYAO:return "受到逍遥伤害"; 
//				case ATTR_DEMAGE_FROM_LIUXING:return "受到流星伤害";
			}
			return value;
		}
		
		public static function getAttributeName(type:int, career:int):String
		{
			var result:String = "";
//			if (type == ATTRIBUTE_ATTACK){
//				if (career == CareerType.SANWU){
//					result = ATTR_MUMPHURTATT_NAME;
//				} else {
//					if (career == CareerType.XIAOYAO){
//						result = ATTR_MAGICHURTATT_NAME;
//					} else {
//						if (career == CareerType.LIUXING){
//							result = ATTR_FARHURTATT_NAME;
//						};
//					};
//				};
//			};
			return (result);
		}
	}
}
