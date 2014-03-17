package sszt.task.components.sec
{
	import fl.controls.ScrollPolicy;
	import fl.core.InvalidationType;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskListUpdateEvent;
	import sszt.core.view.tips.GuideTip;
	import sszt.events.CommonModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.task.components.container.TAccordion;
	import sszt.task.components.sec.TaskList.TaskDetailView;
	import sszt.task.mediators.TaskMediator;
	import sszt.ui.container.MAccordion;
	import sszt.ui.container.MSprite;
	
	public class TaskListPanel extends MSprite implements ITaskMainPanel
	{
		private var _mediator:TaskMediator;
		private var _listView:TAccordion;
		private var _detailView:TaskDetailView;
		
		public function TaskListPanel(mediator:TaskMediator)
		{
			_mediator = mediator;
			super();
			initView();
			initEvent();
			
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.TASK_MAIN));
		}
		
		private function initView():void
		{
			_detailView = new TaskDetailView();
			_detailView.move(195, 2);
			addChild(_detailView);
			
			invalidate(InvalidationType.DATA);
			
			setGuideTipHandler(null);
		}
		
		private function initEvent():void
		{
			GlobalData.taskInfo.addEventListener(TaskListUpdateEvent.ADD_TASK,taskAddHandler);
			GlobalData.taskInfo.addEventListener(TaskListUpdateEvent.REMOVE_TASK,taskRemoveHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_ADD,taskListUpdateHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_FINISH,taskListUpdateHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_ENTRUST_UPDATE,taskListUpdateHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		private function removeEvent():void
		{
			GlobalData.taskInfo.removeEventListener(TaskListUpdateEvent.ADD_TASK,taskAddHandler);
			GlobalData.taskInfo.removeEventListener(TaskListUpdateEvent.REMOVE_TASK,taskRemoveHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_ADD,taskListUpdateHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_FINISH,taskListUpdateHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_ENTRUST_UPDATE,taskListUpdateHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.TASK_MAIN)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addChild);
			}
		}
		
		private function itemSelectHandler(e:Event):void
		{
			_detailView.info = _listView.selectedItemData as TaskItemInfo;
		}
		
		private function taskAddHandler(e:TaskListUpdateEvent):void
		{
			invalidate(InvalidationType.DATA);
		}
		
		private function taskRemoveHandler(e:TaskListUpdateEvent):void
		{
			invalidate(InvalidationType.DATA);
		}
		
		private function taskListUpdateHandler(e:TaskModuleEvent):void
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
				_listView = new TAccordion(GlobalData.taskInfo.getNoSubmitTasksByType(true), 186, -1);
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
				_listView.removeEventListener(MAccordion.ITEM_SELECT,itemSelectHandler);
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