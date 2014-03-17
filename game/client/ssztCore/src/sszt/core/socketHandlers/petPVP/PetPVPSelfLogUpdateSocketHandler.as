package sszt.core.socketHandlers.petPVP
{
	import sszt.core.data.ProtocolType;
	import sszt.core.data.petpvp.PetPVPLogItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.PetPVPModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class PetPVPSelfLogUpdateSocketHandler extends BaseSocketHandler
	{
		public function PetPVPSelfLogUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_PVP_SELF_LOG;
		}
		
		override public function handlePackage():void
		{
			ModuleEventDispatcher.dispatchPetPVPEvent(new PetPVPModuleEvent(PetPVPModuleEvent.PET_PVP_SELF_LOG));
			
			handComplete();
		}
	}
}