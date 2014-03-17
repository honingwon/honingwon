package sszt.interfaces.loader
{
	import flash.utils.ByteArray;

	public interface ICacheApi
	{
		function getFile(path:String,callBack:Function,backup:Boolean = true):void;
		function setFile(path:String,data:ByteArray,backup:Boolean = true,callback:Function = null):void;
		/**
		 * 是否有缓存
		 * @return 
		 * 
		 */		
		function getCanCache():Boolean;
		function setCanCache(value:Boolean):void;
		/**
		 * 保存缓存文件列表
		 * @return 
		 * 
		 */		
		function saveCacheList():Boolean;
		/**
		 * 清除缓存
		 * 
		 */		
		function clearCache():void;
	}
}