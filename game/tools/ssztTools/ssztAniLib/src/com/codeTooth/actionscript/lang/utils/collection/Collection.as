package com.codeTooth.actionscript.lang.utils.collection
{		
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.utils.ArrayUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	import flash.utils.Dictionary;
	
	/**
	 *  对象收集器
	 */
	
	public class Collection implements IDestroy
	{
		use namespace collection_internal;
		
		//存储所有收集的对象
		private var _items:Dictionary = null;
		
		//收集的对象的数量
		private var _length:int = 0;
		
		public function Collection()
		{
			_items = new Dictionary();
			_length = 0;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			DestroyUtil.breakMap(_items);
		}
		
		/**
		 * @private
		 * 
		 * 获得收集对象的个数
		 * 
		 * @return
		 */		
		collection_internal function get length():int
		{
			return _length;
		}
		
		/**
		 * @private
		 * 
		 * 获得收集器值迭代器
		 * 
		 * @return
		 */		
		collection_internal function itemIterator():IIterator
		{	
			return ArrayUtil.getValuesIteratorOfMap(_items);
		}
		
		/**
		 * @private
		 * 
		 * 获得收集器键迭代器
		 * 
		 * @return 
		 */		
		collection_internal function nameIterator():IIterator
		{
			return ArrayUtil.getKeysIteratorOfMap(_items);
		}
		
		/**
		 * @private
		 * 
		 * 添加一个对象
		 * 
		 * @param itemName 名称
		 * @param item 对象实例
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalOperationException 
		 * 添加了相同名称的对象
		 */		
		collection_internal function addItem(itemName:Object, item:Object):void
		{	
			if(_items[itemName] != undefined)
			{
				throw new IllegalOperationException("Has the same item \"" + itemName + "\"");
			}
			else
			{	
				_items[itemName] = item;
				_length++;
			}
		}
		
		/**
		 * @private
		 * 
		 * 移除一个已添加的对象
		 * 
		 * @param itemName 要删除对象的名称
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalOperationException 
		 * 正在删除不存在的对象
		 */		
		collection_internal function removeItem(itemName:Object):void
		{
			if(_items[itemName] == undefined)
			{
				throw new NoSuchObjectException("Has not the item \"" + itemName + "\"");
			}
			else
			{
				delete _items[itemName];
				_length--;
			}
		}
		
		/**
		 * @private
		 * 
		 * 获得对象
		 * 
		 * @param itemName 要获得的对象的名称
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 正在尝试获得一个不存在的对象
		 * 
		 * @return
		 */		
		collection_internal function getItem(itemName:Object):Object
		{
			if(_items[itemName] == undefined)
			{
				throw new NoSuchObjectException("Has not the item \"" + itemName + "\"");
			}
			
			return _items[itemName];
		}
		
		/**
		 * @private
		 * 
		 * 判断是否存在相应的对象
		 * 
		 * @param itemName 指定对象的名称
		 * 
		 * @return
		 */		
		collection_internal function hasItem(itemName:Object):Boolean
		{
			return _items[itemName] != undefined;
		}
	}
}