package sszt.core.data.deploys.deployHandlers
{
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	
	public class LeadDeployHandler extends BaseDeployHandler
	{
		public function LeadDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.LEAD;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
			
		}
	}
}