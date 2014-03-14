package com.codeTooth.actionscript.lang.utils.nil
{
		
	import flash.utils.Dictionary;
	
	/**
	 * 空对象
	 */	
	
	public class NilUtil
	{
		/**
		 * Object 
		 */		
		public static var NIL_OBJECT:Object = new NilObject();
		
		/**
		 * Dictionary
		 */		
		public static var NIL_DICTIONARY:Dictionary = new NilDictionary();
		
		/**
		 * Array
		 */		
		public static var NIL_ARRAY:Array = new NilArray();
	}
}