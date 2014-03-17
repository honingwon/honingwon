package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class UpdateSelfReduceExpSocketHandler extends BaseSocketHandler
	{
		public function UpdateSelfReduceExpSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.REDUCE_EXP;
		}
		
		override public function handlePackage():void
		{
			GlobalData.selfPlayer.updateExp(_data.readNumber());
			handComplete();
		}
	}
}