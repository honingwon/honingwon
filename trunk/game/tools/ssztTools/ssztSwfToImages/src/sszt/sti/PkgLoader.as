package sszt.sti
{
	import flash.events.EventDispatcher;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.system.LoaderContext;
	
	public class PkgLoader extends EventDispatcher
	{
		
		protected var _isStart:Boolean;
		protected var _url:String;
		private var _callbacks:Array;
		protected var _tryTime:int;
		protected var _hasTryTime:int;
		protected var _isfinish:Boolean;
		protected var _loader:Loader;
		private var _hasCheckLocal:Boolean;
		private var _setdata:Boolean;
		private var _quoteDispose:Boolean;
		private var _cacheDispose:Boolean;
		
		public function PkgLoader(path:String, callBack:Function=null, tryTime:int=1)
		{
			this._url = path;
			this._callbacks = [];
			this._tryTime = tryTime;
			if (callBack != null){
				this._callbacks.push(callBack);
			};
			this._isfinish = false;
			this._hasTryTime = 0;
			this._hasCheckLocal = false;
			this._loader = new Loader();
			this.initEvent();
		}
		private function initEvent():void
		{
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completeHandler);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.progressHandler);
			this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
		}
		private function removeEvent():void
		{
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.completeHandler);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.progressHandler);
			this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
		}
		protected function completeHandler(evt:Event):void
		{
			var i:Function;
			var evt:Event = evt;
			this._isStart = false;
			this._isfinish = true;
			if (this._setdata){
				try {
//					if (LoaderManager.localCache){
//						LoaderManager.localCache.setFile(this._url, this._loader.contentLoaderInfo.bytes, false, this.setCacheDispose);
//					};
				} catch(err:Error) {
					trace(err.getStackTrace());
				};
			};
			try {
				for each (i in this._callbacks) {
					if (i != null){
						(i(this));
					};
				};
			} catch(err:Error) {
				trace(err.message, _url);
				trace(err.getStackTrace());
			};
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_COMPLETE));
		}
		protected function progressHandler(evt:ProgressEvent):void
		{
			if ((((evt.bytesLoaded == evt.bytesTotal)) && ((evt.bytesLoaded == 1308)))){
				return;
			};
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_PROGRESS, null, evt.bytesLoaded, evt.bytesTotal));
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
		protected function onError():void
		{
			this._hasTryTime++;
			try {
				if (this._hasTryTime == this._tryTime){
					this._isStart = false;
					dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR));
				} else {
					this._isStart = false;
					this.loadSync();
				};
			} catch(err:Error) {
				trace(err.message, _url);
				trace(err.getStackTrace());
			};
		}
		public function loadSync(context:LoaderContext=null):void
		{
			var cacheBack:Function;
			cacheBack = function (value:ByteArray):void
			{
				if (value){
					_cacheDispose = true;
					_loader.loadBytes(value);
				} else {
					_setdata = true;
//					if (LoaderManager.localCache){
//						_loader.load(new URLRequest(LoaderManager.addRandomCode(_url)));
//					} else {
						_loader.load(new URLRequest(_url));
//					};
				};
			};
			if (!this._isStart){
//				if (((!(this._hasCheckLocal)) && (LoaderManager.localCache))){
//					this._hasCheckLocal = true;
//					LoaderManager.localCache.getFile(this._url, cacheBack, false);
//				} else {
					this._setdata = true;
//					if (LoaderManager.localCache){
//						this._loader.load(new URLRequest(LoaderManager.addRandomCode(this._url)));
//					} else {
						this._loader.load(new URLRequest(this._url));
//					};
//				};
			};
		}
		public function cancel():void
		{
			if (this._isStart){
				this._isStart = false;
				this.dispose();
			};
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
			};
		}
		public function get loader():Loader
		{
			return (this._loader);
		}
		public function setDataFormat(value:String):void
		{
		}
		public function getData():*
		{
			return (null);
		}
		public function setQuoteDispose():void
		{
			this._quoteDispose = true;
		}
		public function setCacheDispose():void
		{
			this._cacheDispose = true;
		}
		private function checkDispose():void
		{
			if (((this._quoteDispose) && (this._cacheDispose))){
				this.dispose();
			};
		}
		public function dispose():void
		{
			this.removeEvent();
			try {
				if (this._loader){
					this._loader.unload();
//					if (this._loader.contentLoaderInfo.bytes){
//						this._loader.contentLoaderInfo.bytes.clear();
//					};
					this._loader.close();
				};
			} catch(e:Error) {
			};
			this._loader = null;
			this._callbacks = null;
		}
		
	}
}
