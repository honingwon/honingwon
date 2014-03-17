package sszt.constData
{
	public class VipType
	{
		public static const NORMAL:int = 0;
		public static const VIP:int = 1;
		public static const BETTERVIP:int = 2;
		public static const BESTVIP:int = 3;
		public static const OneDay:int = 4;
		public static const OneHour:int = 5;
		
		public function VipType()
		{
			
		}
		
		public static function getNameByType(type:int):String
		{
			var result:String = "";
			switch (type)
			{
				case NORMAL:
					result = "普通玩家";
					break;
				case VIP:
					result = "普通VIP玩家";
					break;
				case BETTERVIP:
					result = "高级VIP玩家";
					break;
				case BESTVIP:
					result = "至尊VIP玩家";
					break;
				case OneDay:
					result = "一天VIP玩家";
					break;
				case OneHour:
					result = "体验VIP玩家";
					break;
			}
			return result;
		}
		
		public static function getColorByType(type:int):int
		{
			switch (type)
			{
				case OneDay:
				case OneHour:
				case BETTERVIP:return 0x35c3f7;
				case VIP:return 0x8fd947;
				case BESTVIP:return 0xa85af0;		
			}
			return 0xFFFFFF;	
		}
		
		public static function getIsGM(type:int):Boolean
		{
			return (type & 2) > 0
		}
		
		public static function getIsNewlyGuide(type:int):Boolean
		{
			return (type & 1) > 0;
		}
		
		public static function getVipType(vipType:int):int
		{
			var type:int = 0;
			if((vipType & 4) > 0)type = 1;
			else if((vipType & 8) > 0)type = 2;
			else if((vipType & 16) > 0)type = 3;
			else if((vipType & 32) > 0)type = 4;
			else if((vipType & 64) > 0)type = 5;
			return type;
		}
	}
}