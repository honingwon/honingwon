package sszt.core.data.task
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployEventManager;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.DateUtil;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.tips.GuideTip;
	import sszt.events.CommonModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.accordionItems.IAccordionItemData;
	
	public class TaskItemInfo extends EventDispatcher implements IAccordionItemData
	{
		public var taskId:int;
		/**
		 * 新接任务
		 */		
		public var isNew:Boolean;
		public var dayLeftCount:int;
		public var finishDate:Date;
				
		/**
		 * 刚提交
		 */		
		public var isNewFinish:Boolean;
		
		private var _template:TaskTemplateInfo;
		
		private var _deployIndex:int = 0;
		/**
		 * 是否正在委托
		 */		
		private var _isEntrusting:Boolean;
		/**
		 * 委托任务结束时间
		 */		
		public var entrustEndTime:Date;
		/**
		 * 委托次数
		 */		
		public var entrustCount:int;
		
		/**
		 * 是否存在
		 */		
		private var _isExist:Boolean;
		public function get isExist():Boolean
		{
			return _isExist;
		}
		public function set isExist(value:Boolean):void
		{
			if(_isExist == value)return;
			_isExist = value;
			var list:Array = getTemplate().acceptDeploys;
			if(_isExist && list)
			{
				if(isNew && list.length > 0 && _deployIndex < list.length)
				{
					ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GOTO_NEXT_DEPLOY,gotoNextDeployHandler);
					DeployEventManager.handle(list[_deployIndex]);
				}
				if(isNew)
				{
//					var deploy:DeployItemInfo = new DeployItemInfo();
//					deploy.type = DeployEventType.AUTO_TASK;
//					deploy.param1 = taskId;
//					DeployEventManager.handle(deploy);
			
					GlobalData.selfPlayer.taskAccept(this);
				}
				
				//放弃重接任务
				if(GlobalData.taskInfo.getTask(taskId) != null)
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_ADD,taskId));
				
				if(template.condition == TaskConditionType.JOIN_CLUB)
					GlobalData.taskInfo.updateJoinClubTask();
			}
			else
			{
				if(list.length > 0)
				{
					_deployIndex = 0;
					ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GOTO_NEXT_DEPLOY,gotoNextDeployHandler);
				}
				GuideTip.getInstance().hide();
			}
		}
		
		private function gotoNextDeployHandler(e:CommonModuleEvent):void
		{
			if(isExist && isFinish == false)
			{
				var array:Array = getTemplate().acceptDeploys;
				if(_deployIndex < getTemplate().acceptDeploys.length - 1)
				{
					var deploy:DeployItemInfo = getTemplate().acceptDeploys[_deployIndex+1];
					if(deploy.type != DeployEventType.GUIDE_TIP)
					{
						_deployIndex++;
						DeployEventManager.handle(getTemplate().acceptDeploys[_deployIndex]);
					}
					else if(deploy.param1 == int(e.data))
					{
						_deployIndex++;
						DeployEventManager.handle(getTemplate().acceptDeploys[_deployIndex]);
					}
				}
				else
					ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GOTO_NEXT_DEPLOY,gotoNextDeployHandler);
			}
		}
		
		/**
		 * 任务步骤，从0开始
		 */		
		private var _state:int = -1;
		public function get state():int
		{
			return _state;
		}
		public function set state(value:int):void
		{
			if(_state == value)return;
			_state = value;
			var list:Array = [];//getCurrentState().notFinishDeploys;
			if(state > 0)
				list = list.concat(getTemplate().states[state - 1].finish2Deploys);
			for(var i:int = 0; i < list.length; i++)
			{
				DeployEventManager.handle(list[i]);
			}
		}
		/**
		 * 任务状态
		 */		
		private var _taskState:int;
		public function get taskState():int
		{
			return _taskState;
		}
		public function set taskState(value:int):void
		{
			if(_taskState == value)return;
			_taskState = value;
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_STATE_UPDATE,taskId));
		}
		
		private var _requireCount:Array;
		public function get requireCount():Array
		{
			return _requireCount;
		}
		public function set requireCount(value:Array):void
		{
			_requireCount = value;
			taskState = GlobalData.taskInfo.taskStateChecker.checkTaskState(this);
			if(isExist && isFinish == false && GlobalData.taskInfo.taskStateChecker.checkStateComplete(getCurrentState(),_requireCount))
			{
				for(var i:int = 0; i < getCurrentState().finish1Deploys.length; i++)
				{
					DeployEventManager.handle(getCurrentState().finish1Deploys[i]);
				}
			}
		}
		
		/**
		 * 已提交
		 */		
		private var _isFinish:Boolean;
		public function get isFinish():Boolean
		{
			return _isFinish;
		}
		public function set isFinish(value:Boolean):void
		{
			if(_isFinish == value)return;
			_isFinish = value;
			taskState = GlobalData.taskInfo.taskStateChecker.checkTaskState(this);
			if(_isFinish && isNewFinish)
			{
				GuideTip.getInstance().hide();
				for(var i:int = 0; i < getTemplate().submitDeploys.length; i++)
				{
					DeployEventManager.handle(getTemplate().submitDeploys[i]);
				}
				GlobalData.selfPlayer.taskSubmit(this);
				ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_FINISH));
				
				if(getTemplate().acceptDeploys.length > 0)
					ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GOTO_NEXT_DEPLOY,gotoNextDeployHandler);
				if(taskId == 550103 || taskId == 550202 || taskId == 550003)
				{
					JSUtils.shareInside(1);
				}
				else if(taskId == 550111 || taskId == 550211 || taskId == 550011)
				{
					JSUtils.shareInside(2);
				}
				else if(taskId == 550319)
				{
					JSUtils.shareInside(3);
				}
			}
			
			//完成任务重接任务(循环)
			if(_isFinish == false && _isExist)
				ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_ADD,taskId));
		}
		
		public function get isEntrusting():Boolean
		{
			return _isEntrusting;
		}
		public function set isEntrusting(value:Boolean):void
		{
			if(_isEntrusting == value)return;
			_isEntrusting = value;
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_ENTRUST_UPDATE,taskId));
		}
		
		public function TaskItemInfo()
		{
		}
		
		public function update():void
		{
			dispatchEvent(new TaskItemInfoUpdateEvent(TaskItemInfoUpdateEvent.TASKINFO_UPDATE));
		}
		
		public function getTemplate():TaskTemplateInfo
		{
			if(_template == null)
			{
				_template = TaskTemplateList.getTaskTemplate(taskId);
			}
			return _template;
		}
		
		public function getCurrentState():TaskStateTemplateInfo
		{
			return getTemplate().states[state];
		}
		
		public function getCanAccept():Boolean
		{
			if(isEntrusting)return false;
			if(!getTemplate().canRepeat)return false;
			var dd:int = DateUtil.deltaDay(finishDate,GlobalData.systemDate.getSystemDate());
			if(dd < getTemplate().repeatDay)
			{
				return dayLeftCount > 0;
			}
			return true;
		}
		
		public function getCanReset():Boolean
		{
			if(isEntrusting)return false;
			if(!getTemplate().canReset)return false;
			var dd:int = DateUtil.deltaDay(finishDate,GlobalData.systemDate.getSystemDate());
			if(dd < getTemplate().repeatDay)return false;
			return true;
		}
		
		public function getAccordionItem(width:int):DisplayObject
		{
			var field:TextField = new TextField();
			field.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
			field.filters = [new GlowFilter(0x17380F,1,2,2,10)];
			field.width = width;
			field.height = 20;
			field.mouseEnabled = false;
			field.htmlText = getTemplate().title;
			return field;
		}
		
		public function get template():TaskTemplateInfo
		{
			return _template;
		}
	}
}