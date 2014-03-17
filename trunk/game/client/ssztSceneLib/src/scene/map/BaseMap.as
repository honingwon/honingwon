package scene.map{
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.display.DisplayObject;
	import sszt.constData.SceneConfig;
	import flash.display.DisplayObjectContainer;
	import flash.display.Bitmap;
	import scene.events.MapEvent;
	import flash.display.Shape;
	import sszt.interfaces.tick.*;
	
	public class BaseMap extends EventDispatcher implements ITick {
		
		protected var _preFillRect:Rectangle;
		protected var _yscale:Number;
		protected var _preRenders:Dictionary;
		protected var _thumbnail:BitmapData;
		protected var _imgs:Dictionary;
		protected var _loaderList:Array;
		protected var _xscale:Number;
		private var _thumbMatrix:Matrix;
		protected var _thumbs:Dictionary;
		
		public function BaseMap(){
			_imgs = new Dictionary();
			_thumbs = new Dictionary();
			_thumbMatrix = new Matrix();
			_preFillRect = new Rectangle();
			_loaderList = [];
		}
		public function fillRect(container:DisplayObjectContainer, maxRect:Rectangle, viewRect:Rectangle):void{
			var e:String;
			var j:int;
			var rc:String;
			var img:DisplayObject;
			var eimg:DisplayObject;
			if (((_preFillRect) && (_preFillRect.containsRect(viewRect)))){
				return;
			};
			var startRow:int = ((viewRect.y - maxRect.y) / SceneConfig.TILE_SIZE);
			var startCol:int = ((viewRect.x - maxRect.x) / SceneConfig.TILE_SIZE);
			startRow = (((startRow < 0)) ? 0 : startRow);
			startCol = (((startCol < 0)) ? 0 : startCol);
			var endRow:int = Math.ceil((((viewRect.y + viewRect.height) - maxRect.y) / SceneConfig.TILE_SIZE));
			var endCol:int = Math.ceil((((viewRect.x + viewRect.width) - maxRect.x) / SceneConfig.TILE_SIZE));
			_preFillRect.x = (startCol * SceneConfig.TILE_SIZE);
			_preFillRect.y = (startRow * SceneConfig.TILE_SIZE);
			_preFillRect.width = ((endCol - startCol) * SceneConfig.TILE_SIZE);
			_preFillRect.height = ((endRow - startRow) * SceneConfig.TILE_SIZE);
			var renderObjs:Dictionary = new Dictionary();
			var i:int = startRow;
			while (i < endRow) {
				j = startCol;
				while (j < endCol) {
					if ((((i >= 0)) && ((j >= 0)))){
						rc = ((i + "_") + j);
						img = _imgs[rc];
						if (!(img)){
							img = getThumbObj(i, j);
						};
						if (container.contains(img)){
							delete _preRenders[rc];
						} else {
							container.addChild(img);
						};
						if (!(_imgs[rc])){
							_loaderList.push([i, j]);
						};
						renderObjs[rc] = img;
					};
					j++;
				};
				i++;
			};
			for (e in _preRenders) {
				eimg = _preRenders[e];
				if (container.contains(eimg)){
					container.removeChild(eimg);
				};
			};
			_preRenders = renderObjs;
		}
		public function clear():void{
			var o:DisplayObject;
			var i:String;
			var b:Bitmap;
			var b1:Bitmap;
			if (_thumbnail){
				_thumbnail.dispose();
				_thumbnail = null;
			}
			for (i in _imgs) {
				o = _imgs[i];
				if ((o is Bitmap)){
					b = (o as Bitmap);
					if (b.bitmapData){
						b.bitmapData.dispose();
					};
				};
				if (((o) && (o.parent))){
					o.parent.removeChild(o);
				};
				delete _imgs[i];
			};
			for (i in _thumbs) {
				o = _thumbs[i];
				if (((o) && (o.parent))){
					o.parent.removeChild(o);
				};
				delete _thumbs[i];
			};
			_thumbMatrix = new Matrix();
			for (i in _preRenders) {
				o = _preRenders[i];
				if ((o is Bitmap)){
					b1 = (o as Bitmap);
					if (b1.bitmapData){
						b1.bitmapData.dispose();
					};
				};
				if (((o) && (o.parent))){
					o.parent.removeChild(o);
				};
				delete _preRenders[i];
			};
			_loaderList.length = 0;
			_preFillRect = new Rectangle();
		}
		public function update(times:int, dt:Number=0.04):void{
			var arr:Array;
			if (_loaderList.length > 0){
				arr = (_loaderList.shift() as Array);
				dispatchEvent(new MapEvent(MapEvent.NEED_DATA, arr[0], arr[1]));
			};
		}
		public function setThumbnail(bmp:BitmapData, xscale:Number, yscale:Number):void{
			var i:String;
			var tarr:Array;
			var row:int;
			var col:int;
			var sh:Shape;
			_thumbnail = bmp;
			_xscale = xscale;
			_yscale = yscale;
			_thumbMatrix.scale(_xscale, _yscale);
			for (i in _thumbs) {
				if (((i) && (_thumbs[i]))){
					tarr = i.split("_");
					row = int(tarr[0]);
					col = int(tarr[1]);
					_thumbMatrix.tx = (-(col) * SceneConfig.TILE_SIZE);
					_thumbMatrix.ty = (-(row) * SceneConfig.TILE_SIZE);
					sh = _thumbs[i];
					sh.graphics.clear();
					sh.graphics.beginBitmapFill(_thumbnail, _thumbMatrix);
					sh.graphics.drawRect(0, 0, SceneConfig.TILE_SIZE, SceneConfig.TILE_SIZE);
					sh.graphics.endFill();
				};
			};
		}
		public function getThumbObj(row:int, col:int):DisplayObject{
			var t:Shape;
			var shape:Shape;
			var rc:String = ((row + "_") + col);
			if (_thumbnail == null){
				t = new Shape();
				t.x = (col * SceneConfig.TILE_SIZE);
				t.y = (row * SceneConfig.TILE_SIZE);
				t.graphics.beginFill(0);
				t.graphics.drawRect(0, 0, SceneConfig.TILE_SIZE, SceneConfig.TILE_SIZE);
				t.graphics.endFill();
				_thumbs[rc] = t;
				return (t);
			};
			if (_thumbs[rc] == null){
				_thumbMatrix.tx = (-(col) * SceneConfig.TILE_SIZE);
				_thumbMatrix.ty = (-(row) * SceneConfig.TILE_SIZE);
				shape = new Shape();
				shape.graphics.beginBitmapFill(_thumbnail, _thumbMatrix);
				shape.graphics.drawRect(0, 0, SceneConfig.TILE_SIZE, SceneConfig.TILE_SIZE);
				shape.graphics.endFill();
				_thumbs[rc] = shape;
				shape.x = (col * SceneConfig.TILE_SIZE);
				shape.y = (row * SceneConfig.TILE_SIZE);
			};
			return (_thumbs[rc]);
		}
		public function addTileBitmap(row:int, col:int, bmp:Bitmap):void{
			if ((((bmp.width == 1)) && ((bmp.height == 1)))){
				return;
			};
			var rc:String = ((row + "_") + col);
			_imgs[rc] = bmp;
			bmp.x = (SceneConfig.TILE_SIZE * col);
			bmp.y = (SceneConfig.TILE_SIZE * row);
			var thumb:DisplayObject = _thumbs[rc];
			if (((thumb) && (thumb.parent))){
				thumb.parent.addChild(bmp);
				thumb.parent.removeChild(thumb);
			};
		}
		
	}
}//package scene.map
