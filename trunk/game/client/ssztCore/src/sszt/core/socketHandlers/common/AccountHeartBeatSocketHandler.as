package sszt.core.socketHandlers.common
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.interfaces.tick.ITick;
	
	public class AccountHeartBeatSocketHandler extends BaseSocketHandler
	{
		public function AccountHeartBeatSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
			var t:Timer = new Timer(30000);
			t.addEventListener(TimerEvent.TIMER,timerHandler);
			t.start();
		}
		
		override public function getCode():int
		{
			return ProtocolType.ACCOUNT_HEARTBEAT;
		}
		
		private function timerHandler(evt:TimerEvent):void
		{
			send();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ACCOUNT_HEARTBEAT);
			pkg.writeBoolean(true);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}