package com.codeTooth.actionscript.classesLoader.core
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * @private
	 * 
	 * 二进制加载器
	 */	
	
	internal class ByteArrayLoader extends LoaderBase
	{
		//二进制加载器
		private var _urlLoader:URLLoader = null;
		
		//loader加载器
		private var _loader:Loader = null;
		
		public function ByteArrayLoader()
		{
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			_loader = new Loader();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function close():void
		{
			try
			{
				_urlLoader.close();
			}
			catch(error:Error)
			{
				
			}
			
			try
			{
				_loader.close();
			}
			catch(error:Error)
			{
				
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function destroy():void
		{
			super.destroy();
			
			close();
			
			removeURLLoaderListeners();
			_urlLoader = null;
			
			_loader.unload();
			removeLoaderListeners();
			_loader = null;
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function protectedLoad():void
		{
			close();
			removeURLLoaderListeners();
			addURLLoaderListeners();
			_urlLoader.load(new URLRequest(url));
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function getDefinition(type:String):Object
		{
			return _loader.contentLoaderInfo.applicationDomain.getDefinition(type);
		}
		
		//添加二进制加载器侦听
		private function addURLLoaderListeners():void
		{
			_urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, urlLoaderProgressHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
		}
		
		//移除二进制加载器侦听
		private function removeURLLoaderListeners():void
		{
			_urlLoader.removeEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, urlLoaderProgressHandler);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
		}
		
		//添加loader加载器侦听
		private function addLoaderListeners():void
		{
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderSecurityErrorHandler);
		}
		
		//移除loader加载器侦听
		private function removeLoaderListeners():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderSecurityErrorHandler);
		}
		
		private function urlLoaderCompleteHandler(event:Event):void
		{
			removeURLLoaderListeners();
			removeLoaderListeners();
			addLoaderListeners();
			var byteArray:ByteArray = ByteArray(_urlLoader.data);
			if(hasByteArrayModifier())
			{
				byteArrayModifier.modifyByteArray(byteArray);
			}
			_loader.loadBytes(byteArray, new LoaderContext(false, applicationDomain));
		}
		
		private function urlLoaderProgressHandler(event:ProgressEvent):void
		{
			dispatchEventDelegate(ClassesLoaderEvent.IO_ERROR, event.bytesLoaded, event.bytesTotal);
		}
		
		private function urlLoaderIOErrorHandler(event:IOErrorEvent):void
		{
			removeURLLoaderListeners();
			close();
			dispatchEventDelegate(ClassesLoaderEvent.IO_ERROR, -1, -1);
		}
		
		private function urlLoaderSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			removeURLLoaderListeners();
			close();
			dispatchEventDelegate(ClassesLoaderEvent.SECURITY_ERROR, -1, -1);
		}
		
		private function loaderCompleteHandler(event:Event):void
		{
			removeLoaderListeners();
			dispatchEventDelegate(ClassesLoaderEvent.COMPLETE, _loader.contentLoaderInfo.bytesLoaded, _loader.contentLoaderInfo.bytesTotal);
		}
		
		private function loaderSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			removeLoaderListeners();
			close();
			dispatchEventDelegate(ClassesLoaderEvent.SECURITY_ERROR, -1, -1);
		}
	}
}