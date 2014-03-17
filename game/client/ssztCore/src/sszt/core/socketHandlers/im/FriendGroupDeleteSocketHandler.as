package sszt.core.socketHandlers.im
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FriendGroupDeleteSocketHandler extends BaseSocketHandler
	{
		public function FriendGroupDeleteSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.FRIEND_GROUP_DELETE;
		}
		
		override public function handlePackage():void
		{
			var id:int = _data.readNumber();
			GlobalData.imPlayList.removeGroup(id);
			
			handComplete();
		}
		
		public static function sendDelete(id:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.FRIEND_GROUP_DELETE);
			pkg.writeNumber(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}