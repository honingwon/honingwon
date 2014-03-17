//Created by Action Script Viewer - http://www.buraks.com/asv
package sszt.scene.utils.pathFind3 {
    import flash.geom.*;

    public class FindPath8 implements IFindPath {

        protected var _path:Array;
        private var _endPoint:Object;
        private var _starPoint:Object;
        private var _map:Array;
        private var _h:int;
        private var _open:Array;
        private var _w:int;

        public function FindPath8(_arg1:Array){
            var _local2:int;
            var _local4:int;
            _path = [];
            super();
            FindNode.clearDic();
            _map = [];
            _w = _arg1[0].length;
            _h = _arg1.length;
            var _local3:int;
            while (_local3 < _h) {
                if (_map[_local3] == undefined){
                    _map[_local3] = [];
                };
                _local4 = 0;
                while (_local4 < _w) {
                    if ((((((((((_arg1[_local3][_local4] == 0)) || ((_arg1[_local3][_local4] == 2)))) || ((_arg1[_local3][_local4] == 3)))) || ((_arg1[_local3][_local4] == 5)))) || ((_arg1[_local3][_local4] == 6)))){
                        _local2 = 0;
                    } else {
                        _local2 = 1;
                    };
                    _map[_local3][_local4] = new FindNode();
                    FindNode(_map[_local3][_local4]).init(_local4, _local3, _local2);
                    _local4++;
                };
                _local3++;
            };
        }
        private function drawPath():void{
            var _local1:Object = _endPoint;
            while (_local1 != _starPoint) {
                _path.unshift(new Point(_local1.x, _local1.y));
                _local1 = _local1.nodeparent;
            };
            _path.unshift(new Point(_local1.x, _local1.y));
        }
        private function count(_arg1:Object, _arg2:Object):void{
            var _local3:Number;
            if (!_arg1.block){
                _local3 = (_arg2.value_g + 10);
                if ((((Math.abs((_arg1.x - _arg2.x)) == 1)) && ((Math.abs((_arg1.y - _arg2.y)) == 1)))){
                    _local3 = (_arg2.value_g + 14);
                } else {
                    _local3 = (_arg2.value_g + 10);
                };
                if (_arg1.open){
                    if (_arg1.value_g >= _local3){
                        _arg1.value_g = _local3;
                        ghf(_arg1);
                        _arg1.nodeparent = _arg2;
                    };
                } else {
                    addToOpen(_arg1);
                    _arg1.value_g = _local3;
                    ghf(_arg1);
                    _arg1.nodeparent = _arg2;
                };
            };
        }
        private function getMin():int{
            var _local1:int = _open.length;
            var _local2:Number = 100000;
            var _local3:int;
            var _local4:int;
            while (_local4 < _local1) {
                if (_local2 > _open[_local4].value_f){
                    _local2 = _open[_local4].value_f;
                    _local3 = _local4;
                };
                _local4++;
            };
            return (_local3);
        }
        private function initBlock():void{
            FindNode.resetDic();
            _open = [];
        }
        public function optimizePath():Array{
            var _local4:int;
            var _local9:int;
            var _local1:int = _path.length;
            var _local2:Array = [];
            var _local3:Array = [];
            var _local5:Boolean;
            var _local6:Point = _path[0];
            _local2.push(_path[0]);
            var _local7:int;
            var _local8:int = 1;
            while (_local8 < _local1) {
                _local7++;
                _local3 = Diagonal.each(_local6, _path[_local8]);
                _local4 = _local3.length;
                _local5 = true;
                _local9 = 0;
                while (_local9 < _local4) {
                    if (_map[_local3[_local9].y][_local3[_local9].x].value == 1){
                        _local5 = false;
                        break;
                    };
                    _local9++;
                };
                if (_local7 > 1){
                    _local5 = false;
                };
                if (!_local5){
                    if (_local8 > 1){
                        _local6 = _path[(_local8 - 1)];
                        _local2.push(_path[(_local8 - 1)]);
                        _local7 = 0;
                    };
                };
                _local8++;
            };
            _local2.push(_path[(_local1 - 1)]);
            return (_local2);
        }
        public function get path():Array{
            return (_path);
        }
        private function addToOpen(_arg1:Object):void{
            _open.push(_arg1);
            _arg1.open = true;
        }
        private function ghf(_arg1:Object):void{
            var _local2:Number = Math.abs((_arg1.x - _endPoint.x));
            var _local3:Number = Math.abs((_arg1.y - _endPoint.y));
            _arg1.value_h = (10 * (_local2 + _local3));
            _arg1.value_f = (_arg1.value_g + _arg1.value_h);
        }
        public function find(_arg1:Point, _arg2:Point):Array{
			_arg1 = new Point(int(_arg1.x / 25),int(_arg1.y / 25));
			_arg2 = new Point(int(_arg2.x / 25),int(_arg2.y / 25));
            var _local5:Array;
            var _local6:int;
            var _local7:int;
            var _local8:Object;
            _path = [];
            if (_map[_arg1.y] == null){
                return (null);
            };
            _starPoint = _map[_arg1.y][_arg1.x];
            if (_map[_arg2.y] == null){
                return (null);
            };
            _endPoint = _map[_arg2.y][_arg2.x];
            if ((((_endPoint == null)) || ((_endPoint.value == 1)))){
                return (null);
            };
            if ((((_starPoint == null)) || ((_starPoint.value == 1)))){
                return (null);
            };
            if ((((_endPoint.x == _starPoint.x)) && ((_endPoint.y == _starPoint.y)))){
                return (null);
            };
            var _local3:Boolean;
            initBlock();
            var _local4:Object = _starPoint;
            while (!(_local3)) {
                _local4.block = true;
                _local5 = [];
                if (_local4.y > 0){
                    _local5.push(_map[(_local4.y - 1)][_local4.x]);
                };
                if (_local4.x > 0){
                    _local5.push(_map[_local4.y][(_local4.x - 1)]);
                };
                if (_local4.x < (_w - 1)){
                    _local5.push(_map[_local4.y][(_local4.x + 1)]);
                };
                if (_local4.y < (_h - 1)){
                    _local5.push(_map[(_local4.y + 1)][_local4.x]);
                };
                if ((((((_local4.y > 0)) && ((_local4.x > 0)))) && (!((((_map[_local4.y][(_local4.x - 1)].value == 1)) && ((_map[(_local4.y - 1)][_local4.x].value == 1))))))){
                    _local5.push(_map[(_local4.y - 1)][(_local4.x - 1)]);
                };
                if ((((((_local4.y < (_h - 1))) && ((_local4.x > 0)))) && (!((((_map[_local4.y][(_local4.x - 1)].value == 1)) && ((_map[(_local4.y + 1)][_local4.x].value == 1))))))){
                    _local5.push(_map[(_local4.y + 1)][(_local4.x - 1)]);
                };
                if ((((((_local4.y > 0)) && ((_local4.x < (_w - 1))))) && (!((((_map[(_local4.y - 1)][_local4.x].value == 1)) && ((_map[_local4.y][(_local4.x + 1)].value == 1))))))){
                    _local5.push(_map[(_local4.y - 1)][(_local4.x + 1)]);
                };
                if ((((((_local4.y < (_h - 1))) && ((_local4.x < (_w - 1))))) && (!((((_map[(_local4.y + 1)][_local4.x].value == 1)) && ((_map[_local4.y][(_local4.x + 1)].value == 1))))))){
                    _local5.push(_map[(_local4.y + 1)][(_local4.x + 1)]);
                };
                _local6 = _local5.length;
                _local7 = 0;
                while (_local7 < _local6) {
                    _local8 = _local5[_local7];
                    if (_local8 == _endPoint){
                        _local8.nodeparent = _local4;
                        _local3 = true;
                        break;
                    };
                    if (_local8.value == 0){
                        count(_local8, _local4);
                    };
                    _local7++;
                };
                if (!_local3){
                    if (_open.length > 0){
                        _local4 = _open.splice(getMin(), 1)[0];
                    } else {
                        return ([]);
                    };
                };
            };
            drawPath();
			for each(var tmpP:Point in _path)
			{
				if(tmpP)
				{
					tmpP.x *= 25;
					tmpP.y *= 25;
				}
			}
            return (_path);
        }

    }
}//package common.findPath 
