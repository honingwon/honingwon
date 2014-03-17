package sszt.core.socketHandlers.login
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	
	public class GuestLoginSocketHandler extends BaseSocketHandler
	{
		public function GuestLoginSocketHandler(handlerData:Object=null)
		{
			MonsterDebugger;
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ACCOUNT_GUEST_LOGIN;
		}
		
		override public function handlePackage():void
		{
		}
		
		public static function sendLogin(userId:Number,user:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ACCOUNT_GUEST_LOGIN);
			pkg.writeNumber(userId);
			pkg.writeString(user);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}