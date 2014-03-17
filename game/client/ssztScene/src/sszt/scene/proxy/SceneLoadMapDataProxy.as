package sszt.scene.proxy
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.constData.CategoryType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.interfaces.loader.IDataFileInfo;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	import sszt.scene.data.SceneMapInfo;
	import sszt.scene.mediators.SceneMediator;
	
	public class SceneLoadMapDataProxy
	{
		private static var _mapDataPath:String = "";
		private static var _mapDataLoadComplete:Function;
		
		private static var _mapPrePath:String = "";
		private static var _mapPreLoadComplete:Function;
		private static var _mapPreId:int;
		
		private static var _mapdetails:Dictionary = new Dictionary();
		
		private static var _mediator:SceneMediator;
		
		public static function setup(mediator:SceneMediator):void
		{
			_mediator = mediator;
		}
		
		public static function loadMapData(id:int,loadComplete:Function = null):void
		{
			_mapDataPath = GlobalAPI.pathManager.getSceneConfigPath(getPath(id,false));
			_mapDataLoadComplete = loadComplete; 
			GlobalAPI.loaderAPI.getDataSourceFile(_mapDataPath,mapDataLoadComplete,SourceClearType.CHANGE_SCENE);
		}
		private static function mapDataLoadComplete(data:IDataFileInfo):void
		{
			if(_mapDataLoadComplete != null)
				_mapDataLoadComplete(data.getSourceData());
		}
		
		public static function loadMapPre(id:int,loadComplete:Function = null):void
		{
			_mapPreLoadComplete = loadComplete;
			GlobalAPI.loaderAPI.getPicFile(GlobalAPI.pathManager.getScenePreMapPath(getPath(id)),mapPreLoadComplete,SourceClearType.CHANGESCENE_AND_TIME,10000,1);
			function mapPreLoadComplete(value:BitmapData):void
			{
				loadComplete(value.clone());
			}
		}
		
		public static function loadTreasureMap(id:int, loadComplete:Function = null) : void
		{
			function mapPreLoadComplete(value:BitmapData) : void
			{
				var bd:BitmapData = value.clone();
				loadComplete(bd);
			}
			GlobalAPI.loaderAPI.getPicFile(GlobalAPI.pathManager.getScenePreMapPath(getPath(id)), mapPreLoadComplete, SourceClearType.CHANGE_SCENE, 214783647, 1);
		}
		
		public static function loadNeedMapData(id:int,row:int,col:int,loadComplete:Function = null):void
		{
			var path:String = GlobalAPI.pathManager.getSceneDetailMapPath(getPath(id),row,col);
			GlobalAPI.loaderAPI.getPicFile(path,needMapLoadComplete,SourceClearType.CHANGE_SCENE,214783647,3);
			function needMapLoadComplete(value:BitmapData):void
			{
				loadComplete(new Bitmap(value),row,col);
			}
		}
		
		/**
		 * 
		 * @param id
		 * @param setTime 是否跟据时间变化
		 * @return 
		 * 
		 */		
		public static function getPath(id:int,setTime:Boolean = true):String
		{
			var path:String = MapTemplateList.getMapTemplate(id).mapPath;
			if(setTime)
			{
				if(CategoryType.isClubMap(id))
				{
					var hour:int = GlobalData.systemDate.getSystemDate().hours;
					if(hour < 6 || hour > 17)path += "_1";
				}
				else if(_mediator.sceneInfo.mapInfo.isSpaScene())
				{
					var hour1:int = GlobalData.systemDate.getSystemDate().hours;
					if(hour1 > 20)path += "_1";
				}
			}
			return path;
		}
		
		public static function clear():void
		{
			if(_mapDataPath != "")
			{
				GlobalAPI.loaderAPI.removeDataFile(_mapDataPath,mapDataLoadComplete);
				_mapDataPath = "";
			}
			_mapDataLoadComplete = null;
//			if(_mapPrePath != "")
//			{
//				GlobalAPI.loaderAPI.removeDisplayFile(_mapPrePath,mapPreLoadComplete);
//				GlobalAPI.loaderAPI.displayTimeclear(_mapPrePath);
//				_mapPrePath = "";
//			}
			_mapPreLoadComplete = null;
//			if(_mapdetails)
//			{
//				for each(var i:Object in _mapdetails)
//				{
//					GlobalAPI.loaderAPI.removeDisplayFile(i["path"],needMapLoadComplete);
//					GlobalAPI.loaderAPI.displayTimeclear(i["path"]);
//				}
//				_mapdetails = new Dictionary();
//			}
			_mapdetails = new Dictionary();
		}
	}
}