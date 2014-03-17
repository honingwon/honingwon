package sszt.interfaces.loader
{
	public interface IWaitLoading
	{
		function showLoading(descript:String = "",cancelHandler:Function = null):void;
		function showModuleLoading(moduleId:int,cancelHandler:Function = null):void;
		function showLogin(descript:String = "",cancelHandler:Function = null):void;
		function hide():void;
		function setProgress(bytesLoaded:int,bytesTotal:int):void;
	}
}