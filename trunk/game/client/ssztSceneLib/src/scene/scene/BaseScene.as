package scene.scene{
	import flash.events.EventDispatcher;
	import sszt.interfaces.scene.IViewPort;
	import sszt.interfaces.scene.IMapData;
	import scene.events.SceneEvent;
	import flash.display.DisplayObject;
	import sszt.interfaces.scene.ISceneObj;
	import sszt.constData.SceneConfig;
	import flash.geom.Point;
	import sszt.interfaces.scene.*;
	
	public class BaseScene extends EventDispatcher implements IScene {
		
		private var _viewport:IViewPort;
		private var _sceneObjs:Array;
		private var _mapData:IMapData;
		
		public function BaseScene(mapdata:IMapData, viewport:IViewPort){
			_mapData = mapdata;
			_sceneObjs = [];
			_viewport = viewport;
		}
		public function addToMap(obj:DisplayObject):void{
			dispatchEvent(new SceneEvent(SceneEvent.ADD_TOMAP, null, null, null, obj));
		}
		public function addChild(obj:ISceneObj):ISceneObj{
			return (toAddChild(obj));
		}
		public function addControl(obj:DisplayObject):void{
			dispatchEvent(new SceneEvent(SceneEvent.ADD_CONTROL, null, null, null, obj));
		}
		public function get width():uint{
			return (_mapData.getWidth());
		}
		public function move(obj:ISceneObj, scenePt:Point):void{
			var row:int = Math.floor((obj.sceneY / SceneConfig.TILE_SIZE));
			var col:int = Math.floor((obj.sceneX / SceneConfig.TILE_SIZE));
			var newRow:int = Math.floor((scenePt.y / SceneConfig.TILE_SIZE));
			var newCol:int = Math.floor((scenePt.x / SceneConfig.TILE_SIZE));
			var sourcePoint:Point = new Point(obj.sceneX, obj.sceneY);
			if (((!((newRow == row))) || (!((newCol == col))))){
				toRemoveChild(obj, false);
				obj.setScenePos(scenePt.x, scenePt.y);
				toAddChild(obj, false);
			} else {
				obj.setScenePos(scenePt.x, scenePt.y);
			};
			dispatchEvent(new SceneEvent(SceneEvent.MOVE_CHILD, obj, sourcePoint, scenePt.clone()));
		}
		protected function toAddChild(obj:ISceneObj, dispatch:Boolean=true):ISceneObj{
			if (obj.scene != null){
				obj.scene.removeChild(obj);
			};
			obj.scene = this;
			var row:int = Math.floor((obj.sceneY / SceneConfig.TILE_SIZE));
			var col:int = Math.floor((obj.sceneX / SceneConfig.TILE_SIZE));
			if (dispatch){
				dispatchEvent(new SceneEvent(SceneEvent.ADD_CHILD, obj));
			};
			return (obj);
		}
		public function getSceneObjsByPos(row:int, col:int):Array{
			if (_sceneObjs[row] == null){
				return (null);
			};
			if (_sceneObjs[row][col] == null){
				return (null);
			};
			return (_sceneObjs[row][col]);
		}
		public function dispose():void{
			_mapData = null;
			_sceneObjs = null;
			_viewport = null;
		}
		public function addEffect(effect:DisplayObject):void{
			dispatchEvent(new SceneEvent(SceneEvent.ADD_EFFECT, null, null, null, effect));
		}
		public function get mapData():IMapData{
			return (_mapData);
		}
		public function get height():uint{
			return (_mapData.getHeight());
		}
		public function getViewPort():IViewPort{
			return (_viewport);
		}
		protected function toRemoveChild(obj:ISceneObj, dispatch:Boolean=true):void{
			if (obj.scene != this){
				return;
			};
			obj.scene = null;
			var row:int = Math.floor((obj.sceneY / SceneConfig.TILE_SIZE));
			var col:int = Math.floor((obj.sceneX / SceneConfig.TILE_SIZE));
			if (dispatch){
				dispatchEvent(new SceneEvent(SceneEvent.REMOVE_CHILD, obj));
			};
		}
		public function removeChild(obj:ISceneObj):void{
			toRemoveChild(obj);
		}
		
	}
}//package scene.scene
