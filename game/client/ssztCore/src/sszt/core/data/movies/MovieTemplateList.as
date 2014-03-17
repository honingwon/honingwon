package sszt.core.data.movies
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;

	public class MovieTemplateList
	{
		private static var _movieList:Dictionary;
		
		public static function setup(data:ByteArray):void
		{
//			if(!data.readBoolean())
//			{
//				MAlert.show(data.readUTF());
//			}
//			else
//			{
//				data.readUTF();
			
				_movieList = new Dictionary();
				
				var len:int = data.readInt();
				for(var i:int = 0; i < len; i++)
				{
					var item:MovieTemplateInfo = new MovieTemplateInfo();
					item.parseData(data);
					_movieList[item.id] = item;
				}
//			}
		}
		
		public static function getMovie(id:int):MovieTemplateInfo
		{
			return _movieList[id];
		}
	}
}