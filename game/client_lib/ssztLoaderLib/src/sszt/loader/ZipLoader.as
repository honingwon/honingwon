package sszt.loader
{
	import flash.events.EventDispatcher;
	import riaidea.utils.zip.ZipArchive;
	import riaidea.utils.zip.ZipEvent;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import sszt.events.LoaderEvent;
	import sszt.interfaces.loader.IZipArchive;
	import flash.system.LoaderContext;
	import sszt.interfaces.loader.*;
	
	public class ZipLoader extends EventDispatcher implements IZipLoader 
	{
		
		private var _isStart:Boolean;
		private var _callbacks:Array;
		private var _zip:ZipArchive;
		protected var _url:String;
		private var _isfinish:Boolean;
		private var _tryTime:int;
		private var _hasTryTime:int;
		private var _decodeType:int;
		
		public function ZipLoader(path:String, callback:Function, tryTime:int=1, decodeType:int=1)
		{
			this._url = path;
			this._tryTime = tryTime;
			this._callbacks = [];
			if (callback != null){
				this._callbacks.push(callback);
			};
			this._isfinish = false;
			this._decodeType = decodeType;
			this.init();
			this.initEvent();
		}
		public function set path(value:String):void
		{
			this._url = value;
		}
		public function get path():String
		{
			return (this._url);
		}
		private function init():void
		{
			this._isStart = false;
			this._zip = new ZipArchive(null, this._decodeType);
		}
		private function initEvent():void
		{
			this._zip.addEventListener(ZipEvent.ZIP_FAILED, this.errorHandler);
			this._zip.addEventListener(ZipEvent.ZIP_INIT, this.completeHandler);
			this._zip.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
		}
		private function removeEvent():void
		{
			if (this._zip){
				this._zip.removeEventListener(ZipEvent.ZIP_FAILED, this.errorHandler);
				this._zip.removeEventListener(ZipEvent.ZIP_INIT, this.completeHandler);
				this._zip.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			};
		}
		public function addCallBack(callback:Function):void
		{
			if (callback != null){
				this._callbacks.push(callback);
			};
		}
		private function errorHandler(evt:ZipEvent):void
		{
			this.onError();
		}
		private function ioErrorHandler(evt:IOErrorEvent):void
		{
			this.onError();
		}
		private function completeHandler(evt:Event):void
		{
			this.onCompleted();
		}
		protected function onError():void
		{
			try {
				if (this._hasTryTime == this._tryTime){
					this._isStart = false;
					dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR));
				} else {
					this.load(this._url);
				};
			} catch(err:Error) {
				trace(err.message);
				trace(err.getStackTrace());
			};
		}
		protected function onCompleted():void
		{
			var i:Function;
			try {
				this._isStart = false;
				this._isfinish = true;
				for each (i in this._callbacks) {
					if (i != null){
						(i(this));
					};
				};
				dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_COMPLETE));
			} catch(e:Error) {
				dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR, e.getStackTrace()));
				trace(e.getStackTrace());
			};
		}
		public function get isStart():Boolean
		{
			return (this._isStart);
		}
		public function load(path:String):void
		{
			this._hasTryTime++;
			this._zip.load(path);
		}
		public function getZip():IZipArchive
		{
			return (this._zip);
		}
		public function loadSync(context:LoaderContext=null):void
		{
			if (!(this._isStart)){
				this._isStart = true;
				this.load(this._url);
			};
		}
		public function cancel():void
		{
			if (this._isStart){
				this._isStart = false;
			};
		}
		public function get isFinish():Boolean
		{
			return (this._isfinish);
		}
		public function setDataFormat(value:String):void
		{
		}
		public function getData():*
		{
			return (null);
		}
		public function dispose():void
		{
			this.removeEvent();
			this._callbacks = null;
			this._zip = null;
		}
		
	}
}
