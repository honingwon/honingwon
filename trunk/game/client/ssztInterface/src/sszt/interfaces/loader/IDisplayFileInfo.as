package sszt.interfaces.loader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public interface IDisplayFileInfo
	{
		function get data():BitmapData;
		function set data(value:BitmapData):void;
		function get path():String;
		function set path(value:String):void;
		function dispose():void;
	}
}