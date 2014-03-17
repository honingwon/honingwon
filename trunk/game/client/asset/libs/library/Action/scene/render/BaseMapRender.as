package scene.render
{
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;
    import mhsm.constData.*;
    import mhsm.interfaces.scene.*;
    import scene.map.*;
    import scene.scene.*;

    public class BaseMapRender extends BaseRender implements ITick
    {
        private var _first:Boolean;
        protected var _mapContainer:DisplayObjectContainer;
        private var _hasChange:Boolean;

        public function BaseMapRender(scene:IScene, camera:ICamera, vPort:IViewPort)
        {
            super(scene, camera, vPort);
            _mapContainer = new Sprite();
            var _loc_4:Boolean = false;
            _mapContainer.mouseEnabled = false;
            _mapContainer.mouseChildren = _loc_4;
            _first = true;
            return;
        }// end function

        public function update(times:int, dt:Number = 0.04) : void
        {
            if (!_hasChange)
            {
                return;
            }
            var _loc_3:* = viewPort as DisplayObject;
            var _loc_4:int = 50;
            var _loc_5:* = new Point(viewPort.viewRect.x, viewPort.viewRect.y);
            if (_loc_3.x + _loc_5.x > _loc_4)
            {
                _loc_3.x = _loc_3.x - (_loc_3.x + _loc_5.x - _loc_4) * 0.12;
            }
            else if (_loc_3.x + _loc_5.x < -_loc_4)
            {
                _loc_3.x = _loc_3.x - (_loc_3.x + _loc_5.x + _loc_4) * 0.12;
            }
            if (_loc_3.y + _loc_5.y > _loc_4)
            {
                _loc_3.y = _loc_3.y - (_loc_3.y + _loc_5.y - _loc_4) * 0.12;
            }
            else if (_loc_3.y + _loc_5.y < -_loc_4)
            {
                _loc_3.y = _loc_3.y - (_loc_3.y + _loc_5.y + _loc_4) * 0.12;
            }
            if (Math.abs(_loc_3.x + _loc_5.x) <= _loc_4)
            {
            }
            if (Math.abs(_loc_3.y + _loc_5.y) <= _loc_4)
            {
                _hasChange = false;
            }
            return;
        }// end function

        override public function render() : void
        {
            var _loc_7:DisplayObjectContainer = null;
            var _loc_1:* = getTimer();
            var _loc_2:* = scene as BaseMapScene;
            var _loc_3:* = _loc_2.getMap();
            var _loc_4:* = viewPort.getLayerContainer(LayerIndex.MAPLAYER);
            if (!_loc_4.contains(_mapContainer))
            {
                _loc_4.addChild(_mapContainer);
                _mapContainer.x = viewPort.maxRect.x;
                _mapContainer.y = viewPort.maxRect.y;
            }
            var _loc_5:* = LayerIndex.getLayers();
            var _loc_6:int = 0;
            while (_loc_6 < _loc_5.length)
            {
                
                _loc_7 = viewPort.getLayerContainer(_loc_5[_loc_6]);
                _loc_7.x = -viewPort.viewRect.x;
                _loc_7.y = -viewPort.viewRect.y;
                _loc_6 = _loc_6 + 1;
            }
            _loc_3.fillRect(_mapContainer, viewPort.maxRect, viewPort.viewRect);
            return;
        }// end function

    }
}
