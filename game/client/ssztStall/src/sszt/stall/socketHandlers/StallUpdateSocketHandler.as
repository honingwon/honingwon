package sszt.stall.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.stall.StallInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.stall.StallModule;
	
	public class StallUpdateSocketHandler extends BaseSocketHandler
	{
		public function StallUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.STALL_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var tmpLength:int = _data.readInt();
			var tmpTemplateId:int;
			var tmpRemainCount:int;
			for(var i:int = 0;i<tmpLength;i++)
			{
				tmpTemplateId = _data.readInt();
				tmpRemainCount = _data.readInt();
				GlobalData.stallInfo.updateBegBuyVector(tmpTemplateId,tmpRemainCount);
			}
			
			handComplete();
		}
		
		private function get stallModule():StallModule
		{
			return _handlerData as StallModule;
		}
	}
}