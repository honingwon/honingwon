package sszt.petpvp.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.data.petpvp.PetPVPLogItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.petpvp.PetPVPModule;
	
	public class PetPVPLogListUpdateSocketHandler extends BaseSocketHandler
	{
		public function PetPVPLogListUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_PVP_LOG_LIST;
		}
		
		override public function handlePackage():void
		{
			var i:int;
			
			var logInfo:Array = [];
			var logInfoLen:int = _data.readByte();
			var logItemInfo:PetPVPLogItemInfo;
			for(i = 0; i < logInfoLen; i++)
			{
				logItemInfo = new PetPVPLogItemInfo();
				logItemInfo.parseData(_data);
				logInfo.push(logItemInfo);
			}
			module.petPVPInfo.updateLogInfo(logInfo);			
			handComplete();
		}
		
		public function get module():PetPVPModule
		{
			return _handlerData as PetPVPModule;
		}
	}
}