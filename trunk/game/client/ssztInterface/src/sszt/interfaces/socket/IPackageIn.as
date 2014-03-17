package sszt.interfaces.socket
{
	import flash.utils.IDataInput;

	public interface IPackageIn extends IDataInput
	{
		function get code():int;
		/**
		 * 读取一个32位ID
		 * @return 
		 * 
		 */		
		function readId():String;
		/**
		 * 读取一个字符串
		 * @return 
		 * 
		 */		
		function readString():String;
		function get packageLen():int;
		function readDate():Date;
		function readDate64():Date;
		/**
		 * 解压协议
		 * 
		 */		
		function doUncompress():void;
		function get position():uint;
		function set position(value:uint):void;
		function get length():uint;
		function readNumber():Number;
		
	}
}