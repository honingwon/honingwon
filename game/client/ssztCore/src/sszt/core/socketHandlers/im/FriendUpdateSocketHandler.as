package sszt.core.socketHandlers.im
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.im.GroupType;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FriendUpdateSocketHandler extends BaseSocketHandler
	{
		public function FriendUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.FRIEND_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var player:ImPlayerInfo = new ImPlayerInfo();
			player.info.userId = _data.readNumber();
			player.friendState = _data.readInt();//1好友2黑名单
			player.setState();
			player.online = _data.readInt();
//			player.info.serverId = _data.readShort();
			player.info.nick = _data.readString();
			player.info.sex = _data.readBoolean();
			player.info.level = _data.readByte();
			player.career = _data.readByte();
			player.group = GroupType.FRIEND;
			player.amity = _data.readInt();
			GlobalData.imPlayList.updatePlayer(player);
			
			handComplete();
		}
		
		public static function sendAddFriend(serverId:int,nick:String,isFriend:Boolean):void
		{
			var type:int = 0;
			if(isFriend)
			{
				type = int(1<<15);
			}else
			{	
				type = int(1<<13);
			}
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.FRIEND_UPDATE);
//			pkg.writeShort(serverId);
			pkg.writeString(nick);
			pkg.writeInt(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}