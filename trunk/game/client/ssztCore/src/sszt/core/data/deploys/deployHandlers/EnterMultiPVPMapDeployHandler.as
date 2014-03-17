package sszt.core.data.deploys.deployHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActiveStarTimeData;
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.pvp.ActiveResourceWarEnterSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	
	public class EnterMultiPVPMapDeployHandler extends BaseDeployHandler
	{
		public function EnterMultiPVPMapDeployHandler()
		{
			super();
		}
		
		override public function getType() : int
		{
			return DeployEventType.ENTER_MULTI_PVP_MAP;
		}
		
		override public function handler(info:DeployItemInfo) : void
		{
			var available:Boolean = false;
			var activityInfo:ActiveStarTimeData = GlobalData.activeStartInfo.activeTimeInfo['1008']
			if(activityInfo && activityInfo.state == 1)
			{
				available = true;
			}
			if(!available)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.activity.activityUnavailable'));
				return;
			}
			if(GlobalData.selfPlayer.level < 35)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.scene.unEnterLevelNotMatch'));
				return;
			}
			var now:int = GlobalData.systemDate.getSystemDate().getTime()/1000;
			var quitTime:int =GlobalData.selfPlayer.resourceWarQuitTime;
			if(now - quitTime <= 2*60)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.resourceWar.enterTimeLimitAlert'));
				return;
			}
			ActiveResourceWarEnterSocketHandler.send();
		}
	}
}