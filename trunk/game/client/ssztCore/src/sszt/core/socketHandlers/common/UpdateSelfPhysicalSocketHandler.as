package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class UpdateSelfPhysicalSocketHandler extends BaseSocketHandler
	{
		public function UpdateSelfPhysicalSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.UPDATE_SELF_PHYSICAL;
		}
		
		override public function handlePackage():void
		{
//			GlobalData.selfPlayer.updateHPMP(_data.readInt(),_data.readInt());
			GlobalData.selfPlayer.updatePhysical(_data.readInt());
			
			handComplete();
		}
	}
}