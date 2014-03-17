package sszt.core.data.socket
{
	import sszt.interfaces.socket.ISocketInfo;

	public class SocketInfo implements ISocketInfo
	{
		private var _ip:String;
		private var _port:int;
		
		public function SocketInfo(ip:String,port:int)
		{
			_ip = ip;
			_port = port;
		}

		public function get ip():String
		{
			return _ip;
		}

		public function set ip(value:String):void
		{
			_ip = value;
		}

		public function get port():int
		{
			return _port;
		}

		public function set port(value:int):void
		{
			_port = value;
		}

	}
}