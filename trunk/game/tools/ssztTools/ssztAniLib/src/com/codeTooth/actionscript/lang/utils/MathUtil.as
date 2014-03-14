package com.codeTooth.actionscript.lang.utils
{
	public class MathUtil
	{	
		public static function isInteger(input:Object):Boolean
		{
			if(isNaN(Number(input)))
			{
				return false;
			}
			else
			{
				var number:Number = Number(input);
				
				return number % 1 == 0;
			}
		}
		
		public static function isUnsignedInteger(input:Object):Boolean
		{
			if(isInteger(input))
			{
				return Number(input) >= 0;
			}
			else
			{
				return false;
			}
		}
	}
}