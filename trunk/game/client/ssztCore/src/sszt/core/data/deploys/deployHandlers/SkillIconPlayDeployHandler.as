package sszt.core.data.deploys.deployHandlers
{
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	
	public class SkillIconPlayDeployHandler extends BaseDeployHandler
	{
		public function SkillIconPlayDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.SKILL_ICON;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
//			GlobalData.skillIcon.show();
		}
	}
}