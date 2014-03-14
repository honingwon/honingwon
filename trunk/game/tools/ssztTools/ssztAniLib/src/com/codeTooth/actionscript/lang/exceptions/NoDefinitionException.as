package com.codeTooth.actionscript.lang.exceptions
{
	/**
	 * 没有找到类定义
	 */
	
	public class NoDefinitionException extends Error
	{
		public function NoDefinitionException(message:*="", id:*=0)
		{
			super(message, id);
			name = "NoDefinitionException";
		}
	}
}