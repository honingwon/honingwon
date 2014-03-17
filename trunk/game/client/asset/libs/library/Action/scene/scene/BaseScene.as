package scene.scene
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import mhsm.constData.*;
    import mhsm.interfaces.scene.*;
    import scene.events.*;

    public class BaseScene extends EventDispatcher implements IScene
    {
        private var _viewport:IViewPort;
        private var _sceneObjs:Array;
        private var _mapData:IMapData;

        public function BaseScene(mapdata:IMapData, viewport:IViewPort)
        {
            _mapData = mapdata;
            _sceneObjs = [];
            _viewport = viewport;
            return;
        }// end function

        public function addToMap(obj:DisplayObject) : void
        {
            dispatchEvent(new SceneEvent(SceneEvent.ADD_TOMAP, null, null, null, obj));
            return;
        }// end function

        public function addChild(obj:ISceneObj) : ISceneObj
        {
            return toAddChild(obj);
        }// end function

        public function addControl(obj:DisplayObject) : void
        {
            dispatchEvent(new SceneEvent(SceneEvent.ADD_CONTROL, null, null, null, obj));
            return;
        }// end function

        public function get width() : uint
        {
            return _mapData.getWidth();
        }// end function

        public function move(obj:ISceneObj, scenePt:Point) : void
        {
            var _loc_3:* = Math.floor(obj.sceneY / SceneConfig.TILE_SIZE);
            var _loc_4:* = Math.floor(obj.sceneX / SceneConfig.TILE_SIZE);
            var _loc_5:* = Math.floor(scenePt.y / SceneConfig.TILE_SIZE);
            var _loc_6:* = Math.floor(scenePt.x / SceneConfig.TILE_SIZE);
            var _loc_7:* = new Point(obj.sceneX, obj.sceneY);
            if (_loc_5 == _loc_3)
            {
            }
            if (_loc_6 != _loc_4)
            {
                toRemoveChild(obj, false);
                obj.setScenePos(scenePt.x, scenePt.y);
                toAddChild(obj, false);
            }
            else
            {
                obj.setScenePos(scenePt.x, scenePt.y);
            }
            dispatchEvent(new SceneEvent(SceneEvent.MOVE_CHILD, obj, _loc_7, scenePt.clone()));
            return;
        }// end function

        protected function toAddChild(obj:ISceneObj, dispatch:Boolean = true) : ISceneObj
        {
            if (obj.scene != null)
            {
                obj.scene.removeChild(obj);
            }
            obj.scene = this;
            var _loc_3:* = Math.floor(obj.sceneY / SceneConfig.TILE_SIZE);
            var _loc_4:* = Math.floor(obj.sceneX / SceneConfig.TILE_SIZE);
            if (dispatch)
            {
                dispatchEvent(new SceneEvent(SceneEvent.ADD_CHILD, obj));
            }
            return obj;
        }// end function

        public function getSceneObjsByPos(row:int, col:int) : Array
        {
            if (_sceneObjs[row] == null)
            {
                return null;
            }
            if (_sceneObjs[row][col] == null)
            {
                return null;
            }
            return _sceneObjs[row][col];
        }// end function

        public function dispose() : void
        {
            _mapData = null;
            _sceneObjs = null;
            _viewport = null;
            return;
        }// end function

        public function addEffect(effect:DisplayObject) : void
        {
            dispatchEvent(new SceneEvent(SceneEvent.ADD_EFFECT, null, null, null, effect));
            return;
        }// end function

        public function get mapData() : IMapData
        {
            return _mapData;
        }// end function

        public function get height() : uint
        {
            return _mapData.getHeight();
        }// end function

        public function getViewPort() : IViewPort
        {
            return _viewport;
        }// end function

        protected function toRemoveChild(obj:ISceneObj, dispatch:Boolean = true) : void
        {
            if (obj.scene != this)
            {
                return;
            }
            obj.scene = null;
            var _loc_3:* = Math.floor(obj.sceneY / SceneConfig.TILE_SIZE);
            var _loc_4:* = Math.floor(obj.sceneX / SceneConfig.TILE_SIZE);
            if (dispatch)
            {
                dispatchEvent(new SceneEvent(SceneEvent.REMOVE_CHILD, obj));
            }
            return;
        }// end function

        public function removeChild(obj:ISceneObj) : void
        {
            toRemoveChild(obj);
            return;
        }// end function

    }
}
