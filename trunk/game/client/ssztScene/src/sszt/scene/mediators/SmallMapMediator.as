package sszt.scene.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.task.TaskListUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SceneModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	import sszt.scene.components.smallMap.SmallMapView;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.socketHandlers.PlayerSetHouseSocketHandler;
	
	public class SmallMapMediator extends Mediator
	{
		public static const NAME:String = "SmallMapMeidator";
		
		public function SmallMapMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_ADD,taskAddHandler);
			GlobalData.taskInfo.addEventListener(TaskListUpdateEvent.ADD_TASK,taskAddHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.SHOW_HANG_UP_PANEL,showHangup);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.SCENE_MEDIATOR_START,
				SceneMediatorEvent.SCENE_MEDIATOR_CHANGESCENE,
				SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE,
				SceneMediatorEvent.CHANGE_MOUNTAVOID
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SCENE_MEDIATOR_START:
					initMap();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_CHANGESCENE:
					changeScene();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE:
					dispose();
					break;
				case SceneMediatorEvent.CHANGE_MOUNTAVOID:
					mountAvoid();
					break;
			}
		}
		
		private function initMap():void
		{
			if(sceneModule.smallMap == null)
			{
				sceneModule.smallMap = new SmallMapView(this);
				sceneModule.addChild(sceneModule.smallMap);
			}
		}
		
		private function changeScene():void
		{
		}
		
		public function showHangup(event:Event):void
		{
			facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWSIMPLEHANDUP);
		}
		
		private function taskAddHandler(evt:Event):void
		{
			checkCarState();
		}
		
		public function checkCarState():void
		{
			if(GlobalData.taskInfo.getTransportTask() != null)
			{
				mountAvoid(false);
			}
		}
		
		public function mountAvoid(alarmCar:Boolean = true):void
		{
			if(!sceneInfo.playerList.self)return;
			if(sceneInfo.mapInfo.isSpaScene() || sceneInfo.mapInfo.isClubPointWarScene() || sceneInfo.mapInfo.isShenmoDouScene())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
				return;
			}
			if(sceneInfo.playerList.self.isMount)
			{
				if(sceneModule.sceneInfo.playerList.isDoubleSit())
				{
					sceneModule.sceneInfo.playerList.clearDoubleSit();
				}
				PlayerSetHouseSocketHandler.send(false);
			}
			else
			{
				if( sceneInfo.playerList.self.getIsDead())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.unRidableInFightState"));
					return;
				}
				if(GlobalData.taskInfo.getTransportTask() != null)
				{
					if(alarmCar)
						QuickTips.show(LanguageManager.getWord("ssztl.common.unRidableInFightState"));
					return;
				}
				if(!sceneInfo.playerList.self.fightMounts)
				{
					return;
				}
				
//				if(GlobalData.bagInfo.getItem(12) == null)
//				{
//					return;
//				}
				PlayerSetHouseSocketHandler.send(true);
			} 
		}
		
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
		public function get sceneInfo():SceneInfo
		{
			return sceneModule.sceneInfo;
		}
		
		private function dispose():void
		{
			viewComponent = null;
		}
	}
}