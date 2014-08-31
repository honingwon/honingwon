package testnet
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filters.DisplacementMapFilter;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	internal class TestNet1
	{
		private var _container:DisplayObjectContainer;
		private var _tf:TextField;
		
		public function TestNet1(container:DisplayObjectContainer)
		{
			_container=container;
			_tf=new TextField();
			_container.addChild(_tf);
		}
		
		public function go():void
		{
//			var request:URLRequest=new URLRequest(Config.URL_ROOT + "icon.png?" + getTimer());
			var request:URLRequest=new URLRequest(Config.URL_ROOT + "img.jpg");
			request.data=(new Date()).time;
			var loader:URLLoader=new URLLoader();
			loader.dataFormat=URLLoaderDataFormat.BINARY;
			configureListeners(loader);
			try
			{
				loader.load(request);
			}
			catch (e:Error)
			{
				trace(e);
			}
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, IOErrorEventHandler);
		}
		
		private function IOErrorEventHandler(event:IOErrorEvent):void
		{
			trace("IOErrorEventHandler:" + event);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
			trace("httpStatusHandler: " + event);
			trace("status: " + event.status);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			trace("securityErrorHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void
		{
			var loader:URLLoader=event.target as URLLoader;
//			trace("progressHandler:" + loader.bytesLoaded / loader.bytesTotal);
			_tf.text=int(loader.bytesLoaded / loader.bytesTotal * 100) + "%";
		}
		
		private function openHandler(event:Event):void
		{
			trace("start loading...");
		}
		
		private function completeHandler(event:Event):void
		{
			var urlloader:URLLoader=event.target as URLLoader;
			var loader:Loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOErrorEventHandler2);
			loader.loadBytes(urlloader.data as ByteArray);
		}
		
		protected function IOErrorEventHandler2(event:IOErrorEvent):void
		{
			trace("IOErrorEventHandler2:" + event)
		}
		
		private function loadCompleteHandler(event:Event):void
		{
			var content:DisplayObject=(event.target as LoaderInfo).content;
			content.y=20;
			_container.addChild(content);
		}
	}
}
