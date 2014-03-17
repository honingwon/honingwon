package sszt.interfaces.moviewrapper
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public interface IMovieManager
	{
		function setup(tick:int = 40):void;
		/**
		 * 执行渲染
		 * @param param
		 * @return 
		 * 
		 */		
		function doRemance(param:IRemanceParam):BitmapData;
		/**
		 * 执行时间渲染
		 * @param param
		 * @return 
		 * 
		 */	
		function doTimeRemance(param:IRemanceParam,tick:int = 50,tickFrame:int = 10):BitmapData;
		
		/**
		 * 取得泻染参数
		 * @return 
		 * 
		 */		
		function getRemanceParam(source:Object,column:int,width:Number,height:Number,alpha:Number = 1,scaleX:Number = 1,scaleY:Number = 1,scale9Grid:Rectangle = null):IRemanceParam;
		
		/**
		 * 获取imoviewrapper
		 * @param source mc类型或class类型
		 * @param width mc宽度
		 * @param height mc高度
		 * @param column 列参数，width * column不能超过过2880
		 * @param alpha
		 * @return 
		 * 
		 */		
		function getMovieWrapper(source:Object,width:Number,height:Number,column:int = 1,alpha:Number = 1):IMovieWrapper;
		function getMovieWrapperByParam(param:IRemanceParam):IMovieWrapper;
		/**
		 * 获取系列相同的imoviewrapper
		 * @param count 返回数组的数量
		 * @param cl
		 * @param width
		 * @param height
		 * @param column
		 * @param alpha
		 * @return 
		 * 
		 */		
//		function createMovies(count:int,cl:Class,width:Number,height:Number,column:int = 1,alpha:Number = 1):Vector.<IMovieWrapper>;
		function createMovies(count:int,cl:Class,width:Number,height:Number,column:int = 1,alpha:Number = 1):Array;
//		function createMoviesByParam(count:int,param:IRemanceParam):Vector.<IMovieWrapper>;
		function createMoviesByParam(count:int,param:IRemanceParam):Array;
		
		/**
		 * 获得一个IBDMovieWrapperFactory实例
		 * @param param
		 * @param isTimer
		 * @param tick
		 * @param tickFrame
		 * @return 
		 * 
		 */		
		function getBDMovieWrapperFactory(param:IRemanceParam,isTimer:Boolean = false,tick:int = 50,tickFrame:int = 10):IBDMovieWrapperFactory;
		
	}
}