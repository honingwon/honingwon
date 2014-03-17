package sszt.scene.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.scene.SceneModule;
	import sszt.scene.components.doubleSit.DoubleSitPanel;
	import sszt.scene.components.lifeExpSit.LifeExpSitPanel;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class LifeExpSitMediator extends Mediator
	{
		public static const NAME:String = "LifeExpSitMediator";
		
		public function LifeExpSitMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.SCENE_SHOW_LIFE_EXP_SIT
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SCENE_SHOW_LIFE_EXP_SIT:
					showLifeExpSitPanel();
					break;
			}
		}
		
		public function showLifeExpSitPanel():void
		{
			if(sceneModule.lifeExpSitPanel == null)
			{
				sceneModule.lifeExpSitPanel = new LifeExpSitPanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.lifeExpSitPanel);
				sceneModule.lifeExpSitPanel.addEventListener(Event.CLOSE,lifeExpSitCloseHandler);
			}
		}
		private function lifeExpSitCloseHandler(evt:Event):void
		{
			if(sceneModule.lifeExpSitPanel)
			{
				sceneModule.lifeExpSitPanel.removeEventListener(Event.CLOSE,lifeExpSitCloseHandler);
				sceneModule.lifeExpSitPanel = null;
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