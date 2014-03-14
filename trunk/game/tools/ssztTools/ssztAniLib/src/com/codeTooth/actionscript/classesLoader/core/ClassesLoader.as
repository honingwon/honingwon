package com.codeTooth.actionscript.classesLoader.core
{		
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	/**
	 * 类加载器
	 * 
	 * @example
	 * <pre>
	 * <listing>
	 * var classesLoader:ClassesLoader = new ClassesLoader();
	 * //add listeners
	 * classesLoader.addEventListener(ClassesLoaderEvent.COMPLETE, completeHandler);
	 * //load a swf file as a assets
	 * classesLoader.load("assets1", "assets\\Assets1.swf");
	 * 
	 * function completeHandler(event:ClassesLoaderEvent):void
	 * {
	 * 	var icon:DisplayObject = DisplayObject(new (Class(classesLoader.getDefinition("assets1", "IconDefinition")))());
	 * 	addChild(icon);
	 * }
	 * </listing>
	 * </pre>
	 */
	
	public class ClassesLoader extends EventDispatcher 
																	implements IDestroy
	{	
		/**
		 * 普通Loader加载方式 
		 */		
		public static const LOAD_TYPE_URL:String = "url";
		
		/**
		 * 二进制加载方式
		 */		
		public static const LOAD_TYPE_BYTE_ARRAY:String = "byteArray";
		
		//存储所有的加载器
		private var  _loaders:Dictionary = null;
		
		public function ClassesLoader()
		{
			_loaders = new Dictionary();
		}
		
		/**
		 * 开始加载类资源
		 * 
		 * @param loaderName 指定的资源名称
		 * @param url 路径
		 * @param loadType 加载的类型（LOAD_TYPE_URL || LOAD_TYPE_BYTE_ARRAY）
		 * @param applicationDomain 加载到的应用程序域，默认的null是当前的应用程序域
		 * @param byteArrayModifier 如果使用二进制加载的方式，则使用的二进制修改器，
		 * 如果不指定，不进行二进制的修改，效果和普通Loader加载一样
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalOperationException 
		 * 为加载的类资源指定了相同的名称
		 */		
		public function load(loaderName:String, url:String, loadType:String = "url", applicationDomain:ApplicationDomain = null, byteArrayModifier:IByteArrayModifier = null):void
		{
			if(hasLoader(loaderName))
			{
				throw new IllegalOperationException("Has the loader \"" + loaderName + "\"")
			}
			else
			{	
				var loader:LoaderBase = createLoader(loadType);
				if(byteArrayModifier != null)
				{
					loader.byteArrayModifier = byteArrayModifier;
				}
				loader.eventDispatcherDelegate = this;
				loader.applicationDomain = applicationDomain == null ? ApplicationDomain.currentDomain : applicationDomain;
				loader.url = url;
				loader.loaderName = loaderName;
				loader.load();
				_loaders[loaderName] = loader;
			}
		}
		
		/**
		 * 获得加载的类定义
		 * 
		 * @param loaderName load时指定的资源名称
		 * @param type 类定义类型
		 * 
		 * @exception com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 不存在指定的资源名称
		 * 
		 * @return
		 */		
		public function getDefinition(loaderName:String, type:String):Object
		{
			if(!hasLoader(loaderName))
			{
				throw new NoSuchObjectException("Has not the loader \"" + loaderName + "\"");
			}
			
			return LoaderBase(_loaders[loaderName]).getDefinition(type);
		}
		
		/**
		 * 卸载一个类资源
		 * 
		 * @param loaderName 指定的资源名称
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 没有指定的类资源
		 */		
		public function unload(loaderName:String):void
		{
			if(hasLoader(loaderName))
			{
				var loader:LoaderBase = LoaderBase(_loaders[loaderName]);
				delete _loaders[loaderName];
				loader.destroy();
			}
			else
			{
				throw new NoSuchObjectException("Has not the loader \"" + loaderName + "\"");
			}
		}
		
		/**
		 * 判断是否存在指定的资源名
		 * 
		 * @param loaderName
		 * 
		 * @return
		 */		
		public function hasLoader(loaderName:String):Boolean
		{
			return _loaders[loaderName] != undefined;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			var loader:LoaderBase = null;
			for(var pName:Object in _loaders)
			{
				loader = LoaderBase(_loaders[pName]);
				loader.destroy();
				delete _loaders[pName];
			}
			_loaders = null;
		}
		
		/**
		 * @private
		 * 
		 * 创建相应的加载器
		 * 
		 * @param loadType 加载器类型
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalParameterException 
		 * 非法的加载器类型
		 * 
		 * @return 
		 */
		private function createLoader(loadType:String):LoaderBase
		{
			if(loadType != LOAD_TYPE_URL && 
				loadType != LOAD_TYPE_BYTE_ARRAY)
			{
				throw new IllegalParameterException("Illegal load type \"" + loadType + "\"");
			}
			
			return loadType == LOAD_TYPE_URL ? new URLLoader_Internal() : 
						loadType == LOAD_TYPE_BYTE_ARRAY ? new ByteArrayLoader() : null;
		}
	}
}