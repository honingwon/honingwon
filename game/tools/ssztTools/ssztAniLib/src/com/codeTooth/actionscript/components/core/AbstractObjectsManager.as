package com.codeTooth.actionscript.components.core
{
	import com.codeTooth.actionscript.classesLoader.core.ClassesLoader;
	import com.codeTooth.actionscript.classesLoader.core.ClassesLoaderEvent;
	import com.codeTooth.actionscript.dependencyInjection.core.DiContainer;
	import com.codeTooth.actionscript.dependencyInjection.core.DiXMLLoader;
	import com.codeTooth.actionscript.lang.errors.AbstractError;
	import com.codeTooth.actionscript.lang.utils.collection.Collection;
	import com.codeTooth.actionscript.lang.utils.collection.collection_internal;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	/**
	 * @private
	 * 
	 * 抽象的对象管理器
	 */	
	
	internal class AbstractObjectsManager
	{
		// 事件发送代理
		private var _eventDispatcherDelegate:IEventDispatcher;
		
		/**
		 * 构造函数
		 * 
		 * @param definitionsLoaderName 加载的名称
		 * @param eventDispatcherDelegate 事件发送代理
		 * @param diXML 注入的XML
		 */		
		public function AbstractObjectsManager(definitionsLoaderName:String, eventDispatcherDelegate:IEventDispatcher, diXML:XML)
		{
			_eventDispatcherDelegate = eventDispatcherDelegate;
			
			_definitionsLoaderName = definitionsLoaderName;
			
			_definitionsLoader = new ClassesLoader();
			
			_collection = new Collection();
			
			_diContainer = new DiContainer();
			_diContainer.load(new DiXMLLoader(), diXML);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 类定义加载器
		//--------------------------------------------------------------------------------------------------------------------------
		
		// 类定义加载器
		private var _definitionsLoader:ClassesLoader;
		
		// 加载的名称
		private var _definitionsLoaderName:String;
		
		// 是否正在加载
		private var _isLoading:Boolean = false;
		
		public function loadDeinitions(url:String):void
		{
			if(_definitionsLoader.hasLoader(_definitionsLoaderName))
			{
				_definitionsLoader.unload(_definitionsLoaderName);
			}
			
			if(_isLoading)
			{
				removeDefinitionsLoaderEventListeners();
			}
			
			_isLoading = true;
			addDefinitionsLoaderEventListeners();
			
			// 加载到新的应用程序域
			var applicationDomain:ApplicationDomain = new ApplicationDomain();
			_diContainer.applicationDomain = applicationDomain;
			
			_definitionsLoader.load(_definitionsLoaderName, url, ClassesLoader.LOAD_TYPE_URL, applicationDomain);
		}
		
		/**
		 * @private
		 * 
		 * 抽象方法<br/>
		 * 当加载结束后调用，更新所有已经注册的对象
		 * 
		 * @param iterator
		 */		
		protected function update(iterator:IIterator):void
		{
			throw new AbstractError();
		}
		
		// 添加加载侦听
		private function addDefinitionsLoaderEventListeners():void
		{
			_definitionsLoader.addEventListener(ClassesLoaderEvent.COMPLETE, definitionsLoaderCompleteHandler);
			_definitionsLoader.addEventListener(ClassesLoaderEvent.IO_ERROR, definitionsLoaderIOErrorHandler);
			_definitionsLoader.addEventListener(ClassesLoaderEvent.SECURITY_ERROR, definitinosLoaderSecurityErrorHandler);
		}
		
		// 移除加载侦听
		private function removeDefinitionsLoaderEventListeners():void
		{
			_definitionsLoader.removeEventListener(ClassesLoaderEvent.COMPLETE, definitionsLoaderCompleteHandler);
			_definitionsLoader.removeEventListener(ClassesLoaderEvent.IO_ERROR, definitionsLoaderIOErrorHandler);
			_definitionsLoader.removeEventListener(ClassesLoaderEvent.SECURITY_ERROR, definitinosLoaderSecurityErrorHandler);
		}
		
		// 发送加载事件
		private function dispatchEvent(eventType:String, url:String):void
		{
			var newEvent:ComponentsApplicationEvent = new ComponentsApplicationEvent(eventType);
			newEvent.url = url;
			
			_eventDispatcherDelegate.dispatchEvent(newEvent);
		}
		
		// 加载结束触发
		private function definitionsLoaderCompleteHandler(event:ClassesLoaderEvent):void
		{
			update(_collection.itemIterator());
			
			dispatchEvent(ComponentsApplicationEvent.COMPLETE, event.url);
		}
		
		// 加载发生IOError触发
		private function definitionsLoaderIOErrorHandler(event:ClassesLoaderEvent):void
		{
			dispatchEvent(ComponentsApplicationEvent.IO_ERROR, event.url);
			removeDefinitionsLoaderEventListeners();
			_isLoading = false;
		}
		
		// 加载发生SecurityError触发
		private function definitinosLoaderSecurityErrorHandler(event:ClassesLoaderEvent):void
		{
			dispatchEvent(ComponentsApplicationEvent.SECURITY_ERROR, event.url);
			removeDefinitionsLoaderEventListeners();
			_isLoading = false;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 对象收集器
		//--------------------------------------------------------------------------------------------------------------------------
		
		// 存储所有注册的对象
		protected var _collection:Collection;
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 注入容器
		//--------------------------------------------------------------------------------------------------------------------------
		
		use namespace collection_internal;
		
		protected var _diContainer:DiContainer;
	}
}