package sszt.task
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.module.BaseModule;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.module.IModule;
	import sszt.module.ModuleEventDispatcher;
	import sszt.task.components.FollowTaskPanel;
	import sszt.task.components.NPCTaskPanel;
	import sszt.task.components.TaskMainPanel;
	import sszt.task.components.sec.TaskEntrust.EntrustFinishPanel;
	import sszt.task.events.TaskMediatorEvent;
	
	public class TaskModule extends BaseModule
	{
		public var facade:TaskFacade;
		public var npcTaskPanel:NPCTaskPanel;
		public var taskMainPanel:TaskMainPanel;
		public var followPanel:FollowTaskPanel;
		public var entrustFinishPanel:EntrustFinishPanel;
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			
			facade = TaskFacade.getInstance(String(moduleId));
			facade.startup(this);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.SHOW_NPCTASKPANEL,showNpcTaskPanelHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.SHOW_MAINPANEL,showMainPanelHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.SHOW_FOLLOWPANEL,showFollowPanelHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.CLOSE_NPCTASKPANEL,closeNpcTaskPanelHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.SHOW_FOLLOW,showFollowHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.HIDE_FOLLOW,hideFollowHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_SHOW_FOLLOW_COMPLETE,showFollowCompleteHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_CLOSE_FOLLOW_COMPLETE,closeFollowCompleteHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.SHOW_NPCTASKPANEL,showNpcTaskPanelHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.SHOW_MAINPANEL,showMainPanelHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.SHOW_FOLLOWPANEL,showFollowPanelHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.CLOSE_NPCTASKPANEL,closeNpcTaskPanelHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.SHOW_FOLLOW,showFollowHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.HIDE_FOLLOW,hideFollowHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_SHOW_FOLLOW_COMPLETE,showFollowCompleteHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_CLOSE_FOLLOW_COMPLETE,closeFollowCompleteHandler);

		}
		
		private function showNpcTaskPanelHandler(evt:TaskModuleEvent):void
		{
			facade.sendNotification(TaskMediatorEvent.TASK_MEDIATOR_SHOWNPCPANEL,evt.data);
		}
		
		private function showMainPanelHandler(evt:TaskModuleEvent):void
		{
			var index:int = evt.data as int;
			if(taskMainPanel)
			{
				if(index != 0)
				{
					taskMainPanel.setIndex(index);
					taskMainPanel.setToTop();
				}
				else
				{
					if(GlobalAPI.layerManager.getTopPanel() != taskMainPanel)
						taskMainPanel.setToTop();
					else taskMainPanel.dispose();
				}
			}
			else
			{
				facade.sendNotification(TaskMediatorEvent.TASK_MEDIATOR_SHOWMAINPANEL,index);
			}
		}
		
		private function showFollowPanelHandler(e:TaskModuleEvent):void
		{
			facade.sendNotification(TaskMediatorEvent.TASK_MEDIATOR_SHOWFOLLOWPANEL,e.data);
		}
		
		private function closeNpcTaskPanelHandler(e:TaskModuleEvent):void
		{
			if(npcTaskPanel)
			{
				npcTaskPanel.dispose();
				npcTaskPanel = null;
			}
		}
		
		private function showFollowHandler(e:TaskModuleEvent):void
		{
			facade.sendNotification(TaskMediatorEvent.SHOW_FOLLOW);
		}
		
		private function showFollowCompleteHandler(e:TaskModuleEvent):void
		{
			facade.sendNotification(TaskMediatorEvent.SHOW_FOLLOW_COMPLETE);
		}
		
		private function hideFollowHandler(e:TaskModuleEvent):void
		{
			facade.sendNotification(TaskMediatorEvent.HIDE_FOLLOW);
		}
		
		private function closeFollowCompleteHandler(e:TaskModuleEvent):void
		{
			facade.sendNotification(TaskMediatorEvent.CLOSE_FOLLOW_COMPLETE);
		}
		
		override public function get moduleId():int
		{
			return ModuleType.TASK;
		}
		
		override public function dispose():void
		{
			if(npcTaskPanel)
			{
				npcTaskPanel.dispose();
				npcTaskPanel = null;
			}
			if(taskMainPanel)
			{
				taskMainPanel.dispose();
				taskMainPanel = null;
			}
			if(followPanel)
			{
				followPanel.dispose();
				followPanel = null;
			}
			if(entrustFinishPanel)
			{
				entrustFinishPanel.dispose();
				entrustFinishPanel = null;
			}
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
			super.dispose();
		}
	}
}