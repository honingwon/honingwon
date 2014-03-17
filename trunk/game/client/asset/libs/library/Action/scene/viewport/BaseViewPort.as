package scene.viewport
{
    import flash.display.*;
    import flash.geom.*;
    import mhsm.constData.*;

    public class BaseViewPort extends Sprite implements IViewPort
    {
        protected var _layerContainers:Array;
        protected var _viewRect:Rectangle;
        private var _maxRect:Rectangle;
        private var _movableRect:Rectangle;
        private var _focusPoint:Point;

        public function BaseViewPort(mapWidth:int, mapHeight:int, focusX:int = 500, focusY:int = 300, movWidth:int = 300, movHeight:int = 150, viewWidth:int = 1000, viewHeight:int = 600)
        {
            var _loc_13:Sprite = null;
            mouseEnabled = false;
            _layerContainers = [];
            var _loc_9:* = LayerIndex.getLayers();
            var _loc_10:* = LayerIndex.getMouseEnableds();
            var _loc_11:* = LayerIndex.getMouseChildrens();
            var _loc_12:int = 0;
            while (_loc_12 < _loc_9.length)
            {
                
                _loc_13 = new Sprite();
                _loc_13.mouseEnabled = _loc_10[_loc_12];
                _loc_13.mouseChildren = _loc_11[_loc_12];
                addChild(_loc_13);
                _layerContainers.push(_loc_13);
                _loc_12 = _loc_12 + 1;
            }
            _maxRect = new Rectangle(0, 0, mapWidth, mapHeight);
            _movableRect = new Rectangle(0, 0, movWidth, movHeight);
            _viewRect = new Rectangle(0, 0, viewWidth, viewHeight);
            focusPoint = new Point(focusX, focusY);
            return;
        }// end function

        public function get focusPoint() : Point
        {
            return _focusPoint;
        }// end function

        public function set maxRect(rect:Rectangle) : void
        {
            _maxRect = rect;
            return;
        }// end function

        public function set viewRect(rect:Rectangle) : void
        {
            _viewRect.width = rect.width;
            _viewRect.height = rect.height;
            _viewRect.x = Math.max(rect.x, _maxRect.x);
            _viewRect.x = Math.min(rect.x, _maxRect.x + _maxRect.width - rect.width);
            _viewRect.y = Math.max(rect.y, _maxRect.y);
            _viewRect.y = Math.min(rect.y, _maxRect.y + _maxRect.height - rect.height);
            _movableRect.x = _viewRect.x + (viewRect.width - _movableRect.width) * 0.5;
            _movableRect.y = _viewRect.y + (viewRect.height - _movableRect.height) * 0.5;
            return;
        }// end function

        public function get maxRect() : Rectangle
        {
            return _maxRect;
        }// end function

        public function set movableRect(rect:Rectangle) : void
        {
            _movableRect.width = rect.width;
            _movableRect.height = rect.height;
            _movableRect.x = _viewRect.x + (viewRect.width - _movableRect.width) * 0.5;
            _movableRect.y = _viewRect.y + (viewRect.height - _movableRect.height) * 0.5;
            return;
        }// end function

        public function getLayerContainer(layer:uint) : Sprite
        {
            return _layerContainers[layer];
        }// end function

        public function get viewRect() : Rectangle
        {
            return _viewRect;
        }// end function

        public function get movableRect() : Rectangle
        {
            return _movableRect;
        }// end function

        public function setMapSize(w:Number, h:Number) : void
        {
            _maxRect.width = w;
            _maxRect.height = h;
            return;
        }// end function

        public function set focusPoint(value:Point) : void
        {
            _focusPoint = value;
            var _loc_2:* = _focusPoint.x - _movableRect.x;
            if (_loc_2 < 0)
            {
                _viewRect.x = _viewRect.x + _loc_2;
            }
            var _loc_3:* = _focusPoint.x - (_movableRect.x + _movableRect.width);
            if (_loc_3 > 0)
            {
                _viewRect.x = _viewRect.x + _loc_3;
            }
            var _loc_4:* = _focusPoint.y - _movableRect.y;
            if (_loc_4 < 0)
            {
                _viewRect.y = _viewRect.y + _loc_4;
            }
            var _loc_5:* = _focusPoint.y - (_movableRect.y + _movableRect.height);
            if (_loc_5 > 0)
            {
                _viewRect.y = _viewRect.y + _loc_5;
            }
            viewRect = _viewRect;
            return;
        }// end function

    }
}
