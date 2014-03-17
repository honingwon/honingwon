package sszt.scene.mediators
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalAPI;
	import sszt.scene.SceneModule;
	import sszt.scene.components.nearly.NearlyPanel;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.socketHandlers.TeamInviteSocketHandler;
	import sszt.scene.socketHandlers.TeamNofullMsgSocketHandler;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class NearlyMediator extends Mediator
	{
		public static const NAME:String = "NearlyMediator";
		
		public function NearlyMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.SCENE_MEDIATOR_SHOWNEARLY,
				SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWNEARLY:
					initView();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function initView():void
		{
			if(sceneModule.nearlyPanel == null)
			{
				sceneModule.nearlyPanel = new NearlyPanel(this);
				sceneModule.nearlyPanel.addEventListener(Event.CLOSE,nearlyCloseHandler);
				GlobalAPI.layerManager.addPanel(sceneModule.nearlyPanel);
			}
		}
		private function nearlyCloseHandler(evt:Event):void
		{
			if(sceneModule.nearlyPanel)
			{
				sceneModule.nearlyPanel.removeEventListener(Event.CLOSE,nearlyCloseHandler);
				sceneModule.nearlyPanel = null;
				sceneInfo.nearData.clearData();
			}
		}
		
		public function sendInvite(name:String,serverId:int):void
		{
			TeamInviteSocketHandler.sendInvite(serverId,name);
		}
		
		public function getNearlyData():void
		{
			TeamNofullMsgSocketHandler.send();
		}
		
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
		public function get sceneInfo():SceneInfo
		{
			return sceneModule.sceneInfo;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}