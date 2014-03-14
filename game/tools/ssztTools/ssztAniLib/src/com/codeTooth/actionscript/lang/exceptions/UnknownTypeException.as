package com.codeTooth.actionscript.lang.exceptions
{
	/**
	 * 未知的类型
	 */	
	
	public class UnknownTypeException extends Error
	{
		public function UnknownTypeException(message:String="", id:int=0)
		{
			super(message, id);
			name = "UnknownTypeException";
		}
		
	}
}