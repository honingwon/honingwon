package sszt.core.socketHandlers.task
{
	import flash.utils.getTimer;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.deploys.DeployEventManager;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.task.TaskConditionType;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskStateType;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.TaskModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class TaskUpdateSocketHandler extends BaseSocketHandler
	{
		/**
		 * 更新“所有任务”列表
		 */
		public function TaskUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TASK_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readInt();
			var npcId:int;
			var isSend:Boolean = false;
			for(var i:int = 0; i < len; i++)
			{
				var id:int = _data.readInt();
				var item:TaskItemInfo = GlobalData.taskInfo.getTask(id);
				var isadd:Boolean = false;
				//如果任务未添加到"全部任务"列表
				if(!item)
				{
					item = new TaskItemInfo();
					item.taskId = id;
					isadd = true;
				}
				item.isNewFinish = _data.readBoolean();
				var isExist:Boolean = _data.readBoolean();
				item.isFinish = _data.readBoolean();
				item.finishDate = _data.readDate();
				item.state = _data.readInt();
				item.requireCount = _data.readString().split(",");
				item.dayLeftCount = _data.readInt();
				item.isNew = _data.readBoolean();
				var isEntrusting:Boolean = _data.readBoolean();
				item.entrustEndTime = _data.readDate();
				item.entrustCount = _data.readByte();
				item.isEntrusting = isEntrusting;
				
				if(item.isNew)
					npcId = TaskTemplateList.getTaskTemplate(item.taskId).npc;
				else if(item.isNewFinish)
					npcId = TaskTemplateList.getTaskTemplate(item.taskId).getLastState().npc;
				
				if(isadd)
				{
					GlobalData.taskInfo.addTask(item,isExist ? 1 : 0);
				}
				else
				{
					if(!item.isFinish)
					{
						var list:Array = item.getCurrentState().notFinishDeploys;
						for(var j:int = 0; j < list.length; j++)
						{
							DeployEventManager.handle(list[j]);
						}
					}
					item.update();
				}
				item.isExist = isExist;
				if(item.isExist == false)
				{
					GlobalData.taskInfo.removeTask(item.taskId);
				}
				if(TaskConditionType.getIsCollectTask(item.getCurrentState().condition) && item.isExist && item.isFinish == false)
				{
					GlobalData.taskInfo.addToCollect(item);
				}
				else
				{
					if(GlobalData.taskInfo.collectTaskList.indexOf(item) != -1)GlobalData.taskInfo.removeFromCollect(item);
				}
				if(id == CategoryType.FIRST_CHARGE_TASK && item.isNewFinish)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.core.getSuccess"));
				}
				if(id == CategoryType.FIRST_ITEM_UPLEVEL && item.isExist && item.isFinish == false && item.taskState != TaskStateType.FINISHNOTSUBMIT)
				{
					var count:int = GlobalData.bagInfo.getItemCountByItemplateId(211005);
					var count1:int = GlobalData.bagInfo.getItemCountByItemplateId(212005 );
					var count2:int = GlobalData.bagInfo.getItemCountByItemplateId(213005);
					if(count || count1 || count2)
					{
						isSend = true;
					}
				}
			}
			if(isSend)
			{
				TaskClientSocketHandler.send( CategoryType.FIRST_ITEM_UPLEVEL,0);
			}
			GlobalData.taskInfo.setFirstData();
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CHECKSTATE,npcId));
			
			handComplete();
		}
	}
}