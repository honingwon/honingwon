package sszt.task.mediators
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.task.TaskAcceptSocketHandler;
	import sszt.core.socketHandlers.task.TaskSubmitSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.task.TaskModule;
	import sszt.task.components.FollowTaskPanel;
	import sszt.task.components.NPCTaskPanel;
	import sszt.task.components.TaskMainPanel;
	import sszt.task.components.sec.TaskEntrust.EntrustFinishPanel;
	import sszt.task.events.TaskMediatorEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class TaskMediator extends Mediator
	{
		public static const NAME:String = "TaskMediator";
		
		public function TaskMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				TaskMediatorEvent.TASK_MEDIATOR_START,
				TaskMediatorEvent.TASK_MEDIATOR_SHOWNPCPANEL,
				TaskMediatorEvent.TASK_MEDIATOR_SHOWMAINPANEL,
				TaskMediatorEvent.TASK_MEDIATOR_SHOWFOLLOWPANEL,
				TaskMediatorEvent.SHOW_FOLLOW,
				TaskMediatorEvent.HIDE_FOLLOW,
				TaskMediatorEvent.CLOSE_FOLLOW_COMPLETE,
				TaskMediatorEvent.SHOW_FOLLOW_COMPLETE,
				TaskMediatorEvent.TASK_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case TaskMediatorEvent.TASK_MEDIATOR_START:
					moduleStart();
					break;
				case TaskMediatorEvent.TASK_MEDIATOR_SHOWNPCPANEL:
					showNpcTaskPanel(notification.getBody());
					break;
				case TaskMediatorEvent.TASK_MEDIATOR_SHOWMAINPANEL:
					showMainPanel();
					break;
				case TaskMediatorEvent.TASK_MEDIATOR_SHOWFOLLOWPANEL:
					showFollowPanel(notification.getBody() as int);
					break;
				case TaskMediatorEvent.SHOW_FOLLOW:
					showFollow();
					break;
				case TaskMediatorEvent.HIDE_FOLLOW:
					hideFollow();
					break;
				case TaskMediatorEvent.CLOSE_FOLLOW_COMPLETE:
					closeFollowComplete();
					break;
				case TaskMediatorEvent.SHOW_FOLLOW_COMPLETE:
					showFollowComplete();
					break;
				case TaskMediatorEvent.TASK_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function moduleStart():void
		{
			if(taskModule.followPanel == null)
			{
				taskModule.followPanel = new FollowTaskPanel(this);
				GlobalAPI.layerManager.getPopLayer().addChild(taskModule.followPanel);
			}
		}
		
		private function showNpcTaskPanel(obj:Object):void
		{
			if(taskModule.npcTaskPanel == null)
			{
				taskModule.npcTaskPanel = new NPCTaskPanel(this, obj);
				taskModule.npcTaskPanel.addEventListener(Event.CLOSE,npcTaskPanelCloseHandler);
			}
			GlobalAPI.layerManager.addPanel(taskModule.npcTaskPanel);
		}
		private function npcTaskPanelCloseHandler(e:Event):void
		{
			if(taskModule.npcTaskPanel)
			{
				taskModule.npcTaskPanel.removeEventListener(Event.CLOSE,npcTaskPanelCloseHandler);
				taskModule.npcTaskPanel = null;
			}
		}
		
		public function closeNpcTaskPanel():void
		{
			if(taskModule.npcTaskPanel)
			{
				taskModule.npcTaskPanel.removeEventListener(Event.CLOSE,npcTaskPanelCloseHandler);
				taskModule.npcTaskPanel.dispose();
				taskModule.npcTaskPanel = null;
			}	
		}
		
		public function showMainPanel():void
		{
			if(taskModule.taskMainPanel == null)
			{
				taskModule.taskMainPanel = new TaskMainPanel(this);
				taskModule.taskMainPanel.move(149,93);
				taskModule.taskMainPanel.addEventListener(Event.CLOSE,mainPanelCloseHandler);
			}
			GlobalAPI.layerManager.addPanel(taskModule.taskMainPanel);
		}
		private function mainPanelCloseHandler(e:Event):void
		{
			if(taskModule.taskMainPanel)
			{
				taskModule.taskMainPanel.removeEventListener(Event.CLOSE,mainPanelCloseHandler);
				taskModule.taskMainPanel = null;
			}
		}
		
		public function closeTaskMainPanel():void
		{
			if(taskModule.taskMainPanel)
			{
				taskModule.taskMainPanel.removeEventListener(Event.CLOSE,mainPanelCloseHandler);
				taskModule.taskMainPanel.dispose();
				taskModule.taskMainPanel = null;
			}
		}
		
		private function showFollowPanel(index:int):void
		{
			if(taskModule.followPanel)
			{
				taskModule.followPanel.setIndex(index);
			}
		}
		
		public function showEntrustFinishPanel():void
		{
			if(taskModule.entrustFinishPanel == null)
			{
				taskModule.entrustFinishPanel = new EntrustFinishPanel();
				taskModule.entrustFinishPanel.addEventListener(Event.CLOSE,entrustFinishCloseHandler);
			}
			GlobalAPI.layerManager.addPanel(taskModule.entrustFinishPanel);
		}
		
		private function entrustFinishCloseHandler(e:Event):void
		{
			if(taskModule.entrustFinishPanel)
			{
				taskModule.entrustFinishPanel.removeEventListener(Event.CLOSE,entrustFinishCloseHandler);
				taskModule.entrustFinishPanel = null;
			}
		}
		
		public function acceptTask(id:int):void
		{
			var task:TaskTemplateInfo = TaskTemplateList.getTaskTemplate(id);
			if(task.needItem != 0 && GlobalData.bagInfo.getItemCountById(task.needItem) == 0)
				QuickTips.show(LanguageManager.getWord("ssztl.common.itemNotEnough"));
			else if(task.needCopper != 0 && GlobalData.selfPlayer.userMoney.copper < task.needCopper)
				QuickTips.show(LanguageManager.getWord("ssztl.common.noCopperForTask"));
			else
				TaskAcceptSocketHandler.sendAccept(id);
		}
		
		public function submitTask(id:int,award:int = -1):void
		{
			TaskSubmitSocketHandler.sendSubmit(id,award);
		}
		
		private function showFollow():void
		{
			if(taskModule.followPanel)
			{
				taskModule.followPanel.show();
			}
		}
		
		private function hideFollow():void
		{
			if(taskModule.followPanel)
			{
				taskModule.followPanel.hide();
			}
		}
		
		private function showFollowComplete():void
		{
			if(taskModule.followPanel)
			{
				GlobalAPI.layerManager.getPopLayer().addChild(taskModule.followPanel);
			}
		}
		
		private function closeFollowComplete():void
		{
			if(taskModule.followPanel)
			{
				if(taskModule.followPanel.parent)taskModule.followPanel.parent.removeChild(taskModule.followPanel);
			}
		}
		
		public function get taskModule():TaskModule
		{
			return viewComponent as TaskModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}