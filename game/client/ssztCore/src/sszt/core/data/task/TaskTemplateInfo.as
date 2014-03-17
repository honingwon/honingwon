package sszt.core.data.task
{
	import flash.utils.ByteArray;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.utils.ArrayUtil;
	import sszt.core.utils.DateUtil;
	import sszt.core.utils.PackageUtil;

	/**
	 * 任务模版
	 */
	public class TaskTemplateInfo
	{
		public var taskId:int;
		public var awardCopper:int;
		public var awardExp:int;
		public var awardYuanBao:int;
		public var beginDate:Date;
		public var autoShow:Boolean;
		public var canRepeat:Boolean;
		public var canReset:Boolean;
		public var condition:int;
		/**
		 * 接受任务对白
		 */		
		public var acceptContent:Array;
		public var endDate:Date;
		public var maxLevel:int;
		public var minLevel:int;
		public var clubMinLevel:int;
		public var clubMaxLevel:int;
		public var nextTaskId:Array;
		public var preTaskId:Array;
		public var npc:int;
		public var repeatCount:int;
		public var repeatDay:int;
		public var target:String;
		public var timeLimit:Boolean;
		public var title:String;
		public var type:int;
		public var states:Array;
		/**
		 * ??应为所有状态任务的物品奖励之和
		 */
		public var awardList:Array;
		public var acceptDeploys:Array;
		public var submitDeploys:Array;
		public var needCareer:int;
		public var needCamp:int;
		public var needSex:int;
		public var canEntrust:Boolean;													//是否委托任务
		public var entrustTime:int;														//委托时间
		public var entrustCopper:int;													//委托消耗铜币
		public var entrustYuanbao:int;													//委托消耗元宝
		public var canTransfer:Boolean;													//能否传送
		public var autoAccept:Boolean;													//自动接受
		public var autoSubmit:Boolean;													//自动提交
		public var visibleLevel:int;													//可视等级
		public var needItem:int;														//接受任务需要道具
		public var needCopper:int;														//接受任务需要铜币
		
		private var _lastState:TaskStateTemplateInfo;
		
		public var isAutoTask:Boolean;
		
		public function TaskTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			taskId = data.readInt();
			awardCopper = data.readInt();
			awardExp = data.readInt();
			awardYuanBao = data.readInt();
			beginDate = PackageUtil.readDate(data);
			
			autoShow = data.readBoolean();
			canRepeat = data.readBoolean();
			canReset = data.readBoolean();
			condition = data.readInt();
			acceptContent = ArrayUtil.trimStringArray(data.readUTF().split("||"));
			
			endDate = PackageUtil.readDate(data);
			maxLevel = data.readInt();
			minLevel = data.readInt();
			
			clubMinLevel = data.readInt();
			clubMaxLevel = data.readInt();
			
			nextTaskId = data.readUTF().split("|");
			npc = data.readInt();
			preTaskId = data.readUTF().split("|");
			repeatCount = data.readInt();
			repeatDay = data.readInt();
			target = data.readUTF();
			timeLimit = data.readBoolean();
			title = data.readUTF();
			type = data.readInt();
			needCamp = data.readInt();
			needCareer = data.readInt();
			needSex = data.readInt();
			canEntrust = data.readBoolean();
			entrustTime = data.readInt();
			entrustCopper = data.readInt();
			entrustYuanbao = data.readInt();
			canTransfer = data.readBoolean();
			visibleLevel = data.readInt();
			autoAccept = data.readBoolean();
			autoSubmit = data.readBoolean();
			needItem = data.readInt();
			needCopper = data.readInt();
			
			var acceptDeploys1:Array =  ArrayUtil.trimStringArray(data.readUTF().split("|"));
			var acceptDeploysLen:int = acceptDeploys1.length;
			acceptDeploys = [];
			for(i = 0; i < acceptDeploysLen; i++)
			{
				var deploy:DeployItemInfo = new DeployItemInfo();
				deploy.parseData(acceptDeploys1[i]);
				if (deploy.type == DeployEventType.AUTO_TASK)
				{
					this.isAutoTask = true;
				}
				acceptDeploys.push(deploy);
			}
			
			var submitDeploys1:Array =  ArrayUtil.trimStringArray(data.readUTF().split("|"));
			var submitDeploysLen:int = submitDeploys1.length;
			submitDeploys = [];
			for(i = 0; i < submitDeploysLen; i++)
			{
				var deploy1:DeployItemInfo = new DeployItemInfo();
				deploy1.parseData(submitDeploys1[i]);
				submitDeploys.push(deploy1);
			}
			
			//所有状态任务的物品奖励之和
			//目前数据库中数据没填充完成
			var i:int = 0;
			var awardLen:int = data.readInt();
			awardList = [];
			for(i = 0; i < awardLen; i++)
			{
				var award:TaskAwardTemplateInfo = new TaskAwardTemplateInfo();
				award.parseData(data);
				awardList.push(award);
			}
			
			var stateLen:int = data.readInt();
			states = [];
			for(i = 0; i < stateLen; i++)
			{
				var state:TaskStateTemplateInfo = new TaskStateTemplateInfo();
				state.parseData(data,taskId);
				states.push(state);
				
				if(i == stateLen - 1)_lastState = state;
			}
		}
		
		public function getCanAccept():Boolean
		{
			if(!GlobalData.selfPlayer) return false;
			//检测任务等级限制
			if(GlobalData.selfPlayer.level < minLevel || GlobalData.selfPlayer.level > maxLevel)return false;
			//检测公会等级限制
			if((clubMinLevel != -1 && GlobalData.selfPlayer.clubLevel < clubMinLevel) || (clubMaxLevel != -1 && GlobalData.selfPlayer.clubLevel > clubMaxLevel)) return false;
			//检测是否有前置任务限制。
			//如果有，检测前置任务是否完成。
			var preFinish:Boolean = false;
			var needPre:Boolean = false;
			for each(var id:int in preTaskId)
			{
				if(id != -1)
				{
					var task:TaskItemInfo = GlobalData.taskInfo.getTask(id);
					needPre = true;
					if(task && task.isFinish && task.isExist)
					{
						preFinish = true;
						break;
					}
				}
			}
			if(needPre && !preFinish)return false;
			//检测时间限制
			if(timeLimit)
			{
				if(DateUtil.getTimeBetween(beginDate,GlobalData.systemDate.getSystemDate()) < 0 || DateUtil.getTimeBetween(GlobalData.systemDate.getSystemDate(),endDate) < 0)return false;
			}
			//检测阵营限制
			if(needCamp != -1 && needCamp != GlobalData.selfPlayer.camp)return false;
			if(needCareer != -1 && needCareer != GlobalData.selfPlayer.career)return false;
			if(needSex != -1 && needSex != GlobalData.selfPlayer.sex)return false;
			if(condition == TaskConditionType.HONGMING_COLLECT || condition == TaskConditionType.HONGMING_KILLMONSTER)
			{
				if(GlobalData.selfPlayer.PKValue <= 80)return false;
			}
			return true;
		}
		
		/**
		 * 是否显示在任务追踪
		 * @return 
		 * 
		 */		
		public function getCanShow():Boolean
		{
			if(!GlobalData.selfPlayer) return false;
			if(GlobalData.selfPlayer.level < visibleLevel || GlobalData.selfPlayer.level > maxLevel)return false;
			//检测公会等级限制
			if((clubMinLevel != -1 && GlobalData.selfPlayer.clubLevel < clubMinLevel) || (clubMaxLevel != -1 && GlobalData.selfPlayer.clubLevel > clubMaxLevel)) return false;
			var preFinish:Boolean = false;
			var needPre:Boolean = false;
			for each(var id:int in preTaskId)
			{
				if(id != -1)
				{
					var task:TaskItemInfo = GlobalData.taskInfo.getTask(id);
					needPre = true;
					if(task && task.isFinish && task.isExist)
					{
						preFinish = true;
						break;
					}
				}
			}
			if(needPre && !preFinish)return false;
			if(timeLimit)
			{
				if(!(DateUtil.getTimeBetween(beginDate,GlobalData.systemDate.getSystemDate()) < 0 && DateUtil.getTimeBetween(GlobalData.systemDate.getSystemDate(),endDate) < 0))return false;
			}
			if(needCamp != -1 && needCamp != GlobalData.selfPlayer.camp)return false;
			if(needCareer != -1 && needCareer != GlobalData.selfPlayer.career)return false;
			if(needSex != -1 && needSex != GlobalData.selfPlayer.sex)return false;
			if(condition == TaskConditionType.HONGMING_COLLECT || condition == TaskConditionType.HONGMING_KILLMONSTER)
			{
				if(GlobalData.selfPlayer.PKValue <= 80)return false;
			}
			return true;
		}
		
		public function getLastState():TaskStateTemplateInfo
		{
			return _lastState;
		}
	}
}