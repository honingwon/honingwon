package sszt.loader
{
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	import flash.net.URLLoaderDataFormat;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import sszt.events.LoaderEvent;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import sszt.interfaces.loader.*;
	
	public class BytesLoader extends URLLoader implements ILoader 
	{
		
		protected var _isStart:Boolean;
		protected var _url:String;
		protected var _callbacks:Array;
		protected var _tryTime:int;
		protected var _hasTryTime:int;
		protected var _isfinish:Boolean;
		protected var _dataBytes:ByteArray;
		private var _interval:int;
		
		public function BytesLoader(path:String, callBack:Function=null, tryTime:int=1)
		{
			this._url = path;
			this._callbacks = [];
			this._tryTime = tryTime;
			if (callBack != null)
			{
				this._callbacks.push(callBack);
			}
			this._isfinish = false;
			this.init();
		}
		
		protected function init():void
		{
			this._hasTryTime = 0;
			this.initEvent();
			this.setDataFormat(URLLoaderDataFormat.BINARY);
		}
		private function initEvent():void
		{
			addEventListener(Event.COMPLETE, this.completeHandler);
			addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			addEventListener(ProgressEvent.PROGRESS, this.progressHandler);
		}
		private function removeEvent():void
		{
			removeEventListener(Event.COMPLETE, this.completeHandler);
			removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			removeEventListener(ProgressEvent.PROGRESS, this.progressHandler);
		}
		protected function completeHandler(evt:Event):void
		{
			this.onCompleted();
		}
		protected function progressHandler(evt:ProgressEvent):void
		{
			if (evt.bytesLoaded == evt.bytesTotal && evt.bytesLoaded == 1308){
				return;
			}
			this.onProgress(evt.bytesLoaded, evt.bytesTotal);
		}
		
		protected function ioErrorHandler(evt:IOErrorEvent):void
		{
			trace(("ioError:" + evt.text), this._url);
			this.onError();
		}
		protected function securityErrorHandler(evt:SecurityErrorEvent):void
		{
			trace(("securityError:" + evt.text), this._url);
			this.onError();
		}
		protected function onCompleted():void
		{
			var i:Function;
			this._isStart = false;
			this._isfinish = true;
			try {
				for each (i in this._callbacks) 
				{
					if (i != null){
						(i(this));
					}
				}
			} catch(err:Error) {
				trace(err.message, _url);
				trace(err.getStackTrace());
			}
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_COMPLETE));
		}
		protected function onProgress(bytesLoader:Number, bytesTotal:Number):void
		{
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_PROGRESS, null, bytesLoaded, bytesTotal));
		}
		protected function onError():void
		{
			this._hasTryTime++;
			try {
				if (this._hasTryTime == this._tryTime)
				{
					this._isStart = false;
					dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR));
				} 
				else 
				{
					this._isStart = false;
					this._interval = setInterval(this.timerCompleteHandler, 4000);
				}
			}
			catch(err:Error) {
				trace(err.message, _url);
				trace(err.getStackTrace());
			}
		}
		
		private function timerCompleteHandler():void
		{
			clearInterval(this._interval);
			this._interval = 0;
			this.loadSync();
		}
		
		public function setDataFormat(value:String):void
		{
			dataFormat = value;
		}
		public function loadSync(context:LoaderContext=null):void
		{
			if (!this._isStart){
				load(new URLRequest(LoaderManager.addRandomCode(this._url)));
			}
		}
		public function cancel():void
		{
			if (this._isStart){
				this._isStart = false;
				this.dispose();
			}
		}
		public function get isStart():Boolean
		{
			return (this._isStart);
		}
		public function get path():String
		{
			return (this._url);
		}
		public function set path(value:String):void
		{
			this._url = value;
		}
		public function get isFinish():Boolean
		{
			return (this._isfinish);
		}
		public function addCallBack(callBack:Function):void
		{
			if (this._callbacks != null){
				this._callbacks.push(callBack);
			}
		}
		public function getData():*
		{
			return (data);
		}
		public function dispose():void
		{
			if (this._interval){
				clearInterval(this._interval);
			}
			try {
				close();
			} 
			catch(e:Error) {
			}
			this.removeEvent();
			this._callbacks = null;
			this._dataBytes = null;
		}
		
	}
}
