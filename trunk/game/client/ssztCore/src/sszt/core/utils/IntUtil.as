package sszt.core.utils
{
	public class IntUtil
	{
		private static const FORMATS:Array = ["","0","00","000","0000","00000","000000"];
		/**
		 * 1-->01,001,0001...
		 * @param value
		 * @param format
		 * @return 
		 * 
		 */		
		public static function getIntFormatString(value:int,format:String = "xx"):String
		{
			var len:int = format.length;
			var valueLen:int = String(value).length;
			var dt:int = len - valueLen;
			if(dt > 0)
			{
				return (FORMATS[dt] + value);
			}
			return String(value);
		}
	}
}