package com.codeTooth.actionscript.classesLoader.core
{
	import com.codeTooth.actionscript.lang.errors.AbstractError;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	/**
	 * @private
	 * 
	 * 加载器的基类
	 */
	
	internal class LoaderBase extends EventDispatcher 
																		implements IDestroy
	{	
		//事件发送代理
		protected var _eventDispatcherDelegate:IEventDispatcher = null;
		
		//加载的url
		private var _url:String = null;
		
		//加载器名称
		private var _loaderName:String = null;
		
		//应用程序域
		private var _applicationDomain:ApplicationDomain = null;
		
		//二进制修改器
		private var _byteArrayModifier:IByteArrayModifier = null;
		
		public function LoaderBase()
		{
			
		}
		
		/**
		 * 应用程序域
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的应用程序域是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 没有应用程序域
		 */		
		public function set applicationDomain(applicationDomain:ApplicationDomain):void
		{
			if(applicationDomain == null)
			{
				throw new NullPointerException("Null applicationDomain");
			}
			
			_applicationDomain = applicationDomain;
		}
		
		/**
		 * @private
		 */			
		public function get applicationDomain():ApplicationDomain
		{
			if(!hasApplicationDomain())
			{
				throw new NoSuchObjectException("Has not applicationDomain");
			}
			
			return _applicationDomain;
		}
		
		/**
		 * 二进制修改器
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的二进制修改器是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 没有二进制修改器
		 * 
		 * @param byteArrayModifier
		 */		
		public function set byteArrayModifier(byteArrayModifier:IByteArrayModifier):void
		{
			if(byteArrayModifier == null)
			{
				throw new NullPointerException("Null byteArrayModifier");
			}
			
			_byteArrayModifier = byteArrayModifier;
		}
		
		/**
		 * @private
		 */			
		public function get byteArrayModifier():IByteArrayModifier
		{
			if(!hasByteArrayModifier())
			{
				throw new NoSuchObjectException("Has not byteArray modifier");
			}
			
			return _byteArrayModifier;
		}
		
		/**
		 * 事件发送代理
		 * 
		 * @param eventDispatcherDelegate
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的对象是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 没有事件发送代理
		 */		
		public function set eventDispatcherDelegate(eventDispatcherDelegate:IEventDispatcher):void
		{
			if(eventDispatcherDelegate == null)
			{
				throw new NullPointerException("Null eventDispatcherDelegate");
			}
			
			_eventDispatcherDelegate = eventDispatcherDelegate;
		}
		
		/**
		 * @private
		 */		
		public function get eventDispatcherDelegate():IEventDispatcher
		{
			if(!hasEventDispatcherDelegate())
			{
				throw new NoSuchObjectException("Has not eventDispatcherDelegate");
			}
			
			return _eventDispatcherDelegate;
		}
		
		/**
		 * 加载的url
		 * 
		 * @param url
		 */		
		public function set url(url:String):void
		{
			_url = url;
		}
		
		/**
		 * @private
		 */		
		public function get url():String
		{
			return _url;
		}
		
		/**
		 * 加载器名称
		 * 
		 * @param loaderName
		 */		
		public function set loaderName(loaderName:String):void
		{
			_loaderName = loaderName;
		}
		
		/**
		 * @private
		 */		
		public function get loaderName():String
		{
			return _loaderName;
		}
		
		/**
		 * 获得类定义
		 * 
		 * @param type	类定义类型
		 * 
		 * @return 返回指定类型的类定义
		 */		
		public function getDefinition(type:String):Object
		{
			//抽象方法
			throw new AbstractError("Override the method in sub class");
			return null;
		}
		
		/**
		 * 判断是否设定了二进制修改器
		 * 
		 * @return
		 */		
		public function hasByteArrayModifier():Boolean
		{
			return _byteArrayModifier != null;
		}
		
		/**
		 * 判断是否有事件发送代理
		 * 
		 * @return
		 */		
		public function hasEventDispatcherDelegate():Boolean
		{
			return _eventDispatcherDelegate != null;
		}
		
		/**
		 * 判断是都设定了应用程序域
		 * 
		 * @return
		 */		
		public function hasApplicationDomain():Boolean
		{
			return _applicationDomain != null;
		}
		
		/**
		 * 开始加载
		 */		
		public function load():void
		{
			protectedLoad();
		}
		
		/**
		 * 关闭当前的加载流
		 */		
		public function close():void
		{
			//抽象方法
			throw new AbstractError("Override the method in sub class");
		}
		
		/**
		 * @private
		 * 
		 * 通过代理发送事件
		 * 
		 * @param type 事件类型
		 * @param bytesLoaded 加载的字节数
		 * @param bytesTotal 总字节数
		 */		
		public function dispatchEventDelegate(type:String, bytesLoaded:Number, bytesTotal:Number):void
		{
			var newEvent:ClassesLoaderEvent = new ClassesLoaderEvent(type);
			newEvent.url = url;
			newEvent.bytesLoaded = bytesLoaded;
			newEvent.bytesTotal = bytesTotal;
			eventDispatcherDelegate.dispatchEvent(newEvent);
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			_eventDispatcherDelegate = null;
			_byteArrayModifier = null;
			_applicationDomain = null;
		}
		
		/**
		 * @private
		 *  
		 * 加载方法
		 */
		protected function protectedLoad():void
		{
			//抽象方法
			throw new AbstractError("Override the method in sub class");
		}
	}
}