package sszt.ui.styles
{
	import flash.text.TextFormat;

	public class TextFormatType
	{
		/**
		 * alert内容
		 * bg11内容
		 */		
		public static const FORMAT1:TextFormat = new TextFormat("SimSun",12,0x311A15,false,null,null,null,null,null,null,null,null,8);
		public static function cloneFormat1():TextFormat
		{
//			return new TextFormat("SimSun",12,0x311A15,false,null,null,null,null,null,null,null,null,8);
			return new TextFormat("SimSun",12,0xFFFFFF,false,null,null,null,null,null,null,null,null,8);
		}
		
		/**
		 * alert标题
		 */		
		public static const FORMAT2:TextFormat = new TextFormat("SimSun",12,0xd4b560,true,null,null,null,null,"center");
		
		/**
		 * 翻页文本样式
		 */		
		public static const FORMAT3:TextFormat = new TextFormat("SimSun",12);
	}
}