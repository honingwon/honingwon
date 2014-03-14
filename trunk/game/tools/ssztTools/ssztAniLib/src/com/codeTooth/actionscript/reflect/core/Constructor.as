package com.codeTooth.actionscript.reflect.core
{
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.patterns.iterator.ArrayIterator;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	/**
	 * 构造函数
	 */	
	
	public class Constructor implements IDestroy
	{
		//构造函数入参
		private var _parameters:Array = null;
		
		public function Constructor()
		{
			
		}
		
		/**
		 * 获得构造函数入参迭代器
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 构造函数不需要入参
		 * 
		 * @return 
		 */		
		public function parametersIterator():IIterator
		{
			if(!hasParameters())
			{
				throw new NoSuchObjectException("Has not parameters")
			}
			
			return new ArrayIterator(_parameters);
		}
		
		/**
		 * 判断构造函数是否有入参
		 * 
		 * @return
		 */		
		public function hasParameters():Boolean
		{
			return _parameters != null;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			if(_parameters != null)
			{
				DestroyUtil.breakArray(_parameters);
				_parameters = null;
			}
		}
		
		//设置入参
		internal function set parametersInternal(parameters:Array):void
		{
			_parameters = parameters;
		}
	}
}