package sszt.core.data.deploys
{
	import flash.utils.Dictionary;
	
	import sszt.core.data.deploys.deployHandlers.AutoTaskDeployHandler;
	import sszt.core.data.deploys.deployHandlers.EnterMultiPVPMapDeployHandler;
	import sszt.core.data.deploys.deployHandlers.GetAndUseDeployHandler;
	import sszt.core.data.deploys.deployHandlers.GoNextTwoDeployHandler;
	import sszt.core.data.deploys.deployHandlers.GuideTipDeployHandler;
	import sszt.core.data.deploys.deployHandlers.ItemTipDeployHandler;
	import sszt.core.data.deploys.deployHandlers.LeadDeployHandler;
	import sszt.core.data.deploys.deployHandlers.LinkDeployHandler;
	import sszt.core.data.deploys.deployHandlers.ModuleEventDeployHandler;
	import sszt.core.data.deploys.deployHandlers.PetPVPStartChallengingDeployHandler;
	import sszt.core.data.deploys.deployHandlers.PlayerMenuDeployHandler;
	import sszt.core.data.deploys.deployHandlers.PopupDeployHandler;
	import sszt.core.data.deploys.deployHandlers.QuickBuyDeployHandler;
	import sszt.core.data.deploys.deployHandlers.ShowMountDeployHandler;
	import sszt.core.data.deploys.deployHandlers.ShowPetDeployHandler;
	import sszt.core.data.deploys.deployHandlers.SkillIconPlayDeployHandler;
	import sszt.core.data.deploys.deployHandlers.TaskCollectDeployHandler;
	import sszt.core.data.deploys.deployHandlers.TaskDeployHandler;
	import sszt.core.data.deploys.deployHandlers.TaskMonsterDeployHandler;
	import sszt.core.data.deploys.deployHandlers.TaskNpcDeployHandler;
	import sszt.core.data.deploys.deployHandlers.TaskTipDeployHandler;
	import sszt.core.data.deploys.deployHandlers.TaskTransferDeployHandler;
	import sszt.core.data.deploys.deployHandlers.TransferTaskDeployHandler;
	import sszt.core.data.deploys.deployHandlers.WalkDeployHandler;

	public class DeployEventManager
	{
		private static var _deployList:Dictionary = new Dictionary();
		
		public static function initDeploy():void
		{
			addDeploy(new GoNextTwoDeployHandler());
			addDeploy(new GetAndUseDeployHandler());
			addDeploy(new GuideTipDeployHandler());
			addDeploy(new ItemTipDeployHandler());
			addDeploy(new ShowPetDeployHandler());
			addDeploy(new ShowMountDeployHandler());
			addDeploy(new LeadDeployHandler());
			addDeploy(new LinkDeployHandler());
			addDeploy(new ModuleEventDeployHandler());
			addDeploy(new PlayerMenuDeployHandler());
			addDeploy(new PopupDeployHandler());
			addDeploy(new TaskCollectDeployHandler());
			addDeploy(new TaskDeployHandler());
			addDeploy(new TaskMonsterDeployHandler());
			addDeploy(new TaskNpcDeployHandler());
			addDeploy(new TaskTipDeployHandler());
			addDeploy(new TaskTransferDeployHandler());
			addDeploy(new WalkDeployHandler());
			addDeploy(new SkillIconPlayDeployHandler());
			addDeploy(new QuickBuyDeployHandler());
			addDeploy(new AutoTaskDeployHandler());
			addDeploy(new TransferTaskDeployHandler());
			addDeploy(new EnterMultiPVPMapDeployHandler());
			addDeploy(new PetPVPStartChallengingDeployHandler());
		}
		
		public static function addDeploy(deploy:IDeployHandler):void
		{
			_deployList[deploy.getType()] = deploy;
		}
		
		public static function handle(info:DeployItemInfo):void
		{
			var deploy:IDeployHandler = _deployList[info.type];
			if(deploy)
			{
				deploy.handler(info);
			}
		}
	}
}