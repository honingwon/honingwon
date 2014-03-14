package com.codeTooth.actionscript.patterns.iterator
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

	/**
	 * 迭代器接口
	 */
	
	public interface IIterator extends IDestroy
	{
		/**
		 * 判断迭代器中是否还有下一个元素
		 * 
		 * @return
		 */		
		function hasNext():Boolean;
		
		/**
		 * 获得迭代器中的下一个元素
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 迭代器中已经没有下一个元素
		 * 
		 * @return
		 */		
		function next():Object;
	}
}