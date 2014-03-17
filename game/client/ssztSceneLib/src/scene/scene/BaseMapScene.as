package scene.scene{
	import flash.geom.Rectangle;
	import scene.map.BaseMap;
	import sszt.interfaces.scene.IMapData;
	import sszt.interfaces.scene.IViewPort;
	
	public class BaseMapScene extends BaseScene {
		
		protected var _rect:Rectangle;
		protected var _map:BaseMap;
		
		public function BaseMapScene(mapdata:IMapData, viewport:IViewPort){
			super(mapdata, viewport);
		}
		public function getMap():BaseMap{
			return (_map);
		}
		public function getRect():Rectangle{
			return (_rect);
		}
		public function setMap(map:BaseMap):void{
			_map = map;
		}
		public function setRect(rect:Rectangle):void{
			_rect = rect;
		}
		
	}
}//package scene.scene
