//Created by Action Script Viewer - http://www.buraks.com/asv
package sszt.scene.utils.pathFind2 {

    public class PathMinHeap {

        private var m_data:Array;

        public function PathMinHeap(){
            m_data = [];
        }
        public function get Size():int{
            return (m_data.length);
        }
        public function Front():OpenPathItem{
            if (m_data.length > 0){
                return (m_data[0]);
            };
            return (null);
        }
        public function Push(_arg1:OpenPathItem):void{
            var _local3:int;
            var _local2:int = m_data.length;
            m_data.push(_arg1);
            while (_local2 > 0) {
                _local3 = ((_local2 - 1) / 2);
                if (!_arg1.min(m_data[_local3])){
                    break;
                };
                m_data[_local2] = m_data[_local3];
                _local2 = _local3;
            };
            m_data[_local2] = _arg1;
        }
        public function clear():void{
            m_data = [];
        }
        public function PopFront():void{
            var _local4:int;
            if (m_data.length == 0){
                return;
            };
            var _local1:OpenPathItem = m_data.pop();
            if (m_data.length == 0){
                return;
            };
            var _local2:int;
            var _local3:int = (m_data.length / 2);
            while (_local2 < _local3) {
                _local4 = ((_local2 * 2) + 1);
                if (((((_local4 + 1) < m_data.length)) && (m_data[(_local4 + 1)].min(m_data[_local4])))){
                    _local4++;
                };
                if (!m_data[_local4].min(_local1)){
                    break;
                };
                m_data[_local2] = m_data[_local4];
                _local2 = _local4;
            };
            m_data[_local2] = _local1;
        }

    }
}//package common.findPath.find2 
