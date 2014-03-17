package sszt.interfaces.loader
{
	public interface IZipArchive
	{
		function getFileAt(index:uint):IZipFile;
		function get length():uint;
	}
}