

package sszt.module
{
	import flash.utils.Dictionary;
	
	import sszt.constData.DecodeType;
	import sszt.events.LoaderEvent;
	import sszt.interfaces.loader.ILoader;
	import sszt.interfaces.loader.ILoaderApi;
	import sszt.interfaces.path.IPathManager;
	
	public class ModuleCreator 
	{
		
		private var _loadapi:ILoaderApi;
		private var _pathManager:IPathManager;
		private var _loadingList:Dictionary;
		
		public function ModuleCreator(loader:ILoaderApi, pathmanager:IPathManager)
		{
			_loadapi = loader;
			_pathManager = pathmanager;
			_loadingList = new Dictionary();
		}
		public function cancelLoad(moduleId:int):void
		{
			var path:String = _pathManager.getModulePath(moduleId);
			var obj:Object = _loadingList[moduleId];
			if (obj)
			{
				if (obj["cancel"] != null)
				{
					obj["cancel"](moduleId);
				}
			}
		}
		public function create(moduleId:int, complateHandler:Function, progressHandler:Function=null):void
		{
			var file:String;
			var moduleLoadComplete:Function;
			var moduleLoadProgress:Function;
			var cancelHandler:Function;
			var obj:Object;
			var loader:ILoader;
			var t:ILoader;
			moduleLoadComplete = function (loader:ILoader):void
			{
				loader.removeEventListener(LoaderEvent.LOAD_PROGRESS, moduleLoadProgress);
				loader.dispose();
				delete _loadingList[moduleId];
				complateHandler(moduleId);
			}
			moduleLoadProgress = function (evt:LoaderEvent):void
			{
				if (progressHandler != null){
					progressHandler(evt.bytesLoaded, evt.bytesTotal);
				}
			}
			cancelHandler = function (moduleId:int):void
			{
				var loader:ILoader;
				var obj:Object = _loadingList[moduleId];
				if (obj)
				{
					loader = obj["loader"];
					loader.removeEventListener(LoaderEvent.LOAD_PROGRESS, moduleLoadProgress);
					loader.dispose();
				}
				delete _loadingList[moduleId];
			}
			if (!_loadapi.getHadDefined(_pathManager.getModuleClassPath(moduleId))){
				file = _pathManager.getModulePath(moduleId);
				if (file){
					obj = _loadingList[moduleId];
					if (obj == null){
						t = _loadapi.loadSwf(file, moduleLoadComplete,3, DecodeType.CLIENT_DECODE);
						_loadingList[moduleId] = {
							loader:t,
							cancel:cancelHandler
						}
						obj = _loadingList[moduleId];
					}
					loader = obj["loader"];
					loader.addEventListener(LoaderEvent.LOAD_PROGRESS, moduleLoadProgress, false, 0, true);
				} 
				else {
					trace((_pathManager.getModulePath(moduleId) + "module cannot found"));
				}
			} 
			else {
				complateHandler(moduleId);
			}
		}
		
	}
}
