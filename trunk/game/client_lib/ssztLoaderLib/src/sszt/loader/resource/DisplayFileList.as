package sszt.loader.resource
{
	import sszt.loader.ModuleLoader;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.loader.LoaderManager;
	import flash.display.BitmapData;
	
	public class DisplayFileList 
	{
		
		public var path:String;
		public var classPath:String;
		public var callbacks:Array;
		private var _loader:ModuleLoader;
		private var _fileInfo:IDisplayFileInfo;
		public var clearType:int;
		
		public function DisplayFileList(path:String, classPath:String, callback:Function, clearType:int)
		{
			this.path = path;
			this.classPath = classPath;
			this.callbacks = [];
			this.clearType = clearType;
			this.addCallback(callback);
			this.initLoad();
		}
		private function initLoad():void
		{
			this._loader = new ModuleLoader(this.path, this.loadComplete, 3);
			this._loader.loadSync();
		}
		private function loadComplete(loader:ModuleLoader):void
		{
			var i:Function;
			this._fileInfo = new DisplayFileInfo();
			var t:Class = (LoaderManager.domain.getDefinition(this.classPath) as Class);
			this._fileInfo.data = (new (t)() as BitmapData);
			this._fileInfo.path = this.path;
			for each (i in this.callbacks) {
				(i(this._fileInfo));
			};
			if (this._loader){
				this._loader.dispose();
				this._loader = null;
			};
		}
		public function addCallback(func:Function):void
		{
			if (this.callbacks.indexOf(func) > -1){
				if (this._fileInfo != null){
					(func(this._fileInfo));
				};
				return;
			};
			this.callbacks.push(func);
			if (this._fileInfo != null){
				(func(this._fileInfo));
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
			if (this._fileInfo){
				this._fileInfo.dispose();
				this._fileInfo = null;
			};
			this.callbacks = null;
		}
		
	}
}
