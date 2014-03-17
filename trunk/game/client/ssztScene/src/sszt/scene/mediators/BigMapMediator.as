package sszt.scene.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.utils.AssetUtil;
	import sszt.scene.SceneModule;
	import sszt.scene.components.newBigMap.MapPanel;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class BigMapMediator extends Mediator
	{
		public static const NAME:String = "BigMapMediator";
		
		public function BigMapMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.SCENE_MEDIATOR_SHOWBIGMAP,
				SceneMediatorEvent.SCENE_MEDIATOR_CHANGESCENE,
				SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SCENE_MEDIATOR_SHOWBIGMAP:
					showBigMap();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_CHANGESCENE:
					changeBigMap();
				case SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function showBigMap():void
		{
			if(sceneModule.bigMapPanel == null)
			{
				if(!sceneInfo.playerList.self)return;
				sceneModule.bigMapPanel = new MapPanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.bigMapPanel);
				sceneModule.bigMapPanel.addEventListener(Event.CLOSE,closeHandler);
			}
			else
			{
//				if(GlobalAPI.layerManager.getTopPanel() != sceneModule.bigMapPanel)
//				{
//					sceneModule.bigMapPanel.setToTop();
//				}
//				else 
					sceneModule.bigMapPanel.dispose();
					sceneModule.bigMapPanel = null;
			}
		}
		
		private function changeBigMap():void
		{
		}
		
		private function closeHandler(e:Event):void
		{
			if(sceneModule.bigMapPanel)
			{
				sceneModule.bigMapPanel.removeEventListener(Event.CLOSE,closeHandler);
				sceneModule.bigMapPanel = null;
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
			
		}
	}
}