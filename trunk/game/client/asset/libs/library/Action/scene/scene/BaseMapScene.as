package scene.scene
{
    import flash.geom.*;
    import mhsm.interfaces.scene.*;
    import scene.map.*;

    public class BaseMapScene extends BaseScene
    {
        protected var _rect:Rectangle;
        protected var _map:BaseMap;

        public function BaseMapScene(mapdata:IMapData, viewport:IViewPort)
        {
            super(mapdata, viewport);
            return;
        }// end function

        public function getMap() : BaseMap
        {
            return _map;
        }// end function

        public function getRect() : Rectangle
        {
            return _rect;
        }// end function

        public function setMap(map:BaseMap) : void
        {
            _map = map;
            return;
        }// end function

        public function setRect(rect:Rectangle) : void
        {
            _rect = rect;
            return;
        }// end function

    }
}
