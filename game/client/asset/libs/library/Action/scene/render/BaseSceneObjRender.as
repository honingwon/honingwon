package scene.render
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import mhsm.constData.*;
    import mhsm.interfaces.scene.*;
    import scene.events.*;
    import scene.utils.*;

    public class BaseSceneObjRender extends BaseRender implements ITick
    {
        protected var _preTiles:Dictionary;
        private var _frameCount:int;
        protected var _gcTimer:Timer;
        protected var _gcTiles:Dictionary;
        protected var _objContainer:Sprite;
        protected var _lastRenderRect:Rectangle;
        protected var _containers:Dictionary;
        protected var _sortList:Array;

        public function BaseSceneObjRender(scene:IScene, camera:ICamera, vPort:IViewPort)
        {
            super(scene, camera, vPort);
            _frameCount = 0;
            _containers = new Dictionary();
            _preTiles = new Dictionary();
            _gcTiles = new Dictionary();
            _sortList = [];
            _gcTimer = new Timer(500, 1);
            _gcTimer.addEventListener(TimerEvent.TIMER_COMPLETE, gcTimerCompleteHandler);
            scene.addEventListener(SceneEvent.ADD_CHILD, addChildHandler);
            scene.addEventListener(SceneEvent.REMOVE_CHILD, removeChildHandler);
            scene.addEventListener(SceneEvent.MOVE_CHILD, moveChildHandler);
            scene.addEventListener(SceneEvent.ADD_EFFECT, addEffectHandler);
            scene.addEventListener(SceneEvent.ADD_TOMAP, addToMapHandler);
            scene.addEventListener(SceneEvent.ADD_CONTROL, addControlHandler);
            _objContainer = viewPort.getLayerContainer(LayerIndex.SCENEOBJLAYER);
            return;
        }// end function

        public function getMouseOverObject() : ISceneObj
        {
            var _loc_7:Sprite = null;
            var _loc_12:int = 0;
            var _loc_13:int = 0;
            var _loc_14:ISceneObj = null;
            var _loc_1:* = (_objContainer.mouseX - viewPort.maxRect.x) / SceneConfig.BROST_WIDTH;
            var _loc_2:* = (_objContainer.mouseY - viewPort.maxRect.y) / SceneConfig.BROST_HEIGHT;
            var _loc_3:* = _loc_1 > 0 ? ((_loc_1 - 1)) : (_loc_1);
            var _loc_4:* = _loc_1 + 1;
            var _loc_5:* = _loc_2 > 0 ? ((_loc_2 - 1)) : (_loc_2);
            var _loc_6:* = _loc_2 + 1;
            var _loc_8:Array = [];
            var _loc_9:* = _loc_3;
            while (_loc_9 <= _loc_4)
            {
                
                _loc_12 = _loc_5;
                while (_loc_12 <= _loc_6)
                {
                    
                    _loc_7 = getContainer(_loc_12, _loc_9);
                    if (_loc_7)
                    {
                        _loc_13 = _loc_7.numChildren - 1;
                        while (_loc_13 >= 0)
                        {
                            
                            _loc_14 = _loc_7.getChildAt(_loc_13) as ISceneObj;
                            if (_loc_14)
                            {
                                if (_loc_14.isMouseOver())
                                {
                                    _loc_8.push(_loc_14);
                                    break;
                                }
                            }
                            _loc_13 = _loc_13 - 1;
                        }
                    }
                    _loc_12 = _loc_12 + 1;
                }
                _loc_9 = _loc_9 + 1;
            }
            if (_loc_8.length == 0)
            {
                return null;
            }
            if (_loc_8.length == 1)
            {
                return _loc_8[0];
            }
            var _loc_10:* = _loc_8[0];
            var _loc_11:int = 1;
            while (_loc_11 < _loc_8.length)
            {
                
                if (_loc_8[_loc_11].sceneY > _loc_10.sceneY)
                {
                    _loc_10 = _loc_8[_loc_11];
                }
                _loc_11 = _loc_11 + 1;
            }
            return _loc_10;
        }// end function

        public function getContainer(row:int, col:int) : Sprite
        {
            var _loc_3:* = row + "_" + col;
            var _loc_4:* = _containers[_loc_3];
            if (_containers[_loc_3] == null)
            {
                _loc_4 = new Sprite();
                _loc_4.mouseEnabled = false;
                _loc_4.x = viewPort.maxRect.x + col * SceneConfig.BROST_WIDTH;
                _loc_4.y = viewPort.maxRect.y + row * SceneConfig.BROST_HEIGHT;
                _containers[_loc_3] = _loc_4;
            }
            return _loc_4;
        }// end function

        protected function addChildHandler(event:SceneEvent) : void
        {
            var _loc_2:* = event.sceneObj;
            var _loc_3:* = (_loc_2.sceneX - viewPort.maxRect.x) / SceneConfig.BROST_WIDTH;
            var _loc_4:* = (_loc_2.sceneY - viewPort.maxRect.y) / SceneConfig.BROST_HEIGHT;
            var _loc_5:* = getContainer(_loc_4, _loc_3);
            var _loc_6:* = _loc_2 as DisplayObject;
            _loc_5.addChild(_loc_6);
            _loc_6.x = _loc_2.sceneX - _loc_5.x;
            _loc_6.y = _loc_2.sceneY - _loc_5.y;
            if (_sortList.indexOf(_loc_5) == -1)
            {
                _sortList.push(_loc_5);
            }
            return;
        }// end function

        public function update(timers:int, dt:Number = 0.04) : void
        {
            var _loc_3:Sprite = null;
            var _loc_5:* = _frameCount + 1;
            _frameCount = _loc_5;
            if (_frameCount >= 5)
            {
                _frameCount = 0;
                if (_sortList.length == 0)
                {
                    return;
                }
                for each (_loc_3 in _sortList)
                {
                    
                    SceneObjSort.move(_loc_3);
                }
                _sortList.length = 0;
            }
            return;
        }// end function

        override public function render() : void
        {
            var _loc_4:DisplayObjectContainer = null;
            var _loc_6:String = null;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:Array = null;
            var _loc_10:String = null;
            var _loc_1:Boolean = false;
            if (_lastRenderRect == null)
            {
                _loc_1 = true;
            }
            else
            {
                _loc_7 = _lastRenderRect.x - viewPort.viewRect.x;
                _loc_8 = _lastRenderRect.y - viewPort.viewRect.y;
                _loc_7 = _loc_7 < 0 ? (-_loc_7) : (_loc_7);
                _loc_8 = _loc_8 < 0 ? (-_loc_8) : (_loc_8);
                if (_loc_7 <= 50)
                {
                }
                if (_loc_8 > 50)
                {
                    _loc_1 = true;
                }
            }
            if (!_loc_1)
            {
                return;
            }
            _lastRenderRect = viewPort.viewRect.clone();
            var _loc_2:* = getViewTiles(viewPort.maxRect, viewPort.viewRect, SceneConfig.BROST_WIDTH, SceneConfig.BROST_HEIGHT);
            var _loc_3:* = new Dictionary();
            var _loc_5:int = 0;
            while (_loc_5 < _loc_2.length)
            {
                
                _loc_9 = _loc_2[_loc_5];
                _loc_10 = _loc_9[0] + "_" + _loc_9[1];
                if (_preTiles[_loc_10] == null)
                {
                }
                if (_gcTiles[_loc_10] == null)
                {
                    _loc_4 = getContainer(_loc_9[0], _loc_9[1]);
                    _objContainer.addChildAt(_loc_4, _loc_5);
                    _loc_3[_loc_10] = _loc_4;
                }
                else
                {
                    _loc_4 = _preTiles[_loc_10] == null ? (_gcTiles[_loc_10]) : (_preTiles[_loc_10]);
                    _loc_3[_loc_10] = _loc_4;
                    _loc_4.parent.setChildIndex(_loc_4, _loc_5);
                    delete _preTiles[_loc_10];
                    delete _gcTiles[_loc_10];
                }
                _loc_5 = _loc_5 + 1;
            }
            for (_loc_6 in _preTiles)
            {
                
                _gcTiles[_loc_6] = _preTiles[_loc_6];
            }
            _preTiles = _loc_3;
            _gcTimer.reset();
            _gcTimer.start();
            return;
        }// end function

        private function gcTimerCompleteHandler(event:TimerEvent) : void
        {
            var _loc_2:String = null;
            for (_loc_2 in _gcTiles)
            {
                
                if (_gcTiles[_loc_2])
                {
                }
                if (_gcTiles[_loc_2].parent)
                {
                    _gcTiles[_loc_2].parent.removeChild(_gcTiles[_loc_2]);
                }
            }
            _gcTiles = new Dictionary();
            return;
        }// end function

        protected function addEffectHandler(event:SceneEvent) : void
        {
            var _loc_2:* = viewPort.getLayerContainer(LayerIndex.EFFECTLAYER);
            _loc_2.addChild(event.data as DisplayObject);
            return;
        }// end function

        protected function addToMapHandler(event:SceneEvent) : void
        {
            var _loc_2:* = viewPort.getLayerContainer(LayerIndex.MAPLAYER);
            _loc_2.addChild(event.data as DisplayObject);
            return;
        }// end function

        protected function addControlHandler(event:SceneEvent) : void
        {
            var _loc_2:* = viewPort.getLayerContainer(LayerIndex.CONTROLLER);
            _loc_2.addChild(event.data as DisplayObject);
            return;
        }// end function

        protected function removeChildHandler(event:SceneEvent) : void
        {
            var _loc_2:* = event.sceneObj as DisplayObject;
            if (_loc_2.parent)
            {
                _loc_2.parent.removeChild(_loc_2);
            }
            return;
        }// end function

        public function getViewTiles(maxRect:Rectangle, viewRect:Rectangle, tileWidth:int, tileHeight:int) : Array
        {
            var _loc_11:int = 0;
            var _loc_5:* = (viewRect.y - maxRect.y) / tileHeight;
            var _loc_6:* = (viewRect.x - maxRect.x) / tileWidth;
            _loc_5 = _loc_5 < 0 ? (0) : (_loc_5);
            _loc_6 = _loc_6 < 0 ? (0) : (_loc_6);
            var _loc_7:* = Math.ceil((viewRect.y + viewRect.height - maxRect.y) / tileHeight);
            var _loc_8:* = Math.ceil((viewRect.x + viewRect.width - maxRect.x) / tileWidth);
            var _loc_9:Array = [];
            var _loc_10:* = _loc_5;
            while (_loc_10 < _loc_7)
            {
                
                _loc_11 = _loc_6;
                while (_loc_11 < _loc_8)
                {
                    
                    _loc_9.push([_loc_10, _loc_11]);
                    _loc_11 = _loc_11 + 1;
                }
                _loc_10 = _loc_10 + 1;
            }
            return _loc_9;
        }// end function

        protected function moveChildHandler(event:SceneEvent) : void
        {
            var _loc_2:* = (event.sourcePoint.x - viewPort.maxRect.x) / SceneConfig.BROST_WIDTH;
            var _loc_3:* = (event.sourcePoint.y - viewPort.maxRect.y) / SceneConfig.BROST_HEIGHT;
            var _loc_4:* = (event.destPoint.x - viewPort.maxRect.x) / SceneConfig.BROST_WIDTH;
            var _loc_5:* = (event.destPoint.y - viewPort.maxRect.y) / SceneConfig.BROST_HEIGHT;
            var _loc_6:* = getContainer(_loc_5, _loc_4);
            var _loc_7:* = event.sceneObj as DisplayObject;
            if (!_loc_6.contains(_loc_7))
            {
                _loc_6.addChild(_loc_7);
            }
            _loc_7.x = event.destPoint.x - _loc_6.x;
            _loc_7.y = event.destPoint.y - _loc_6.y;
            if (_sortList.indexOf(_loc_6) == -1)
            {
                _sortList.push(_loc_6);
            }
            return;
        }// end function

    }
}
