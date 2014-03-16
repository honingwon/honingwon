package sszt.loader
{
	import flash.display.Loader;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.system.LoaderContext;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import sszt.events.LoaderEvent;
	import sszt.loader.data.LoaderClearType;
	
	public class ModuleLoader extends BytesLoader 
	{
		
		private var _md:Loader;
		private var _hadcryptType:int;
		private var _complete:Boolean;
		private var _startNext:Boolean;
		private var _selfLoading:Boolean;
		private var _domain:ApplicationDomain;
		
		public function ModuleLoader(path:String, callBack:Function=null, tryTime:int=1, hadcryptType:int=0)
		{
			this._hadcryptType = hadcryptType;
			this._domain = LoaderManager.domain;
			super(path, callBack, tryTime);
		}
		override public function loadSync(context:LoaderContext=null):void
		{
			var getCacheBack:Function;
			getCacheBack = function (bytes:ByteArray):void
			{
				if (bytes){
					_dataBytes = bytes;
					onCompleted();
				} else {
					superLoadSync(context);
				};
			};
			var superLoadSync:Function = super.loadSync;
			if (ModuleLoaderManager.getLoaderState(_url)){
				ModuleLoaderManager.addLoaderInfo(_url, this, this.listLoadComplete, this.listLoadError, this.listLoadProgress);
			} else {
				if (ModuleLoaderManager.getPathHadLoaded(_url)){
					this.listLoadComplete();
				} else {
					this._selfLoading = true;
					ModuleLoaderManager.addLoaderInfo(_url, this, this.listLoadComplete, this.listLoadError, this.listLoadProgress);
					ModuleLoaderManager.setCurrentLoading(_url, this);
					ModuleLoaderManager.setLoaderStart(_url);
					if (LoaderManager.localCache){
						LoaderManager.localCache.getFile(_url, getCacheBack, false);
					} else {
						super.loadSync(context);
					};
				};
			};
		}
		override protected function onCompleted():void
		{
			var shouldCache:Boolean = (_dataBytes == null);
			if (_dataBytes == null){
				_dataBytes = (data as ByteArray);
			};
			if (((LoaderManager.localCache) && (shouldCache))){
				LoaderManager.localCache.setFile(_url, _dataBytes, false);
			};
			this._md = new Loader();
			this._md.contentLoaderInfo.addEventListener(Event.COMPLETE, this.domainAddCompleteHandler);
			this._md.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.domainAddErrorHandler);
			try {
				if (this._hadcryptType != 0 && LoaderManager.decode)
				{
					this._md.loadBytes(LoaderManager.decode.decode(_dataBytes, this._hadcryptType), new LoaderContext(false, this._domain));
				} 
				else {
					this._md.loadBytes(_dataBytes, new LoaderContext(false, this._domain));
				}
			} 
			catch(e:Error) {
				trace(e.message);
				trace(e.getStackTrace());
			}
		}
		override protected function onProgress(bytesLoader:Number, bytesTotal:Number):void
		{
			ModuleLoaderManager.loaderProgress(_url, bytesLoaded, bytesTotal);
		}
		override protected function onError():void
		{
			_hasTryTime++;
			try {
				if (_hasTryTime == _tryTime){
					_isStart = false;
					ModuleLoaderManager.setLoaderState(_url, false);
					ModuleLoaderManager.clearLoader(_url, 0);
				} else {
					_isStart = false;
					load(new URLRequest(LoaderManager.addRandomCode(_url)));
					return;
				};
			} catch(err:Error) {
				trace(err.message);
				trace(err.getStackTrace());
			};
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR));
		}
		private function startNext():void
		{
			if (ModuleLoaderManager.getPathLoadNum(_url) > 0){
				ModuleLoaderManager.startNextLoad(_url);
			} else {
				ModuleLoaderManager.clearLoader(_url, 0);
			};
		}
		private function domainAddCompleteHandler(evt:Event):void
		{
			ModuleLoaderManager.clearLoader(_url, LoaderClearType.CLEARQUEUEANDDOCOMPLETE);
		}
		private function domainAddErrorHandler(evt:IOErrorEvent):void
		{
			trace(evt.text);
			ModuleLoaderManager.clearLoader(_url, LoaderClearType.CLEARQUEUEANDDOERROR);
		}
		private function listLoadComplete():void
		{
			this._complete = true;
			super.onCompleted();
		}
		private function listLoadError():void
		{
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR));
		}
		private function listLoadProgress(loadedBytes:Number, totalBytes:Number):void
		{
			super.onProgress(loadedBytes, totalBytes);
		}
		override public function cancel():void
		{
			if (this._md){
				this._md.close();
			};
			super.cancel();
		}
		public function setHadEncryptType(value:int):void
		{
			this._hadcryptType = value;
		}
		override public function dispose():void
		{
			if (this._md){
				this._md.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.domainAddCompleteHandler);
				this._md.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.domainAddErrorHandler);
				this._md.unload();
				this._md = null;
			};
			ModuleLoaderManager.removeLoaderInfo(_url, this);
			this._startNext = true;
			this.startNext();
			super.dispose();
		}
		
	}
}
