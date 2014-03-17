package sszt.core.proxy
{
	import flash.utils.ByteArray;
	
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.socket.SocketInfo;
	import sszt.interfaces.loader.ILoader;

	public class LoginProxy
	{
//		public static function login(nick:String,user:String,pass:String,site:String):void
//		{
//			var loader:ILoader = GlobalAPI.loaderAPI.createRequestLoader(GlobalAPI.pathManager.getLoginPath(),{user:user,pass:pass,nick:nick,site:site},loginComplete);
//			loader.loadSync();
//		}
//		
//		private static function loginComplete(loader:ILoader):void
//		{
//			var data:ByteArray = loader.getData() as ByteArray;
//			if(!data.readBoolean())
//			{
//				MAlert.show(data.readUTF());
//			}
//			else
//			{
//				LoginSocketProxy.loginSocket(new SocketInfo(GlobalData.tmpIp,8010));
//			}
//		}
	}
}