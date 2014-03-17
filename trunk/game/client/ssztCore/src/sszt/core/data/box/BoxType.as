package sszt.core.data.box
{
	import sszt.core.manager.LanguageManager;

	public class BoxType
	{
		public static const QISHI:int = 1;
		public static const ZHENSHI:int = 2;
		public static const XIANSHI:int = 3;
		public function BoxType()
		{
		}
		
		public static function getBoxNameByType(type:int):String 
		{
			var boxName:String = "";
			switch(type)
			{
				case QISHI:
					boxName = LanguageManager.getWord("ssztl.box.qiShi");
					break;
				case ZHENSHI:
					boxName = LanguageManager.getWord("ssztl.box.zhenShi");
					break;
				case XIANSHI:
					boxName = LanguageManager.getWord("ssztl.box.xianShi");
					break;
			}
			return boxName;
		}
		
		public static function getColorByType(type:int):int
		{
			var colorStr:int = 0xFFFFFF;
			switch(type)
			{
				case QISHI:
					colorStr = 0x8fd947;
					break;
				case ZHENSHI:
					colorStr = 0x35c3f7;
					break;
				case XIANSHI:
					colorStr = 0xa85af0;
					break;
			}
			return colorStr;
		}	
	}
}