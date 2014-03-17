package sszt.interfaces.loader
{
	import flash.utils.ByteArray;

	public interface IZipFile
	{
		function get data():ByteArray;
		function get name():String;
	}
}