package sszt.core.socketHandlers.im
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	
	public class FriendAmityUpdateSocketHandler extends BaseSocketHandler
	{
		public function FriendAmityUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.FRIEND_AMITY_UPDATE;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			var oldAmity:int = 0;
			var player:ImPlayerInfo = new ImPlayerInfo();
			player.info.userId = _data.readNumber();
			player = GlobalData.imPlayList.getFriend(player.info.userId);
			oldAmity = player.amity;
			player.amity = _data.readInt();
			GlobalData.imPlayList.updatePlayer(player);
			QuickTips.show(LanguageManager.getWord("ssztl.friends.addFriendShipNum",(player.amity - oldAmity)));
			handComplete();
		}
	}
}