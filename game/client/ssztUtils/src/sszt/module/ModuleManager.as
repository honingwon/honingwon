/**
 *  @author lxb
 * 2012.9.13 修改
 */
package sszt.module
{
	import flash.display.DisplayObject;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	import sszt.constData.DecodeType;
	import sszt.events.ModuleEvent;
	import sszt.interfaces.layer.ILayerManager;
	import sszt.interfaces.loader.ILoader;
	import sszt.interfaces.loader.ILoaderApi;
	import sszt.interfaces.loader.IWaitLoading;
	import sszt.interfaces.module.*;
	import sszt.interfaces.module.IModule;
	import sszt.interfaces.path.IPathManager;
		
	public class ModuleManager implements IModuleManager 
	{
		
		private var _addModules:Dictionary;
		private var _currentModule:IModule;
		private var _loadingPanel:IWaitLoading;
		private var _pathManager:IPathManager;
		private var _moduleCreator:ModuleCreator;
		private var _loaderapi:ILoaderApi;
		private var _tranview:ModuleTransitionView;
		private var _layerManager:ILayerManager;
		
		private function createModuleSync(moduleId:int, complateHandler:Function, progressHandler:Function=null):void
		{
			if (_loaderapi.getHadDefined(_pathManager.getModuleClassPath(moduleId))){
				complateHandler(moduleId);
			}
			else 
			{
				_moduleCreator.create(moduleId, complateHandler, progressHandler);
			}
		}
		public function setup(layermanager:ILayerManager, pathManager:IPathManager, loaderapi:ILoaderApi, loadingPanel:IWaitLoading):void
		{
			_layerManager = layermanager;
			_pathManager = pathManager;
			_loaderapi = loaderapi;
			_loadingPanel = loadingPanel;
			_addModules = new Dictionary();
			_tranview = new ModuleTransitionView(_layerManager.getTipLayer());
			_moduleCreator = new ModuleCreator(_loaderapi, _pathManager);
		}
		
		public function getCurrentModule():IModule
		{
			return _currentModule;
		}
		private function showChanging(moduleId:int, data:Object=null):void
		{
			var startChange:Function;
			var moduleId:int = moduleId;
			startChange = function ():void
			{
				setModuleImmediately(moduleId, data);
			}
			_tranview.start(startChange);
		}
		public function removeModule(module:IModule):void
		{
			if (_addModules[module.moduleId] != null){
				delete _addModules[module.moduleId];
			}
			module.free(null);
		}
		private function addModuleImmediately(moduleId:int, data:*=null, addToStage:Boolean=false):void
		{
			if (_addModules[moduleId] != null){
				(_addModules[moduleId] as IModule).configure(data);
				return;
			}
			var module:IModule = newModule(moduleId);
			if (module == null){
				return;
			}
			module.addEventListener(ModuleEvent.MODULE_DISPOSE, addModuleDisposeHandler);
			_addModules[moduleId] = module;
			if (addToStage){
				/**添加到弹窗层*/
				_layerManager.getPopLayer().addChild((module as DisplayObject));
			}
			module.setup(null, data);
		}
		private function newModule(moduleId:int):IModule
		{
			var moduleClass:Class = _loaderapi.getClassByPath(_pathManager.getModuleClassPath(moduleId));
			if (moduleClass)
			{
				return new (moduleClass)() as IModule;
			}
			return null;
		}
		
		/**
		 * 添加模块 
		 * @param moduleId
		 * @param data
		 * @param addToStage
		 * @param assetNeeds 
		 * @param showLoading
		 * 
		 */		
		public function addModule(moduleId:int, data:Object=null, addToStage:Boolean=false, assetNeeds:Array=null, showLoading:Boolean=true):void
		{
			var add:Boolean;
			var totalLen:int;
			var check:Function;
			var assetLoadComplete:Function;
			var loadingCancel:Function;
			check = function (moduleId:int):void
			{
				if (!add){
					return;
				}
				loadComplete();
				_loadingPanel.hide();
				
				var path:String;
				
				if (totalLen != 0)
				{
					for each (path in assetNeeds) 
					{
						if (_loaderapi.pathHadLoaded(path))
						{
							totalLen--;
						} 
						else {
							_loaderapi.loadSwf(path, assetLoadComplete, 3, DecodeType.NONE);
						}
					}
					checkAllAssetComplete();
				}
			}
			assetLoadComplete = function (loader:ILoader):void
			{
				if (loader){
					loader.dispose();
				}
				totalLen--;
				checkAllAssetComplete();
			}
			var checkAllAssetComplete:Function = function ():void
			{
				if (totalLen == 0){
					if (_addModules[moduleId] != null){
						(_addModules[moduleId] as IModule).assetsCompleteHandler();
						return;
					}
				}
			}
			loadingCancel = function ():void
			{
				add = false;
				if (_moduleCreator){
					_moduleCreator.cancelLoad(moduleId);
				}
			}
			var loadComplete:Function = function ():void
			{
				if (add){
					addModuleImmediately(moduleId, data, addToStage);
				}
			}
			add = true;
			assetNeeds = _pathManager.getModulAssetsPath(moduleId);
			totalLen = assetNeeds == null ? 0 : assetNeeds.length;
			if (_loaderapi.getHadDefined(_pathManager.getModuleClassPath(moduleId))){
				check(moduleId);
			} 
			else {
				if (showLoading)
				{
					_loadingPanel.showModuleLoading(moduleId, loadingCancel);
					createModuleSync(moduleId, check, _loadingPanel.setProgress);
				} 
				else 
				{
					createModuleSync(moduleId, check);
				}
			}
		}
		private function setModuleImmediately(moduleId:int, data:Object=null):void
		{
			if (_currentModule && _currentModule.moduleId == moduleId){
				_currentModule.configure(data);
				return;
			}
			var module:IModule = newModule(moduleId);
			if (!module){
				return;
			}
			if (_currentModule != null){
				_currentModule.free(module);
			}
			_currentModule = module;
			_layerManager.getModuleLayer().addChild((module as DisplayObject));
			module.setup(_currentModule, data);
			Mouse.show();
			ModuleEventDispatcher.dispatchModuleEvent(new ModuleEvent(ModuleEvent.MODULE_CHANGE, moduleId));
		}
		public function setModule(moduleId:int, moduleNeed:Array=null, data:*=null, assetNeeds:Array=null, modulePres:Array=null, showChange:Boolean=true, cancelAble:Boolean=true):void
		{
			var modules:Array;
			var loaded:int;
			var assetLoaded:int;
			var assetTotal:int;
			var toId:int;
			var goto:Boolean;
			var targetModule:int;
			var loadingCancel:Function;
			var check:Function;
			var assetLoadComplete:Function;
			var loadNext:Function = function ():void
			{
				var cancel:Function;
				if (!_loaderapi.getHadDefined(_pathManager.getModuleClassPath(modules[loaded]))){
					cancel = cancelAble ? loadingCancel : null;
					_loadingPanel.showModuleLoading(moduleId, cancel);
					createModuleSync(modules[loaded], check, _loadingPanel.setProgress);
				}
				else 
				{
					check(modules[loaded]);
				}
			}
			loadingCancel = function ():void
			{
				goto = false;
				if (_moduleCreator)
				{
					_moduleCreator.cancelLoad(moduleId);
				}
			}
			check = function (moduleId:int):void
			{
				if (loaded == 0){
					targetModule = toId;
				}
				loaded++;
				if (loaded == modules.length){
					checkAsset();
				} 
				else {
					loadNext();
				}
			}
			var checkAsset:Function = function ():void
			{
				var i:String;
				if (assetTotal == 0){
					allLoadComplete();
				} 
				else {
					for each (i in assetNeeds) {
						if (!_loaderapi.pathHadLoaded(i)){
							_loaderapi.loadSwf(i, assetLoadComplete, 3, DecodeType.RESOURCE_DECODE);
						}
					}
				}
			}
			assetLoadComplete = function (loader:ILoader):void
			{
				assetLoaded++;
				if (assetLoaded >= assetTotal){
					allLoadComplete();
				}
				loader.dispose();
			}
			var allLoadComplete:Function = function ():void
			{
				var i:ILoader;
				if (modulePres != null && modulePres.length > 0){
					for each (i in modulePres) {
						i.loadSync();
					}
				}
				_loadingPanel.hide();
				if (!goto){
					return;
				}
				if (showChange){
					changeMethod(targetModule, data);
				} 
				else {
					setModuleImmediately(targetModule, data);
				}
			}
			modules = new Array();
			loaded = 0;
			assetLoaded = 0;
			assetTotal = assetNeeds == null ? 0 : assetNeeds.length;
			toId = moduleId;
			goto = true;
			var changeMethod:Function = showChanging;
			modules.push(moduleId);
			if (moduleNeed != null){
				modules = moduleNeed;
			}
			loadNext();
		}
		
		
		private function addModuleDisposeHandler(evt:ModuleEvent):void
		{
			var module:IModule = (evt.currentTarget as IModule);
			module.removeEventListener(ModuleEvent.MODULE_DISPOSE, addModuleDisposeHandler);
			delete _addModules[module.moduleId];
		}
		
		/**
		 * 根据模块编号获得模块
		 * @param moduleId 模块编号
		 * @return 
		 * 
		 */
		public function getModuleById(moduleId:int):IModule
		{
			if(_addModules[moduleId])
			{
				return _addModules[moduleId]
			}
			return null;
		}
		
	}
}