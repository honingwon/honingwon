package sszt.core.socketHandlers.enthral
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class EnthralControlSocketHandler extends BaseSocketHandler
	{
		public function EnthralControlSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ENTHRAL_CONTROL;
		}
		
		override public function handlePackage():void
		{
			GlobalData.enthralType = _data.readByte();
			
			handComplete();
		}
	}
}