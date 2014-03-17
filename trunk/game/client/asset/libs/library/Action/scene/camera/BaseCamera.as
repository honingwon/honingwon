package scene.camera
{
    import flash.events.*;
    import flash.geom.*;

    public class BaseCamera extends EventDispatcher implements ICamera
    {

        public function BaseCamera()
        {
            return;
        }// end function

        public function getScenePosition(x:int, y:int) : Point
        {
            return new Point(x, y);
        }// end function

        public function getSceneRect(w:uint, h:uint) : Rectangle
        {
            return new Rectangle(0, 0, w, h);
        }// end function

        public function getProjectPosition(x:int, y:int) : Point
        {
            return new Point(x, y);
        }// end function

    }
}
