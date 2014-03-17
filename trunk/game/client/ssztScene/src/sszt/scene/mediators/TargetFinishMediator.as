package sszt.scene.mediators
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.scene.SceneModule;
	import sszt.scene.components.target.TargetFinishPanel;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class TargetFinishMediator extends Mediator
	{
		public static const NAME:String = "targetFinishMediator";
		
		public function TargetFinishMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			switch(notification.getName())
			{
				case SceneMediatorEvent.TARGET_FINISH_PANEL:
					showTargetFinishPanel();
					break;
				case SceneMediatorEvent.TARGET_FINISH_DISPOSE:
					dispose();
			}
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return [
				SceneMediatorEvent.TARGET_FINISH_PANEL,
				SceneMediatorEvent.TARGET_FINISH_DISPOSE
			];
		}
		
		private function showTargetFinishPanel():void
		{
			if(sceneModule.targetFinishPanel == null)
			{
				sceneModule.targetFinishPanel = new TargetFinishPanel();
				GlobalAPI.layerManager.getTipLayer().addChild(sceneModule.targetFinishPanel);
			}
		}
		
		public function dispose():void
		{
			if(sceneModule.targetFinishPanel)
			{
				sceneModule.targetFinishPanel.dispose();
				sceneModule.targetFinishPanel = null;
			}
			viewComponent = null;
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