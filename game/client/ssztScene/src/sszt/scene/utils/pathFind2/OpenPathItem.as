//Created by Action Script Viewer - http://www.buraks.com/asv
package sszt.scene.utils.pathFind2 {

    public class OpenPathItem {

        public var f:int;
        public var x:int;
        public var y:int;

        public function OpenPathItem(_arg1:int=0, _arg2:int=0, _arg3:int=0){
            x = _arg1;
            y = _arg2;
            f = _arg3;
        }
        public function min(_arg1:OpenPathItem):Boolean{
            return ((f < _arg1.f));
        }
        public function clone():OpenPathItem{
            var _local1:OpenPathItem = new OpenPathItem(x, y, f);
            return (_local1);
        }

    }
}//package common.findPath.find2 
