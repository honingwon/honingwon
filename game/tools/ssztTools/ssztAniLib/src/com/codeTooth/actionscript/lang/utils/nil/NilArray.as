package com.codeTooth.actionscript.lang.utils.nil
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	
	/**
	 * @private
	 * 
	 * 空数组，对该对象进行添加或删除元素的操作将引发异常
	 */	
	
	internal class NilArray extends Array
	{
		use namespace AS3;
		
		public function NilArray()
		{
			
		}
		
		override public function get length():uint
		{
			return 0;
		}
		
		override public function set length(length:uint)
		{
			if(length != 0)
			{
				throw new IllegalOperationException();
			}
		}
		
		override AS3 function pop():*
		{
			throw new IllegalOperationException();
			return null;
		}
		
		override AS3 function push(...args):uint
		{
			throw new IllegalOperationException();
			return 0;
		}
		
		override AS3 function shift():*
		{
			throw new IllegalOperationException();
			return null;
		}
		
		override AS3 function splice(...args):*
		{
			throw new IllegalOperationException();
			return null;
		}
		
		override AS3 function unshift(...args):uint
		{
			throw new IllegalOperationException();
			return 0;
		}
	}
}