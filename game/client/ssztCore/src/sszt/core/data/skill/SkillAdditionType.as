package sszt.core.data.skill
{
	import sszt.constData.CareerType;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;

	/**
	 * 技能附加效果类型
	 * @author Administrator
	 * 
	 */	
	public class SkillAdditionType
	{
//		/**
//		 * 普通攻击
//		 */		
//		public static const ACTOR_ATTACK:int = 1;
//		public static const ACTOR_HITTARGET:int = 2;
//		public static const ACTOR_POWERHIT:int = 3;
//		public static const ACTOR_MAGICHURT:int = 4;
//		public static const ACTOR_FARHURT:int = 5;
//		public static const ACTOR_MUMPHURT:int = 6;
//		
//		public static const ACTOR_HP:int = 31;
//		public static const ACTOR_MP:int = 32;
//		public static const ACTOR_SPEED:int = 33;
//		
//		public static const ACTOR_ATTACKSPEED:int = 61;
//		
//		
//		public static const TARGET_DEFENSE:int = 201;
//		public static const TARGET_DUCK:int = 202;
//		public static const TARGET_KEEPOFF:int = 203;
//		public static const TARGET_DELIGENCY:int = 204;
//		public static const TARGET_MAGICDEFENSE:int = 205;
//		public static const TARGET_MAGICAVOIDINHURT:int = 206;
//		public static const TARGET_FARDEFENSE:int = 207;
//		public static const TARGET_FARAVOIDINHURT:int = 208;
//		public static const TARGET_MUMPDEFENSE:int = 209;
//		public static const TARGET_MUMPAVOIDINHURT:int = 210;
//		
//		public static const TARGET_HP:int = 231;
//		public static const TARGET_MP:int = 232;
//		public static const TARGET_SPPED:int = 233;
//		
//		public static const TARGET_ATTACKSPPED:int = 261;
//		
//		/**
//		 * 打断目标动作
//		 */		
//		public static const CANCELTARGETACTION:int = 501;
		
		
		public static const ACTOR_ATTACK:int = 1;
		public static const ACTOR_DEFENCE:int = 2;
		public static const ACTOR_HURT:int = 3;
		public static const ACTOR_MUMPATTACK:int = 4;
		public static const ACTOR_MAGICATTACK:int =5;
		public static const ACTOR_FARATTACK:int = 6;
		public static const ACTOR_MUMPDEFENCE:int = 7;
		public static const ACTOR_MAGICDEFENCE:int = 8;
		public static const ACTOR_FARDEFENCE:int = 9;
		public static const ACTOR_MUMPHURT:int = 10;
		public static const ACTOR_MAGICHURT:int = 11;
		public static const ACTOR_FARHURT:int = 12;
		public static const ACTOR_HP:int = 13;
		public static const ACTOR_MP:int = 14;
		public static const ACTOR_POWERHIT:int = 15;
		public static const ACTOR_DELIGENCY:int = 16;
		public static const ACTOR_HITTARGET:int = 17;
		public static const ACTOR_DUCK:int = 18;
		
		public static const MUMP_FECTH:int = 19; //斗气吸收
		public static const FAR_FECTH:int = 20; //远程吸收
		public static const MAGIC_FECTH:int = 21; //魔法吸收
		public static const ATTACK_WIN:int = 22; //攻击压制
		public static const DEFENCE_WIN:int = 23; //防御压制
		public static const HP_BACK_SPEED:int = 24; //生命恢复速度
		public static const MP_BACK_SPEED:int = 25; //魔法恢复速度
		
		public static const ATTACK_VS_HUMAN:int = 26;//对人种族怪物攻击力
		public static const ATTACK_VS_BEAST:int = 27; //对兽种族怪物攻击力
		public static const ATTACK_VS_GHOST:int = 28; //对魔种族怪物攻击力
		public static const ATTACK:int = 29; //对妖种族攻击力
		
		public static const DEFENCE_VS_HUMAN:int = 30;//对人种族怪物防御力
		public static const DEFENCE_VS_BEAST:int = 31; //对兽种族怪物防御力
		public static const DEFENCE_VS_GHOST:int = 32; //对魔种族怪物防御力
		public static const DEFENCE_VS_DEVIL:int = 33; //对妖种族防御力
		
		public static const HURT_VS_HUMAN:int = 34;//对人种族怪物伤害
		public static const HURT_VS_BEAST:int = 35; //对兽种族怪物伤害
		public static const HURT_VS_GHOST:int = 36; //对魔种族怪物伤害
		public static const HURT_VS_DEVIL:int = 37; //对妖种族伤害
		
		public static const HURT_TO_XIANGWU:int = 38;  //针对尚武伤害
		public static const HURT_TO_XIAOYAO:int = 39;  //针对逍遥伤害
		public static const HURT_TO_LIUXING:int = 40;  //针对流星伤害
		
		public static const HURT_BY_XIANGWU:int = 41;  //受到尚武伤害
		public static const HURT_BY_XIAOYAO:int = 42;  //受到逍遥伤害
		public static const HURT_BY_LIUXING:int = 43;  //受到流星伤害
		
		
		public static const DUCK:int = 44;             //格挡
		public static const ATTACK_SPEED:int = 45;     //攻击速度
		public static const SPEED:int = 46;             //移动速度
		
		public static const CARRAY_PARALYSIS_STATE:int = 47; //附带麻痹状体
		public static const CARRAY_SLEEP_STATE:int = 48; //附带昏迷状态
		public static const CARRAY_CURSE_STATE:int = 49; //附带诅咒状态
		public static const CARRAY_CLOSE_FOOT:int = 50;  //附带封脚状态
		public static const CARRAY_CLOSR_SKILL:int = 51;  //附带封招状态
		
		public static const CARRAY_PARALYSIS_RESISTANCE_STATE:int = 52; //附带麻痹抗性状体
		public static const CARRAY_SLEEP_RESISTANCE_STATE:int = 53; //附带昏迷抗性状态
		public static const CARRAY_CURSE_RESISTANCE_STATE:int = 54; //附带诅咒抗性状态
		public static const CARRAY_CLOSE_RESISTANCE_FOOT:int = 55;  //附带封脚抗性状态
		public static const CARRAY_CLOSR_RESISTANCE_SKILL:int = 56;  //附带封招抗性状态
		
		public static const DOUBLE_SIT_GET_LIFEEXP:int = 57;   //每次双修获得历练
		public static const SIT_GET_LIFEEXP:int = 58 ;         //每次打坐获得历练
		public static const DOUBLE_SIT_GET_EXP:int = 59;     //每次双修获得经验
		public static const SIT_GET_EXP:int = 60;            //每次打坐获得经验
		
		public static const ATTACK_ATTR:int = 61;         //属性攻
		public static const STRONG_DOWM:int = 62;         //强击倒
		public static const INVINCEBLE:int = 63;          //无敌
		public static const HARD_LINE:int = 64;          //硬直
		public static const SLEEP:int = 65;         // 昏迷
		public static const CLOSR_FOOT:int = 66;        // 封脚
		public static const POISIONING:int = 67;         //中毒
		public static const RUIN_HELMET:int = 68;       //碎甲
		public static const WEAK:int = 69;              //衰弱
		public static const MAD_CATTLE:int = 70;        //蛮牛
		
		public static const REDUCE_SPEED:int = 71;//减速		
		public static const ADD_SPEED:int = 72;//加速

		public static const RAGE:int = 74;//狂暴
		public static const DULL:int = 75;//迟钝
		public static const LIFE_REPLY:int = 76;//生命回复
		public static const MAGIC_REPLY:int = 77;//法力回复
		public static const BLOOD:int = 78;//流血
		public static const PARALYSIS:int = 78;//麻痹
		public static const WEEK:int = 79;//虚弱
		public static const FREEZE:int = 80;//冻结
		public static const MORE_EXPERIENCE:int = 81;//多倍经验
		
		public static const EXTENT_TOTAL_HP:int = 82; //生命上限
		public static const EXTENT_HP:int = 83; 		//恢复生命
		
		
		public static const TARGET_ATTACK:int = 201;
		public static const TARGET_DEFENCE:int = 202;
		public static const TARGET_HITTARGET:int = 203;
		public static const TARGET_DUCK:int = 204;
		public static const TARGET_DELIGENCY:int = 205;
		public static const TARGET_POWERHIT:int = 206;
		public static const TARGET_KEEPOFF:int = 207;
		public static const TARGET_MUMPATTACK:int = 208;
		public static const TARGET_FARATTACK:int = 209;
		public static const TARGET_MAGICATTACK:int = 210;
		public static const TARGET_MUMPDEFENCE:int = 211;
		public static const TARGET_FARDEFENCE:int = 212;
		public static const TARGET_MAGICDEFENCE:int = 213;
		public static const TARGET_MUMPAVOIDINHURT:int = 214;
		public static const TARGET_FARAVOIDINHURT:int = 215;
		public static const TARGET_MAGICAVOIDINHURT:int = 216;
		public static const TARGET_HP:int = 217;
		public static const TARGET_MP:int = 218;
		public static const TARGET_SPEED:int = 219;
		public static const TARGET_ATTACKSPEED:int = 220;
		
		public static const ATTR_PHYSICS_HURT_ADD:int = 230;  //物理攻击加成
		public static const ATTR_RANGE_HURT_ADD:int   = 231;  //远程攻击加成
		public static const ATTR_MAGIC_HURT_ADD:int   = 232;  //内力攻击加成
		public static const ATTR_VINDICTIVE_HURT_ADD:int = 233;//外功攻击加成

		public static const TARGET_RELIVE:int = 250;
		
		public static const CLUB_EXP:int = 305;
		public static const CLUB_TRANSPORT:int = 306;
		
		public static const CANCELTARGETACTION:int = 501;
		public static const HITDOWN:int = 502;								//击倒
		public static const SLOW:int = 503;									//减速
		public static const REPEL:int = 504;								//击退
		public static const POISON:int = 505;								//中毒
		
		public static function getStringByType(type:int):String
		{
			var result:String;
			switch (type)
			{
				case ACTOR_ATTACK:
					result = LanguageManager.getWord("ssztl.common.physicalAttack");
					break;
				case ACTOR_DEFENCE:
					result = LanguageManager.getWord("ssztl.common.physicalDefense");
					break;
				case ACTOR_HURT:
					result = LanguageManager.getWord("ssztl.common.physicalHurt");
					break;
				case ACTOR_MUMPATTACK:
					result = LanguageManager.getWord("ssztl.common.mumpAttack") ;
					break;
				case ACTOR_MAGICATTACK:
					result = LanguageManager.getWord("ssztl.common.magicAttack");
					break;
				case ACTOR_FARATTACK:
					result = LanguageManager.getWord("ssztl.common.farAttack");
					break;
				case ACTOR_MUMPDEFENCE:
					result = LanguageManager.getWord("ssztl.common.mumpDefence2");
					break;
				case ACTOR_MAGICDEFENCE:
					result = LanguageManager.getWord("ssztl.common.magicDefence2");
					break;
				case ACTOR_FARDEFENCE:
					result = LanguageManager.getWord("ssztl.common.farDefence2");
					break;
				case ACTOR_MUMPHURT:
					result = LanguageManager.getWord("ssztl.common.mumpHurt");
					break;
				case ACTOR_MAGICHURT:
					result = LanguageManager.getWord("ssztl.common.magicHurt");
					break;
				case ACTOR_FARHURT:
					result = LanguageManager.getWord("ssztl.common.farHurt");
					break;
				case EXTENT_HP:
					result = LanguageManager.getWord("ssztl.common.lifeReback");
					break;
				case ACTOR_HP:
					result = LanguageManager.getWord("ssztl.common.lifeUpLine");
					break;
				case ACTOR_MP:
					result = LanguageManager.getWord("ssztl.common.mpUpLine");
					break;
				case ACTOR_POWERHIT:
					result = LanguageManager.getWord("ssztl.common.powerHit3");
					break;
				case ACTOR_DELIGENCY:
					result = LanguageManager.getWord("ssztl.common.deligency3");
					break;
				case ACTOR_HITTARGET:
					result = LanguageManager.getWord("ssztl.common.hittargeth");
					break;
				case ACTOR_DUCK:
					result = LanguageManager.getWord("ssztl.common.duck3");
					break;
				
				case MUMP_FECTH:
					result = LanguageManager.getWord("ssztl.common.mumpFetch");
					break;
				case FAR_FECTH:
					result = LanguageManager.getWord("ssztl.common.farFetch");
					break;
				case MAGIC_FECTH:
					result = LanguageManager.getWord("ssztl.common.magicFetch");
					break;
				case ATTACK_WIN:
					result = LanguageManager.getWord("ssztl.common.vindictiveAttack2");
					break;
				case DEFENCE_WIN:
					result = LanguageManager.getWord("ssztl.common.vindictiveDefense2");
					break;
				case HP_BACK_SPEED:
					result = LanguageManager.getWord("ssztl.common.lifeBackSpeed");
					break;
				case MP_BACK_SPEED:
					result = LanguageManager.getWord("ssztl.common.mpBackSpeed");
					break;
				
				case ATTACK_VS_HUMAN:
					result = LanguageManager.getWord("ssztl.common.attackHuman");
					break;
				case ATTACK_VS_BEAST:
					result = LanguageManager.getWord("ssztl.common.attackBeast");
					break;
				case ATTACK_VS_GHOST:
					result = LanguageManager.getWord("ssztl.common.attackGhost");
					break;
				case ATTACK:
					result = LanguageManager.getWord("ssztl.common.attackYao");
					break;
				case DEFENCE_VS_HUMAN:
					result = LanguageManager.getWord("ssztl.common.defenseHuman");
					break;
				case DEFENCE_VS_BEAST:
					result = LanguageManager.getWord("ssztl.common.defenseBeast");
					break;
				
				case DEFENCE_VS_GHOST:
					result = LanguageManager.getWord("ssztl.common.defenseGhost");
					break;
				case DEFENCE_VS_DEVIL:
					result = LanguageManager.getWord("ssztl.common.defenseYao");
					break;	
				case HURT_VS_HUMAN:
					result = LanguageManager.getWord("ssztl.common.hurtHuman");
					break;
				case HURT_VS_BEAST:
					result = LanguageManager.getWord("ssztl.common.hurtBeast");
					break;
				case HURT_VS_GHOST:
					result = LanguageManager.getWord("ssztl.common.hurtGhost");
				case HURT_VS_DEVIL:
					result = LanguageManager.getWord("ssztl.common.hurtYao");
					break;
				
				case HURT_TO_XIANGWU:
					result = LanguageManager.getWord("ssztl.common.hurtShangWu");
					break;
				case HURT_TO_XIAOYAO:
					result = LanguageManager.getWord("ssztl.common.hurtXiaoYao");
					break;
				case HURT_TO_LIUXING:
					result =LanguageManager.getWord("ssztl.common.hurtLIuXing")
					break;
				case HURT_BY_XIANGWU:
					result = LanguageManager.getWord("ssztl.common.hurtByShangWu")
					break;
				case HURT_BY_XIAOYAO:
					result = LanguageManager.getWord("ssztl.common.hurtByXiaoYao");
					break;
				case HURT_BY_LIUXING:
					result = LanguageManager.getWord("ssztl.common.hurtByLiuXing");
					break;
				case DUCK:
					result = LanguageManager.getWord("ssztl.common.geDang");
					break;
				case ATTACK_SPEED:
					result = LanguageManager.getWord("ssztl.common.attackSpeed");
					break;
				case SPEED:
					result = LanguageManager.getWord("ssztl.common.moveSpeed");
					break;
				
				case CARRAY_PARALYSIS_STATE:
					result = LanguageManager.getWord("ssztl.common.carrayParalysis");
					break;
				case CARRAY_SLEEP_STATE:
					result = LanguageManager.getWord("ssztl.common.carraySleep");
					break;
				case CARRAY_CURSE_STATE:
					result =LanguageManager.getWord("ssztl.common.carrayCurse");
					break;
				case CARRAY_CLOSE_FOOT:
					result = LanguageManager.getWord("ssztl.common.carrayCloseFoot");
					break;
				case CARRAY_CLOSR_SKILL:
					result = LanguageManager.getWord("ssztl.common.carrayCloseSkill");
					break;
				
				case CARRAY_PARALYSIS_RESISTANCE_STATE:
					result =LanguageManager.getWord("ssztl.common.carrayParalysisResistance");
					break;
				case CARRAY_SLEEP_RESISTANCE_STATE:
					result = LanguageManager.getWord("ssztl.common.carraySleepResistance");
					break;
				case CARRAY_CURSE_RESISTANCE_STATE:
					result = LanguageManager.getWord("ssztl.common.carrayCurseResistance");
					break;
				case CARRAY_CLOSE_RESISTANCE_FOOT:
					result = LanguageManager.getWord("ssztl.common.carrayCloseFootResistance");
					break;
				case CARRAY_CLOSR_RESISTANCE_SKILL:
					result = LanguageManager.getWord("ssztl.common.carrayCloseSkillResistance");
					break;
				
				case DOUBLE_SIT_GET_LIFEEXP:
					result = LanguageManager.getWord("ssztl.common.doubleSitGetLifeExp");
					break;
				case SIT_GET_LIFEEXP:
					result = LanguageManager.getWord("ssztl.common.sitGetLifeExp");
					break;
				case DOUBLE_SIT_GET_EXP:
					result = LanguageManager.getWord("ssztl.common.doubleSitGetExp");
					break;
				case SIT_GET_EXP:
					result = LanguageManager.getWord("ssztl.common.sitGetExp");
					break;
				
				case ATTACK_ATTR:
					if(GlobalData.selfPlayer.career == CareerType.SANWU) result = LanguageManager.getWord("ssztl.common.mumpAttack");
					if(GlobalData.selfPlayer.career == CareerType.XIAOYAO) result = LanguageManager.getWord("ssztl.common.magicAttack");
					if(GlobalData.selfPlayer.career == CareerType.LIUXING) result = LanguageManager.getWord("ssztl.common.farAttack");
					break;
				case STRONG_DOWM:
					result = LanguageManager.getWord("ssztl.common.strongHitDown");
					break;
				case INVINCEBLE:
					result = LanguageManager.getWord("ssztl.common.invinceble");
					break;
				case HARD_LINE:
					result = LanguageManager.getWord("ssztl.common.hardLine");
					break;
				case SLEEP:
					result = LanguageManager.getWord("ssztl.common.sleep");
					break;
				case CLOSR_FOOT:
					result = LanguageManager.getWord("ssztl.common.closeFoot");
					break;
				case POISIONING:
					result = LanguageManager.getWord("ssztl.common.poisioning");
					break;
				case RUIN_HELMET:
					result = LanguageManager.getWord("ssztl.common.ruinHemmet");
					break;
				case WEAK:
					result = LanguageManager.getWord("ssztl.common.weak");
					break;
				case MAD_CATTLE:
					result = LanguageManager.getWord("ssztl.common.madcattle");
					break;
				
				case REDUCE_SPEED:
					result = LanguageManager.getWord("ssztl.common.speedDown");
					break;
				case ADD_SPEED:
					result = LanguageManager.getWord("ssztl.common.speedUp");
					break;
				case RAGE:
					result = LanguageManager.getWord("ssztl.common.rage");
					break;
				case DULL:
					result = LanguageManager.getWord("ssztl.common.dull");
					break;
				case LIFE_REPLY:
					result = LanguageManager.getWord("ssztl.common.lifeReback");
					break;
				case MAGIC_REPLY:
					result = LanguageManager.getWord("ssztl.common.mpReback");
					break;
				case BLOOD:
					result = LanguageManager.getWord("ssztl.common.blood");
					break;
				case PARALYSIS:
					result = LanguageManager.getWord("ssztl.common.paralysis");
					break;
				case WEEK:
					result = LanguageManager.getWord("ssztl.common.weakDown");
					break;
				case FREEZE:
					result = LanguageManager.getWord("ssztl.common.freeze");
					break;
				case MORE_EXPERIENCE:
					result = LanguageManager.getWord("ssztl.common.multiExp");
					break;
				case EXTENT_TOTAL_HP:
					result = LanguageManager.getWord("ssztl.common.totalHP");
					break;
				case TARGET_ATTACK:
					result = LanguageManager.getWord("ssztl.common.attackTarget");
					break;
				case TARGET_DEFENCE:
					result = LanguageManager.getWord("ssztl.common.defenseTarget");
					break;
				case TARGET_HITTARGET:
					result = LanguageManager.getWord("ssztl.common.hitTarget");
					break;
				case TARGET_DUCK:
					result = LanguageManager.getWord("ssztl.common.duckTarget");
					break;
				case TARGET_DELIGENCY:
					result = LanguageManager.getWord("ssztl.common.delicencyTarget");
					break;
				case TARGET_POWERHIT:
					result = LanguageManager.getWord("ssztl.common.powerHitTarget");
					break;
				case TARGET_KEEPOFF:
					result = LanguageManager.getWord("ssztl.common.keepoffTarget");
					break;
				case TARGET_MUMPATTACK:
					result = LanguageManager.getWord("ssztl.common.mumpAttackTarget");
					break;
				case TARGET_FARATTACK:
					result = LanguageManager.getWord("ssztl.common.farAttackTarget");
					break;
				case TARGET_MAGICATTACK:
					result = LanguageManager.getWord("ssztl.common.magicAttackTarget");
					break;
				case TARGET_MUMPDEFENCE:
					result = LanguageManager.getWord("ssztl.common.mumpDefenseTarget");
					break;
				case TARGET_FARDEFENCE:
					result = LanguageManager.getWord("ssztl.common.farDefenseTarget");
					break;	
				case TARGET_MAGICDEFENCE:
					result = LanguageManager.getWord("ssztl.common.magicDefenseTarget");
					break;
				case TARGET_MUMPAVOIDINHURT:
					result = LanguageManager.getWord("ssztl.common.mumpAvoidTarget");
					break;	
				case TARGET_FARAVOIDINHURT:
					result = LanguageManager.getWord("ssztl.common.farAvoidTarget");
					break;
				case TARGET_MAGICAVOIDINHURT:
					result = LanguageManager.getWord("ssztl.common.magicAvoidTarget");
					break;		
				case TARGET_HP:
					result = LanguageManager.getWord("ssztl.common.targetLife");
					break;	
				case TARGET_MP:
					result = LanguageManager.getWord("ssztl.common.targetMp");
					break;	
				case TARGET_SPEED:
					result = LanguageManager.getWord("ssztl.common.targetMoveSpeed");
					break;	
				case TARGET_ATTACKSPEED:
					result = LanguageManager.getWord("ssztl.common.targetAttackSpeed");
					break;	
				case ATTR_PHYSICS_HURT_ADD://230
					result = LanguageManager.getWord("ssztl.common.attackAddition");
					break;
				case ATTR_RANGE_HURT_ADD:
					result = LanguageManager.getWord("ssztl.common.longDistanceAttackAddition");
					break;
				case ATTR_MAGIC_HURT_ADD:
					result = LanguageManager.getWord("ssztl.common.internalAttackAddition");
					break;
				case ATTR_VINDICTIVE_HURT_ADD://233
					result = LanguageManager.getWord("ssztl.common.externalAttackAddition");
					break;
				case TARGET_RELIVE:
					result = LanguageManager.getWord("ssztl.common.targetRelive");
					break;
				case CANCELTARGETACTION:
					result = LanguageManager.getWord("ssztl.common.breakSkill");
					break;	
				case HITDOWN:
					result = LanguageManager.getWord("ssztl.common.hitDown");
					break;
				case SLOW:
					result = LanguageManager.getWord("ssztl.common.slow");
					break;
				case REPEL:
					result = LanguageManager.getWord("ssztl.common.repel");
					break;
				case POISON:
					result = LanguageManager.getWord("ssztl.common.poison");
					break;
				case CLUB_EXP:
					result = LanguageManager.getWord("ssztl.common.clubExp");
					break;
				case CLUB_TRANSPORT:
					result = LanguageManager.getWord("ssztl.common.openClubTransport");
					break;
			}
			return result;
		}
		
		public static function needShowNum(type:int):Boolean
		{
			if(type == HITDOWN)return false;
			if(type == TARGET_RELIVE)return false;
			if(type == SLOW)return false;
			if(type == REPEL)return false;
			if(type == POISON)return false;
			if(type == HP_BACK_SPEED)return false;
			return true;
		}
		
		public static function needShowAdd(type:int):Boolean
		{
			if(type == ATTR_PHYSICS_HURT_ADD)return true;
			if(type == ATTR_RANGE_HURT_ADD)return true;
			if(type == ATTR_MAGIC_HURT_ADD)return true;
			if(type == ATTR_VINDICTIVE_HURT_ADD)return true;
			return false;
		}
	}
}