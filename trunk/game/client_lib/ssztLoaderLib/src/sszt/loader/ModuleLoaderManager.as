package sszt.loader
{
	import flash.utils.Dictionary;
	import sszt.loader.loaderinfo.LoaderList;
	import sszt.interfaces.loader.ILoader;
	import sszt.loader.data.LoaderClearType;
	
	public class ModuleLoaderManager 
	{
		
		public static var loaderQueue:Dictionary = new Dictionary();
		public static var hadLoads:Dictionary = new Dictionary();
		
		public static function addLoaderInfo(path:String, loader:ILoader, completeHandler:Function=null, errorHandler:Function=null, progressHandler:Function=null):void
		{
			if (loaderQueue[path] == null){
				loaderQueue[path] = new LoaderList(path);
			};
			LoaderList(loaderQueue[path]).addLoading(loader, completeHandler, errorHandler, progressHandler);
		}
		public static function removeLoaderInfo(path:String, loader:ILoader):void
		{
			var loaderList:LoaderList = loaderQueue[path];
			if (loaderList == null){
				return;
			};
			loaderList.removeLoading(loader);
			if (loaderList.list.length == 0){
				delete loaderQueue[path];
			};
		}
		public static function setLoaderStart(path:String):void
		{
			var loader:LoaderList = loaderQueue[path];
			if (loader == null){
				return;
			};
			loader.setLoadingState(true);
		}
		public static function setLoaderStop(path:String):void
		{
			var loader:LoaderList = loaderQueue[path];
			if (loader == null){
				return;
			};
			loader.setLoadingState(false);
		}
		public static function setLoaderState(path:String, value:Boolean):void
		{
			var loader:LoaderList = loaderQueue[path];
			if (loader == null){
				return;
			};
			loader.setLoadingState(value);
		}
		public static function setCurrentLoading(path:String, loader:ILoader):void
		{
			var loaderlist:LoaderList = loaderQueue[path];
			if (loaderlist == null){
				return;
			};
			loaderlist.setCurrentLoading(loader);
		}
		public static function getLoaderState(path:String):Boolean
		{
			var loader:LoaderList = loaderQueue[path];
			if (loader == null){
				return (false);
			};
			return (loader.isLoading);
		}
		public static function addToHadLoads(path:String):void
		{
			hadLoads[path] = true;
		}
		public static function getPathHadLoaded(path:String):Boolean
		{
			return ((hadLoads[path] == true));
		}
		public static function getPathLoadNum(path:String):int
		{
			var loader:LoaderList = loaderQueue[path];
			if (loader == null){
				return 0;
			}
			return (loader.list.length);
		}
		public static function startNextLoad(path:String):void
		{
			var loader:LoaderList = loaderQueue[path];
			if (loader == null){
				return;
			};
			loader.nextStartLoad();
		}
		public static function selfIsCurrent(path:String, loader:ILoader):Boolean
		{
			var sloader:LoaderList = loaderQueue[path];
			if (sloader == null){
				return (false);
			};
			return (sloader.checkIsCurrent(loader));
		}
		public static function loaderProgress(path:String, loadedBytes:Number, totalBytes:Number):void
		{
			var loader:LoaderList = loaderQueue[path];
			if (loader == null){
				return;
			};
			loader.loadProgress(loadedBytes, totalBytes);
		}
		public static function clearLoader(path:String, state:int=-1):void
		{
			var loader:LoaderList = loaderQueue[path];
			if (loader == null){
				return;
			};
			if (state == LoaderClearType.CLEARQUEUEANDDOERROR){
				loader.loadError();
			} else {
				if (state == LoaderClearType.CLEARQUEUEANDDOCOMPLETE){
					loader.loadComplete();
					addToHadLoads(path);
				};
			};
			loader.dispose();
			loaderQueue[path] = null;
		}
		
	}
}
