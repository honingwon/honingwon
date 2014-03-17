package sszt.loader.newResource
{
	import flash.utils.Dictionary;
	import sszt.constData.SourceClearType;
	import flash.utils.getTimer;
	import sszt.interfaces.tick.*;
	
	public class PacckageLoaderManager implements ITick 
	{
		
		public static const LOAD_LINE:int = 3;
		
		public var caches:Dictionary;
		public var clearList:Array;
		private var _waitingList:Array;
		private var _loadedList:Array;
		
		public function PacckageLoaderManager()
		{
			this.caches = new Dictionary();
			this.clearList = [];
			this._waitingList = [];
			this._loadedList = [];
			super();
		}
		public function getFile(path:String, callback:Function, clearType:int, clearTime:int=214783647, priority:int=1):void
		{
			var cache:PacckageLoaderList = this.caches[path];
			if (cache == null){
				cache = new PacckageLoaderList(path, callback, clearType, clearTime, this, priority);
				this.caches[cache.path] = cache;
				this._waitingList.push(cache);
			} else {
				cache.addCallback(callback);
			};
			this.setCacheClearList(cache);
		}
		private function inWaitingList(path:String):int
		{
			var len:int = this._waitingList.length;
			var i:int;
			while (i < len) {
				if (this._waitingList[i].path == path){
					return (i);
				};
				i++;
			};
			return (-1);
		}
		private function inLoadList(path:String):int
		{
			var len:int = this._loadedList.length;
			var i:int;
			while (i < len) {
				if (this._loadedList[i].path == path){
					return (i);
				};
				i++;
			};
			return (-1);
		}
		public function removeAQuote(path:String):void
		{
			var cache:PacckageLoaderList = this.caches[path];
			if (cache){
				cache.removeCallback();
				this.setCacheClearList(cache);
			};
		}
		public function setCacheClearList(cache:PacckageLoaderList):void
		{
			var index:int;
			if (cache.quoteCount <= 0){
				if (((!((cache.clearType == SourceClearType.CHANGESCENE_AND_TIME))) && (!((cache.clearType == SourceClearType.TIME))))){
					return;
				};
				if (this.clearList.indexOf(cache) > -1){
					return;
				};
				cache.start();
				this.clearList.push(cache);
			} else {
				cache.stop();
				index = this.clearList.indexOf(cache);
				if (index > -1){
					this.clearList.splice(index, 1);
				};
			};
		}
		public function update(times:int, dt:Number=0.04):void
		{
			var n:int;
			var i:int;
			var cache:PacckageLoaderList;
			var loaded:PacckageLoaderList;
			var list:Array;
			var len:int = this.clearList.length;
			i = (len - 1);
			while (i >= 0) {
				cache = this.clearList[i];
				if (cache.getClear()){
					n = this.inWaitingList(cache.path);
					if (n > -1){
						this._waitingList.splice(n, 1);
					};
					n = this.inLoadList(cache.path);
					if (n > -1){
						this._loadedList.splice(n, 1);
					};
					delete this.caches[cache.path];
					cache.dispose();
					this.clearList.splice(i, 1);
				};
				i--;
			};
			i = (this._loadedList.length - 1);
			while (i >= 0) {
				loaded = this._loadedList[i];
				if ((getTimer() - loaded.startTime) > 10000){
					this._loadedList.splice(i, 1);
				};
				i--;
			};
			n = (LOAD_LINE - this._loadedList.length);
			if (this._waitingList.length > 0){
				this._waitingList.sortOn(["priority"], [(Array.CASEINSENSITIVE | Array.NUMERIC)]);
				list = this._waitingList.splice(0, n);
				i = 0;
				while (i < list.length) {
					list[i].load();
					this._loadedList.push(list[i]);
					i++;
				};
			};
		}
		public function pathComplete(list:PacckageLoaderList):void
		{
			var path:String = list.path;
			var n:int = this._loadedList.indexOf(list);
			if (n > -1){
				this._loadedList.splice(n, 1);
			};
		}
		public function changeSceneClear():void
		{
			var i:PacckageLoaderList;
			var index:int;
			var tmp:Dictionary = new Dictionary();
			for each (i in this.caches) {
				if (i){
					if (i.clearType == SourceClearType.CHANGE_SCENE || (i.clearType == SourceClearType.CHANGESCENE_AND_TIME && i.getClear()))
					{
						i.dispose();
						index = this.clearList.indexOf(i);
						if (index > -1){
							this.clearList.splice(index, 1);
						};
						index = this._waitingList.indexOf(i);
						if (index > -1){
							this._waitingList.splice(index, 1);
						};
						index = this._loadedList.indexOf(i);
						if (index > -1){
							this._loadedList.splice(index, 1);
						};
					} else {
						tmp[i.path] = i;
					};
				};
			};
			this.caches = tmp;
		}
		
	}
}
