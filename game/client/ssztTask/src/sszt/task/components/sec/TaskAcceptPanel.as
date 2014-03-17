package sszt.task.components.sec
{
	import fl.controls.ScrollPolicy;
	import fl.core.InvalidationType;
	
	import flash.events.Event;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.task.TaskAccordionData;
	import sszt.core.data.task.TaskConditionType;
	import sszt.core.data.task.TaskListUpdateEvent;
	import sszt.core.data.task.TaskType;
	import sszt.events.TaskModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.task.components.container.TAccordion;
	import sszt.task.components.sec.TaskList.TaskAcceptableDetailView;
	import sszt.task.data.TaskAcceptItemInfo;
	import sszt.task.mediators.TaskMediator;
	import sszt.ui.container.MAccordion;
	import sszt.ui.container.MSprite;
	
	public class TaskAcceptPanel extends MSprite implements ITaskMainPanel
	{
		private var _mediator:TaskMediator;
		private var _listView:MAccordion;
		private var _detailView:TaskAcceptableDetailView;
		
		public function TaskAcceptPanel(mediator:TaskMediator)
		{
			_mediator = mediator;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_detailView = new TaskAcceptableDetailView();
			_detailView.move(195, 2);
			addChild(_detailView);
			
			invalidate(InvalidationType.DATA);
		}
		
		private function initEvent():void
		{
			GlobalData.taskInfo.addEventListener(TaskListUpdateEvent.ADD_TASK,taskListUpdateHandler);
			GlobalData.taskInfo.addEventListener(TaskListUpdateEvent.REMOVE_TASK,taskListUpdateHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_ADD,taskListUpdateHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_FINISH,taskListUpdateHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_ENTRUST_UPDATE,taskListUpdateHandler);
		}
		
		private function removeEvent():void
		{
			GlobalData.taskInfo.removeEventListener(TaskListUpdateEvent.ADD_TASK,taskListUpdateHandler);
			GlobalData.taskInfo.removeEventListener(TaskListUpdateEvent.REMOVE_TASK,taskListUpdateHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_ADD,taskListUpdateHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_FINISH,taskListUpdateHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_ENTRUST_UPDATE,taskListUpdateHandler);
		}
		
		private function itemSelectHandler(e:Event):void
		{
			_detailView.info = _listView.selectedItemData as TaskAcceptItemInfo;
		}
		
		private function taskListUpdateHandler(e:Event):void
		{
			invalidate(InvalidationType.DATA);
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.DATA))
			{
				_detailView.info = null;
				if(_listView)
				{
					_listView.removeEventListener(MAccordion.ITEM_SELECT,itemSelectHandler);
					_listView.dispose();
				}
				
				var i:int;
				var list:Array = GlobalData.taskInfo.taskStateChecker.getCanAccept();
				var data:Array = new Array(TaskType.getTaskTypes().length);
				var addTransport:Boolean = false;
				for(i = 0; i < list.length; i++)
				{
					var index:int = TaskType.getTaskTypes().indexOf(list[i].type);
					if(index == -1)continue;
					if(list[i].type == TaskType.CLUB)continue;
					if(list[i].states[0].condition == TaskConditionType.SHENMOLING)continue;
					if(list[i].states[0].condition == TaskConditionType.TRANSPORT)
					{
						if(addTransport)continue;
						else addTransport = true;
					}
					var iteminfo:TaskAcceptItemInfo = new TaskAcceptItemInfo();
					iteminfo.taskId = list[i].taskId;
					if(data[index] == null)
					{
						data[index] = new TaskAccordionData(list[i].type);
					}
					data[index].data.push(iteminfo);
				}
				
				_listView = new TAccordion(data, 186, -1);
				_listView.move(4,5);
				_listView.setSize(186, 333);
				_listView.verticalScrollPolicy = ScrollPolicy.AUTO;
				addChild(_listView);
				_listView.addEventListener(MAccordion.ITEM_SELECT,itemSelectHandler);
				_listView.setSelectedGroup(0);
			}
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_listView)
			{
				_listView.dispose();
				_listView = null;
			}
			if(_detailView)
			{
				_detailView.dispose();
				_detailView = null;
			}
			_mediator = null;
			super.dispose();
		}
	}
}