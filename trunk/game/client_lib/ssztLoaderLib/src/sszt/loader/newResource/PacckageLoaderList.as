package sszt.loader.newResource
{
	import sszt.loader.PkgLoader;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.utils.getTimer;
	import sszt.events.LoaderEvent;
	import sszt.loader.LoaderManager;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import sszt.interfaces.tick.*;
	
	public class PacckageLoaderList implements ITick 
	{
		
		public var path:String;
		public var callbacks:Array;
		private var _pckgLoader:PkgLoader;
		public var clearType:int;
		private var _datas:Object;
		public var quoteCount:int;
		private var _frameCount:int;
		private var _source:MovieClip;
		private var _tmpDatas:Array;
		private var _createCount:int;
		private var _matrix:Matrix;
		private var _currentSize:int;
		public var clearTime:int;
		public var currentTime:int;
		public var _manager:PacckageLoaderManager;
		public var priority:int;
		public var startTime:Number;
		
		public function PacckageLoaderList(path:String, callback:Function, clearType:int, clearTime:int=2147483647, manager:PacckageLoaderManager=null, priority:int=1)
		{
			this.path = path;
			this.callbacks = [];
			this.quoteCount = 0;
			this.clearTime = clearTime;
			this.currentTime = int.MAX_VALUE;
			this._createCount = 1;
			this.startTime = Number.MAX_VALUE;
			this.addCallback(callback);
			this.clearType = clearType;
			this._manager = manager;
			this.priority = priority;
		}
		public function load():void
		{
			this.startTime = getTimer();
			this._pckgLoader = new PkgLoader(this.path, this.loadComplete, 3);
			this._pckgLoader.addEventListener(LoaderEvent.LOAD_ERROR, this.loadErrorHandler);
			this._pckgLoader.loadSync();
		}
		private function loadErrorHandler(evt:LoaderEvent):void
		{
			if (this._manager){
				this._manager.pathComplete(this);
			};
		}
		private function loadComplete(loader1:PkgLoader):void
		{
			this._source = (loader1.loader.content as MovieClip);
			this._frameCount = this._source.totalFrames;
			this._tmpDatas = [];
			this._matrix = new Matrix();
			LoaderManager.tickManager.addTick(this);
		}
		public function start():void
		{
			this.currentTime = getTimer();
		}
		public function stop():void
		{
			this.currentTime = int.MAX_VALUE;
		}
		public function getClear():Boolean
		{
			return (((getTimer() - this.currentTime) > this.clearTime));
		}
		public function update(times:int, dt:Number=0.04):void
		{
			var bound:Rectangle;
			var bd:BitmapData;
			var fileData:PacckageFileData;
			var func:Function;
			this._currentSize = 0;
			var i:int;
			while (i < 20) {
				this._source.gotoAndStop(this._createCount);
				bound = this._source.getBounds(this._source);
				if ((((bound.height == 0)) || ((bound.width == 0)))){
					this._tmpDatas.push(null);
				} else {
					bd = new BitmapData(bound.width, bound.height, true, 0);
					this._matrix.tx = -(bound.x);
					this._matrix.ty = -(bound.y);
					bd.draw(this._source, this._matrix);
					fileData = new PacckageFileData(bd, bound.x, bound.y);
					this._tmpDatas.push(fileData);
				};
				this._createCount++;
				if (this._createCount > this._frameCount){
					LoaderManager.tickManager.removeTick(this);
					if (this._manager){
						this._manager.pathComplete(this);
					};
					this._datas = {
						datas:this._tmpDatas,
							path:this.path
					};
					if (this._pckgLoader){
						this._pckgLoader.setQuoteDispose();
						this._pckgLoader = null;
						this._source = null;
					};
					for each (func in this.callbacks) {
						if (func != null){
							(func(this._datas));
						};
					};
					this.callbacks.length = 0;
					break;
				};
				this._currentSize = (this._currentSize + (bound.width + bound.height));
				if (this._currentSize > 4000) break;
				i++;
			};
		}
		public function addCallback(func:Function):void
		{
			if (this._datas){
				(func(this._datas));
				this.quoteCount++;
			} else {
				if (this.callbacks.indexOf(func) == -1){
					this.callbacks.push(func);
					this.quoteCount++;
				};
			};
		}
		public function removeCallback():void
		{
			this.quoteCount--;
			if (this.quoteCount < 0){
				this.quoteCount = 0;
			};
		}
		public function dispose():void
		{
			var i:PacckageFileData;
			LoaderManager.tickManager.removeTick(this);
			if (this._pckgLoader){
				this._pckgLoader.removeEventListener(LoaderEvent.LOAD_ERROR, this.loadErrorHandler);
				this._pckgLoader.dispose();
				this._pckgLoader = null;
			};
			if (this._datas){
				if (this._datas.hasOwnProperty("datas")){
					for each (i in this._datas.datas) {
						if (i){
							i.dispose();
						};
					};
				};
			};
			this._datas = null;
			this.callbacks = null;
			this._source = null;
			this._tmpDatas = null;
		}
		
	}
}
