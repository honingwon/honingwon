package sszt.core.proxy
{
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.socket.SocketInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.login.GuestLoginSocketHandler;
	import sszt.core.socketHandlers.login.LoginSocketHandler;

	public class LoginSocketProxy
	{
		public static function loginSocket(info:SocketInfo):void
		{
			GlobalAPI.waitingLoading.showLogin(LanguageManager.getWord(""));
			GlobalAPI.socketManager.setSocket(info,successHandler,errorHandler);
		}
		
		private static function successHandler():void
		{
			GlobalAPI.waitingLoading.hide();
			if(GlobalData.guest)
				GuestLoginSocketHandler.sendLogin(GlobalData.tmpId,GlobalData.tmpUserName);
			else
				LoginSocketHandler.sendLogin();
//			AccountPasswordSocketHandler.sendAccountPassword();
		}
		private static function errorHandler():void
		{
			GlobalAPI.waitingLoading.hide();
			trace("LoginSocketProxy:error");
		}
	}
}