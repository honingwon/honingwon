package sszt.loader.resource
{
	import flash.utils.Dictionary;
	import sszt.constData.SourceClearType;
	import sszt.interfaces.loader.*;
	
	public class DataFileManager implements IDataFileManager 
	{
		
		public var caches:Dictionary;
		
		public function DataFileManager()
		{
			this.caches = new Dictionary();
			super();
		}
		public function getDataSourceFile(path:String, callback:Function, clearType:int):void
		{
			var cache:BaseDataFileList = this.caches[path];
			if (cache == null){
				cache = new BaseDataFileList(path, callback, clearType);
				this.caches[cache.path] = cache;
			} else {
				cache.addCallback(callback);
			};
		}
		public function removeQuote(path:String, callback:Function):void
		{
			var len:int;
			var cache:BaseDataFileList = this.caches[path];
			if (cache){
				cache.removeCallback(callback);
				if (cache.clearType == SourceClearType.CHANGE_SCENE){
					len = cache.getLen();
					if (len == 0){
						cache.dispose();
						delete this.caches[path];
					};
				};
			};
		}
		public function changeSceneClear():void
		{
			var i:BaseDataFileList;
			for each (i in this.caches) {
				if (((i) && ((i.clearType == SourceClearType.CHANGE_SCENE)))){
					delete this.caches[i.path];
					i.dispose();
				};
			};
		}
		
	}
}
