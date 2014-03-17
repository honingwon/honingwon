package sszt.core.socketHandlers.im
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.quickIcon.iconInfo.FriendIconInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FriendResponseSocketHandler extends BaseSocketHandler
	{
		public function FriendResponseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.FRIEND_RESPONSE;
		}
		
		override public function handlePackage():void
		{
			var toId:Number = _data.readNumber();
//			var serverId:int = _data.readShort();
			var userId:Number = _data.readNumber();
			var nick:String = _data.readString();
			
			GlobalData.quickIconInfo.addToFriendList(new FriendIconInfo(0,userId,nick));
			handComplete();
		}
		
		public static function sendAddRespose():void
		{

		}
	}
}