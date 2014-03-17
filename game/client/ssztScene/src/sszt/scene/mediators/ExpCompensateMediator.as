package sszt.scene.mediators
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalAPI;
	import sszt.scene.SceneModule;
	import sszt.scene.components.expCompensate.ExpCompensatePanel;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ExpCompensateMediator extends Mediator
	{
		public static const NAME:String = "ExpCompensateMediator";
		
		public function ExpCompensateMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.SCENE_MEDIATOR_SHOWEXPCOMPENSATE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWEXPCOMPENSATE:
					showExpCompensatePanel();
					break;
			}
		}
		
		public function showExpCompensatePanel():void
		{
			if(sceneModule.expCompensatePanel == null)
			{
				sceneModule.expCompensatePanel = new ExpCompensatePanel(this);
				sceneModule.expCompensatePanel.addEventListener(Event.CLOSE,expCompensateCloseHandler);
				GlobalAPI.layerManager.addPanel(sceneModule.expCompensatePanel);
			}
		}
		private function expCompensateCloseHandler(evt:Event):void
		{
			if(sceneModule.expCompensatePanel)
			{
				sceneModule.expCompensatePanel.removeEventListener(Event.CLOSE,expCompensateCloseHandler);
				sceneModule.expCompensatePanel = null;
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