package scene.events
{
    import flash.events.*;

    public class BaseSceneObjectEvent extends Event
    {
        public var data:Object;
        public static const SCENEOBJ_CLICK:String = "sceneObjClick";
        public static const SCENEOBJ_OUT:String = "sceneObjOut";
        public static const SCENEOBJ_OVER:String = "sceneObjOver";

        public function BaseSceneObjectEvent(type:String, obj:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            data = obj;
            super(type, bubbles, cancelable);
            return;
        }// end function

    }
}
