package sszt.core.data.deploys.deployHandlers
{
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.petpvp.PetPVPLogItemInfo;
	import sszt.events.PetPVPModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class PetPVPStartChallengingDeployHandler extends BaseDeployHandler
	{
		public function PetPVPStartChallengingDeployHandler()
		{
			super();
		}
		
		override public function getType() : int
		{
			return DeployEventType.PET_PVP_CHALLENGE;
		}
		
		override public function handler(info:DeployItemInfo) : void
		{
			var petPVPLogItemInfo:PetPVPLogItemInfo = new PetPVPLogItemInfo();
			petPVPLogItemInfo.petId = info.param1;
			petPVPLogItemInfo.opponentPetId = info.param2;
			ModuleEventDispatcher.dispatchPetPVPEvent(new PetPVPModuleEvent(PetPVPModuleEvent.START_CHALLENGING,petPVPLogItemInfo));
		}
	}
}