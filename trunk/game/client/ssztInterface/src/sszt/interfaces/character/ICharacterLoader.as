package sszt.interfaces.character
{
	import flash.display.BitmapData;
	
	import sszt.interfaces.dispose.IDispose;
	import sszt.interfaces.loader.IDataFileInfo;

	public interface ICharacterLoader extends IDispose
	{
		function load(callBack:Function = null):void;
//		function getContent():Vector.<IDataFileInfo>;
		function getContent():Array;
		function clearContent():void;
		function get info():ICharacterInfo;
	}
}