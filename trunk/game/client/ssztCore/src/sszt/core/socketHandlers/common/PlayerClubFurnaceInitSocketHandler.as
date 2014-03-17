package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class PlayerClubFurnaceInitSocketHandler extends BaseSocketHandler
	{
		public function PlayerClubFurnaceInitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_CLUB_FURNACE_INIT;
		}
		
		override public function handlePackage():void
		{
			GlobalData.selfPlayer.clubFurnaceLevel = _data.readInt();
			GlobalData.selfPlayer.furnaceNeedExploit = _data.readInt();
			GlobalData.selfPlayer.clubRich = _data.readInt();
		}
	}
}