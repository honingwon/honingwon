package scene.map
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import mhsm.constData.*;
    import scene.events.*;

    public class BaseMap extends EventDispatcher implements ITick
    {
        protected var _preFillRect:Rectangle;
        protected var _yscale:Number;
        protected var _preRenders:Dictionary;
        protected var _thumbnail:BitmapData;
        protected var _imgs:Dictionary;
        protected var _loaderList:Array;
        protected var _xscale:Number;
        private var _thumbMatrix:Matrix;
        protected var _thumbs:Dictionary;

        public function BaseMap()
        {
            _imgs = new Dictionary();
            _thumbs = new Dictionary();
            _thumbMatrix = new Matrix();
            _preFillRect = new Rectangle();
            _loaderList = [];
            return;
        }// end function

        public function fillRect(container:DisplayObjectContainer, maxRect:Rectangle, viewRect:Rectangle) : void
        {
            var _loc_10:String = null;
            var _loc_11:int = 0;
            var _loc_12:String = null;
            var _loc_13:DisplayObject = null;
            var _loc_14:DisplayObject = null;
            if (_preFillRect)
            {
            }
            if (_preFillRect.containsRect(viewRect))
            {
                return;
            }
            var _loc_4:* = (viewRect.y - maxRect.y) / SceneConfig.TILE_SIZE;
            var _loc_5:* = (viewRect.x - maxRect.x) / SceneConfig.TILE_SIZE;
            _loc_4 = _loc_4 < 0 ? (0) : (_loc_4);
            _loc_5 = _loc_5 < 0 ? (0) : (_loc_5);
            var _loc_6:* = Math.ceil((viewRect.y + viewRect.height - maxRect.y) / SceneConfig.TILE_SIZE);
            var _loc_7:* = Math.ceil((viewRect.x + viewRect.width - maxRect.x) / SceneConfig.TILE_SIZE);
            _preFillRect.x = _loc_5 * SceneConfig.TILE_SIZE;
            _preFillRect.y = _loc_4 * SceneConfig.TILE_SIZE;
            _preFillRect.width = (_loc_7 - _loc_5) * SceneConfig.TILE_SIZE;
            _preFillRect.height = (_loc_6 - _loc_4) * SceneConfig.TILE_SIZE;
            var _loc_8:* = new Dictionary();
            var _loc_9:* = _loc_4;
            while (_loc_9 < _loc_6)
            {
                
                _loc_11 = _loc_5;
                while (_loc_11 < _loc_7)
                {
                    
                    if (_loc_9 >= 0)
                    {
                    }
                    if (_loc_11 >= 0)
                    {
                        _loc_12 = _loc_9 + "_" + _loc_11;
                        _loc_13 = _imgs[_loc_12];
                        if (!_loc_13)
                        {
                            _loc_13 = getThumbObj(_loc_9, _loc_11);
                        }
                        if (container.contains(_loc_13))
                        {
                            delete _preRenders[_loc_12];
                        }
                        else
                        {
                            container.addChild(_loc_13);
                        }
                        if (!_imgs[_loc_12])
                        {
                            _loaderList.push([_loc_9, _loc_11]);
                        }
                        _loc_8[_loc_12] = _loc_13;
                    }
                    _loc_11 = _loc_11 + 1;
                }
                _loc_9 = _loc_9 + 1;
            }
            for (_loc_10 in _preRenders)
            {
                
                _loc_14 = _preRenders[_loc_10];
                if (container.contains(_loc_14))
                {
                    container.removeChild(_loc_14);
                }
            }
            _preRenders = _loc_8;
            return;
        }// end function

        public function clear() : void
        {
            var _loc_1:DisplayObject = null;
            var _loc_2:String = null;
            var _loc_3:Bitmap = null;
            var _loc_4:Bitmap = null;
            if (_thumbnail)
            {
                _thumbnail.dispose();
                _thumbnail = null;
            }
            for (_loc_2 in _imgs)
            {
                
                _loc_1 = _imgs[_loc_2];
                if (_loc_1 is Bitmap)
                {
                    _loc_3 = _loc_1 as Bitmap;
                    if (_loc_3.bitmapData)
                    {
                        _loc_3.bitmapData.dispose();
                    }
                }
                if (_loc_1)
                {
                }
                if (_loc_1.parent)
                {
                    _loc_1.parent.removeChild(_loc_1);
                }
                delete _imgs[_loc_2];
            }
            for (_loc_2 in _thumbs)
            {
                
                _loc_1 = _thumbs[_loc_2];
                if (_loc_1)
                {
                }
                if (_loc_1.parent)
                {
                    _loc_1.parent.removeChild(_loc_1);
                }
                delete _thumbs[_loc_2];
            }
            _thumbMatrix = new Matrix();
            for (_loc_2 in _preRenders)
            {
                
                _loc_1 = _preRenders[_loc_2];
                if (_loc_1 is Bitmap)
                {
                    _loc_4 = _loc_1 as Bitmap;
                    if (_loc_4.bitmapData)
                    {
                        _loc_4.bitmapData.dispose();
                    }
                }
                if (_loc_1)
                {
                }
                if (_loc_1.parent)
                {
                    _loc_1.parent.removeChild(_loc_1);
                }
                delete _preRenders[_loc_2];
            }
            _loaderList.length = 0;
            _preFillRect = new Rectangle();
            return;
        }// end function

        public function update(times:int, dt:Number = 0.04) : void
        {
            var _loc_3:Array = null;
            if (_loaderList.length > 0)
            {
                _loc_3 = _loaderList.shift() as Array;
                dispatchEvent(new MapEvent(MapEvent.NEED_DATA, _loc_3[0], _loc_3[1]));
            }
            return;
        }// end function

        public function setThumbnail(bmp:BitmapData, xscale:Number, yscale:Number) : void
        {
            var _loc_4:String = null;
            var _loc_5:Array = null;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:Shape = null;
            _thumbnail = bmp;
            _xscale = xscale;
            _yscale = yscale;
            _thumbMatrix.scale(_xscale, _yscale);
            for (_loc_4 in _thumbs)
            {
                
                if (_loc_4)
                {
                }
                if (_thumbs[_loc_4])
                {
                    _loc_5 = _loc_4.split("_");
                    _loc_6 = int(_loc_5[0]);
                    _loc_7 = int(_loc_5[1]);
                    _thumbMatrix.tx = (-_loc_7) * SceneConfig.TILE_SIZE;
                    _thumbMatrix.ty = (-_loc_6) * SceneConfig.TILE_SIZE;
                    _loc_8 = _thumbs[_loc_4];
                    _loc_8.graphics.clear();
                    _loc_8.graphics.beginBitmapFill(_thumbnail, _thumbMatrix);
                    _loc_8.graphics.drawRect(0, 0, SceneConfig.TILE_SIZE, SceneConfig.TILE_SIZE);
                    _loc_8.graphics.endFill();
                }
            }
            return;
        }// end function

        public function getThumbObj(row:int, col:int) : DisplayObject
        {
            var _loc_4:Shape = null;
            var _loc_5:Shape = null;
            var _loc_3:* = row + "_" + col;
            if (_thumbnail == null)
            {
                _loc_4 = new Shape();
                _loc_4.x = col * SceneConfig.TILE_SIZE;
                _loc_4.y = row * SceneConfig.TILE_SIZE;
                _loc_4.graphics.beginFill(0);
                _loc_4.graphics.drawRect(0, 0, SceneConfig.TILE_SIZE, SceneConfig.TILE_SIZE);
                _loc_4.graphics.endFill();
                _thumbs[_loc_3] = _loc_4;
                return _loc_4;
            }
            if (_thumbs[_loc_3] == null)
            {
                _thumbMatrix.tx = (-col) * SceneConfig.TILE_SIZE;
                _thumbMatrix.ty = (-row) * SceneConfig.TILE_SIZE;
                _loc_5 = new Shape();
                _loc_5.graphics.beginBitmapFill(_thumbnail, _thumbMatrix);
                _loc_5.graphics.drawRect(0, 0, SceneConfig.TILE_SIZE, SceneConfig.TILE_SIZE);
                _loc_5.graphics.endFill();
                _thumbs[_loc_3] = _loc_5;
                _loc_5.x = col * SceneConfig.TILE_SIZE;
                _loc_5.y = row * SceneConfig.TILE_SIZE;
            }
            return _thumbs[_loc_3];
        }// end function

        public function addTileBitmap(row:int, col:int, bmp:Bitmap) : void
        {
            if (bmp.width == 1)
            {
            }
            if (bmp.height == 1)
            {
                return;
            }
            var _loc_4:* = row + "_" + col;
            _imgs[_loc_4] = bmp;
            bmp.x = SceneConfig.TILE_SIZE * col;
            bmp.y = SceneConfig.TILE_SIZE * row;
            var _loc_5:* = _thumbs[_loc_4];
            if (_loc_5)
            {
            }
            if (_loc_5.parent)
            {
                _loc_5.parent.addChild(bmp);
                _loc_5.parent.removeChild(_loc_5);
            }
            return;
        }// end function

    }
}
