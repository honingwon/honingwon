package sszt.loader.newResource
{
	import sszt.loader.PicLoader;
	import flash.display.BitmapData;
	import flash.utils.getTimer;
	import sszt.events.LoaderEvent;
	
	public class PicLoaderList 
	{
		
		public var path:String;
		public var callbacks:Array;
		private var _picLoader:PicLoader;
		public var clearType:int;
		private var _data:BitmapData;
		public var quoteCount:int;
		public var clearTime:int;
		public var currentTime:int;
		public var priority:int;
		private var _manager:PicLoaderManager;
		public var startTime:Number;
		
		public function PicLoaderList(path:String, callback:Function, clearType:int, clearTime:int=2147483647, manager:PicLoaderManager=null, priority:int=1)
		{
			this.path = path;
			this.callbacks = [];
			this.clearTime = clearTime;
			this.currentTime = int.MAX_VALUE;
			this.quoteCount = 0;
			this.startTime = Number.MAX_VALUE;
			this.addCallback(callback);
			this.priority = priority;
			this.clearType = clearType;
			this._manager = manager;
		}
		public function load():void
		{
			this.startTime = getTimer();
			this._picLoader = new PicLoader(this.path, this.loadComplete, 3);
			this._picLoader.addEventListener(LoaderEvent.LOAD_ERROR, this.loadErrorHandler);
			this._picLoader.loadSync();
		}
		private function loadComplete(loader:PicLoader):void
		{
			var i:Function;
			this._data = loader.bdData;
			if (this._manager != null){
				this._manager.pathComplete(this);
			}
			for each (i in this.callbacks) {
				(i(this._data));
			}
			this.callbacks.length = 0;
		}
		private function loadErrorHandler(evt:LoaderEvent):void
		{
			if (this._manager != null){
				this._manager.pathComplete(this);
			}
		}
		public function addCallback(func:Function):void
		{
			if (this._data){
				func(this._data);
				this.quoteCount++;
			} 
			else {
				if (this.callbacks.indexOf(func) == -1){
					this.callbacks.push(func);
					this.quoteCount++;
				}
			}
		}
		public function removeCallback(func:Function):void
		{
			var index:int = this.callbacks.indexOf(func);
			if (index != -1){
				this.callbacks.splice(index, 1);
			}
			this.quoteCount--;
			if (this.quoteCount < 0){
				this.quoteCount = 0;
			}
		}
		public function start():void
		{
			this.currentTime = getTimer();
		}
		public function stop():void
		{
			this.currentTime = int.MAX_VALUE;
		}
		public function getClear():Boolean
		{
			return (((getTimer() - this.currentTime) > this.clearTime));
		}
		public function dispose():void
		{
			if (this._picLoader){
				this._picLoader.removeEventListener(LoaderEvent.LOAD_ERROR, this.loadErrorHandler);
				this._picLoader.dispose();
				this._picLoader = null;
			};
			this._data = null;
			this.callbacks = null;
			this._manager = null;
		}
		
	}
}
