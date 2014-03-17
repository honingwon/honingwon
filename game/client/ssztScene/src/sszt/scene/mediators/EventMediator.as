package sszt.scene.mediators
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.systemMessage.SystemMessageInfo;
	import sszt.scene.SceneModule;
	import sszt.scene.components.eventList.EventPanel;
	import sszt.scene.components.eventList.SceneEventView;
	import sszt.scene.components.eventList.SceneHidePlayerView;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class EventMediator extends Mediator
	{
		public static const NAME:String = "EventMediator";
		
		public function EventMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.SCENE_MEDIATOR_START,
				SceneMediatorEvent.SCENE_MEDIATOR_EVENTPANEL,
				SceneMediatorEvent.SCENE_ADD_EVENTLIST,
				SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SCENE_MEDIATOR_START:
					initView();
					initHidePlayerIconView();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_EVENTPANEL:
					showEventPanel();
					break;
				case SceneMediatorEvent.SCENE_ADD_EVENTLIST:
					addEventList(notification.getBody() as String);
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function initView():void
		{
			if(sceneModule.eventView == null)
			{
				sceneModule.eventView = new SceneEventView(this);
				sceneModule.addChild(sceneModule.eventView);
			}
		}
		
		private function initHidePlayerIconView():void
		{
			if(sceneModule.hidePlayerIconVIew == null)
			{
				sceneModule.hidePlayerIconVIew = new SceneHidePlayerView(this);
				sceneModule.addChild(sceneModule.hidePlayerIconVIew);
			}
		}
		
		public function showEventPanel():void
		{
			if(sceneModule.eventPanel == null)
			{
				sceneModule.eventPanel = new EventPanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.eventPanel);
				sceneModule.eventPanel.addEventListener(Event.CLOSE,eventPanelCloseHandler);
			}else if(sceneModule.eventPanel.parent)
			{
				sceneModule.eventPanel.dispose();
			}
		}
		
		private function eventPanelCloseHandler(evt:Event):void
		{
			if(sceneModule.eventPanel)
			{
				sceneModule.eventPanel.removeEventListener(Event.CLOSE,eventPanelCloseHandler);
				sceneModule.eventPanel = null;
			}
		}
		
		private function addEventList(mes:String):void
		{
			sceneInfo.eventList.addEvent(mes);
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