package sszt.interfaces.loader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public interface IPackageFileData
	{
		function getBD():BitmapData;
		function getX():Number;
		function getY():Number;
		function dispose():void;
	}
}