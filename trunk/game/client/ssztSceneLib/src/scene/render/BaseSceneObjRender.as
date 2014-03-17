package scene.render{
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.TimerEvent;
	import scene.events.SceneEvent;
	import sszt.constData.LayerIndex;
	import sszt.interfaces.scene.IScene;
	import sszt.interfaces.scene.ICamera;
	import sszt.interfaces.scene.IViewPort;
	import sszt.interfaces.scene.ISceneObj;
	import sszt.constData.SceneConfig;
	import flash.display.DisplayObject;
	import scene.utils.SceneObjSort;
	import flash.display.DisplayObjectContainer;
	import sszt.interfaces.tick.*;
	
	public class BaseSceneObjRender extends BaseRender implements ITick {
		
		protected var _preTiles:Dictionary;
		private var _frameCount:int;
		protected var _gcTimer:Timer;
		protected var _gcTiles:Dictionary;
		protected var _objContainer:Sprite;
		protected var _lastRenderRect:Rectangle;
		protected var _containers:Dictionary;
		protected var _sortList:Array;
		
		public function BaseSceneObjRender(scene:IScene, camera:ICamera, vPort:IViewPort){
			super(scene, camera, vPort);
			_frameCount = 0;
			_containers = new Dictionary();
			_preTiles = new Dictionary();
			_gcTiles = new Dictionary();
			_sortList = [];
			_gcTimer = new Timer(500, 1);
			_gcTimer.addEventListener(TimerEvent.TIMER_COMPLETE, gcTimerCompleteHandler);
			scene.addEventListener(SceneEvent.ADD_CHILD, addChildHandler);
			scene.addEventListener(SceneEvent.REMOVE_CHILD, removeChildHandler);
			scene.addEventListener(SceneEvent.MOVE_CHILD, moveChildHandler);
			scene.addEventListener(SceneEvent.ADD_EFFECT, addEffectHandler);
			scene.addEventListener(SceneEvent.ADD_TOMAP, addToMapHandler);
			scene.addEventListener(SceneEvent.ADD_CONTROL, addControlHandler);
			_objContainer = viewPort.getLayerContainer(LayerIndex.SCENEOBJLAYER);
		}
		public function getMouseOverObject():ISceneObj{
			var container:Sprite;
			var r:int;
			var i:int;
			var obj:ISceneObj;
			var col:int = ((_objContainer.mouseX - viewPort.maxRect.x) / SceneConfig.BROST_WIDTH);
			var row:int = ((_objContainer.mouseY - viewPort.maxRect.y) / SceneConfig.BROST_HEIGHT);
			var startCol:int = (((col > 0)) ? (col - 1) : col);
			var endCol:int = (col + 1);
			var startRow:int = (((row > 0)) ? (row - 1) : row);
			var endRow:int = (row + 1);
			var objs:Array = [];
			var c:int = startCol;
			while (c <= endCol) {
				r = startRow;
				while (r <= endRow) {
					container = getContainer(r, c);
					if (container){
						i = (container.numChildren - 1);
						while (i >= 0) {
							obj = (container.getChildAt(i) as ISceneObj);
							if (obj){
								if (obj.isMouseOver()){
									objs.push(obj);
									break;
								}
							}
							i--;
						}
					}
					r++;
				}
				c++;
			}
			if (objs.length == 0){
				return (null);
			}
			if (objs.length == 1){
				return (objs[0]);
			}
			var tmp:ISceneObj = objs[0];
			var t:int = 1;
			while (t < objs.length) 
			{
				if (objs[t].sceneY > tmp.sceneY){
					tmp = objs[t];
				}
				t++;
			}
			return (tmp);
		}
		public function getContainer(row:int, col:int):Sprite{
			var rc:String = ((row + "_") + col);
			var sp:Sprite = _containers[rc];
			if (_containers[rc] == null){
				sp = new Sprite();
				sp.mouseEnabled = false;
				sp.x = (viewPort.maxRect.x + (col * SceneConfig.BROST_WIDTH));
				sp.y = (viewPort.maxRect.y + (row * SceneConfig.BROST_HEIGHT));
				_containers[rc] = sp;
			};
			return (sp);
		}
		protected function addChildHandler(evt:SceneEvent):void{
			var obj:ISceneObj = evt.sceneObj;
			var col:int = ((obj.sceneX - viewPort.maxRect.x) / SceneConfig.BROST_WIDTH);
			var row:int = ((obj.sceneY - viewPort.maxRect.y) / SceneConfig.BROST_HEIGHT);
			var container:Sprite = getContainer(row, col);
			var disobj:DisplayObject = (obj as DisplayObject);
			container.addChild(disobj);
			disobj.x = (obj.sceneX - container.x);
			disobj.y = (obj.sceneY - container.y);
			if (_sortList.indexOf(container) == -1){
				_sortList.push(container);
			};
		}
		public function update(timers:int, dt:Number=0.04):void{
			var i:Sprite;
			_frameCount++;
			if (_frameCount >= 5){
				_frameCount = 0;
				if (_sortList.length == 0){
					return;
				};
				for each (i in _sortList) {
					SceneObjSort.move(i);
				};
				_sortList.length = 0;
			};
		}
		override public function render():void{
			var tile:DisplayObjectContainer;
			var k:String;
			var dx:int;
			var dy:int;
			var ele:Array;
			var rc:String;
			var flag:Boolean;
			if (_lastRenderRect == null){
				flag = true;
			} else {
				dx = (_lastRenderRect.x - viewPort.viewRect.x);
				dy = (_lastRenderRect.y - viewPort.viewRect.y);
				dx = (((dx < 0)) ? -(dx) : dx);
				dy = (((dy < 0)) ? -(dy) : dy);
				if ((((dx > 50)) || ((dy > 50)))){
					flag = true;
				};
			};
			if (!(flag)){
				return;
			};
			_lastRenderRect = viewPort.viewRect.clone();
			var tileArr:Array = getViewTiles(viewPort.maxRect, viewPort.viewRect, SceneConfig.BROST_WIDTH, SceneConfig.BROST_HEIGHT);
			var tiles:Dictionary = new Dictionary();
			var j:int;
			while (j < tileArr.length) {
				ele = tileArr[j];
				rc = ((ele[0] + "_") + ele[1]);
				if ((((_preTiles[rc] == null)) && ((_gcTiles[rc] == null)))){
					tile = getContainer(ele[0], ele[1]);
					_objContainer.addChildAt(tile, j);
					tiles[rc] = tile;
				} else {
					tile = (((_preTiles[rc] == null)) ? _gcTiles[rc] : _preTiles[rc]);
					tiles[rc] = tile;
					tile.parent.setChildIndex(tile, j);
					delete _preTiles[rc];
					delete _gcTiles[rc];
				};
				j++;
			};
			for (k in _preTiles) {
				_gcTiles[k] = _preTiles[k];
			};
			_preTiles = tiles;
			_gcTimer.reset();
			_gcTimer.start();
		}
		private function gcTimerCompleteHandler(evt:TimerEvent):void{
			var k:String;
			for (k in _gcTiles) {
				if (((_gcTiles[k]) && (_gcTiles[k].parent))){
					_gcTiles[k].parent.removeChild(_gcTiles[k]);
				};
			};
			_gcTiles = new Dictionary();
		}
		protected function addEffectHandler(evt:SceneEvent):void{
			var container:Sprite = viewPort.getLayerContainer(LayerIndex.EFFECTLAYER);
			container.addChild((evt.data as DisplayObject));
		}
		protected function addToMapHandler(evt:SceneEvent):void{
			var container:Sprite = viewPort.getLayerContainer(LayerIndex.MAPLAYER);
			container.addChild((evt.data as DisplayObject));
		}
		protected function addControlHandler(evt:SceneEvent):void{
			var container:Sprite = viewPort.getLayerContainer(LayerIndex.CONTROLLER);
			container.addChild((evt.data as DisplayObject));
		}
		protected function removeChildHandler(evt:SceneEvent):void{
			var obj:DisplayObject = (evt.sceneObj as DisplayObject);
			if (obj.parent){
				obj.parent.removeChild(obj);
			};
		}
		public function getViewTiles(maxRect:Rectangle, viewRect:Rectangle, tileWidth:int, tileHeight:int):Array{
			var j:int;
			var startRow:int = ((viewRect.y - maxRect.y) / tileHeight);
			var startCol:int = ((viewRect.x - maxRect.x) / tileWidth);
			startRow = (((startRow < 0)) ? 0 : startRow);
			startCol = (((startCol < 0)) ? 0 : startCol);
			var endRow:int = Math.ceil((((viewRect.y + viewRect.height) - maxRect.y) / tileHeight));
			var endCol:int = Math.ceil((((viewRect.x + viewRect.width) - maxRect.x) / tileWidth));
			var result:Array = [];
			var i:int = startRow;
			while (i < endRow) {
				j = startCol;
				while (j < endCol) {
					result.push([i, j]);
					j++;
				};
				i++;
			};
			return (result);
		}
		protected function moveChildHandler(evt:SceneEvent):void{
			var col:int = ((evt.sourcePoint.x - viewPort.maxRect.x) / SceneConfig.BROST_WIDTH);
			var row:int = ((evt.sourcePoint.y - viewPort.maxRect.y) / SceneConfig.BROST_HEIGHT);
			var newCol:int = ((evt.destPoint.x - viewPort.maxRect.x) / SceneConfig.BROST_WIDTH);
			var newRow:int = ((evt.destPoint.y - viewPort.maxRect.y) / SceneConfig.BROST_HEIGHT);
			var container:Sprite = getContainer(newRow, newCol);
			var disobj:DisplayObject = (evt.sceneObj as DisplayObject);
			if (!(container.contains(disobj))){
				container.addChild(disobj);
			};
			disobj.x = (evt.destPoint.x - container.x);
			disobj.y = (evt.destPoint.y - container.y);
			if (_sortList.indexOf(container) == -1){
				_sortList.push(container);
			};
		}
		
	}
} 
