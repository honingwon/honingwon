package sszt.ani.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.getTimer;
	

	public class ImageLoader extends EventDispatcher
	{
		public static const COMPLETE:String = "COMPLETE";
		public static const ERROR:String = "ERROR";
		
		private var _loader:Loader;

		private var _bitmapdata:BitmapData;
		private var _seq:int;
		private var _url:String;
		private var _timer:int;
		private var _type:String;
		
		public function ImageLoader(url:String,seq:int,type:String)
		{
			
			_url = url
			_seq = seq;
			_type = type;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		public function load():void{
			_timer= getTimer();
			_loader.load(new URLRequest(_url), new LoaderContext());
		}
		
		private function onComplete(evt:Event):void{
			
			trace("图片加载成功:"+(getTimer() - _timer));
			var  _bitmap:Bitmap = LoaderInfo(evt.target).content as Bitmap;
			_bitmapdata = _bitmap.bitmapData;
			_loader.unload();
			_loader = null;
			this.dispatchEvent(new Event(COMPLETE));
		}
		
		private function onError(evt:Event):void{
			this.dispatchEvent(new Event(ERROR));
		}
		
		public function dispose():void{
			if(_loader)
			{
				_loader.unload();
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				_loader = null;
			}
			if(_bitmapdata)
			{
				_bitmapdata.dispose();
				_bitmapdata = null;
			}
			_seq = 0;
		}
		
		public function get seq():int{
			return _seq;
		}
		public function get type():String{
			return _type;
		}
		
		public function get bitmapData():BitmapData{
			return _bitmapdata;
		}
		
		public function get url():String{
			return _url;
		}
		
	}
}