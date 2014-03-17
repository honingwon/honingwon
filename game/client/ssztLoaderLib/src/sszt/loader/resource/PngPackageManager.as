package sszt.loader.resource
{
	import flash.utils.Dictionary;
	import sszt.constData.SourceClearType;
	
	public class PngPackageManager 
	{
		
		public var caches:Dictionary;
		
		public function PngPackageManager()
		{
			this.caches = new Dictionary();
			super();
		}
		public function getFile(path:String, id:int, layerType:String, playerSex:int, callback:Function, clearType:int):void
		{
			var cache:PngPackageFileList = this.caches[path];
			if (cache == null){
				cache = new PngPackageFileList(path, id, layerType, playerSex, callback, clearType);
				this.caches[cache.path] = cache;
			} else {
				cache.addCallback(callback);
			};
		}
		public function removeQuote(path:String, callback:Function):void
		{
			var len:int;
			var cache:PngPackageFileList = this.caches[path];
			if (cache){
				cache.removeCallback(callback);
				if (cache.clearType == SourceClearType.IMMEDIAT){
					len = this.caches[path].getLen();
					if (len == 0){
						cache.dispose();
						delete this.caches[path];
					};
				};
			};
		}
		public function changeSceneClear():void
		{
			var i:PngPackageFileList;
			for each (i in this.caches) {
				if (((i) && ((i.clearType == SourceClearType.CHANGE_SCENE)))){
					delete this.caches[i.path];
					i.dispose();
				};
			};
		}
		
	}
}
