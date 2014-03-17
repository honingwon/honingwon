package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class PlayerSelfLifeexpSocketHandler extends BaseSocketHandler
	{
		public function PlayerSelfLifeexpSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_SELF_LIFEEXP;
		}
		
		override public function handlePackage():void
		{
//			GlobalData.selfPlayer.lifeExperiences = _data.readInt();
			GlobalData.selfPlayer.updateLifeExp(_data.readUnsignedInt());
			handComplete();
		}
	}
}