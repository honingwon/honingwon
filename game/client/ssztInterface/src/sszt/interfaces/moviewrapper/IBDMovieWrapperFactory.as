package sszt.interfaces.moviewrapper
{
	import flash.display.BitmapData;
	
	/**
	 * 缓存bitmapdata，对重复性多的图像使用
	 * @author Administrator
	 * 
	 */	
	public interface IBDMovieWrapperFactory
	{
		/**
		 * 获得一个imoviewrapper
		 * @return 
		 * 
		 */		
		function getMovie():IMovieWrapper;
		/**
		 * 获得源图数据
		 * @return 
		 * 
		 */		
		function getBitmapData():BitmapData;
		function dispose():void;
	}
}