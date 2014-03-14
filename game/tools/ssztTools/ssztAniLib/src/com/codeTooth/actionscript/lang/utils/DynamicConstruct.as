package com.codeTooth.actionscript.lang.utils
{		
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	/**
	 * 构造函数动态传参，通过参数列表构造对象
	 */
	
	public class DynamicConstruct
	{
		/**
		 * 类似于Function的apply方法来构造一个对象
		 * 
		 * @param definition 创建对象的类定义
		 * @param arguments 参数列表，默认的null或者长度为0的参数列表表示构造不需要参数列表
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的类定义是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalOperationException 
		 * 传入的构造参数列表长度过长，限定只支持9个长度的参数列表
		 * 
		 * @return 返回构造后的对象
		 */		
		public static function newApply(definition:Class, arguments:Array = null):Object
		{
			if(definition == null)
			{
				throw new NullPointerException("Null definition");
			}
			
			var numberArguments:int = arguments == null || arguments.length == 0 ? 0 : arguments.length;
			var object:Object = null;
			switch(numberArguments)
			{
				case 0:
					object = new definition();
					break;
				case 1:
					object = new definition(arguments[0]);
					break;
				case 2:
					object = new definition(arguments[0], arguments[1]);
					break;
				case 3:
					object = new definition(arguments[0], arguments[1], arguments[2]);
					break;
				case 4:
					object = new definition(arguments[0], arguments[1], arguments[2], arguments[3]);
					break;
				case 5:
					object = new definition(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4]);
					break;
				case 6:
					object = new definition(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]);
					break;
				case 7:
					object = new definition(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6]);
					break;
				case 8:
					object = new definition(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7]);
					break;
				case 9:
					object = new definition(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8]);
					break;
				default:
					throw new IllegalOperationException("Length of arguments list more than 9 : " + arguments);
			}
			
			return object;
		}
		
		/**
		 * 类似于Function的call方法来构造一个对象
		 * 
		 * @param definition 创建对象的类定义
		 * @param arguments 参数列表
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的类定义是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalOperationException 
		 * 传入的构造参数列表长度过长，限定只支持9个长度的参数列表
		 * 
		 * @return 返回构造后的对象
		 */		
		public static function newCall(definition:Class, ...arguments):Object
		{
			return newApply(definition, arguments);
		}
	}
}