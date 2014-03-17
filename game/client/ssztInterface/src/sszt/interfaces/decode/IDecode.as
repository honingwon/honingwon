package sszt.interfaces.decode
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	public interface IDecode
	{
		function decode(data:ByteArray,type:int):ByteArray;
	}
}