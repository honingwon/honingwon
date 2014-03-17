package sszt.core.data.deploys.deployHandlers
{
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class GoNextTwoDeployHandler extends BaseDeployHandler
	{
		public function GoNextTwoDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.GO_NEXT_TWO;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,info.param1));
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,info.param2));
		}
	}
}