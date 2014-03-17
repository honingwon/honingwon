package sszt.core.data.deploys.deployHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	
	public class GuideTipDeployHandler extends BaseDeployHandler
	{
		public function GuideTipDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.GUIDE_TIP;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
			GlobalData.setGuideTipInfo(info);
		}
	}
}