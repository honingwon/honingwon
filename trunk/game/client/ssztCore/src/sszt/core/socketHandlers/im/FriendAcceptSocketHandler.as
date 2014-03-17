package sszt.core.socketHandlers.im
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FriendAcceptSocketHandler extends BaseSocketHandler
	{
		public function FriendAcceptSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.FRIEND_ACCEPT;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function sendAccept(id:Number,flag:Boolean):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.FRIEND_ACCEPT);
			pkg.writeNumber(id);
			pkg.writeBoolean(flag);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}