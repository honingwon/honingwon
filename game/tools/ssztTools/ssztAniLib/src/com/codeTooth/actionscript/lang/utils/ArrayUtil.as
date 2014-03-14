package com.codeTooth.actionscript.lang.utils
{	
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.patterns.iterator.ArrayIterator;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	/**
	 * 数组助手ArrayUtil
	 */	
	
	public class ArrayUtil
	{
		/**
		 * 获得一个数组，每个项是map对象的每个值对象<br/>
		 * 获得的值数组不保证顺序
		 * 
		 * @param map	指定的map对象
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的map对象是null
		 * 
		 * @return	 返回一个数组，数组中的每一项是map的值
		 */		
		public static function getValuesArrayOfMap(map:Object):Array
		{
			if(map == null)
			{
				throw new NullPointerException("Null map");
			}
			
			var array:Array = new Array();
			for each(var item:Object in map)
			{
				array.push(item);
			}
			
			return array;
		}
		
		/**
		 * 获得一个数组，每个项是map对象的每个键对象<br/>
		 * 获得的键数组不保证顺序
		 * 
		 * @param map 指定的map对象
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的map对象是null
		 * 
		 * @return 返回一个数组，每一项是map对象的键对象
		 */		
		public static function getKeysArrayOfMap(map:Object):Array
		{
			if(map == null)
			{
				throw new NullPointerException("Null map");
			}
			
			var array:Array = new Array();
			for(var pName:Object in map)
			{
				array.push(pName);
			}
			
			return array;
		}
		
		/**
		 * 获得map对象的值迭代器<br/>
		 * 获得的值迭代器的不保证顺序
		 * 
		 * @param map 指定的map对象
		 * 
		 * @return 返回map对象的值迭代器
		 */		
		public static function getValuesIteratorOfMap(map:Object):IIterator
		{
			return new ArrayIterator(getValuesArrayOfMap(map));
		}
		
		/**
		 * 获得map对象的键迭代器<br/>
		 * 获得的键迭代器的不保证顺序
		 * 
		 * @param map 指定的map对象
		 * 
		 * @return 返回map对象的键迭代器
		 */
		public static function getKeysIteratorOfMap(map:Object):IIterator
		{
			return new ArrayIterator(getKeysArrayOfMap(map));
		}
	}
}