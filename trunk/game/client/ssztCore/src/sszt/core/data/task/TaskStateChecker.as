package sszt.core.data.task
{
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalData;
	import sszt.core.utils.DateUtil;

	public class TaskStateChecker
	{
		public function TaskStateChecker()
		{
		}
		
		public function checkTaskState(task:TaskItemInfo):int
		{
			if(task == null)
			{
				var template:TaskTemplateInfo = task.getTemplate();
				if(template.getCanAccept())return TaskStateType.CANACCEPT;
				else if(template.timeLimit && DateUtil.getTimeBetween(template.endDate,GlobalData.systemDate.getSystemDate()) > 0)return TaskStateType.OUTOFDATE;
				else return TaskStateType.CANNOTACCEPT;
			}
			else
			{
				if(task.isFinish)return TaskStateType.SUBMITED;
				else if(task.getTemplate().timeLimit && DateUtil.getTimeBetween(task.getTemplate().endDate,GlobalData.systemDate.getSystemDate()) > 0)return TaskStateType.OUTOFDATE;
//				else if(task.state != task.getTemplate().states.length - 1)return TaskStateType.ACCEPTNOTFINISH;
				else
				{
					if(checkStateComplete(task.getTemplate().states[task.getTemplate().states.length - 1],task.requireCount))
					{
						return TaskStateType.FINISHNOTSUBMIT;
					}
					return TaskStateType.ACCEPTNOTFINISH;
				}
			}
			return TaskStateType.ERROR;
		}
		
//		public function checkStateComplete(state:TaskStateTemplateInfo,requiteCount:Vector.<int>):Boolean
		public function checkStateComplete(state:TaskStateTemplateInfo,requiteCount:Array):Boolean
		{
			switch(state.condition)
			{
				case TaskConditionType.COLLECT_MONSTER:
				case TaskConditionType.COLLECT_NPC:
				case TaskConditionType.COPY_COLLECT:
					for(var i:int = 0; i < state.data.length; i++)
					{
						var id:int = state.data[i][0];
						var count:int = state.data[i][1];
						if(GlobalData.bagInfo.getItemCountById(id) < count)return false;
					}
					return true;
				case TaskConditionType.CLIENT_CONTROL:
				case TaskConditionType.JOIN_CLUB:
					return requiteCount[0] == 0;
				case TaskConditionType.KILLMONSTER:
				case TaskConditionType.DROP_MONSTER:
				case TaskConditionType.COLLECT_ITEM:
				case TaskConditionType.COPY_KILLMONSTER:
				case TaskConditionType.COPY_COLLECT_ITEM:
				case TaskConditionType.BUY_UNBIND:
				case TaskConditionType.FILL:
				case TaskConditionType.HONGMING_COLLECT:
				case TaskConditionType.HONGMING_KILLMONSTER:
					for(var j:int = 0; j < state.data.length; j++)
					{
						if(requiteCount[j] > 0)return false
					}
					return true;
				case TaskConditionType.DIALOG:
				case TaskConditionType.TRANSPORT:
				case TaskConditionType.SHENMOLING:
				case TaskConditionType.COPY_DIALOG:
					return true;
			}
			return false;
		}
		
//		public function getCanAccept():Vector.<TaskTemplateInfo>
		public function getCanAccept():Array
		{
//			var result:Vector.<TaskTemplateInfo> = new Vector.<TaskTemplateInfo>();
			var result:Array = [];
			var list:Dictionary = TaskTemplateList.getTemplateList();
			for each(var i:TaskTemplateInfo in list)
			{
				if(checkCanAccept(i))
					result.push(i);
			}
			return result;
		}
		
		/**
		 * 任务追踪界面可视任务
		 */		
		public function getTaskVisible():Array
		{
			var types:Array = TaskType.getTaskTypes();
			var result:Array = new Array(types.length);
			var list:Dictionary = TaskTemplateList.getTemplateList();
			var index:int;
			for each(var i:TaskTemplateInfo in list)
			{
				if(TaskTemplateList.showInFollow(i))
				{
					if(checkCanAccept(i))//任务可接
					{
						index = types.indexOf(i.type);
						if(result[index] == null)
						{
							result[index] = new TaskAccordionData(i.type);
						}
						result[index].data.push(i);
					}
				}
			}
			for each(var j:TaskTemplateInfo in list)
			{
				index = types.indexOf(j.type);
				if(checkCanShow(j))//任务不可接但可以显示在任务追踪
				{
					if(result[index] == null)
					{
						result[index] = new TaskAccordionData(j.type);
					}
					if(result[index].data.indexOf(j) == -1)result[index].data.push(j);
				}
			}
			for each(var type:uint in types)
			{
				var index1:int = types.indexOf(type);
				if(result[index1] == null)
				{
					result[index1] = new TaskAccordionData(type);
				}
			}
			return result;
		}
		
		/**
		 * 任务追踪界面可接主线任务
		 */		
		public function getMainLineTaskVisible():TaskTemplateInfo
		{
			var list:Dictionary = TaskTemplateList.getTemplateList();
			var ret:TaskTemplateInfo;
			for each(var i:TaskTemplateInfo in list)
			{
				if(i.type == TaskType.MAINLINE && TaskTemplateList.showInFollow(i))
				{
					if(checkCanAccept(i))//任务可接
					{
						ret = i;
					}
				}
			}
			for each(var j:TaskTemplateInfo in list)
			{
				if(j.type == TaskType.MAINLINE && checkCanShow(j))//任务不可接但可以显示在任务追踪
				{
					ret = j;
				}
			}
			return ret;
		}
		
		/**
		 * 任务追踪界面不可接的等级需求最低的主线任务
		 */
		public function getMainLineTaskInvisible():TaskTemplateInfo
		{
			var list:Dictionary = TaskTemplateList.getTemplateList();
			var ret:TaskTemplateInfo;
			for each(var i:TaskTemplateInfo in list)
			{
				if(i.type == TaskType.MAINLINE &&  TaskTemplateList.showInFollow(i))
				{
					if(i.needCareer != -1 && i.needCareer != GlobalData.selfPlayer.career)continue;
					if(!GlobalData.taskInfo.getTask(i.taskId))
					{
						if(!ret)
						{
							ret = i;
						}
						else if(ret.minLevel > i.minLevel)
						{
							ret = i;
						}
					}
				}
			}
			return ret;
		}
//		public function getTaskVisible():Array
//		{
//			var result:Array = [];
//			var list:Dictionary = TaskTemplateList.getTemplateList();
//			for each(var i:TaskTemplateInfo in list)
//			{
//				if(TaskTemplateList.showInFollow(i))
//				{
//					if(checkCanAccept(i))result.push(i);
//				}
//			}
//			for each(var j:TaskTemplateInfo in list)
//			{
//				if(checkCanShow(j) && result.indexOf(j) == -1)result.push(j);
//			}
//			return result;
//		}
		
		/**
		 * 检测能否接受任务
		 */		
		public function checkCanAccept(task:TaskTemplateInfo):Boolean
		{
			if(task.getCanAccept())
			{
				var item:TaskItemInfo = GlobalData.taskInfo.getTask(task.taskId);
				if(task.getLastState().condition == TaskConditionType.TRANSPORT)
				{
					if(GlobalData.taskInfo.getTransportTask() != null)return false;
					else
					{
						var list:Array = GlobalData.taskInfo.getAllTransportTask();
						var count:int = 0;
						for(var i:int = 0; i < list.length; i++)
						{
							count += (list[i].getTemplate().repeatCount - list[i].dayLeftCount);
						}
						if(count >= task.repeatCount)return false;
					}
				}
				if(item == null)
				{
					//身上没有此任务，可接
					return true;
				}
				else if(!item.isExist)
				{
					//身上没有任务，可接
					return true;
				}
				else if(item.isFinish)
				{
					//身上有任务，并且已经完成，检测能否重新
					if(item.getCanAccept())return true;
				}
				else if(task.canReset)
				{
					//身上有任务，并且未完成，并且能重设，检测是否需要重设
					if(item.getCanReset())return true;
				}
			}
			return false;
		}
		
		/**
		 * 是否显示在任务追踪
		 * @param task
		 * @return 
		 * 
		 */		
		public function checkCanShow(task:TaskTemplateInfo):Boolean
		{
			if(task.getCanShow())
			{
				var item:TaskItemInfo = GlobalData.taskInfo.getTask(task.taskId);
				if(task.states[0].condition == TaskConditionType.TRANSPORT)
				{
					if(GlobalData.taskInfo.getTransportTask() != null)return false;
					else
					{
						var list:Array = GlobalData.taskInfo.getAllTransportTask();
						var count:int = 0;
						for(var i:int = 0; i < list.length; i++)
						{
							count += (list[i].getTemplate().repeatCount - list[i].dayLeftCount);
						}
						if(count >= task.repeatCount)return false;
					}
				}
				if(item == null)
				{
					return true;
				}
				else if(!item.isExist)
				{
					return true;
				}
				else if(item.isFinish)
				{
					if(item.getCanAccept())return true;
				}
				else if(task.canReset)
				{
					if(item.getCanReset())return true;
				}
			}
			return false;
		}
	}
}