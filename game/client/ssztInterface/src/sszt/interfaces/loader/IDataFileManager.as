package sszt.interfaces.loader
{
	public interface IDataFileManager
	{
		function getDataSourceFile(path:String,callback:Function,clearType:int):void;
		function removeQuote(path:String,callback:Function):void
	}
}