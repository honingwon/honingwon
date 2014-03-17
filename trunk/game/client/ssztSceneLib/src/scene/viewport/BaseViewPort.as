package scene.viewport{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import sszt.constData.LayerIndex;
	import sszt.interfaces.scene.*;
	
	public class BaseViewPort extends Sprite implements IViewPort {
		
		protected var _layerContainers:Array;
		protected var _viewRect:Rectangle;
		private var _maxRect:Rectangle;
		private var _movableRect:Rectangle;
		private var _focusPoint:Point;
		
		public function BaseViewPort(mapWidth:int, mapHeight:int, focusX:int=500, focusY:int=300, movWidth:int=300, movHeight:int=150, viewWidth:int=1000, viewHeight:int=600){
			var container:Sprite;
			super();
			mouseEnabled = false;
			_layerContainers = [];
			var layers:Array = LayerIndex.getLayers();
			var mouseEnableds:Array = LayerIndex.getMouseEnableds();
			var mouseChildrens:Array = LayerIndex.getMouseChildrens();
			var i:int;
			while (i < layers.length) {
				container = new Sprite();
				container.mouseEnabled = mouseEnableds[i];
				container.mouseChildren = mouseChildrens[i];
				addChild(container);
				_layerContainers.push(container);
				i++;
			};
			_maxRect = new Rectangle(0, 0, mapWidth, mapHeight);
			_movableRect = new Rectangle(0, 0, movWidth, movHeight);
			_viewRect = new Rectangle(0, 0, viewWidth, viewHeight);
			focusPoint = new Point(focusX, focusY);
		}
		public function get focusPoint():Point{
			return (_focusPoint);
		}
		public function set maxRect(rect:Rectangle):void{
			_maxRect = rect;
		}
		public function set viewRect(rect:Rectangle):void{
			_viewRect.width = rect.width;
			_viewRect.height = rect.height;
			_viewRect.x = Math.max(rect.x, _maxRect.x);
			_viewRect.x = Math.min(rect.x, ((_maxRect.x + _maxRect.width) - rect.width));
			_viewRect.y = Math.max(rect.y, _maxRect.y);
			_viewRect.y = Math.min(rect.y, ((_maxRect.y + _maxRect.height) - rect.height));
			_movableRect.x = (_viewRect.x + ((viewRect.width - _movableRect.width) * 0.5));
			_movableRect.y = (_viewRect.y + ((viewRect.height - _movableRect.height) * 0.5));
		}
		public function get maxRect():Rectangle{
			return (_maxRect);
		}
		public function set movableRect(rect:Rectangle):void{
			_movableRect.width = rect.width;
			_movableRect.height = rect.height;
			_movableRect.x = (_viewRect.x + ((viewRect.width - _movableRect.width) * 0.5));
			_movableRect.y = (_viewRect.y + ((viewRect.height - _movableRect.height) * 0.5));
		}
		public function getLayerContainer(layer:uint):Sprite{
			return (_layerContainers[layer]);
		}
		public function get viewRect():Rectangle{
			return (_viewRect);
		}
		public function get movableRect():Rectangle{
			return (_movableRect);
		}
		public function setMapSize(w:Number, h:Number):void{
			_maxRect.width = w;
			_maxRect.height = h;
		}
		public function set focusPoint(value:Point):void{
			_focusPoint = value;
			var ldx:int = (_focusPoint.x - _movableRect.x);
			if (ldx < 0){
				_viewRect.x = (_viewRect.x + ldx);
			};
			var rdx:int = (_focusPoint.x - (_movableRect.x + _movableRect.width));
			if (rdx > 0){
				_viewRect.x = (_viewRect.x + rdx);
			};
			var udy:int = (_focusPoint.y - _movableRect.y);
			if (udy < 0){
				_viewRect.y = (_viewRect.y + udy);
			};
			var ddy:int = (_focusPoint.y - (_movableRect.y + _movableRect.height));
			if (ddy > 0){
				_viewRect.y = (_viewRect.y + ddy);
			};
			viewRect = _viewRect;
		}
		
	}
}//package scene.viewport
