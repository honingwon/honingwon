package scene.events
{
    import flash.events.*;
    import flash.geom.*;
    import mhsm.interfaces.scene.*;

    public class SceneEvent extends Event
    {
        public var data:Object;
        public var sourcePoint:Point;
        public var sceneObj:ISceneObj;
        public var destPoint:Point;
        public static const REMOVE_CHILD:String = "removeChild";
        public static const ADD_TOMAP:String = "addToMap";
        public static const MOVE_CHILD:String = "moveChild";
        public static const ADD_EFFECT:String = "addEffect";
        public static const ADD_CHILD:String = "addChild";
        public static const ADD_CONTROL:String = "addControl";

        public function SceneEvent(type:String, obj:ISceneObj = null, sourcePoint:Point = null, destPoint:Point = null, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            sceneObj = obj;
            this.sourcePoint = sourcePoint;
            this.destPoint = destPoint;
            this.data = data;
            super(type, bubbles, cancelable);
            return;
        }// end function

    }
}
