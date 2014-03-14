package com.codeTooth.actionscript.patterns.iterator
{
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	/**
	 * 数组迭代器
	 */
	
	public class ArrayIterator implements IIterator
	{
		//指定的数组
		private var _array:Array = null;
		
		//迭代器光标位置
		private var _cursor:uint = 0;
		
		private var _length:int = -1;
		
		/**
		 * 构造函数
		 * 
		 * @param array 指定的数组 
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的数组是null
		 */		
		public function ArrayIterator(array:Array)
		{
			if(array == null)
			{
				throw new NullPointerException("Null array");
			}
			
			_array = array;
			_length = _array.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasNext():Boolean
		{
			return _cursor < _length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function next():Object
		{
			if(_cursor >= _length)
			{
				throw new NoSuchObjectException("Has not the element");
			}
			
			return _array[_cursor++];
		}
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			_array = null;
		}
		
		/**
		 * 获得数组迭代器迭代的数组的长度
		 *  
		 * @return
		 */		
		public function get length():int
		{
			return _length;
		}
		
		/**
		 * 获得迭代的数组的一个浅拷贝
		 * 
		 * @return
		 */		
		public function toArray():Array
		{
			var array:Array = new Array();
			for each(var item:Object in _array)
			{
				array.push(item);
			}
			
			return array;
		}
	}
}