package sszt.core.data.deploys.deployHandlers
{
	import flash.geom.Point;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.collect.CollectTemplateInfo;
	import sszt.core.data.collect.CollectTemplateList;
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class TaskCollectDeployHandler extends BaseDeployHandler
	{
		public function TaskCollectDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.TASK_COLLECT;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
			var collectInfo:CollectTemplateInfo = CollectTemplateList.getCollect(info.param1);
			if(GlobalData.copyEnterCountList.isInCopy || MapTemplateList.getIsInSpaMap() || MapTemplateList.getIsInVipMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
			}
			else if(collectInfo)
			{
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.WALK_TO_CENTERCOLLECT,collectInfo.id));
			}
		}
	}
}