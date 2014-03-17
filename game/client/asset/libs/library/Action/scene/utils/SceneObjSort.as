package scene.utils
{
    import flash.display.*;
    import mhsm.interfaces.scene.*;

    public class SceneObjSort extends Object
    {

        public function SceneObjSort()
        {
            return;
        }// end function

        public static function sortFun(a:DisplayObject, b:DisplayObject) : int
        {
            if (a.y > b.y)
            {
                return 1;
            }
            if (a.y < b.y)
            {
                return -1;
            }
            if (a is ISceneObj)
            {
            }
            if (b is ISceneObj)
            {
                var _loc_3:* = a;
                var _loc_3:* = b;
                return _loc_3.a["getObjId"]() > _loc_3.b["getObjId"]() ? (1) : (-1);
            }
            return 0;
        }// end function

        public static function move(par:Sprite) : void
        {
            var _loc_6:DisplayObject = null;
            var _loc_7:DisplayObject = null;
            if (!par)
            {
                return;
            }
            var _loc_2:* = par.numChildren;
            var _loc_3:* = new Array(_loc_2);
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3[_loc_4] = par.getChildAt(_loc_4);
                _loc_4 = _loc_4 + 1;
            }
            _loc_3.sort(sortFun);
            var _loc_5:int = 0;
            while (_loc_5 < _loc_3.length)
            {
                
                _loc_6 = par.getChildAt(_loc_5);
                _loc_7 = _loc_3[_loc_5];
                if (_loc_6 != _loc_7)
                {
                    par.swapChildren(_loc_6, _loc_7);
                }
                _loc_5 = _loc_5 + 1;
            }
            return;
        }// end function

    }
}
