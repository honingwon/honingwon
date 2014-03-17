package sszt.core.data.deploys.deployHandlers
{
	import flash.geom.Point;
	
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.GuideTip;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class TaskTransferDeployHandler extends BaseDeployHandler
	{
		private var taskList:Array = [511113,511213,511313,512009,512017];
		
		public function TaskTransferDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.TASK_TRANSFER;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
			
//			if(GlobalData.copyEnterCountList.isInCopy || MapTemplateList.getIsInSpaMap())
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
//			}
//			else if(GlobalData.taskInfo.getTransportTask() != null)
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.cannotUseTransfer"));
//			}
//			else
//			{
//				if(!GlobalData.selfPlayer.canfly())
//				{
//					MAlert.show(LanguageManager.getWord("ssztl.common.transferNotEnough"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
//				}
//				else
//				{
//					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER,{sceneId:info.param1,target:new Point(info.param2,info.param3)}));
//					var task:TaskItemInfo;
//					for(var i:int = 0; i < taskList.length; i++)
//					{
//						task = GlobalData.taskInfo.getTask(taskList[i]);
//						if(task && task.isExist && task.isFinish == false)
//						{
//							GuideTip.getInstance().hide();
//						}
//					}
//				}
//			}
		}
		
		private function closeHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
//				BuyPanel.getInstance().show(Vector.<int>([CategoryType.TRANSFER]),new ToStoreData(1));
				BuyPanel.getInstance().show([CategoryType.TRANSFER],new ToStoreData(ShopID.QUICK_BUY));
			}
		}
	}
}