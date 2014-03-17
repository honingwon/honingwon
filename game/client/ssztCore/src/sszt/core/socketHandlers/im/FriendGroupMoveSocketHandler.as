package sszt.core.socketHandlers.im
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FriendGroupMoveSocketHandler extends BaseSocketHandler
	{
		public function FriendGroupMoveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.FRIEND_GROUP_MOVE;
		}
		
		override public function handlePackage():void
		{
			var fromId:int = _data.readNumber();
			var toId:int = _data.readNumber();
			var userId:Number = _data.readNumber();
			GlobalData.imPlayList.move(fromId,toId,userId);
			
			handComplete();
		}
		
		public static function  sendMove(fromGId:Number,toGId:Number,userId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.FRIEND_GROUP_MOVE);
			pkg.writeNumber(fromGId);
			pkg.writeNumber(toGId);
			pkg.writeNumber(userId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}