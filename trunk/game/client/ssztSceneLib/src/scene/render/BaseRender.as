package scene.render{
	import flash.events.EventDispatcher;
	import sszt.interfaces.scene.ICamera;
	import sszt.interfaces.scene.IViewPort;
	import sszt.interfaces.scene.IScene;
	import sszt.interfaces.scene.*;
	
	public class BaseRender extends EventDispatcher implements IRender {
		
		private var _camera:ICamera;
		private var _viewPort:IViewPort;
		private var _scene:IScene;
		
		public function BaseRender(scene:IScene, camera:ICamera, vPort:IViewPort){
			_scene = scene;
			_camera = camera;
			_viewPort = vPort;
		}
		public function get viewPort():IViewPort{
			return (_viewPort);
		}
		public function set camera(value:ICamera):void{
			_camera = value;
		}
		public function get camera():ICamera{
			return (_camera);
		}
		public function set viewPort(value:IViewPort):void{
			_viewPort = value;
		}
		public function render():void{
		}
		public function set scene(value:IScene):void{
			_scene = value;
		}
		public function get scene():IScene{
			return (_scene);
		}
		
	}
}//package scene.render
