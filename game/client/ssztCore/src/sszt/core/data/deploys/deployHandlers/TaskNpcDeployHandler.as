package sszt.core.data.deploys.deployHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class TaskNpcDeployHandler extends BaseDeployHandler
	{
		public function TaskNpcDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.TASK_NPC;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
			if(GlobalData.copyEnterCountList.isInCopy || MapTemplateList.getIsInSpaMap() || MapTemplateList.getIsInVipMap()) 
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
			}
			else
			{
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.WALKTONPC,info.param1));
			}
		}
	}
}