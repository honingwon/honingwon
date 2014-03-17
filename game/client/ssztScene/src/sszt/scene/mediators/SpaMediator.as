package sszt.scene.mediators
{
	import flash.events.Event;
	
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.scene.SceneModule;
	import sszt.scene.components.spa.SpaIconView;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.socketHandlers.PlayerSitSocketHandler;
	import sszt.scene.socketHandlers.spa.SpaSceneEnterSocketHandler;
	import sszt.scene.socketHandlers.spa.SpaSceneLeaveSocketHandler;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	
	public class SpaMediator extends Mediator
	{
		private static const NAME:String = "spaMediator";
		
		private var _doubleSitalert:MAlert;
		
		public function SpaMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
							SceneMediatorEvent.SCENE_MEDIATOR_SHOWSPACOPY,
							SceneMediatorEvent.SCENE_MEDIATOR_LEAVE_SPACOPY,
							SceneMediatorEvent.SCENE_MEDIATOR_SPA_ICON
						];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWSPACOPY:
					showSpaPanel();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_LEAVE_SPACOPY:
					leaveSpaScene();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_SPA_ICON:
					showSpaIcon(notification.getBody() as int);
					break;
			}
		}
		
		private function showSpaPanel():void
		{
			sendEnter();
		}
		
		private function leaveSpaScene():void
		{
			MAlert.show(LanguageManager.getWord("ssztl.scene.isSureLeaveSpa"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,leaveAlertHandler);
			
			function leaveAlertHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					sendLeave();
				}
			}
		}
		
		private function showSpaIcon(argShowTime:int):void
		{
			if(sceneModule.spaIconView == null)
			{
				sceneModule.spaIconView = new SpaIconView(this);
				sceneModule.spaIconView.addEventListener(Event.CLOSE,hideSpaIcon);
				sceneModule.spaIconView.show(argShowTime);
			}
		}
		
		public function hideSpaIcon(e:Event):void
		{
			if(sceneModule.spaIconView)
			{
				sceneModule.spaIconView.removeEventListener(Event.CLOSE,hideSpaIcon);
				sceneModule.spaIconView.dispose();
				sceneModule.spaIconView = null;
			}
		}
		
		public function sendEnter():void
		{
			if(sceneInfo.playerList.isDoubleSit())
			{
				if(!_doubleSitalert)
					_doubleSitalert = MAlert.show(LanguageManager.getWord("ssztl.scene.sureBreakDoubleSit"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,stopDoubleSit);
			}
			else
			{
				doEnter();
			}
			
			function stopDoubleSit(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					PlayerSitSocketHandler.send(false);
					sceneInfo.playerList.clearDoubleSit();
					doEnter();
				}
				_doubleSitalert = null;
			}
			
			function doEnter():void
			{
				GlobalData.selfPlayer.scenePathCallback = null;
				GlobalData.selfPlayer.scenePathTarget = null;
				GlobalData.selfPlayer.scenePathStopAtDistance = 0;
				GlobalData.selfPlayer.scenePath = null;
				if(sceneModule.sceneInit.playerListController.getSelf().isMoving)
				{
					sceneModule.sceneInit.playerListController.getSelf().stopMoving();
				}
				SpaSceneEnterSocketHandler.sendEnter();
			}
		}
		
		public function sendLeave():void
		{
			GlobalData.selfPlayer.scenePathCallback = null;
			GlobalData.selfPlayer.scenePathTarget = null;
			GlobalData.selfPlayer.scenePathStopAtDistance = 0;
			GlobalData.selfPlayer.scenePath = null;
			if(sceneModule.sceneInit.playerListController.getSelf().isMoving)
			{
				sceneModule.sceneInit.playerListController.getSelf().stopMoving();
			}
			SpaSceneLeaveSocketHandler.sendLeave();
		}
			
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
		
		public function get sceneInfo():SceneInfo
		{
			return sceneModule.sceneInfo;
		}
	}
}