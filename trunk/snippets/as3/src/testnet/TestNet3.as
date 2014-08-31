package testnet
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	internal class TestNet3
	{
		private var _container:DisplayObjectContainer;
		private var _tf:TextField;
		
		public function TestNet3(container:DisplayObjectContainer)
		{
			_container=container;
			_tf=new TextField();
		}
		
		public function go():void
		{
			var request:URLRequest=new URLRequest(Config.URL_ROOT + "params.txt");
			var loader:URLLoader=new URLLoader();
			loader.dataFormat=URLLoaderDataFormat.VARIABLES;
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.load(request);
		}
		
		protected function onComplete(event:Event):void
		{
			var loader:URLLoader=event.target as URLLoader;
			var variables:URLVariables=loader.data as URLVariables
			_tf.text=variables["firstName"] + " " + variables["lastName"];
			_container.addChild(_tf);
		}
	}
}
