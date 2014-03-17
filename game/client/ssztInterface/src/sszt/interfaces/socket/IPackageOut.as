package sszt.interfaces.socket
{
	import flash.utils.IDataOutput;

	public interface IPackageOut extends IDataOutput
	{
		function get position():uint;
		function set position(value:uint):void;
		/**
		 * 设置包长度
		 * 
		 */		
		function setPackageLen():void;
		/**
		 * 写字符串
		 * @param str
		 * 
		 */		
		function writeString(str:String):void;
		function get code():int;
		/**
		 * 写日期
		 * @param date
		 * 
		 */		
		function writeDate(date:Date):void;
		function get length():uint; 
		function doCompress():void;
		function writeNumber(n:Number):void;
	}
}