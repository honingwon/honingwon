package scene.render{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import sszt.interfaces.scene.IScene;
	import sszt.interfaces.scene.ICamera;
	import sszt.interfaces.scene.IViewPort;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import scene.scene.BaseMapScene;
	import scene.map.BaseMap;
	import sszt.constData.LayerIndex;
	import sszt.interfaces.tick.*;
	
	public class BaseMapRender extends BaseRender implements ITick {
		
		private var _first:Boolean;
		protected var _mapContainer:DisplayObjectContainer;
		private var _hasChange:Boolean;
		
		public function BaseMapRender(scene:IScene, camera:ICamera, vPort:IViewPort){
			super(scene, camera, vPort);
			_mapContainer = new Sprite();
			_mapContainer.mouseChildren = (_mapContainer.mouseEnabled = false);
			_first = true;
		}
		public function update(times:int, dt:Number=0.04):void{
			if (!(_hasChange)){
				return;
			};
			var view:DisplayObject = (viewPort as DisplayObject);
			var t:int = 50;
			var focus:Point = new Point(viewPort.viewRect.x, viewPort.viewRect.y);
			if ((view.x + focus.x) > t){
				view.x = (view.x - (((view.x + focus.x) - t) * 0.12));
			} else {
				if ((view.x + focus.x) < -(t)){
					view.x = (view.x - (((view.x + focus.x) + t) * 0.12));
				};
			};
			if ((view.y + focus.y) > t){
				view.y = (view.y - (((view.y + focus.y) - t) * 0.12));
			} else {
				if ((view.y + focus.y) < -(t)){
					view.y = (view.y - (((view.y + focus.y) + t) * 0.12));
				};
			};
			if ((((Math.abs((view.x + focus.x)) <= t)) && ((Math.abs((view.y + focus.y)) <= t)))){
				_hasChange = false;
			};
		}
		override public function render():void{
			var c:DisplayObjectContainer;
			var t:Number = getTimer();
			var mapScene:BaseMapScene = (scene as BaseMapScene);
			var map:BaseMap = mapScene.getMap();
			var container:DisplayObjectContainer = viewPort.getLayerContainer(LayerIndex.MAPLAYER);
			if (!(container.contains(_mapContainer))){
				container.addChild(_mapContainer);
				_mapContainer.x = viewPort.maxRect.x;
				_mapContainer.y = viewPort.maxRect.y;
			};
			var layers:Array = LayerIndex.getLayers();
			var i:int;
			while (i < layers.length) {
				c = viewPort.getLayerContainer(layers[i]);
				c.x = -(viewPort.viewRect.x);
				c.y = -(viewPort.viewRect.y);
				i++;
			};
			map.fillRect(_mapContainer, viewPort.maxRect, viewPort.viewRect);
		}
		
	}
}
