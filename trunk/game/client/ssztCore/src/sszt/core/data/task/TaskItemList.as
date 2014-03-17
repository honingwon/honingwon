package sszt.core.data.task
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.task.TaskClientSocketHandler;
	import sszt.events.SceneModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class TaskItemList extends EventDispatcher
	{
		public static var EQUIP_STRENGHT_TASK:int = 520006;
		public static var EQUIP_REBUILD_TASK:int = 520007;
		
		public var taskStateChecker:TaskStateChecker;
		/**
		 * "所有任务"列表，包括已接受任务、已完成任务
		 */
		private var _taskList:Dictionary;
//		private var _collectTaskList:Vector.<TaskItemInfo>;
		private var _collectTaskList:Array;
		/**
		 * 第一次取数据后设为true,true才刷NPC状态和可接任务
		 */		
		public var firstGetData:Boolean;
		
		private var _isFirstUpdate:Boolean = true;
		
		
		/**
		 * "所有任务"列表
		 */
		public function TaskItemList()
		{
			firstGetData = false;
			_taskList = new Dictionary();
			taskStateChecker = new TaskStateChecker();
			
//			_collectTaskList = new Vector.<TaskItemInfo>();
			_collectTaskList = [];
		}
		
		/**
		 * 添加任务至"所有任务"列表
		 * @param task
		 * @param isExist  isExist为-1的时候判断isExist，否则判断isExist
		 */		
		public function addTask(task:TaskItemInfo, isExist:int = -1):void
		{
			_taskList[task.taskId] = task;
			if(TaskConditionType.getIsCollectTask(task.getCurrentState().condition) && task.isFinish == false)
			{
				_collectTaskList.push(task);
			}
			if(task.taskId == 550108 || task.taskId == 550008 || task.taskId == 550208 || task.taskId == 551016)
			{
				if(task.isFinish == false)
				{
					if((isExist == -1 && task.isExist) || isExist == 1)
					{
						if(GlobalData.skillInfo.getSkills().length > 1)TaskClientSocketHandler.send(task.taskId,0);
					}
				}
			}
			
			if (this._isFirstUpdate && task.template.isAutoTask && (task.taskState == TaskStateType.ACCEPTNOTFINISH || task.taskState == TaskStateType.FINISHNOTSUBMIT)){
				this._isFirstUpdate = false;
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.AUTO_TASK_INIT, task.taskId));
			}
			
			dispatchEvent(new TaskListUpdateEvent(TaskListUpdateEvent.ADD_TASK,task));
		}
		
		/**
		 * 添加到收集任务
		 * 
		 */		
		public function addToCollect(task:TaskItemInfo):void
		{
			if(TaskConditionType.getIsCollectTask(task.getCurrentState().condition) && task.isFinish == false)
			{
				if(_collectTaskList.indexOf(task) == -1)_collectTaskList.push(task);
			}
		}
		
		public function removeTask(id:int):void
		{
			_taskList[id].isFinish = true;
			dispatchEvent(new TaskListUpdateEvent(TaskListUpdateEvent.REMOVE_TASK,id));
		}
		/**
		 * 移除收集任务
		 * 
		 */		
		public function removeFromCollect(task:TaskItemInfo):void
		{
			if(!TaskConditionType.getIsCollectTask(task.getCurrentState().condition) || task.isFinish)
			{
				if(_collectTaskList.indexOf(task) != -1)
				{
					_collectTaskList.splice(_collectTaskList.indexOf(task),1);
				}
			}
		}
		
		public function setFirstData():void
		{
			if(firstGetData)return;
			firstGetData = true;
//			var taskItem:TaskItemInfo = getTask(CategoryType.FIRST_CHARGE_TASK);
//			if(!taskItem)
//			{
//				TaskAcceptSocketHandler.sendAccept(CategoryType.FIRST_CHARGE_TASK);
//			}
//			if(taskItem && taskItem.isExist && !taskItem.isFinish && DateUtil.deltaDay(GlobalData.openServerDate,GlobalData.systemDate.getSystemDate()) < 3)
//			{
//				GuideChargeView.getInstance().show();
//			}
//			dispatchEvent(new TaskListUpdateEvent(TaskListUpdateEvent.FIRST_GETDATA));
		}
		
		public function getTask(id:int):TaskItemInfo
		{
			return _taskList[id];
		}
		
		public function getTaskByTemplateId(id:int):TaskItemInfo
		{
			for each(var i:TaskItemInfo in _taskList)
			{
				if(i.getTemplate().taskId == id)
					return i;
			}
			return null;
		}
		
		/**
		 * 根据任务类型获得任务信息 
		 * @param type 类型 1.主线2.支线3.循环
		 * @return 
		 * 
		 */
		public function getTaskByTaskType(type:int):Array
		{
			var ret:Array = [];
			for each(var i:TaskItemInfo in _taskList)
			{
				if(i.getTemplate().type == type)
					ret.push(i);
			}
			return ret; 
		}
		
		public function getTaskExist(id:int):TaskItemInfo
		{
			var task:TaskItemInfo = getTask(id);
			if(!task || !task.isExist)return null;
			return task;
		}
		
		public function getTaskNoSubmitByNpcId(npcId:int):Array
		{
			var result:Array = [];
			var canSubmit:Array = [];
			var cantSubmit:Array = [];
			for each(var i:TaskItemInfo in _taskList)
			{
				if(i.isExist == false)continue;
				if(i.isEntrusting)continue;
				if(i.getCurrentState().npc != npcId)continue;
				if(i.isFinish == false)
				{
					if(taskStateChecker.checkStateComplete(i.getCurrentState(),i.requireCount))
						canSubmit.push(i);
					else
						cantSubmit.push(i);
				}
			}
			result.push(canSubmit,cantSubmit);
			return result;
		}
		
		/**
		 * 获取未提交的任务(已接受任务)
		 * IAccordionGroupData
		 * @return 
		 * 
		 */		
		public function getNoSubmitTasksByType(isTaskMainPanel:Boolean = false):Array
		{
			var types:Array = TaskType.getTaskTypes();
			//TaskAccordionData
			var result:Array = new Array(types.length);//返回分组结果按type:Array中类型的顺序排序。
			for each(var i:TaskItemInfo in _taskList)
			{
				if(i.isFinish)continue;
				if(i.isEntrusting)continue;
				var index:int = types.indexOf(i.getTemplate().type);
				if(index == -1)continue;
				if(result[index] == null)
				{
					result[index] = new TaskAccordionData(i.getTemplate().type);
				}
				if(GlobalData.taskInfo.taskStateChecker.checkStateComplete(i.getCurrentState(),i.requireCount))
					result[index].isFinish = true;
				result[index].data.push(i);
			}
			
			var mainLineIndex:int = types.indexOf(TaskType.MAINLINE)
			//如果主线任务组为空(没有已接受的主线任务)，那么把【指定主线任务】添加进去。
			if(!isTaskMainPanel && !result[mainLineIndex] && GlobalData.selfPlayer)
			{
				var tmp:Object = getMainLineTask();
				if(tmp)
				{
					result[mainLineIndex] = new TaskAccordionData(TaskType.MAINLINE);
					result[mainLineIndex].data.push(getMainLineTask());
				}
			}
			
			//如果类型分组为空，那么创建一个空的分组数据
			for each(var type:uint in types)
			{
				var index1:int = types.indexOf(type);
				if(result[index1] == null)
				{
					result[index1] = new TaskAccordionData(type);
				}
			}
			//排序的时候永远把主线任务组放在第一个。
			//其余按是【否有已完成的任务】和【组类型】排序
			if(isTaskMainPanel)
			{
				result = result.sortOn(["isFinish","type"],[[Array.NUMERIC | Array.DESCENDING],[Array.NUMERIC]]);
			}
			else
			{
				var spliced:Array = result.splice(0,1);
				result = result.sortOn(["isFinish","type"],[[Array.NUMERIC | Array.DESCENDING],[Array.NUMERIC]]);
				result.splice(0,0,spliced[0]);
			}
			return result;
		}
		
		/**
		 * 获取【指定主线任务】，【指定主线任务】分两种情况:1、可接主线任务 2、不可接主线任务中等级要求最低的
		 */
		private function getMainLineTask():Object
		{
			var ret:Object;
			ret = GlobalData.taskInfo.taskStateChecker.getMainLineTaskVisible();
			if(!ret)
			{
				//不可接主线任务中等级要求最低的
				ret = GlobalData.taskInfo.taskStateChecker.getMainLineTaskInvisible();
			}
			return ret;
		}
		
		
		/**
		 * 获取完成未提交的任务
		 * @return 
		 * 
		 */		
//		public function getTaskFinishNotSubmit():Vector.<TaskItemInfo>
		public function getTaskFinishNotSubmit():Array
		{
//			var result:Vector.<TaskItemInfo> = new Vector.<TaskItemInfo>();
			var result:Array = [];
			for each(var i:TaskItemInfo in _taskList)
			{
				if(i.taskState == TaskStateType.FINISHNOTSUBMIT && i.isEntrusting == false)result.push(i);
			}
			return result;
		}
		/**
		 * 获取未完成的任务
		 * @return 
		 * 
		 */		
//		public function getTaskAcceptNotFinish():Vector.<TaskItemInfo>
		public function getTaskAcceptNotFinish():Array
		{
//			var result:Vector.<TaskItemInfo> = new Vector.<TaskItemInfo>();
			var result:Array = [];
			for each(var i:TaskItemInfo in _taskList)
			{
				if(i.taskState == TaskStateType.ACCEPTNOTFINISH && i.isEntrusting == false)result.push(i);
			}
			return result;
		}
		
		/**
		 * 获取可委托任务
		 * @return 
		 * 
		 */		
		public function getCanEntrustTasks():Array
		{
//			var types:Vector.<uint> = TaskType.getTaskTypes();
			var types:Array = TaskType.getEntrustTaskTypes();
			//TaskAccordionData
			var result:Array = new Array(types.length);
			var index:int;
			var itemInfo:TaskEntrustItemInfo;
			
			var list:Dictionary = TaskTemplateList.getTemplateList();
			for each(var i:TaskTemplateInfo in list)
			{
				if(i.canEntrust)
				{
					var taskItem:TaskItemInfo = getTask(i.taskId);
					if(taskItem && taskItem.isEntrusting)continue;
					if(taskItem == null || taskItem.isExist == false || taskItem.isFinish)
					{
						if(!GlobalData.taskInfo.taskStateChecker.checkCanAccept(i))continue;
					}
					itemInfo = new TaskEntrustItemInfo();
					itemInfo.taskId = i.taskId;
					if(taskItem)
					{
						if(taskItem.isFinish)itemInfo.dayLeftCount = taskItem.dayLeftCount;
						else itemInfo.dayLeftCount = taskItem.dayLeftCount + 1;
					}
					else
					{
						itemInfo.dayLeftCount = i.repeatCount;
					}
					index = types.indexOf(i.type);
					if(result[index] == null)
					{
						result[index] = new TaskAccordionData(i.type);
					}
					result[index].data.push(itemInfo);
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
		 * 获取正在委托的任务
		 * @return 
		 * 
		 */		
//		public function getEntrustingTask():Vector.<TaskItemInfo>
		public function getEntrustingTask():Array
		{
//			var result:Vector.<TaskItemInfo> = new Vector.<TaskItemInfo>();
			var result:Array = [];
			for each(var i:TaskItemInfo in _taskList)
			{
				if(i.isEntrusting && i.isFinish == false)result.push(i);
			}
			return result;
		}
		
		/**
		 * 获取当前的运镖任务
		 * @return 
		 * 
		 */		
		public function getTransportTask():TaskItemInfo
		{
			for each(var info:TaskItemInfo in _taskList)
			{
				if(info.getCurrentState().condition == TaskConditionType.TRANSPORT && info.isExist && info.isFinish == false)return info;
			}
			return null;
		}
		/**
		 * 获取身上所有运镖任务
		 * @return 
		 * 
		 */		
		public function getAllTransportTask():Array
		{
			var result:Array = [];
			for each(var info:TaskItemInfo in _taskList)
			{
				if(info.getCurrentState().condition == TaskConditionType.TRANSPORT)result.push(info);
			}
			return result;
		}
		/**
		 * 获取身上所有神魔令任务
		 */
		public function getAllShenMoLingTask():Array
		{
			var result:Array = [];
			for each(var info:TaskItemInfo in _taskList)
			{
				if(info.getCurrentState().condition == TaskConditionType.SHENMOLING)
					result.push(info);
			}
			return result;
		}
		
		/**
		 * 根据地图ID获取任务怪物ID
		 * @param sceneId
		 * @return 
		 * 
		 */		
		public function getTaskMonsters(sceneId:int):Dictionary
		{
			var list:Dictionary = new Dictionary();
//			var taskList:Vector.<TaskItemInfo> = getTaskAcceptNotFinish();
			var taskList:Array = getTaskAcceptNotFinish();
			for each(var info:TaskItemInfo in taskList)
			{
				if(TaskConditionType.getIsKillMonster(info.getCurrentState().condition))
				{
					for(var i:int = 0; i < info.getCurrentState().data.length; i++)
					{
						if(info.getCurrentState().getMonsterScene(i) == sceneId)
						{
							var monsterId:int = info.getCurrentState().getObjId(i);
							if(list[monsterId] == null)
							{
								list[monsterId] = [monsterId,info.requireCount[i]];
							}
							else
							{
								list[monsterId][1] = info.requireCount[i] + list[monsterId][1];
							}
						}
					}
				}
			}
			return list;
		}
		/**
		 * 返回monsterId怪物还差多少只
		 * @param monsterId
		 * @return 
		 * 
		 */		
		public function getTaskMonsterCountByMonsterId(monsterId:int):int
		{
			var result:int = 0;
//			var taskList:Vector.<TaskItemInfo> = getTaskAcceptNotFinish();
			var taskList:Array = getTaskAcceptNotFinish();
			for each(var info:TaskItemInfo in taskList)
			{
				if(TaskConditionType.getIsKillMonster(info.getCurrentState().condition))
				{
					for(var i:int = 0; i < info.getCurrentState().data.length; i++)
					{
						if(info.getCurrentState().getObjId(i) == monsterId)
						{
							result += info.requireCount[i];
						}
					}
				}
			}
			return result;
		}
		/**
		 * 返回一只需要打的任务怪
		 * @return 
		 * 
		 */		
		public function getATaskNeedMonster():int
		{
//			var taskList:Vector.<TaskItemInfo> = getTaskAcceptNotFinish();
			var taskList:Array = getTaskAcceptNotFinish();
			for each(var info:TaskItemInfo in taskList)
			{
				if(TaskConditionType.getIsKillMonster(info.getCurrentState().condition))
				{
					for(var i:int = 0; i < info.getCurrentState().data.length; i++)
					{
						if(info.requireCount[i] > 0)
						{
							return info.getCurrentState().getObjId(i);
						}
					}
				}
			}
			return -1;
		}
		
		public function updateCollectTask():void
		{
			for each(var info:TaskItemInfo in _collectTaskList)
			{
				if(info.isExist && info.isFinish == false)
				{
					var p:Boolean = false;
//					var requireCount:Vector.<int> = info.requireCount.slice();
					var requireCount:Array = info.requireCount.slice();
					for(var i:int = 0; i < info.getCurrentState().data.length; i++)
					{
						var id:int = info.getCurrentState().data[i][0];
						var count:int = info.getCurrentState().data[i][1];
						if(info.getCurrentState().condition != TaskConditionType.BUY_UNBIND)
						{
							if(requireCount[i] != count - GlobalData.bagInfo.getItemCountById(id))
							{
								p = true;
								requireCount[i] = count - GlobalData.bagInfo.getItemCountById(id);
							}
						}
//						else
//						{
//							var list:Array = GlobalData.bagInfo.getItemById(id);
//							for each(var itemInfo:ItemInfo in list)
//							{
//								if(itemInfo.isBind == false)
//								{
//									p = true;
//									requireCount[i] = count - itemInfo.count;
//								}
//							}
//						}
						if(requireCount[i] < 0)requireCount[i] = 0;
					}
					if(p)
					{
						info.requireCount = requireCount;
						info.update();
						ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CHECKSTATE));
					}
				}
			}
		}
		
		public function updateJoinClubTask():void
		{
			for each(var task:TaskItemInfo in _taskList)
			{
				if(task.isExist && task.template.condition == TaskConditionType.JOIN_CLUB)
				{
					task.requireCount[0] = GlobalData.selfPlayer.clubId == 0 ? 1 : 0;
					task.update();
				}
			}
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CHECKSTATE));
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.UPDATE_CLUB_TASK));
		}
		
		public function getNoSubmitMainLineTasks():Array{
			var result:Array = [];
			for each (var i:TaskItemInfo in _taskList) {
				if (i.template.type == TaskType.MAINLINE){
					if (i.taskState == TaskStateType.ACCEPTNOTFINISH && i.isEntrusting == false){
						result.push(i);
					}
					if (i.taskState == TaskStateType.FINISHNOTSUBMIT && i.isEntrusting == false){
						result.push(i);
					}
				}
			}
			return result;
		}
		
		public function get collectTaskList():Array
		{
			return _collectTaskList;
		}
	}
}