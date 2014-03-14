package com.codeTooth.actionscript.lang.utils
{	
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;

	/**
	 * 字符串助手 
	 */	
	
	public class StringUtils
	{	
		/**
		 * 将字符串转换为布尔型
		 *  
		 * @param str 指定的字符串
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalParameterException 
		 * 指定了非法的字符串
		 * 
		 * @return
		 */		
		public static function toBoolean(str:String):Boolean
		{
			var bool:Boolean;
			
			if(str == "true")
			{
				bool = true;
			}
			else if(str == "false")
			{
				bool = false;
			}
			else
			{
				throw new IllegalParameterException("Illegal parameter : " + str);
			}
			
			return bool;
		}
		
		/**
		 * 截去字符串左右两边的空白字符
		 * 
		 * @param input 想要处理的字符串
		 * 
		 * @return
		 */		
		public static function trim(input:String):String
		{
			return leftTrim(rightTrim(input));
		}
		
		/**
		 * 截去字符串左边的空白字符
		 * 
		 * @param input 想要处理的字符串
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的字符串是null
		 * 
		 * @return 返回处理后的字符串
		 */		
		public static function leftTrim(input:String):String
		{
			if(input == null)
			{
				throw new NullPointerException("Null input string");
			}
			
			var size:Number = input.length;
			for(var i:Number = 0; i < size; i++)
			{
				if(input.charCodeAt(i) > 32)
				{
					return input.substring(i);
				}
			}
			return "";
		}
		
		/**
		 * 截去字符串右边的空白字符
		 * 
		 * @param input 想要处理的字符串
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的字符串是null
		 * 
		 * @return 返回处理后的字符串
		 */
		public static function rightTrim(input:String):String
		{
			if(input == null)
			{
				throw new NullPointerException("Null input string");
			}
			
			var size:Number = input.length;
			for(var i:Number = size; i > 0; i--)
			{
				if(input.charCodeAt(i - 1) > 32)
				{
					return input.substring(0, i);
				}
			}

			return "";
		}
		
		/**
		 * 判断是否是空白字符
		 * 
		 * @param ch
		 * 
		 * @return
		 */		
		public static function isWhitespace(ch:String):Boolean 
		{
			return ch == '\r' || 
					ch == '\n' ||
					ch == '\f' || 
					ch == '\t' ||
					ch == ' '; 
		}
	}
}