package testnet
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	internal class TestNet2
	{
		private var _container:DisplayObjectContainer;
		private var _tf:TextField;
		
		public function TestNet2(container:DisplayObjectContainer)
		{
			_container=container;
			_tf=new TextField();
		}
		
		public function go():void
		{
			var request:URLRequest=new URLRequest(Config.URL_ROOT + "text.txt");
			var loader:URLLoader=new URLLoader();
			loader.dataFormat=URLLoaderDataFormat.TEXT; //default
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.load(request);
		}
		
		protected function onComplete(event:Event):void
		{
			var loader:URLLoader=event.target as URLLoader;
			_tf.text=loader.data as String;
			_container.addChild(_tf);
		}
	}
}
