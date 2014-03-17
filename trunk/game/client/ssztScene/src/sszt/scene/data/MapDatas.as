package sszt.scene.data
{
    import flash.events.*;
    import flash.utils.*;
    
    import sszt.constData.SourceClearType;
    import sszt.core.data.GlobalAPI;
    import sszt.core.data.map.MapTemplateList;
    import sszt.interfaces.loader.IDataFileInfo;

    public class MapDatas extends EventDispatcher
    {
        private var _mapList:Dictionary;

        public function MapDatas()
        {
            this._mapList = new Dictionary();
        }

        public function loadMapData(id:int) : void
        {
			var mapDataLoadComplete:Function =  function (data:IDataFileInfo) : void
			{
				var byteArray:ByteArray = data.getSourceData();
				var mapData:ByteArray = new ByteArray();
				byteArray.position = 0;
				byteArray.readBytes(mapData, 0);
				var sceneMapInfo:SceneMapInfo = new SceneMapInfo(id);
				sceneMapInfo.setData(mapData);
				_mapList[id] = sceneMapInfo;
				dispatchEvent(new SceneMapInfoUpdateEvent(SceneMapInfoUpdateEvent.LOAD_DATA_COMPLETE, id));
			};
            if (this._mapList[id] == null)
            {
                GlobalAPI.loaderAPI.getDataSourceFile(GlobalAPI.pathManager.getSceneConfigPath(MapTemplateList.getMapTemplate(id).mapPath), mapDataLoadComplete, SourceClearType.NEVER);
            }
            else
            {
                dispatchEvent(new SceneMapInfoUpdateEvent(SceneMapInfoUpdateEvent.LOAD_DATA_COMPLETE, id));
            } 
			
        }

        public function getMapInfo(id:int) : SceneMapInfo
        {
            return this._mapList[id];
        }

    }
}
