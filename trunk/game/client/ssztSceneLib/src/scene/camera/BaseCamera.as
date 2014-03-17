package scene.camera{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import sszt.interfaces.scene.*;
	
	public class BaseCamera extends EventDispatcher implements ICamera {
		
		public function getScenePosition(x:int, y:int):Point{
			return (new Point(x, y));
		}
		public function getSceneRect(w:uint, h:uint):Rectangle{
			return (new Rectangle(0, 0, w, h));
		}
		public function getProjectPosition(x:int, y:int):Point{
			return (new Point(x, y));
		}
		
	}
}//package scene.camera
