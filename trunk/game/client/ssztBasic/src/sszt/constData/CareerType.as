package sszt.constData
{
	public class CareerType
	{
		/**
		 * 岳王宗
		 */		
		public static const SANWU:int = 1;
		/**
		 * 花间派
		 */		
		public static const XIAOYAO:int = 2;
		/**
		 * 唐门
		 */		
		public static const LIUXING:int = 3;
		
		public static function getNameByCareer(career:int):String
		{
			switch(career)
			{
				case SANWU:return "岳王宗";
				case XIAOYAO:return "花间派";
				case LIUXING:return "唐门";
			}
			return "";
		}
		
		/**
		 * 根据职业性别获取头像
		 * @param career
		 * @param sex
		 * @return 
		 * 
		 */		
		public static function getHeadByCareerSex(career:int,sex:Boolean):int
		{
			switch(career)
			{
				case SANWU:return sex ? 0 : 1;
				case XIAOYAO:return sex ? 2 : 3;
				case LIUXING:return sex ? 4 : 5;
			}
			return 0;
		}
	}
}