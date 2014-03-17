package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PlayerNoticeUtil;
	import sszt.scene.components.ActivityIcon.FirstPayView;

	public class PlayerActivityFirstPayHandler extends BaseSocketHandler
	{
		public function PlayerActivityFirstPayHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var flag:int = _data.readByte();
			if(GlobalData.selfPlayer.level >= 8) 
			{
//				FirstPayView.getInstance().show();
			}
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_ACTIVE_FIRST_PAY;
		}
	}
}