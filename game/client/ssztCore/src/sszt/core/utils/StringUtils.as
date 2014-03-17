package sszt.core.utils
{
	import flash.utils.ByteArray;

	public class StringUtils
	{
		/**
		 * 检测文本长度
		 * @param str
		 * @return 
		 * 
		 */		
		public static function checkLen(str:String):int
		{
			var result:int = 0;
			for(var i:int = 0; i < str.length; i++)
			{
				var b:ByteArray = new ByteArray();
				b.writeUTFBytes(str.charAt(i));
				if(b.length == 1)result++;
				else result += 2;
			}
			return result;
		}
		/**
		 * 截取文本长度
		 * @param str
		 * @param len
		 * @return 
		 * 
		 */		
		public static function getLenString(str:String,len:int):String
		{
			var current:int = 0;
			var result:String = "";
			for(var i:int = 0; i < str.length; i++)
			{
				var b:ByteArray = new ByteArray();
				b.writeUTFBytes(str.charAt(i));
				if(b.length == 1)current++;
				else current += 2;
				if(current > len)break;
				else if(current == len)
				{
					result += str.charAt(i);
					break;
				}
				else result += str.charAt(i);
			}
			return result;
		}
		
		/**
		 * 空格  
		 * @param str
		 * @return 
		 * 
		 */		
		public static function checkIsAllSpace(str:String):Boolean{
			var len:int = str.length;
			for(var i:int = 0; i < len; i++)
			{
				if (str.charAt(i) != " "){
					return false;
				}
			}
			return true;
		}
	}
}