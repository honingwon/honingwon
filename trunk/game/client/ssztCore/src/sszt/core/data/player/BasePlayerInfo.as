package sszt.core.data.player
{
	import flash.events.EventDispatcher;
	
	public class BasePlayerInfo extends EventDispatcher
	{
		public var userId:Number;
//		public var nick:String;
		private var _nick:String;
		public var sex:Boolean;
		public var level:int;
			
		/**
		 * 服务器ID
		 * (固定不变)
		 */		
		public var serverId:int;
		/**
		 * 当前服务器ID
		 */		
		public var currentServerId:int;
		
		public function BasePlayerInfo()
		{
		}
		
		public function set nick(value:String):void
		{
			_nick = value;
		}
		public function get nick():String
		{
			return _nick;
		}
		public function getShowNick():String
		{
			return   nick;
		}
	}
}