package sszt.core.data.deploys.deployHandlers
{
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.module.changeInfos.ToMountsData;
	import sszt.core.utils.SetModuleUtils;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class ShowMountDeployHandler extends BaseDeployHandler
	{
		public function ShowMountDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.SHOW_MOUNT;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
			SetModuleUtils.addMounts(
				new ToMountsData(0, 2, info.param2, info.param1)
			);
		}
	}
}