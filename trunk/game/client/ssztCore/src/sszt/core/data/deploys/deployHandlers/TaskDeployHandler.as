package sszt.core.data.deploys.deployHandlers
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.task.TaskConditionType;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.task.StartClubTransportSocketHandler;
	import sszt.core.socketHandlers.task.TaskAcceptSocketHandler;
	import sszt.core.socketHandlers.task.TaskSubmitSocketHandler;
	import sszt.core.socketHandlers.task.TaskTransportAddSocketHandler;
	import sszt.core.utils.StatUtils;
	import sszt.core.view.getAndUse.GetAndUsePanel;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.GuideTip;
	import sszt.events.SceneModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class TaskDeployHandler extends BaseDeployHandler
	{
		private var _timeoutIndex:int = -1;
		
		public function TaskDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.TASK;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
			switch(info.param1)
			{
				case 1:
					if(info.param2 != 0)
					{
						var taskId:int = info.param2;
						var task:TaskTemplateInfo = TaskTemplateList.getTaskTemplate(taskId);
						if(task.needItem != 0 && GlobalData.bagInfo.getItemCountById(task.needItem) == 0)
						{
							if(task.states[0].condition == TaskConditionType.TRANSPORT)
							{
								MAlert.show(LanguageManager.getWord("ssztl.common.transportLingNotEnough"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,buyCloseHandler);
							}
							else
							{
								QuickTips.show(LanguageManager.getWord("ssztl.common.itemNotEnough"));
							}
						}
						else if(task.needCopper != 0 && GlobalData.selfPlayer.userMoney.copper < task.needCopper)
							QuickTips.show(LanguageManager.getWord("ssztl.common.noCopperForTask"));
						else if(task.states[0].condition == TaskConditionType.TRANSPORT)
						{
							if(GlobalData.taskInfo.getTransportTask() != null)
							{
								QuickTips.show(LanguageManager.getWord("ssztl.common.inTransport"));
							}
							else if(GlobalData.selfPlayer.level < task.minLevel)
							{
								QuickTips.show(LanguageManager.getWord("ssztl.common.transportNeedLevel"));
							}
							else if(getCount() >= task.repeatCount)
							{
								QuickTips.show(LanguageManager.getWord("ssztl.common.transportMostTimesCurDay"));
							}
							else if(GlobalData.taskInfo.taskStateChecker.checkCanAccept(task))
							{
								MAlert.show(LanguageManager.getWord("ssztl.common.autoChangeFightModel"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,transportCloseHandler);
							}
						}
						else if(GlobalData.taskInfo.taskStateChecker.checkCanAccept(task))
							TaskAcceptSocketHandler.sendAccept(taskId);
						
						function transportCloseHandler(e:CloseEvent):void
						{
							if(e.detail == MAlert.OK)
							{
								TaskAcceptSocketHandler.sendAccept(taskId);
							}
						}
						
						function getCount():int
						{
							var list:Array = GlobalData.taskInfo.getAllTransportTask();
							var count:int = 0;
							for(var i:int = 0; i < list.length; i++)
							{
								count += (list[i].getTemplate().repeatCount - list[i].dayLeftCount);
							}
							return count;
						}
					}
					break;
				case 2:
					var iteminfo:TaskItemInfo = GlobalData.taskInfo.getTransportTask();
					if(iteminfo == null)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.noAcceptTransport"));
					}
					else
					{
						TaskSubmitSocketHandler.sendSubmit(iteminfo.taskId);
					}
					break;
				case 3:
//					var iteminfo1:TaskItemInfo = GlobalData.taskInfo.getTransportTask();
//					if(iteminfo1 == null)
//					{
//						QuickTips.show("你还没有开始运镖任务，不能加货！");
//					}
//					else if(iteminfo1.state == iteminfo1.getTemplate().states.length - 1)
//					{
//						QuickTips.show("镖车已为最高奖励，不能加货。");
//					}
//					else if(GlobalData.bagInfo.getItemCountById(CategoryType.TRANSPORT_ADD) == 0)
//					{
//						QuickTips.show("背包中没有加货令，不能加货。");
//						MAlert.show("加货令不足，需要立即购买吗？",LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,buyCloseHandler1);
//					}
//					else
//					{
//						TaskTransportAddSocketHandler.send(iteminfo1.taskId);
//						_timeoutIndex = setTimeout(delayFunction,200);
//						
//						function delayFunction():void
//						{
//							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_NPC_DIALOG,info.param4));
//							if(_timeoutIndex != -1)
//							{
//								clearTimeout(_timeoutIndex);
//							}
//						}
//					}
					break;
				case 4:
					if(ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty))
					{
						if(GlobalData.clubTransportTime > 0)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.common.clubTransportOpenToday"));
						}
						else
						{
							MAlert.show(LanguageManager.getWord("ssztl.common.sureOpenClubTransport"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
						}
					}
					else
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.leaderCanOpenClubTransport"));
					}
					break;
				case 5:
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.SHOW_FOLLOWPANEL,info.param2));
					break;
				case 6:
					GlobalData.setGuideTipInfo(null);
					GuideTip.getInstance().hide();
					break;
				case 7:
					var taskInfo:TaskTemplateInfo = TaskTemplateList.getTaskTemplate(info.param2);
					if(taskInfo)
					{
//						var templateId:int = taskInfo.getLastState().getSelfAwardList()[0].templateId;
//						GetAndUsePanel.getInstance().show(ItemTemplateList.getTemplate(templateId));
					}
					break;
				case 8:
					StatUtils.doStat(info.param2);
					break;
				case 9:
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.GET_CLUB_WAR_REWARDS));
					break;
			}
		}
		
		private function closeHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				StartClubTransportSocketHandler.send();
			}
		}
		
		private function buyCloseHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				BuyPanel.getInstance().show(CategoryType.TRANSPORT_BRAND,new ToStoreData(ShopID.QUICK_BUY));
			}
		}
		
		private function buyCloseHandler1(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				BuyPanel.getInstance().show([CategoryType.TRANSPORT_ADD],new ToStoreData(ShopID.QUICK_BUY));
			}
		}
	}
}