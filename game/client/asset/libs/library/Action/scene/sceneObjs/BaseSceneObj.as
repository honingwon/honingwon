package scene.sceneObjs
{
    import flash.display.*;
    import mhqy.ui.container.*;
    import mhsm.core.data.scene.*;
    import mhsm.interfaces.scene.*;

    public class BaseSceneObj extends MSprite implements ISceneObj
    {
        protected var _info:BaseSceneObjInfo;
        public var canSort:Boolean;
        protected var _isMouseOver:Boolean;
        private var _scene:IScene;
        protected var _mouseAvoid:Boolean;

        public function BaseSceneObj(info:BaseSceneObjInfo)
        {
            _info = info;
            init();
            initEvent();
            return;
        }// end function

        public function getCanAttack() : Boolean
        {
            if (!_scene)
            {
                return false;
            }
            return _info.getCanAttack();
        }// end function

        public function get sceneX() : Number
        {
            if (!_info)
            {
                return -500;
            }
            return _info.sceneX;
        }// end function

        public function isMouseOver() : Boolean
        {
            return false;
        }// end function

        public function setMouseAvoid(value:Boolean) : void
        {
            _mouseAvoid = value;
            return;
        }// end function

        public function get dir() : int
        {
            return 0;
        }// end function

        public function doMouseOver() : void
        {
            return;
        }// end function

        protected function init() : void
        {
            mouseEnabled = false;
            return;
        }// end function

        public function set scene(s:IScene) : void
        {
            _scene = s;
            return;
        }// end function

        public function get scene() : IScene
        {
            return _scene;
        }// end function

        public function getFigure() : DisplayObject
        {
            return this;
        }// end function

        public function get selected() : Boolean
        {
            return _info.selected;
        }// end function

        public function doMouseClick() : void
        {
            return;
        }// end function

        public function doMouseOut() : void
        {
            return;
        }// end function

        override public function dispose() : void
        {
            removeEvent();
            if (_scene)
            {
                _scene.removeChild(this);
            }
            _scene = null;
            _info = null;
            super.dispose();
            return;
        }// end function

        protected function initEvent() : void
        {
            return;
        }// end function

        protected function removeEvent() : void
        {
            return;
        }// end function

        public function setScenePos(x:Number, y:Number) : void
        {
            _info.setScenePosWhitoutDispath(x, y);
            return;
        }// end function

        public function get sceneY() : Number
        {
            if (!_info)
            {
                return -500;
            }
            return _info.sceneY;
        }// end function

        public function getObjId() : Number
        {
            if (_info)
            {
                return _info.getObjId();
            }
            return 0;
        }// end function

        public function set selected(value:Boolean) : void
        {
            _info.selected = value;
            return;
        }// end function

    }
}
