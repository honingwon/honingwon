package sszt.welfare.socket
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class LoginRewardLoginDaySocketHandler extends BaseSocketHandler
	{
		public function LoginRewardLoginDaySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.WELFARE_LOGIN_DAY;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.WELFARE_LOGIN_DAY);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}