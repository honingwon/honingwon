package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	
	public class PlayerDynamicInfoUpdateSocketHandler extends BaseSocketHandler
	{
		public function PlayerDynamicInfoUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_DYNAMIC_INFO;
		}
		
		override public function handlePackage():void
		{
			GlobalData.selfPlayer.setFreePropertys(PackageUtil.parseProperty(_data.readString()));
			handComplete();
		}
	}
}