package com.codeTooth.actionscript.classesLoader.core
{	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * @private
	 * 
	 * Loader加载器
	 */
	
	internal class URLLoader_Internal extends LoaderBase
	{
		//Loader加载器
		private var _loader:Loader = null;
		
		public function URLLoader_Internal()
		{
			_loader = new Loader();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function close():void
		{
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
			
			if(_loader != null)
			{
				close();
				removeListeners();
				_loader.unload();
				_loader = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function protectedLoad():void
		{
			close();
			removeListeners();
			addListeners();
			_loader.load(new URLRequest(url), new LoaderContext(false, applicationDomain));
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function getDefinition(type:String):Object
		{
			return _loader.contentLoaderInfo.applicationDomain.getDefinition(type);
		}
		
		//添加加载器侦听
		private function addListeners():void
		{
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		//移除加载器侦听
		private function removeListeners():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		private function completeHandler(event:Event):void
		{
			removeListeners();
			dispatchEventDelegate(ClassesLoaderEvent.COMPLETE, _loader.contentLoaderInfo.bytesLoaded, _loader.contentLoaderInfo.bytesTotal);
		}
		
		private function progressHandler(event:ProgressEvent):void
		{
			dispatchEventDelegate(ClassesLoaderEvent.PROGRESS, event.bytesLoaded, event.bytesTotal);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			removeListeners();
			close();
			dispatchEventDelegate(ClassesLoaderEvent.IO_ERROR, -1, -1);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			removeListeners();
			close();
			dispatchEventDelegate(ClassesLoaderEvent.SECURITY_ERROR, -1, -1);
		}
	}
}