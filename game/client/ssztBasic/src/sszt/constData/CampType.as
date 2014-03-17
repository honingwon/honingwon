package sszt.constData
{
	public class CampType
	{
		/**
		 *无阵营 
		 */		
		public static const WU:int = 0;
		/**
		 *神 
		 */		
		public static const SHEN:int = 1;
		/**
		 *魔 
		 */		
		public static const MO:int = 2;
		/**
		 *人 
		 */	
		public static const REN:int = 3;
		
		public static const ATK_CITY:int = 6;
		
		public static const DEF_CITY:int = 7;
		
		public static function getCampName(campType:int):String
		{
			switch(campType)
			{
				case WU:return "无阵营";
				case SHEN:return "宋";
				case MO:return "辽";
				case REN:return "夏";
				case ATK_CITY:return "进攻";
				case DEF_CITY:return "防守";
			}
			return "";
		}
		
		public function CampType()
		{
		}
	}
}