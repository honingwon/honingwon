package sszt.scene.mediators
{
	import sszt.scene.SceneModule;
	import sszt.scene.components.elementInfoView.ElementInfoContainer;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ElementInfoMediator extends Mediator
	{
		public static const NAME:String = "elementInfoMediator";
		
		public function ElementInfoMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.SCENE_MEDIATOR_START,
				SceneMediatorEvent.SCENE_MEDIATOR_CHANGESCENE,
				SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SCENE_MEDIATOR_START:
					initElementPanel();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_CHANGESCENE:
					changeScene();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function initElementPanel():void
		{
			if(sceneModule.elementInfoContainer == null)
			{
				sceneModule.elementInfoContainer = new ElementInfoContainer(this);
				sceneModule.addChild(sceneModule.elementInfoContainer);
			}
		}
		
		private function changeScene():void
		{
		}
		
		public function sit():void
		{
			facade.sendNotification(SceneMediatorEvent.SIT);
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