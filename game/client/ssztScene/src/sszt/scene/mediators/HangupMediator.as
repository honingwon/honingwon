package sszt.scene.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.scene.SceneModule;
	import sszt.scene.components.hangup.HangupPanel;
	import sszt.scene.components.hangup.NewHandupPanel;
	import sszt.scene.components.hangup.SimpleHandupPanel;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class HangupMediator extends Mediator
	{
		public static const NAME:String = "HangupMediator";
		
		public function HangupMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.SCENE_MEDIATOR_SHOWHANGUP,
				SceneMediatorEvent.SCENE_MEDIATOR_SHOWSIMPLEHANDUP,
				SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWHANGUP:
					initView();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWSIMPLEHANDUP:
					initSimpleView();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function initView():void
		{
			if(sceneModule.hangupPanel == null)
			{
				sceneModule.hangupPanel = new NewHandupPanel(this);
				sceneModule.hangupPanel.addEventListener(Event.CLOSE,hangupCloseHandler);
				GlobalAPI.layerManager.addPanel(sceneModule.hangupPanel);
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel() != sceneModule.hangupPanel)
				{
					sceneModule.hangupPanel.setToTop();
				}
				else
				{
					sceneModule.hangupPanel.dispose();
				}
			}
		}
		private function initSimpleView():void
		{			
			if(sceneModule.simpleHandupPanel == null)
			{
				sceneModule.simpleHandupPanel = new SimpleHandupPanel(this);
				sceneModule.simpleHandupPanel.addEventListener(Event.CLOSE,simpleHandupCloseHandler);
				GlobalAPI.layerManager.addPanel(sceneModule.simpleHandupPanel);
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel() != sceneModule.simpleHandupPanel)
				{
					sceneModule.simpleHandupPanel.setToTop();
				}
				else
				{
					sceneModule.simpleHandupPanel.dispose();
				}
			}
		}
		private function hangupCloseHandler(evt:Event):void
		{
			if(sceneModule.hangupPanel)
			{
				sceneModule.hangupPanel.removeEventListener(Event.CLOSE,hangupCloseHandler);
				sceneModule.hangupPanel = null;
			}
		}
		private function simpleHandupCloseHandler(evt:Event):void
		{
			if(sceneModule.simpleHandupPanel)
			{
				sceneModule.simpleHandupPanel.removeEventListener(Event.CLOSE,simpleHandupCloseHandler);
				sceneModule.simpleHandupPanel = null;
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
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}