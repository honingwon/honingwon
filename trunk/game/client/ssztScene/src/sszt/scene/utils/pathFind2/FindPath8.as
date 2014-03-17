//Created by Action Script Viewer - http://www.buraks.com/asv
package sszt.scene.utils.pathFind2
{
    import flash.geom.*;

    public class FindPath8 implements IFindPath {

        protected var _path:Array;
        private var _endPoint:Object;
        private var _starPoint:Object;
        private var _m_open_list:PathMinHeap;
        private var _map:Array;
        private var _h:int;
        private var _w:int;

        public function FindPath8(_arg1:Array){
            var _local3:int;
            var _local4:int;
            var _local5:PathNode;
            _path = [];
            super();
            _map = [];
            _w = _arg1[0].length;
            _h = _arg1.length;
            _m_open_list = new PathMinHeap();
            var _local2:int;
            while (_local2 < _h) {
                if (_map[_local2] == undefined){
                    _map[_local2] = [];
                };
                _local3 = 0;
                while (_local3 < _w) {
                    if ((((_arg1[_local2][_local3] == 0)) || ((_arg1[_local2][_local3] == 2)))){
                        _local4 = 0;
                    } else {
                        _local4 = 1;
                    };
                    _local5 = new PathNode();
                    _local5.x = _local3;
                    _local5.y = _local2;
                    _local5.value = _local4;
                    _map[_local2][_local3] = _local5;
                    _local3++;
                };
                _local2++;
            };
        }
        public function find(_arg1:Point, _arg2:Point):Array{
			_arg1 = new Point(int(_arg1.x / 25),int(_arg1.y / 25));
			_arg2 = new Point(int(_arg2.x / 25),int(_arg2.y / 25));
            var _local5:Array;
            var _local6:int;
            var _local7:int;
            var _local8:Object;
            var _local9:OpenPathItem;
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
                if (_local4.y > 0){
                    _local5.push(_map[(_local4.y - 1)][(_local4.x - 1)]);
                };
                if (_local4.y < (_h - 1)){
                    _local5.push(_map[(_local4.y + 1)][(_local4.x - 1)]);
                };
                if (_local4.y > 0){
                    _local5.push(_map[(_local4.y - 1)][(_local4.x + 1)]);
                };
                if (_local4.y < (_h - 1)){
                    _local5.push(_map[(_local4.y + 1)][(_local4.x + 1)]);
                };
                _local6 = _local5.length;
                _local7 = 0;
                while (_local7 < _local6) {
                    _local8 = _local5[_local7];
                    if ((((_local8 == _endPoint)) && (!((abs(((_local8.y - _local4.y) / (_local8.x - _local4.x))) == 1))))){
                        _local8.nodeparent = _local4;
                        _local3 = true;
                        break;
                    };
                    if (((_local8) && ((_local8.value == 0)))){
                        count(_local8, _local4);
                    };
                    _local7++;
                };
                if (!_local3){
                    if (_m_open_list.Size > 0){
                        _local9 = (_m_open_list.Front() as OpenPathItem);
                        _local4 = _map[_local9.x][_local9.y];
                        _m_open_list.PopFront();
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
                if ((((abs((_arg1.x - _arg2.x)) == 1)) && ((abs((_arg1.y - _arg2.y)) == 1)))){
                    _local3 = (_arg2.value_g + 14);
                } else {
                    _local3 = (_arg2.value_g + 10);
                };
                if ((((_arg1.x > _arg2.x)) && ((_arg1.y < _arg2.y)))){
                    if ((((_map[_arg1.y][(_arg1.x - 1)].value == 1)) && ((_map[(_arg1.y + 1)][_arg1.x].value == 1)))){
                        _local3 = (_local3 + 10000);
                    };
                } else {
                    if ((((_arg1.x > _arg2.x)) && ((_arg1.y > _arg2.y)))){
                        if ((((_map[_arg1.y][(_arg1.x - 1)].value == 1)) && ((_map[(_arg1.y - 1)][_arg1.x].value == 1)))){
                            _local3 = (_local3 + 10000);
                        };
                    } else {
                        if ((((_arg1.x < _arg2.x)) && ((_arg1.y > _arg2.y)))){
                            if ((((_map[_arg1.y][(_arg1.x + 1)].value == 1)) && ((_map[(_arg1.y - 1)][_arg1.x].value == 1)))){
                                _local3 = (_local3 + 10000);
                            };
                        } else {
                            if ((((_arg1.x < _arg2.x)) && ((_arg1.y < _arg2.y)))){
                                if ((((_map[(_arg1.y + 1)][_arg1.x].value == 1)) && ((_map[_arg1.y][(_arg1.x + 1)].value == 1)))){
                                    _local3 = (_local3 + 10000);
                                };
                            };
                        };
                    };
                };
                if (_arg1.open){
                    if (_arg1.value_g >= _local3){
                        _arg1.value_g = _local3;
                        ghf(_arg1);
                        _arg1.nodeparent = _arg2;
                    };
                } else {
                    _arg1.value_g = _local3;
                    ghf(_arg1);
                    _arg1.nodeparent = _arg2;
                    addToOpen(_arg1);
                };
            };
        }
        private function find_ex(_arg1:Object, _arg2:Object):void{
            var _local3:int = _arg1.x;
            var _local4:int = _arg1.y;
            if (_arg1.x == _arg2.x){
                while (_local4 != _arg2.y) {
                    if (_map[_local4][_local3].value == 1){
                        _path = [];
                        return;
                    };
                    _path.push(new Point(_local3, _local4));
                    if (_arg1.y < _arg2.y){
                        _local4++;
                    } else {
                        _local4--;
                    };
                };
            } else {
                if (_arg1.y == _arg2.y){
                    while (_local3 != _arg2.x) {
                        if (_map[_local4][_local3].value == 1){
                            _path = [];
                            return;
                        };
                        _path.push(new Point(_local3, _local4));
                        if (_arg1.x < _arg2.x){
                            _local3++;
                        } else {
                            _local3--;
                        };
                    };
                } else {
                    if (Math.abs(((_arg1.y - _arg2.y) / (_arg1.x - _arg2.x))) == 1){
                        while (((!((_local3 == _arg2.x))) && (!((_local4 == _arg2.y))))) {
                            if ((((((((((_map[_local4][_local3].value == 1)) || ((((_map[(_local4 - 1)][_local3].value == 1)) && ((_map[_local4][(_local3 + 1)].value == 1)))))) || ((((_map[(_local4 + 1)][_local3].value == 1)) && ((_map[_local4][(_local3 + 1)].value == 1)))))) || ((((_map[(_local4 - 1)][_local3].value == 1)) && ((_map[_local4][(_local3 - 1)].value == 1)))))) || ((((_map[(_local4 + 1)][_local3].value == 1)) && ((_map[_local4][(_local3 - 1)].value == 1)))))){
                                _path = [];
                                return;
                            };
                            _path.push(new Point(_local3, _local4));
                            if ((((_arg2.x < _arg1.x)) && ((_arg2.y < _arg1.y)))){
                                _local3--;
                                _local4--;
                            } else {
                                if ((((_arg2.x < _arg1.x)) && ((_arg2.y > _arg1.y)))){
                                    _local3--;
                                    _local4++;
                                } else {
                                    if ((((_arg2.x > _arg1.x)) && ((_arg2.y < _arg1.y)))){
                                        _local3++;
                                        _local4--;
                                    } else {
                                        _local3++;
                                        _local4++;
                                    };
                                };
                            };
                        };
                    } else {
                        if ((((_arg2.x > _arg1.x)) && ((_arg2.y > _arg1.y)))){
                            if (_arg2.y > ((_arg2.x - _arg1.x) + _arg1.y)){
                                while (_local3 <= _arg2.x) {
                                    if ((((_map[_local4][_local3].value == 1)) || ((((_map[(_local4 + 1)][_local3].value == 1)) && ((_map[_local4][(_local3 + 1)].value == 1)))))){
                                        _path = [];
                                        return;
                                    };
                                    _path.push(new Point(_local3, _local4));
                                    _local3++;
                                    _local4++;
                                };
                                _local3--;
                                _local4--;
                                while (_local4 <= _arg2.y) {
                                    if (_map[_local4][_local3].value == 1){
                                        _path = [];
                                        return;
                                    };
                                    _path.push(new Point(_local3, _local4));
                                    _local4++;
                                };
                            } else {
                                while (_local4 <= _arg2.y) {
                                    if ((((_map[_local4][_local3].value == 1)) || ((((_map[(_local4 + 1)][_local3].value == 1)) && ((_map[_local4][(_local3 + 1)].value == 1)))))){
                                        _path = [];
                                        return;
                                    };
                                    _path.push(new Point(_local3, _local4));
                                    _local3++;
                                    _local4++;
                                };
                                _local3--;
                                _local4--;
                                while (_local3 <= _arg2.x) {
                                    if (_map[_local4][_local3].value == 1){
                                        _path = [];
                                        return;
                                    };
                                    _path.push(new Point(_local3, _local4));
                                    _local3++;
                                };
                            };
                        } else {
                            if ((((_arg2.x > _arg1.x)) && ((_arg2.y < _arg1.y)))){
                                if (_arg2.y > ((_arg1.x + _arg1.y) - _arg2.x)){
                                    while (_local4 >= _arg2.y) {
                                        if ((((_map[_local4][_local3].value == 1)) || ((((_map[(_local4 - 1)][_local3].value == 1)) && ((_map[_local4][(_local3 + 1)].value == 1)))))){
                                            _path = [];
                                            return;
                                        };
                                        _path.push(new Point(_local3, _local4));
                                        _local3++;
                                        _local4--;
                                    };
                                    _local3--;
                                    _local4++;
                                    while (_local3 <= _arg2.x) {
                                        if (_map[_local4][_local3].value == 1){
                                            _path = [];
                                            return;
                                        };
                                        _path.push(new Point(_local3, _local4));
                                        _local3++;
                                    };
                                } else {
                                    while (_local3 <= _arg2.x) {
                                        if ((((_map[_local4][_local3].value == 1)) || ((((_map[(_local4 - 1)][_local3].value == 1)) && ((_map[_local4][(_local3 + 1)].value == 1)))))){
                                            _path = [];
                                            return;
                                        };
                                        _path.push(new Point(_local3, _local4));
                                        _local3++;
                                        _local4--;
                                    };
                                    _local3--;
                                    _local4++;
                                    while (_local4 >= _arg2.y) {
                                        if (_map[_local4][_local3].value == 1){
                                            _path = [];
                                            return;
                                        };
                                        _path.push(new Point(_local3, _local4));
                                        _local4--;
                                    };
                                };
                            } else {
                                if ((((_arg2.x < _arg1.x)) && ((_arg2.y < _arg1.y)))){
                                    if (_arg2.y < ((_arg2.x - _arg1.x) + _arg1.y)){
                                        while (_local3 >= _arg2.x) {
                                            if ((((_map[_local4][_local3].value == 1)) || ((((_map[(_local4 - 1)][_local3].value == 1)) && ((_map[_local4][(_local3 - 1)].value == 1)))))){
                                                _path = [];
                                                return;
                                            };
                                            _path.push(new Point(_local3, _local4));
                                            _local3--;
                                            _local4--;
                                        };
                                        _local3++;
                                        _local4++;
                                        while (_local4 >= _arg2.y) {
                                            if (_map[_local4][_local3].value == 1){
                                                _path = [];
                                                return;
                                            };
                                            _path.push(new Point(_local3, _local4));
                                            _local4--;
                                        };
                                    } else {
                                        while (_local4 >= _arg2.y) {
                                            if ((((_map[_local4][_local3].value == 1)) || ((((_map[(_local4 - 1)][_local3].value == 1)) && ((_map[_local4][(_local3 - 1)].value == 1)))))){
                                                _path = [];
                                                return;
                                            };
                                            _path.push(new Point(_local3, _local4));
                                            _local4--;
                                            _local3--;
                                        };
                                        _local4++;
                                        _local3++;
                                        while (_local3 >= _arg2.x) {
                                            if (_map[_local4][_local3].value == 1){
                                                _path = [];
                                                return;
                                            };
                                            _path.push(new Point(_local3, _local4));
                                            _local3--;
                                        };
                                    };
                                } else {
                                    if (_arg2.y < ((_arg1.x + _arg1.y) - _arg2.x)){
                                        while (_local4 <= _arg2.y) {
                                            if ((((_map[_local4][_local3].value == 1)) || ((((_map[(_local4 + 1)][_local3].value == 1)) && ((_map[_local4][(_local3 - 1)].value == 1)))))){
                                                _path = [];
                                                return;
                                            };
                                            _path.push(new Point(_local3, _local4));
                                            _local3--;
                                            _local4++;
                                        };
                                        _local3++;
                                        _local4--;
                                        while (_local3 >= _arg2.x) {
                                            if (_map[_local4][_local3].value == 1){
                                                _path = [];
                                                return;
                                            };
                                            _path.push(new Point(_local3, _local4));
                                            _local3--;
                                        };
                                    } else {
                                        while (_local3 >= _arg2.x) {
                                            if ((((_map[_local4][_local3].value == 1)) || ((((_map[(_local4 + 1)][_local3].value == 1)) && ((_map[_local4][(_local3 - 1)].value == 1)))))){
                                                _path = [];
                                                return;
                                            };
                                            _path.push(new Point(_local3, _local4));
                                            _local3--;
                                            _local4++;
                                        };
                                        _local3++;
                                        _local4--;
                                        while (_local4 <= _arg2.y) {
                                            if (_map[_local4][_local3].value == 1){
                                                _path = [];
                                                return;
                                            };
                                            _path.push(new Point(_local3, _local4));
                                            _local4++;
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }
        private function initBlock():void{
            var _local2:int;
            var _local3:PathNode;
            var _local1:int;
            while (_local1 < _h) {
                _local2 = 0;
                while (_local2 < _w) {
                    _local3 = (_map[_local1][_local2] as PathNode);
                    _local3.open = false;
                    _local3.block = false;
                    _local3.value_g = (_local3.value_f = (_local3.value_h = 0));
                    _local3.nodeparent = null;
                    _local2++;
                };
                _local1++;
            };
            _m_open_list.clear();
        }
        public function get path():Array{
            return (_path);
        }
        private function addToOpen(_arg1:Object):void{
            _arg1.open = true;
            var _local2:OpenPathItem = new OpenPathItem(_arg1.y, _arg1.x, _arg1.value_f);
            _m_open_list.Push(_local2);
        }
        private function ghf(_arg1:Object):void{
            var _local2:Number = abs((_arg1.x - _endPoint.x));
            var _local3:Number = abs((_arg1.y - _endPoint.y));
            _arg1.value_h = (10 * (_local2 + _local3));
            _arg1.value_f = (_arg1.value_g + _arg1.value_h);
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
        private function abs(_arg1:Number):Number{
            return (((_arg1 < 0)) ? (_arg1 * -1) : _arg1);
        }

    }
}//package common.findPath 
