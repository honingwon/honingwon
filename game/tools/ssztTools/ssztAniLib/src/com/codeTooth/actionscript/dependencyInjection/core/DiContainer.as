package com.codeTooth.actionscript.dependencyInjection.core
{		
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;

	/**
	 * 注入容器
	 * 
	 * @example
	 * <pre>
	 * <listing>
	 * dependency injection xml file named di.xml
	 * &lt;data&gt;
	 * 	&lt;item id="redBall" type="flash.display.Sprite" isSingle="true"&gt;
	 * 		&lt;content property1="this.x" number="100"/&gt;
	 * 	 	&lt;content property1="this.y" number="200"/&gt;
	 * 		&lt;content method="this.graphics.beginFill"&gt;
	 * 			&lt;parameter number="0xFF0000"&gt;
	 * 		&lt;/content&gt;
	 * 		&lt;content method="this.graphics.drawCircle"&gt;
	 * 			&lt;parameter number="0"/&gt;
	 * 			&lt;parameter number="0"/&gt;
	 * 			&lt;parameter number="100"/&gt;
	 * 		&lt;/content&gt;
	 * 	&lt;/item&gt;
	 * &lt;/data&gt;
	 * </listing>
	 * <listing>
	 * //code here
	 * var diContainer:DiContainer = new DiContainer();
	 * //add listeners
	 * diContainer.addEventListener(DiContainerEvent.COMPLETE, completeHandler);
	 * //if the xml is a enternal file
	 * diContainer.load(new DiURLLoader(new DiXMLLoaderDataParser()), "di.xml");
	 * //else if the xml is a xml object in code
	 * //diContainer.load(new DiXMLLoader(), xml);
	 * 
	 * function completeHandler(event:DiContainerEvent):void
	 * {
	 * 	var redBall:Sprite = Sprite(diContainer.createObject("redBall"));
	 * 	addChild(radBall);
	 * }
	 * </listing>
	 * </pre>
	 */
	 
	//BUG Reinject\null	
	//FIXME has not progress event
	public class DiContainer extends EventDispatcher 
																	implements IDestroy
	{
		//加载器		
		private var _loader:IDiLoader = null;
		
		//注入对象创建器 
		private var _objectCreator:ObjectCreator = null;
		
		public function DiContainer()
		{
			_objectCreator = new ObjectCreator();
		}
		
		/**
		 * 注入容器的应用程序域
		 */		
		public function set applicationDomain(applicationDomain:ApplicationDomain):void
		{
			_objectCreator.applicationDomain = applicationDomain;
		}
		
		/**
		 * @private
		 */		
		public function get applicationDomain():ApplicationDomain
		{
			return _objectCreator.applicationDomain;
		}
		
		/**
		 * 开始加载注入
		 * 
		 * @param loader 指定的加载器
		 * @param source 指定的加载源
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的加载器或加载源是null
		 */		
		public function load(loader:IDiLoader, source:Object):void
		{
			if(loader == null)
			{
				throw new NullPointerException("Null loader");
			}
			
			if(source == null)
			{
				throw new NullPointerException("Null source");
			}
			
			destroyLoader();
			_loader = loader;
			addListeners();
			_loader.setGetLocalFunction(getLocal);
			_loader.load(source);
		}
		
		/**
		 * 添加一条本地数据
		 * 
		 * @param name 本地数据的名称
		 * @param object 本地数据的值
		 */			
		public function addLocal(name:String, object:Object):void
		{
			_objectCreator.addLocal(name, object);
		}
		
		/**
		 * 移除一条本地数据
		 * 
		 * @param name
		 */		
		public function removeLocal(name:String):void
		{
			_objectCreator.removeLocal(name);
		}
		
		/**
		 * 获得一条本地数据
		 * 
		 * @param name
		 * 
		 * @return
		 */		
		public function getLocal(name:String):*
		{
			return _objectCreator.getLocal(name);
		}
		
		/**
		 * 判断是否存在指定的本地数据
		 * 
		 * @param name
		 * 
		 * @return
		 */		
		public function hasLocal(name:String):Boolean
		{
			return _objectCreator.hasLocal(name);
		}
		
		/**
		 * 创建注入对象
		 * 
		 * @param id 要创建对象的id
		 * 
		 * @return
		 */		
		public function createObject(id:String):*
		{
			return _objectCreator.createObject(id);
		}
		
		/**
		 * 判断是否存在一个注入对象
		 * 
		 * @param id 注入对象的id
		 * 
		 * @return
		 */		
		public function hasObject(id:String):Boolean
		{
			return _objectCreator.hasObject(id);
		}
		
		/**
		 * 销毁所有已经存在的单例对象
		 */		
		public function destroySingletons():void
		{
			_objectCreator.destroySingletons();
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			destroyLoader();
			_objectCreator.destroy();
			_objectCreator = null;
		}
		
		//销毁加载器
		private function destroyLoader():void
		{
			if(_loader != null)
			{
				removeListeners();
				_loader.destroy();
				_loader = null;
			}
		}
		
		//发出事件
		private function dispatchEventInternal(type:String, source:Object):void
		{
			// FIXME do not new a event to propagate the event, the clone method is overrided
			var newEvent:DiContainerEvent = new DiContainerEvent(type);
			newEvent.source = source;
			dispatchEvent(newEvent);
		}
		
		//为加载器添加帧听
		private function addListeners():void
		{
			_loader.addEventListener(DiContainerEvent.COMPLETE, completeHandler);
			_loader.addEventListener(DiContainerEvent.IO_ERROR, ioErrorHandler);
			_loader.addEventListener(DiContainerEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		//移除加载器帧听
		private function removeListeners():void
		{
			_loader.removeEventListener(DiContainerEvent.COMPLETE, completeHandler);
			_loader.removeEventListener(DiContainerEvent.IO_ERROR, ioErrorHandler);
			_loader.removeEventListener(DiContainerEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		//加载结束
		private function completeHandler(event:DiContainerEvent):void
		{
			_objectCreator.setItems(new Parser().parse(_loader.getLoadedData()));
			dispatchEventInternal(event.type, event.source);
		}
		
		//加载发生IOError
		private function ioErrorHandler(event:DiContainerEvent):void
		{
			destroyLoader();
			dispatchEventInternal(event.type, event.source);
		}
		
		//加载发生SecurityError
		private function securityErrorHandler(event:DiContainerEvent):void
		{
			destroyLoader();
			dispatchEventInternal(event.type, event.source);
		}
	}
}