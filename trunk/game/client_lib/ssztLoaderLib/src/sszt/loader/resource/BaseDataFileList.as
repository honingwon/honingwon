package sszt.loader.resource
{
	import sszt.interfaces.loader.IDataFileInfo;
	import sszt.interfaces.loader.ILoader;
	import sszt.loader.DataFileLoader;
	import flash.utils.ByteArray;
	
	public class BaseDataFileList 
	{
		
		protected var _fileDatas:IDataFileInfo;
		public var path:String;
		public var callbacks:Array;
		protected var _loader:ILoader;
		public var clearType:int;
		
		public function BaseDataFileList(path:String, callback:Function, clearType:int)
		{
			this.path = path;
			this.callbacks = [];
			this.clearType = clearType;
			this.addCallback(callback);
			this.initLoad();
		}
		protected function initLoad():void
		{
			this._loader = new DataFileLoader(this.path, this.loadComplete, 3);
			this._loader.loadSync();
		}
		protected function loadComplete(loader:ILoader):void
		{
			var j:Function;
			this._fileDatas = new BaseDataFileInfo(this.path, (loader.getData() as ByteArray));
			for each (j in this.callbacks) {
				if (j != null){
					(j(this._fileDatas));
				};
			};
			this.callbacks.length = 0;
		}
		public function addCallback(func:Function):void
		{
			if (this._fileDatas){
				(func(this._fileDatas));
			} else {
				if (this.callbacks.indexOf(func) == -1){
					this.callbacks.push(func);
				};
			};
		}
		public function removeCallback(func:Function):void
		{
			var index:int = this.callbacks.indexOf(func);
			if (index > -1){
				this.callbacks.splice(index, 1);
			};
		}
		public function getLen():int
		{
			if (this.callbacks == null){
				return (0);
			};
			return (this.callbacks.length);
		}
		public function dispose():void
		{
			if (this._loader){
				this._loader.dispose();
				this._loader = null;
			};
			if (this._fileDatas){
				this._fileDatas.dispose();
				this._fileDatas = null;
			};
			this.callbacks = null;
		}
		
	}
}
