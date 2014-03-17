//Created by Action Script Viewer - http://www.buraks.com/asv
package sszt.scene.utils.pathFind3 {
    import flash.utils.*;

    public class FindNode {

        public static var _dic:Dictionary = new Dictionary();

        public var _nodeparent:Object;
        public var _block:Boolean;
        public var _value_f:int;
        public var _value_h:int;
        public var _value_g:int;
        public var _open:Boolean;
        public var _value:int;
        public var _x:int;
        public var _y:int;

        public static function clearDic():void{
            _dic = new Dictionary();
        }
        public static function changeValue(_arg1:FindNode):void{
            if (_dic[_arg1] == undefined){
                _dic[_arg1] = null;
            };
        }
        public static function resetDic():void{
            var _local1:*;
            for (_local1 in _dic) {
                _local1.reset();
            };
        }

        public function get y():int{
            return (_y);
        }
        public function set value_h(_arg1:int):void{
            changeValue(this);
            _value_h = _arg1;
        }
        public function set y(_arg1:int):void{
            _y = _arg1;
        }
        public function get open():Boolean{
            return (_open);
        }
        public function get block():Boolean{
            return (_block);
        }
        private function reset():void{
            _block = false;
            _open = false;
            _value_g = 0;
            _value_h = 0;
            _value_f = 0;
            _nodeparent = null;
        }
        public function init(_arg1:int, _arg2:int, _arg3:int):void{
            _x = _arg1;
            _y = _arg2;
            _value = _arg3;
            reset();
        }
        public function set open(_arg1:Boolean):void{
            changeValue(this);
            _open = _arg1;
        }
        public function get value_f():int{
            return (_value_f);
        }
        public function set block(_arg1:Boolean):void{
            changeValue(this);
            _block = _arg1;
        }
        public function get value_g():int{
            return (_value_g);
        }
        public function set value(_arg1:int):void{
            _value = _arg1;
        }
        public function set nodeparent(_arg1:Object):void{
            changeValue(this);
            _nodeparent = _arg1;
        }
        public function set value_g(_arg1:int):void{
            changeValue(this);
            _value_g = _arg1;
        }
        public function get nodeparent():Object{
            return (_nodeparent);
        }
        public function set value_f(_arg1:int):void{
            changeValue(this);
            _value_f = _arg1;
        }
        public function get value():int{
            return (_value);
        }
        public function set x(_arg1:int):void{
            _x = _arg1;
        }
        public function get x():int{
            return (_x);
        }
        public function get value_h():int{
            return (_value_h);
        }

    }
}//package common.findPath 
