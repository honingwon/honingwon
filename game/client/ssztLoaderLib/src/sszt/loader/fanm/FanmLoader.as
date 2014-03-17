package sszt.loader.fanm
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import sszt.events.LoaderEvent;
	import sszt.loader.BytesLoader;
	import sszt.loader.LoaderManager;
	import sszt.loader.data.LoaderClearType;
	
	public class FanmLoader extends BytesLoader
	{
		
		private var _loader:Loader;
		private var _hadcryptType:int;
		
		
		
		public function FanmLoader(path:String, callBack:Function=null, tryTime:int=1, hadcryptType:int=0)
		{
			this._hadcryptType = hadcryptType;
			super(path, callBack, tryTime);
		}
		
		override public function loadSync(context:LoaderContext=null):void
		{
			var getCacheBack:Function;
			getCacheBack = function (bytes:ByteArray):void
			{
				if (bytes)
				{
					_dataBytes = bytes;
					onCompleted();
				} 
				else 
				{
					superLoadSync(context);
				}
			}
			var superLoadSync:Function = super.loadSync;
			
			if (LoaderManager.localCache)
			{
				LoaderManager.localCache.getFile(_url, getCacheBack, false);
			} 
			else 
			{
				super.loadSync(context);
			}
			
		}
		override protected function onCompleted():void
		{
			var shouldCache:Boolean = (_dataBytes == null);
			if (_dataBytes == null)
			{
				_dataBytes = data as ByteArray;
			}
			if (LoaderManager.localCache && shouldCache)
			{
				LoaderManager.localCache.setFile(_url, _dataBytes, false);
			}
			this._loader = new Loader();
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.domainAddCompleteHandler);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.domainAddErrorHandler);
			try {
				var lc:LoaderContext = new LoaderContext(false);
//				lc.allowCodeImport = true;
				if (this._hadcryptType != 0 && LoaderManager.decode)
				{
					this._loader.loadBytes(LoaderManager.decode.decode(_dataBytes, this._hadcryptType),lc);
				} 
				else 
				{
					this._loader.loadBytes(_dataBytes, lc);
				}
			} 
			catch(e:Error) {
				trace(e.message);
				trace(e.getStackTrace());
			}
		}
		
		override protected function onError():void
		{
			_hasTryTime++;
			try {
				if (_hasTryTime == _tryTime){
					_isStart = false;
				} 
				else {
					_isStart = false;
					super.loadSync();
					return;
				}
			} 
			catch(err:Error) {
				trace(err.message);
				trace(err.getStackTrace());
			}
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR));
		}
		

		
		private function domainAddCompleteHandler(evt:Event):void
		{
			
			var i:Function;
			this._isStart = false;
			this._isfinish = true;
			try {
				for each (i in this._callbacks) 
				{
					if (i != null){
						i(_loader.contentLoaderInfo.applicationDomain);
					}
				}
			} catch(err:Error) 
			{
				trace(err.message, _url);
				trace(err.getStackTrace());
			}
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_COMPLETE));
			
		}
		private function domainAddErrorHandler(evt:IOErrorEvent):void
		{
			trace(evt.text);
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR));
		}
		

	
		public function setHadEncryptType(value:int):void
		{
			this._hadcryptType = value;
		}
		
		override public function dispose():void
		{
			if (this._loader){
				this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.domainAddCompleteHandler);
				this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.domainAddErrorHandler);
				this._loader.unload();
				this._loader = null;
			}
			super.dispose();
		}
		
	}
}
