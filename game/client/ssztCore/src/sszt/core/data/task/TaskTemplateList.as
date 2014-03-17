package sszt.core.data.task
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateInfo;

	/**
	 * ‘所有任务’模版
	 */
	public class TaskTemplateList
	{
		/**
		 * ‘所有任务’模版
		 */
		private static var _taskTemplateList:Dictionary = new Dictionary();
		/**
		 * 神魔令任务模版
		 */		
		private static var _shenMOLingList:Dictionary = new Dictionary();
		/**
		 * 帮会任务模版
		 */		
		private static var _clubTaskList:Dictionary = new Dictionary();
		
		public static function setup(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var task:TaskTemplateInfo = new TaskTemplateInfo();
				task.parseData(data);
				_taskTemplateList[task.taskId] = task;
				if(task.condition == TaskConditionType.SHENMOLING)
				{
					_shenMOLingList[task.taskId] = task;
				}
				if(task.type == TaskType.CLUB)
				{
					_clubTaskList[task.taskId] = task;
				}
			}
		}
		
		public static function getTemplateList():Dictionary
		{
			return _taskTemplateList;
		}
		
		public static function getClubTaskList():Dictionary
		{
			return _clubTaskList;		
		}
		
		public static function getTaskTemplate(id:int):TaskTemplateInfo
		{
			if( _taskTemplateList[id])
				return _taskTemplateList[id];
			else if(_shenMOLingList[id])
				return _shenMOLingList[id]
			else 
				return _clubTaskList[id];
		}
		
		public static function getSMLTaskTemplate(id:int):TaskTemplateInfo
		{
			for each(var smlTemplate:TaskTemplateInfo in _shenMOLingList)
			{
				if(smlTemplate.taskId == id)
				{
					return smlTemplate;
					break;
				}
			}
			return null;
		}
		
//		public static function getCanAcceptTaskByNpcId(npcId:int):Vector.<TaskTemplateInfo>
		/**
		 * 获取指定NPC可接受的任务
		 */
		public static function getCanAcceptTaskByNpcId(npcId:int):Array
		{
//			var result:Vector.<TaskTemplateInfo> = new Vector.<TaskTemplateInfo>();
			var result:Array = [];
			for each(var task:TaskTemplateInfo in _taskTemplateList)
			{
				if(task.npc == npcId && GlobalData.taskInfo.taskStateChecker.checkCanAccept(task))
					result.push(task);
			}
			result.sort(compare);
			return result;
			
			function compare(task1:TaskTemplateInfo,task2:TaskTemplateInfo):int
			{
				if(task1.taskId > task2.taskId)return 1;
				return -1;
			}
		}
		
		/**
		 * 获取所有符合级别的神魔令任务
		 */
		public static function getShenMoLingListByLevel(level:int):Array
		{
			var list:Array = [];
			for each(var taskItem:TaskTemplateInfo in _shenMOLingList)
			{
				if(taskItem.minLevel<= level && taskItem.maxLevel>= level)
					list.push(taskItem);
			}
			return list;
		}
		
		/**
		 * 帮会任务列表 
		 * @param argLevel
		 */		
		public static function getClubTaskListByClubLevel(argLevel:int):Array
		{
			var list:Array = [];
			for each(var taskItem:TaskTemplateInfo in _clubTaskList)
			{
				if(taskItem.clubMinLevel <= argLevel && taskItem.clubMaxLevel>= argLevel)
					list.push(taskItem);
			}
			return list;
		}
		
		/**
		 * 是否显示在任务追踪界面
		 */		
		public static function showInFollow(task:TaskTemplateInfo):Boolean
		{
//			if(task.type == TaskType.CLUB)return false;
			if(task.type == TaskType.ACTIVITY) return false;
			if(task.states[0].condition == TaskConditionType.SHENMOLING)return false;
			return true;
		}
	}
}