package sszt.core.data.deploys.deployHandlers
{
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.module.changeInfos.ToPetData;
	import sszt.core.utils.SetModuleUtils;
	
	public class ShowPetDeployHandler extends BaseDeployHandler
	{
		public function ShowPetDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.SHOW_PET;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
			SetModuleUtils.addPet(
				new ToPetData(0, 2, info.param2, info.param1)
			);
		}
	}
}