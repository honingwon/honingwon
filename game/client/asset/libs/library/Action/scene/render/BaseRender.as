package scene.render
{
    import flash.events.*;
    import mhsm.interfaces.scene.*;

    public class BaseRender extends EventDispatcher implements IRender
    {
        private var _camera:ICamera;
        private var _viewPort:IViewPort;
        private var _scene:IScene;

        public function BaseRender(scene:IScene, camera:ICamera, vPort:IViewPort)
        {
            _scene = scene;
            _camera = camera;
            _viewPort = vPort;
            return;
        }// end function

        public function get viewPort() : IViewPort
        {
            return _viewPort;
        }// end function

        public function set camera(value:ICamera) : void
        {
            _camera = value;
            return;
        }// end function

        public function get camera() : ICamera
        {
            return _camera;
        }// end function

        public function set viewPort(value:IViewPort) : void
        {
            _viewPort = value;
            return;
        }// end function

        public function render() : void
        {
            return;
        }// end function

        public function set scene(value:IScene) : void
        {
            _scene = value;
            return;
        }// end function

        public function get scene() : IScene
        {
            return _scene;
        }// end function

    }
}
