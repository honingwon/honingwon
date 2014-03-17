package sszt.loader.resource
{
	import flash.utils.Dictionary;
	import sszt.constData.SourceClearType;
	import sszt.interfaces.loader.*;
	
	public class DisplayFileManager implements IDisplayFileManager 
	{
		
		public var caches:Dictionary;
		
		public function DisplayFileManager()
		{
			this.caches = new Dictionary();
			super();
		}
		public function getFile(path:String, classPath:String, callback:Function, clearType:int):void
		{
			var cache:DisplayFileList = this.caches[path];
			if (cache == null){
				cache = new DisplayFileList(path, classPath, callback, clearType);
				this.caches[cache.path] = cache;
			} else {
				cache.addCallback(callback);
			};
		}
		public function removeQuote(path:String, callback:Function):void
		{
			var len:int;
			var cache:DisplayFileList = this.caches[path];
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
		public function timeclear(path:String, checkQuote:Boolean=false):void
		{
			var i:DisplayFileList;
			for each (i in this.caches) {
				if (((i) && ((i.path == path)))){
					if ((((i.clearType == SourceClearType.TIME)) && (((!(checkQuote)) || (((checkQuote) && ((i.getLen() == 0)))))))){
						i.dispose();
						delete this.caches[i.path];
					};
					break;
				};
			};
		}
		public function changeSceneClear():void
		{
			var i:DisplayFileList;
			for each (i in this.caches) {
				if (((i) && ((i.clearType == SourceClearType.CHANGE_SCENE)))){
					delete this.caches[i.path];
					i.dispose();
				};
			};
		}
		
	}
}
