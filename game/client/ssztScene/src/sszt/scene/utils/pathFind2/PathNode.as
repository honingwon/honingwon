//Created by Action Script Viewer - http://www.buraks.com/asv
package sszt.scene.utils.pathFind2 {

    public class PathNode {

        public var value_g:int = 0;
        public var value_h:int = 0;
        public var open:Boolean = false;
        public var nodeparent:PathNode = null;
        public var block:Boolean = false;
        public var value:int = 0;
        public var x:int;
        public var y:int;
        public var value_f:int = 0;

    }
}//package common.findPath 
