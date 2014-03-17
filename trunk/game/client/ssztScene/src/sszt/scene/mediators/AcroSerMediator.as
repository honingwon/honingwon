package sszt.scene.mediators
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalAPI;
	import sszt.scene.SceneModule;
	import sszt.scene.components.acrossServer.AcroSerIconView;
	import sszt.scene.components.acrossServer.AcroSerMainPanel;
	import sszt.scene.data.bossWar.BossWarInfo;
	import sszt.scene.events.SceneAcroSerUpdateEvent;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.socketHandlers.acrossServer.AcroSerBossEnterSocketHandler;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class AcroSerMediator extends Mediator
	{
		private static var NAME:String = "acroSerMediator";
		public function AcroSerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [SceneAcroSerUpdateEvent.ACROSER_ICON_UPDATE,
					     SceneAcroSerUpdateEvent.ACROSER_SHOW_MAIN_PANEL,
					   	 SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneAcroSerUpdateEvent.ACROSER_ICON_UPDATE:
					showAcroSerIcon();
				break;
				case  SceneAcroSerUpdateEvent.ACROSER_SHOW_MAIN_PANEL:
					showAcroSerMainPanel();
				break;
				case SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE:
					dispose();
				break;
			}
		}
		
		
		public function showAcroSerMainPanel():void
		{
			if(sceneModule.acroSerMainPanel == null)
			{
				sceneModule.acroSerMainPanel = new AcroSerMainPanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.acroSerMainPanel);
				sceneModule.acroSerMainPanel.addEventListener(Event.CLOSE,hideAcroSerMainPanel);
			}
		}
		
		private function hideAcroSerMainPanel(e:Event):void
		{
			if(sceneModule.acroSerMainPanel)
			{
				sceneModule.acroSerMainPanel.removeEventListener(Event.CLOSE,hideAcroSerMainPanel);
				sceneModule.acroSerMainPanel = null;
			}
		}
		
		public function showAcroSerIcon():void
		{
			if(sceneModule.acroSerIconView == null)
			{
				sceneModule.acroSerIconView = new AcroSerIconView(this);
				GlobalAPI.layerManager.getPopLayer().addChild(sceneModule.acroSerIconView);
			}
		}
		
		public function hideAcroSerIcon(e:Event):void
		{
			
		}
		
		
		public function sendEnter(argMonsterMapId:int):void
		{
			AcroSerBossEnterSocketHandler.send(argMonsterMapId);
		}
		
		
		public function get bossWarInfo():BossWarInfo
		{
			return sceneModule.bossWarInfo;
		}
		
		public function get sceneModule():SceneModule
		{
			return viewComponent  as SceneModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}