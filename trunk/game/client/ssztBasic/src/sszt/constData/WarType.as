package sszt.constData
{
	public class WarType
	{
		/**
		 * 无阵营
		 */		
		public static const NONE:int = 0;
		/**
		 * 神
		 */		
		public static const SHEN:int = 1;
		/**
		 * 魔
		 */		
		public static const MO:int = 2;
		/**
		 * 人
		 */		
		public static const REN:int = 3;
		
		public static function getNameByWarState(argState:int):String
		{
			switch(argState)
			{
				case NONE:return "无阵营";
				case SHEN:return "宋";
				case MO:return "辽";
				case REN:return "夏";
			}
			return "";
		}
		
		public static function getStateColor(argState:int):int
		{
			switch (argState)
			{
				case NONE:return 0xFFFFFF;
				case SHEN:return 0x0066FF;
				case MO:return 0xFF9900;
				case REN:return 0x00FF00;
			}
			return 0xFFFFFF;
		}
		
		public static function getStateColorString(argState:int):String
		{
			switch (argState)
			{
				case NONE:return "FFFFFF";
				case SHEN:return "0066FF";
				case MO:return "FF9900";
				case REN:return "00FF00";
			}
			return "FFFFFF";
		}
	}
}