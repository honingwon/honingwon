package sszt.interfaces.character
{
	import flash.display.BitmapData;
	
	import sszt.interfaces.dispose.IDispose;

	/**
	 * 
	 * @author Administrator
	 * 
	 */	
	public interface ILayer extends IDispose
	{
		function getSource():BitmapData;
		function load(callBack:Function,errorHandler:Function = null,autoDraw:Boolean = true):void;
		function getId():int;
	}
}
