//Created by Action Script Viewer - http://www.buraks.com/asv
package sszt.scene.utils.pathFind2 {
    import flash.geom.*;

    public class Diagonal {

        public static function each(_arg1:Point, _arg2:Point):Array{
            var _local3:int;
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local8:Number;
            var _local9:Number;
            var _local10:Number;
            var _local11:Boolean;
            var _local12:Boolean;
            var _local13:int;
            var _local7:Array = [];
            var _local14:int;
            var _local15:Boolean = ((_arg1.x < _arg2.x) == (_arg1.y < _arg2.y));
            if (_arg1.x < _arg2.x){
                _local5 = _arg1.x;
                _local6 = _arg1.y;
                _local3 = (_arg2.x - _local5);
                _local4 = Math.abs((_arg2.y - _local6));
            } else {
                _local5 = _arg2.x;
                _local6 = _arg2.y;
                _local3 = (_arg1.x - _local5);
                _local4 = Math.abs((_arg1.y - _local6));
            };
            if (_local3 == _local4){
                _local13 = 0;
                while (_local13 <= _local3) {
                    if (_local15){
                        _local7.push(new Point((_local5 + _local13), (_local6 + _local13)));
                    } else {
                        _local7.push(new Point((_local5 + _local13), (_local6 - _local13)));
                    };
                    if (_local13 > 0){
                        if (_local15){
                            _local7.push(new Point(((_local5 + _local13) - 1), (_local6 + _local13)));
                        } else {
                            _local7.push(new Point(((_local5 + _local13) - 1), (_local6 - _local13)));
                        };
                    };
                    if (_local13 < _local3){
                        if (_local15){
                            _local7.push(new Point(((_local5 + _local13) + 1), (_local6 + _local13)));
                        } else {
                            _local7.push(new Point(((_local5 + _local13) + 1), (_local6 - _local13)));
                        };
                    };
                    _local13++;
                };
            } else {
                if (_local3 > _local4){
                    _local8 = (_local4 / _local3);
                    _local7.push(new Point(_local5, _local6));
                    _local13 = 1;
                    while (_local13 <= _local3) {
                        _local9 = ((_local13 - 0.5) * _local8);
                        _local10 = ((_local13 + 0.5) * _local8);
                        _local11 = (((_local9 > (_local14 - 0.5))) && ((_local9 < (_local14 + 0.5))));
                        _local12 = (((_local10 > (_local14 - 0.5))) && ((_local10 < (_local14 + 0.5))));
                        if (((_local11) || (_local12))){
                            if (_local15){
                                _local7.push(new Point((_local5 + _local13), (_local6 + _local14)));
                            } else {
                                _local7.push(new Point((_local5 + _local13), (_local6 - _local14)));
                            };
                            if (!_local12){
                                _local14++;
                                if (_local15){
                                    _local7.push(new Point((_local5 + _local13), (_local6 + _local14)));
                                } else {
                                    _local7.push(new Point((_local5 + _local13), (_local6 - _local14)));
                                };
                            };
                        };
                        _local13++;
                    };
                } else {
                    if (_local3 < _local4){
                        _local8 = (_local3 / _local4);
                        _local7.push(new Point(_local5, _local6));
                        _local13 = 1;
                        while (_local13 <= _local4) {
                            _local9 = ((_local13 - 0.5) * _local8);
                            _local10 = ((_local13 + 0.5) * _local8);
                            _local11 = (((_local9 > (_local14 - 0.5))) && ((_local9 < (_local14 + 0.5))));
                            _local12 = (((_local10 > (_local14 - 0.5))) && ((_local10 < (_local14 + 0.5))));
                            if (((_local11) || (_local12))){
                                if (_local15){
                                    _local7.push(new Point((_local5 + _local14), (_local6 + _local13)));
                                } else {
                                    _local7.push(new Point((_local5 + _local14), (_local6 - _local13)));
                                };
                                if (!_local12){
                                    _local14++;
                                    if (_local15){
                                        _local7.push(new Point((_local5 + _local14), (_local6 + _local13)));
                                    } else {
                                        _local7.push(new Point((_local5 + _local14), (_local6 - _local13)));
                                    };
                                };
                            };
                            _local13++;
                        };
                    };
                };
            };
            return (_local7);
        }

    }
}//package common.findPath 
