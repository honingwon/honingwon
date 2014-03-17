/**
 * 动画文件加载器列表 
 */
package sszt.loader.fanm
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.getTimer;
	
	import sszt.events.LoaderEvent;
	import sszt.interfaces.tick.*;
	import sszt.loader.LoaderManager;
	import sszt.loader.ModuleLoader;
	import sszt.loader.PkgLoader;
	
	public class FanmLoaderList implements ITick 
	{
		
		public var path:String;
		public var callbacks:Array;
		private var _loader:FanmLoader;
		public var clearType:int;
		private var _datas:Object;
		public var quoteCount:int;
		private var _frameCount:int;
		private var _scaleX:int;
		private var _directType:int;
		private var _actions:Array;
		private var _actionsSE:Array;
		private var _tmpDatas:Array;
		private var _createCount:int;
		private var _currentSize:int;
		public var clearTime:int;
		public var currentTime:int;
		public var _manager:FanmLoaderManager;
		public var priority:int;
		public var startTime:Number;
		private var _domain:ApplicationDomain;
		
		private var _hadcryptType:int;
		
		private var className:String = "zzstAnimeModel";
		
		public function FanmLoaderList(path:String, callback:Function, clearType:int, clearTime:int=2147483647, manager:FanmLoaderManager=null, priority:int=1,hadcryptType:int=0)
		{
			this.path = path;
			this.callbacks = [];
			this.quoteCount = 0;
			this.startTime = Number.MAX_VALUE;
			this.clearTime = clearTime;
			this.currentTime = int.MAX_VALUE;
			this._createCount = 1;
			this.addCallback(callback);
			this.clearType = clearType;
			this._manager = manager;
			this.priority = priority;
			this._hadcryptType = hadcryptType;
		}
		public function load():void
		{
			this.startTime = getTimer();
			this._loader = new FanmLoader(this.path, this.loadComplete, 3,this._hadcryptType);
			this._loader.addEventListener(LoaderEvent.LOAD_ERROR, this.loadErrorHandler);
			this._loader.loadSync();
			
		}
		private function loadErrorHandler(evt:LoaderEvent):void
		{
			if (this._manager){
				this._manager.pathComplete(this);
			}
		}
		private function loadComplete(domain:ApplicationDomain):void
		{
			_domain = domain;
			try
			{
				var cl:Class = _domain.getDefinition(className) as Class;
				var sp:Sprite = new cl() as Sprite;
				this._frameCount = sp["count"];
				this._actions =  sp["actions"];
				this._actionsSE =  sp["actionsFrameSE"];
				this._directType = sp["directType"];
				this._scaleX = sp["sX"];
				
			} catch(err:Error) {
				trace(err.message, path);
				trace(err.getStackTrace());
			}
			this._tmpDatas = [];
			
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
			return (getTimer() - this.currentTime) > this.clearTime;
		}
		public function update(times:int, dt:Number=0.04):void
		{
			var bd:BitmapData;
			var fileData:FanmFileData;
			var func:Function;
			var i:int;
			while (i < 30)
			{
				try
				{
					var cl:Class = _domain.getDefinition(className + "_" + (10000 + this._createCount -1)) as Class;
					bd = new cl(0,0) as BitmapData;
					
				} catch(err:Error) {
					trace(err.message, path);
					trace(err.getStackTrace());
				}
				if(bd != null)
				{
					fileData = new FanmFileData(bd, bd["xoff"],bd["yoff"]);
					_tmpDatas.push(fileData);
				}
				
				this._createCount++;
				if (this._createCount > this._frameCount)
				{
					LoaderManager.tickManager.removeTick(this);
					if (this._manager){
						this._manager.pathComplete(this);
					}
					this._datas = {
						count:this._frameCount,
						directType:this._directType,
						datas:this._tmpDatas,
						action:this._actions,
						actionSE:this._actionsSE,
						sX:this._scaleX,
						path:this.path						
					}
					if (this._loader){
						this._loader.dispose();
						this._loader = null;
					}
					for each (func in this.callbacks) {
						if (func != null){
							func(this._datas);
						}
					}
					this.callbacks.length = 0;
					break;
				}
				i++;
			}
		}
		
		public function addCallback(func:Function):void
		{
			if (this._datas){
				func(this._datas);
				this.quoteCount++;
			}
			else 
			{
				if (this.callbacks.indexOf(func) == -1)
				{
					this.callbacks.push(func);
					this.quoteCount++;
				}
			}
		}
		public function removeCallback():void
		{
			this.quoteCount--;
			if (this.quoteCount < 0)
			{
				this.quoteCount = 0;
			}
		}
		public function dispose():void
		{
			var i:FanmFileData;
			LoaderManager.tickManager.removeTick(this);
			if (this._loader){
				this._loader.removeEventListener(LoaderEvent.LOAD_ERROR, this.loadErrorHandler);
				this._loader.dispose();
				this._loader = null;
			}
			if (this._datas){
				if (this._datas.hasOwnProperty("datas")){
					for each (i in this._datas.datas) {
						if (i){
							i.dispose();
						}
					}
				}
			}
			this._domain = null;
			this._datas = null;
			this.callbacks = null;
			this._tmpDatas = null;
			this._actions = null;
			this._actionsSE = null;
		}
		
	}
}
