package sszt.interfaces.loader
{
	import flash.system.ApplicationDomain;
	
	import sszt.interfaces.decode.IDecode;
	import sszt.interfaces.tick.ITickManager;
	
	public interface ILoaderApi
	{
		/**
		 * 
		 * @param domain 
		 * @param dec 解密类
		 * 
		 */		
		function setup(domain:ApplicationDomain,dec:IDecode = null,cache:ICacheApi = null,version:int = 1000):void;
		/**
		 * 创建加开始加载，返回loader
		 * @return 
		 * 
		 */		
		function loadSwf(path:String,callback:Function,tryTime:int = 1,hadCryptType:int = 0):ILoader;
		function loadZip(path:String,callback:Function,tryTime:int = 1,decodeType:int = 1):ILoader;
		function loadQueueLoader(loaders:Array,callback:Function = null):ILoader;
		function loadConfig(path:String,callback:Function,tryTime:int = 1,decodeType:int = 0):ILoader;
		function loadData(path:String,callback:Function,tryTime:int = 1,decodeType:int = 0):ILoader;
		/**
		 * 创建并返回loader
		 * @return 
		 * 
		 */		
		function createSwfLoader(path:String,callback:Function,tryTime:int = 1,hadCryptType:int = 0):ILoader;
//		function createSwfLoader(path:String,callback:Function,tryTime:int = 1,hadCryptType:int = 0,domain:ApplicationDomain = null):ILoader;		
		function createRequestLoader(path:String,param:Object = null,callback:Function = null,isCompress:Boolean = false,tryTime:int = 1):ILoader;
		function createZipLoader(path:String,callback:Function,tryTime:int = 1,decodeType:int = 1):ILoader;
		function createQueueLoader(loaders:Array,callback:Function = null):ILoader;
		function createConfigLoader(path:String,callback:Function,tryTime:int = 1,decodeType:int = 0):ILoader;
		/**
		 * 类是否已经定义
		 * @param path
		 * @return 
		 * 
		 */		
		function getHadDefined(path:String):Boolean;
//		function getHadDefined(path:String,domain:ApplicationDomain = null):Boolean;
		/**
		 * 反射类
		 * @param path
		 * @return 
		 * 
		 */		
		function getClassByPath(path:String):Class;
//		function getClassByPath(path:String,domain:ApplicationDomain = null):Class
		
		function getObjectByClassPath(path:String):Object;
		/**
		 * 地址是否加载过
		 * @return 
		 * 
		 */		
		function pathHadLoaded(path:String):Boolean;
		/**
		 * 获取可视文件（JPG文件）
		 * @param path
		 * @param callback
		 * 
		 */		
		function getDisplayFile(path:String,classPath:String,callback:Function,clearType:int):void;
		function removeDisplayFile(path:String,callback:Function):void;
		function displayTimeclear(path:String,checkQuote:Boolean = false):void
		/**
		 * 获取数据文件（txt文件）
		 * @param path
		 * @param callback
		 * 
		 */		
		function getDataFile(path:String,callback:Function,clearType:int):void;
		function getDataSourceFile(path:String,callback:Function,clearType:int):void;
		function removeDataFile(path:String,callback:Function):void;
		function dataTimeClear(path:String,checkQuote:Boolean = false):void;
		/**
		 * 获取PNGPACKAGE数据文件
		 * @param path
		 * @param id
		 * @param layerType
		 * @param playerSex
		 * @param callback
		 * @param clearType
		 * 
		 */		
		function getPngPackageFile(path:String,id:int,layerType:String,playerSex:int,callback:Function,clearType:int):void;
		function removePngPackageFile(path:String,callback:Function):void;
//		function removePngPackageChangeScene(path:String,callback:Function):void;
//		function clearPngPackageFile(path:String):void;
		/**
		 * 清除场景上的资源数据
		 * 
		 */		
		function changeSceneClear():void;
		
		
//		/**
//		 * 记录类型资源,切场景时清除
//		 * @param path
//		 * @param id
//		 * @param layerType
//		 * @param sex
//		 * @param callback
//		 * 
//		 */		
//		function getPngRecordFile(path:String,id:int,layerType:String,sex:int,callback:Function):void;
//		function removePngRecordFile(path:String,callback:Function):void;
		
		
		
		/**********loader更新*******************************/
		function setTickManager(manager:ITickManager):void;
		function getPicFile(path:String,callback:Function,clearType:int,clearTime:int = 214783647,priority:int = 1):void;
		function removeAQuote(path:String,callback:Function):void;
		
		function getPackageFile(path:String,callback:Function,clearType:int,clearTime:int = 214783647,priority:int = 1):void;
		function removePackageAQuote(path:String):void;
		
		function getFanmFile(path:String,callback:Function,clearType:int,clearTime:int = 214783647,priority:int = 1):void;
		function removeFanmAQuote(path:String):void;
		
		
		
	}
}