package sszt.core.proxy
{
	import sszt.constData.SourceClearType;
	import sszt.core.caches.MovieCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.interfaces.loader.IDataFileInfo;

	public class LoadMovieProxy
	{		
		public static function LoadMovie(movieIds:Array):void
		{
			for(var i:int = 0; i < movieIds.length; i++)
			{
				loadMovie(movieIds[i]);
			}
		}
		
		private static function loadMovie(id:String):void
		{
			GlobalAPI.loaderAPI.getDataFile(GlobalAPI.pathManager.getMoviePath(id),getDataComplete,SourceClearType.NEVER);
			function getDataComplete(data:IDataFileInfo):void
			{
			}
		}
	}
}