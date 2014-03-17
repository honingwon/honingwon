package sszt.loader.loaderinfo
{
	import sszt.interfaces.loader.ILoader;
	
	public class LoaderList 
	{
		
		public var path:String;
		public var isLoading:Boolean;
		public var list:Array;
		public var loadingLoader:LoaderInfo;
		
		public function LoaderList(path:String)
		{
			this.path = path;
			this.isLoading = false;
			this.list = [];
		}
		public function addLoading(loader:ILoader, completeHandler:Function=null, errorHandler:Function=null, progressHandler:Function=null):void
		{
			var i:LoaderInfo;
			for each (i in this.list) 
			{
				if (i.loader == loader)
				{
					return;
				}
			}
			this.list.push(new LoaderInfo(loader, completeHandler, errorHandler, progressHandler));
		}
		public function removeLoading(loader:ILoader):void
		{
			var i:int;
			while (i < this.list.length) {
				if (this.list[i].loader == loader){
					if (this.list[i] == this.loadingLoader){
						this.loadingLoader = null;
					};
					this.list.splice(i, 1);
					return;
				}
				i++;
			}
		}
		public function setCurrentLoading(loader:ILoader):void
		{
			var i:LoaderInfo;
			for each (i in this.list) {
				if (i.loader == loader){
					this.loadingLoader = i;
					return;
				}
			}
		}
		public function nextStartLoad():void
		{
			if (this.list.length == 0){
				return;
			}
			LoaderInfo(this.list[0]).loader.loadSync();
		}
		public function setLoadingState(value:Boolean):void
		{
			this.isLoading = value;
		}
		public function getLoadingState():Boolean
		{
			return (this.isLoading);
		}
		public function checkIsCurrent(loader:ILoader):Boolean
		{
			if (this.loadingLoader == null){
				return (false);
			}
			return ((this.loadingLoader.loader == loader));
		}
		public function loadComplete():void
		{
			var i:LoaderInfo;
			var tmp:Array = this.list.slice(0);
			for each (i in tmp) {
				i.doComplete();
			}
			tmp = null;
		}
		public function loadError():void
		{
			var i:LoaderInfo;
			var tmp:Array = this.list.slice(0);
			for each (i in tmp) {
				i.doError();
			}
			tmp = null;
		}
		public function loadProgress(loadedBytes:Number, totalBytes:Number):void
		{
			var i:LoaderInfo;
			var tmp:Array = this.list.slice(0);
			for each (i in tmp) {
				i.doProgress(loadedBytes, totalBytes);
			}
			tmp = null;
		}
		public function dispose():void
		{
			this.isLoading = false;
			this.list = null;
			this.loadingLoader = null;
		}
		
	}
}