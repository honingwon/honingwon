package sszt.rank.data
{
	public class RankType
	{
		public static function getTypeCategory(code:int):int
		{
			return Math.floor(code/10000) * 10000;
		}
		
		/**
		 * 单人排行
		 */
		public static const INDIVIDUAL_RANK:int = 1;
		
		public static const TOP_TYPE_FIGHT:int = 1000;//战斗力排行
		public static const TOP_TYPE_LEVEL:int = 2000;//等级排行
		public static const TOP_TYPE_VEINS:int = 3000;//经脉排行
		public static const TOP_TYPE_GENGU:int = 4000;//根骨排行
		public static const TOP_TYPE_COPPER:int = 5000;//铜币排行
		public static const TOP_TYPE_ACHIEVE:int = 6000;//成就排行
		
		public static function isIndividualRank(type:int):Boolean
		{
			return (type == RankType.TOP_TYPE_FIGHT ||	
				type == RankType.TOP_TYPE_LEVEL ||
				type == RankType.TOP_TYPE_VEINS ||
				type == RankType.TOP_TYPE_GENGU ||
				type == RankType.TOP_TYPE_COPPER ||
				type == RankType.TOP_TYPE_ACHIEVE)
		}
		
		/**
		 * 副本排行
		 */
		public static const COPY_RANK:int = 2;
		
		/**
		 * 遮天阁 - 单人爬塔
		 */
		public static const COPY_TYPE1:Number = 4200601;
		/**
		 * 保卫襄阳 - 单人守护副本
		 */
		public static const COPY_TYPE2:Number = 3202101;
		/**
		 * 恶人谷 - 组队爬塔
		 */
		public static const COPY_TYPE3:Number = 4200701;
		/**
		 * 保卫雁门关 - 初级组队守护副本
		 */
		public static const COPY_TYPE4:Number = 3200301;
		
		
		public static const EQUIP:int = 3;
		public static const MOUNT:int = 4;
		public static const PET:int = 5;
		public static const CLUB:int = 6;
		public static const ACTIVITY:int = 7;
		
		public static const EQUIP1:int = 25;
		public static const EQUIP2:int = 26;
		public static const EQUIP3:int = 27;
		public static const EQUIP4:int = 28;
		public static const EQUIP5:int = 29;
		
		public static const MOUNT1:int = 30;
		public static const MOUNT2:int = 31;
		public static const MOUNT3:int = 32;
		public static const MOUNT4:int = 33;
		
		public static function isMountRank(type:int):Boolean
		{
			return (type == RankType.MOUNT1 ||	
				type == RankType.MOUNT2 ||
				type == RankType.MOUNT3 ||
				type == RankType.MOUNT4
				)
		}
		
		public static const PET1:int = 34;
		public static const PET2:int = 35;
		public static const PET3:int = 36;
		public static const PET4:int = 37;
		
		public static function isPetRank(type:int):Boolean
		{
			return (type == RankType.PET1 ||	
				type == RankType.PET2 ||
				type == RankType.PET3 ||
				type == RankType.PET4)
		}
		
		public static const CLUB1:int = 38;
		
		public static const PVP:int = 39;
		
		public static function isCopyRank(type:int):Boolean
		{
			return (type == RankType.COPY_TYPE1 ||	
				type == RankType.COPY_TYPE2 ||
				type == RankType.COPY_TYPE3 ||
				type == RankType.COPY_TYPE4)
		}
		
		/**
		 * 职业类型
		 */
		public static const ALL_CAREER_TYPE:int = 0;
		public static const YUE_WANG_ZONG:int = 1;
		public static const TANG_MEN:int = 2;
		public static const BAI_HUA_GU:int = 3;
		/**
		 *性别 
		 */
		public static const ALL_SEX_TYPE:int = 0;
		public static const MALE_SEX_TYPE:int = 1;
		public static const FEMALE_SEX_TYPE:int = 2;
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 单人排行
		 */
//		public static const INDIVIDUAL_RANK:int = 1;  //个人排行	
		public static const INDIVIDUA_LEVEL:int = 101;           //等级排行
		public static const INDIVIDUA_MONEY:int = 102;           //财富排行
		public static const INDIVIDUA_STRIKE:int = 103;          //战斗力排行
		public static const INDIVIDUA_PET:int = 104;             //宠物排行
//		/**
//		 * 帮会排行
//		 */
//		public static const CLUB_RANK:int = 20;        //帮会排行
//		public static const CLUB_LEVEL:int = 201;      //帮会等级排行
//		/**
//		 * 副本排行
//		 */
//		public static const COPY_RANK:int = 30;
//		public static const COPY_CHIYUEKU:int = 301;     //赤月窟排行
//		public static const COPY_XIULUOCHANG:int = 302;  //修罗场排行
		/**
		 * 装备排行
		 */
		public static const EQUIP_RANK:int = 40;
		public static const EQUIP_WUQI:int = 401;    //武器排行
		public static const EQUIP_FANGJU:int = 402; //防具排行
		public static const EQUIP_SHIPIN:int = 403;  //饰品排行
		/**
		 * 宠物排行
		 */
		public static const PET_RANK:int = 50;
		public static const PET_LEVEL:int = 501;     //宠物等级排行
		public static const PET_APTITUDE:int = 502;  //宠物资质排行
		public static const PET_GROW:int = 503;      //宠物成长排行
		
		/**
		 * 霸主排行
		 */
		public static const WINNER_RANK:int = 60;
		public static const SHENMO_ISLAND:int = 601;
		
		public var type:String;
		public var pageNum:int;
		
		public function RankType(argType:String, argPageNum:int)
		{
			type = argType;
			pageNum = argPageNum;
		}
	}
}