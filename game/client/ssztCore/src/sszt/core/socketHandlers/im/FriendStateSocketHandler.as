package sszt.core.socketHandlers.im
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class FriendStateSocketHandler extends BaseSocketHandler
	{
		public function FriendStateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.FRIEND_ONLINE_STATE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			var online:Boolean = _data.readBoolean();
			var player:ImPlayerInfo = GlobalData.imPlayList.getFriendAndBlack(id);
			if(player)
			{
				if(player.isBlack) return;
				player.changeState(online);
			}
			var player1:ImPlayerInfo = GlobalData.imPlayList.getEnemy(id);
			if(player1 && player1 != player)
			{
				player1.changeState(online);
			}
			
			handComplete();
		}
	}
}