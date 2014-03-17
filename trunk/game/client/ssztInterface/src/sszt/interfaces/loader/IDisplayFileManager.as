package sszt.interfaces.loader
{
	public interface IDisplayFileManager
	{
		function getFile(path:String,classPath:String,callback:Function,clearType:int):void;
		function removeQuote(path:String,callback:Function):void;
	}
}