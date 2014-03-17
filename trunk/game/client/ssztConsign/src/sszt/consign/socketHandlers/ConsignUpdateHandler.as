package sszt.consign.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class ConsignUpdateHandler extends BaseSocketHandler
	{
		public function ConsignUpdateHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CONSIGN_UPDATE;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
	}
}