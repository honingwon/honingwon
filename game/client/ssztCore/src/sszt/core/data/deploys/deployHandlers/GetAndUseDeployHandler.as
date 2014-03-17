/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-24 上午11:56:29 
 * 
 */ 
package sszt.core.data.deploys.deployHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.view.getAndUse.GetAndUsePanel;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;

	public class GetAndUseDeployHandler extends BaseDeployHandler
	{
		public function GetAndUseDeployHandler()
		{
		}
		
		override public function getType() : int
		{
			return DeployEventType.GET_AND_USE;
		} 
		
		override public function handler(info:DeployItemInfo) : void
		{
			var templateId:int;
			function checkTaskState() : void
			{
				GlobalData.taskCallback = null;
				if (info.param2 > 0)
				{
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_NPC_DIALOG, info.param2));
				}
			} 
			var taskInfo:TaskTemplateInfo = TaskTemplateList.getTaskTemplate(info.param1);
			if (taskInfo)
			{
				templateId = taskInfo.getLastState().getSelfAwardList()[0].templateId;
				GetAndUsePanel.getInstance().show(ItemTemplateList.getTemplate(templateId));
				GlobalData.taskCallback = checkTaskState;
			}
		}
	}
}