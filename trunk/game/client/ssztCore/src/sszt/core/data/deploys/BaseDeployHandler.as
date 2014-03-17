package sszt.core.data.deploys
{
	public class BaseDeployHandler implements IDeployHandler
	{
		public function BaseDeployHandler()
		{
		}
		
		public function getType():int
		{
			return 0;
		}
		
		public function handler(info:DeployItemInfo):void
		{
		}
	}
}