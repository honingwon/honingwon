//Created by Action Script Viewer - http://www.buraks.com/asv
package sszt.scene.utils.pathFind3 {
    import flash.utils.*;

    public class FindScenePath {

        private var _dic:Dictionary;

        public function FindScenePath(_arg1:Object):void{
            var _local2:SceneNode;
            var _local3:*;
            var _local4:String;
            var _local5:*;
            var _local6:String;
            super();
            _dic = new Dictionary();
            for (_local3 in _arg1) {
                _local2 = new SceneNode();
                _local2.id = _local3;
                _local2.links = _arg1[_local3].links;
                _local2.isFind = false;
                _dic[_local2.id] = _local2;
            };
            for (_local4 in _dic) {
                _local2 = (_dic[_local4] as SceneNode);
                _local2.nodeLinks = new Array();
                for (_local5 in _local2.links) {
                    _local6 = _local2.links[_local5];
                    if (_dic[_local6] != undefined){
                        _local2.nodeLinks.push(_dic[_local6]);
                    };
                };
            };
        }
        public function find(_arg1:int, _arg2:int):Array{
            var _local3:String;
            var _local4:Array;
            var _local5:SceneNode;
            var _local9:String;
            var _local11:SceneNode;
            var _local12:SceneNode;
            var _local13:String;
            for (_local3 in _dic) {
                _local11 = _dic[_local3];
                _local11.isFind = false;
                _local11.isRoot = false;
                _local11.parentNode = null;
            };
            _local4 = new Array();
            if (_dic[_arg1] == undefined){
                return (null);
            };
            if (_dic[_arg2] == undefined){
                return (null);
            };
            var _local6:SceneNode = _dic[_arg1];
            _local6.isRoot = true;
            var _local7:int = _arg1;
            while (_local7 != _arg2) {
                _local5 = _dic[_local7];
                _local5.isFind = true;
                for (_local13 in _local5.nodeLinks) {
                    _local12 = _local5.nodeLinks[_local13];
                    if ((((_local12.isFind == true)) || ((_local12.isClose == true)))){
                    } else {
                        _local12.parentNode = _local5;
                        _local7 = _local12.id;
                        break;
                    };
                };
                if (_local7 != _local5.id){
                } else {
                    if (_local5.isRoot == true){
                        return (null);
                    };
                    _local7 = _local5.parentNode.id;
                };
            };
            var _local8:SceneNode = _dic[_arg2];
            var _local10:Array = new Array();
            while (1) {
                _local10.unshift(_local8.id);
                if (_local8.parentNode != null){
                    _local8 = _local8.parentNode;
                } else {
                    break;
                };
            };
            return (_local10);
        }
        public function changeCountry(_arg1:int):void{
            var _local2:SceneNode;
            var _local3:*;
            var _local4:int;
            if (_dic[101] != null){
                _local2 = _dic[101];
                for (_local3 in _local2.links) {
                    _local4 = _local2.links[_local3];
                    if (_local4 == 100){
                    } else {
                        if ((((_arg1 == 1)) && (!((_local4 == 160))))){
                            _local2.nodeLinks[_local3].isClose = true;
                        } else {
                            if ((((_arg1 == 2)) && (!((_local4 == 180))))){
                                _local2.nodeLinks[_local3].isClose = true;
                            } else {
                                if ((((_arg1 == 3)) && (!((_local4 == 200))))){
                                    _local2.nodeLinks[_local3].isClose = true;
                                };
                            };
                        };
                    };
                };
            };
            if (_dic[161] != null){
                _local2 = _dic[161];
                for (_local3 in _local2.links) {
                    _local4 = _local2.links[_local3];
                    if (_local4 == 220){
                    } else {
                        if ((((_arg1 == 1)) && (!((_local4 == 160))))){
                            _local2.nodeLinks[_local3].isClose = true;
                        } else {
                            if ((((_arg1 == 2)) && (!((_local4 == 180))))){
                                _local2.nodeLinks[_local3].isClose = true;
                            } else {
                                if ((((_arg1 == 3)) && (!((_local4 == 200))))){
                                    _local2.nodeLinks[_local3].isClose = true;
                                };
                            };
                        };
                    };
                };
            };
        }

    }
}//package common.findPath 
