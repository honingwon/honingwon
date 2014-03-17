package sszt.core.data.deploys.deployHandlers
{
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.utils.JSUtils;
	
	public class LinkDeployHandler extends BaseDeployHandler
	{
		public function LinkDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.LINK;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
			JSUtils.gotoPage(String(info.param));
		}
	}
}