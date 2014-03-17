package sszt.loader
{
	import flash.events.EventDispatcher;
	import flash.system.LoaderContext;
	import sszt.interfaces.loader.ILoader;
	import sszt.events.LoaderEvent;
	import sszt.interfaces.loader.*;
	
	public class QueueLoader extends EventDispatcher implements ILoader 
	{
		
		private var _isStart:Boolean;
		private var _callbacks:Array;
		private var _isfinish:Boolean;
		private var _index:int;
		private var _len:int;
		private var _loaders:Array;
		
		public function QueueLoader(loaders:Array, callback:Function=null)
		{
			this._loaders = loaders;
			this._len = this._loaders.length;
			this._callbacks = [];
			if (callback != null){
				this._callbacks.push(callback);
			};
			this._isStart = false;
			this._isfinish = false;
		}
		public function loadSync(context:LoaderContext=null):void
		{
			this.loadNext();
		}
		private function loadNext():void
		{
			var l:ILoader;
			var i:Function;
			if (this._index < this._len){
				this._index++;
				l = (this._loaders.shift() as ILoader);
				l.addCallBack(this.loadCompleteHandler);
				l.addEventListener(LoaderEvent.LOAD_ERROR, this.loadErrorHandler);
				l.loadSync();
			} else {
				for each (i in this._callbacks) {
					(i(this));
				};
			};
		}
		private function loadErrorHandler(evt:LoaderEvent):void
		{
			dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR, evt.data));
		}
		private function loadCompleteHandler(loader:ILoader):void
		{
			this.loadNext();
			loader.dispose();
			loader = null;
		}
		public function cancel():void
		{
		}
		public function get isStart():Boolean
		{
			return (this._isStart);
		}
		public function get path():String
		{
			return (null);
		}
		public function set path(value:String):void
		{
		}
		public function get isFinish():Boolean
		{
			return (this._isfinish);
		}
		public function addCallBack(callBack:Function):void
		{
			if (callBack != null){
				this._callbacks.push(callBack);
			};
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
			this._loaders = null;
			this._callbacks = null;
		}
		
	}
}
