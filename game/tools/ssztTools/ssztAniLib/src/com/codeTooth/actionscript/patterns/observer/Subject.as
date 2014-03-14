package com.codeTooth.actionscript.patterns.observer
{	
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.collection.Collection;
	import com.codeTooth.actionscript.lang.utils.collection.collection_internal;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	/**
	 * 观察者订阅的主题
	 */	
	
	public class Subject implements IDestroy
	{
		use namespace collection_internal;
		
		//存储所有的观察者
		private var _observers:Collection = null;
		
		public function Subject()
		{
			_observers = new Collection();
		}
		
		/**
		 * 添加一个观察者
		 * 
		 * @param observerName 指定的观察者名称
		 * @param observer 观察者实例
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的观察者是null，或者名称是null
		 */		
		public function addObserver(observerName:String, observer:IObserver):void
		{
			if(observerName == null)
			{
				throw new NullPointerException("Null observer name");
			}
			
			if(observer == null)
			{
				throw new NullPointerException("Null observer");
			}
			
			_observers.addItem(observerName, observer);
		}
		
		/**
		 * 移除一个观察者
		 * 
		 * @param observerName 指定的观察者名称
		 */		
		public function removeObserver(observerName:String):void
		{
			_observers.removeItem(observerName);
		}
		
		/**
		 * 判断是否存在指定名称的观察者
		 * 
		 * @param observerName 指定的名称
		 * 
		 * @return 
		 */		
		public function hasObserver(observerName:String):Boolean
		{
			return _observers.hasItem(observerName);
		}
		
		/**
		 * 获得观察者实例
		 * 
		 * @param observerName 观察者名称
		 * 
		 * @return
		 */		
		public function getObserver(observerName:String):IObserver
		{
			return IObserver(_observers.getItem(observerName));
		}
		
		/**
		 * 通知所有已经订阅该主题的观察者
		 * 
		 * @param data 指定通知的内容
		 */		
		public function notify(data:Object):void
		{
			var itemIterator:IIterator = _observers.itemIterator();
			while(itemIterator.hasNext())
			{
				IObserver(itemIterator.next()).update(data);
			}
			itemIterator.destroy();
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
				_observers.destroy();
				_observers = null;
		}
	}
}