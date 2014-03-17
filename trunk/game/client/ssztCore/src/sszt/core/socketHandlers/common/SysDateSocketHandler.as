package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class SysDateSocketHandler extends BaseSocketHandler
	{
		public function SysDateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SYS_DATE;
		}
		
		override public function handlePackage():void
		{
			GlobalData.systemDate.syncSystemDate(_data.readDate());
			GlobalData.selfPlayer.updateVipLastGetAwardDate();
			handComplete();
		}
	}
}