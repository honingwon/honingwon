package sszt.loader.loaderinfo
{
	import sszt.interfaces.loader.ILoader;
	
	public class LoaderInfo 
	{
		
		public var loader:ILoader;
		public var completeHandler:Function;
		public var errorHandler:Function;
		public var progressHandler:Function;
		
		public function LoaderInfo(loader:ILoader, completeHandler:Function=null, errorHandler:Function=null, progressHandler:Function=null)
		{
			this.loader = loader;
			this.completeHandler = completeHandler;
			this.errorHandler = errorHandler;
			this.progressHandler = progressHandler;
		}
		public function doComplete():void
		{
			if (this.completeHandler != null){
				this.completeHandler();
			}
		}
		public function doError():void
		{
			if (this.errorHandler != null){
				this.errorHandler();
			}
		}
		public function doProgress(loadedBytes:Number, totalBytes:Number):void
		{
			if (this.progressHandler != null)
			{
				this.progressHandler(loadedBytes, totalBytes);
			}
		}
		
	}
}
