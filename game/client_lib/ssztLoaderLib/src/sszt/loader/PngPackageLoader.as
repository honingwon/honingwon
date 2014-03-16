package sszt.loader
{
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import flash.utils.ByteArray;
	import flash.system.LoaderContext;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import sszt.events.LoaderEvent;
	import sszt.interfaces.loader.*;
	
	public class PngPackageLoader extends EventDispatcher implements ILoader 
	{
		
		private var _hadcryptType:int;
		private var _url:String;
		private var _callbacks:Array;
		private var _tryTime:int;
		private var _hasTrytime:int;
		protected var _isfinish:Boolean;
		private var _tmpLoadValue:Number;
		private var _id:int;
		private var _layerType:String;
		private var _sex:String;
		private var _urlloader:URLLoader;
		private var _loader:Loader;
		
		public function PngPackageLoader(path:String, id:int, layerType:String, sex:String, callBack:Function=null, tryTime:int=1, hadcryptType:int=0)
		{
			this._hadcryptType = hadcryptType;
			this._callbacks = [];
			if (callBack != null){
				this._callbacks.push(callBack);
			};
			this._tryTime = tryTime;
			this._url = path;
			this._isfinish = false;
			this._hasTrytime = 0;
			this._id = id;
			this._layerType = layerType;
			this._sex = sex;
		}
		public function loadSync(context:LoaderContext=null):void
		{
			var getCache:Function;
			getCache = function (bytes:ByteArray):void
			{
				if (bytes){
					addToDomain(bytes);
				} else {
					thisLoad();
				};
			};
			if (LoaderManager.domain.hasDefinition(((this._layerType + this._sex) + this._id))){
				this.doComplete();
			} else {
				if (LoaderManager.localCache){
					LoaderManager.localCache.getFile(this._url, getCache, false);
				} else {
					this.thisLoad();
				};
			};
		}
		private function thisLoad():void
		{
			this._urlloader = new URLLoader();
			this._urlloader.addEventListener(Event.COMPLETE, this.urlloadCompleteHandler);
			this._urlloader.addEventListener(IOErrorEvent.IO_ERROR, this.urlloadErrorHandler);
			this._urlloader.addEventListener(ProgressEvent.PROGRESS, this.urlProgressHandler);
			this._urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.urlloadErrorHandler);
			this._urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			this._urlloader.load(new URLRequest(LoaderManager.addRandomCode(this._url)));
		}
		private function urlloadCompleteHandler(evt:Event):void
		{
			if (LoaderManager.localCache){
				LoaderManager.localCache.setFile(this._url, (this._urlloader.data as ByteArray), false);
			};
			this.addToDomain(this._urlloader.data);
		}
		private function urlloadErrorHandler(evt:Event):void
		{
			trace((this._url + "error"));
			this._hasTrytime++;
			if (this._hasTrytime < this._tryTime){
				this.thisLoad();
			} else {
				dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR));
			};
		}
		private function urlProgressHandler(evt:ProgressEvent):void
		{
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_PROGRESS, null, evt.bytesLoaded, evt.bytesTotal));
		}
		private function addToDomain(sourceBytes:ByteArray):void
		{
			this._loader = new Loader();
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loaderComplete);
			this._loader.loadBytes(sourceBytes, new LoaderContext(false, LoaderManager.domain));
		}
		private function loaderComplete(evt:Event):void
		{
			this.doComplete();
		}
		private function doComplete():void
		{
			var callback:Function;
			this._isfinish = true;
			for each (callback in this._callbacks) {
				if (callback != null){
					(callback(this));
				};
			};
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_COMPLETE));
		}
		public function cancel():void
		{
		}
		public function get isStart():Boolean
		{
			return (false);
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
			this._callbacks.push(callBack);
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
			if (this._loader){
				this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.loaderComplete);
				try {
					this._loader.unload();
					this._loader.close();
				} catch(e:Error) {
				};
			};
			this._loader = null;
			if (this._urlloader){
				this._urlloader.removeEventListener(Event.COMPLETE, this.urlloadCompleteHandler);
				this._urlloader.removeEventListener(IOErrorEvent.IO_ERROR, this.urlloadErrorHandler);
				this._urlloader.removeEventListener(ProgressEvent.PROGRESS, this.urlProgressHandler);
				this._urlloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.urlloadErrorHandler);
				try {
					this._urlloader.close();
				} catch(e:Error) {
				};
			};
			this._urlloader = null;
			this._callbacks = null;
		}
		
	}
}
