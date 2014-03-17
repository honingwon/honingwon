package sszt.interfaces.socket
{
	public interface ISocketInfo
	{
		function get ip():String;
		function get port():int;
		
		function set ip(value:String):void;
		function set port(value:int):void;
	}
}