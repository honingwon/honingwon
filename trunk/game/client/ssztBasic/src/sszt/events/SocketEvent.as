package sszt.events
{
	import flash.events.Event;
	
	public class SocketEvent extends Event
	{
		/**
		 * socket断开
		 */		
		public static const SOCKET_CLOSE:String = "socketClose";
		/**
		 * 连接失败
		 */		
		public static const CONNECT_FAIL:String = "connectFail";
		
		public static const SECURITY_ERROR:String = "securityError";
		/**
		 * 收到数据包
		 */		
		public static const SOCKET_DATA:String = "socketData";
		/**
		 * 连接成功
		 */		
		public static const CONNECT_SUCCESS:String = "connectSuccess";
		
		public var data:Object;
		
		public function SocketEvent(type:String,data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}