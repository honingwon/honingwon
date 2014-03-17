package sszt.scene.mediators
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.changeInfos.ToBossWarIconData;
	import sszt.scene.SceneModule;
	import sszt.scene.components.bossWar.BossIconView;
	import sszt.scene.components.bossWar.BossWarMainPanel;
	import sszt.scene.data.bossWar.BossWarInfo;
	import sszt.scene.events.SceneBossWarUpdateEvent;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.socketHandlers.bossWar.BossWarMainInfoUpdateSocketHandler;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class BossWarMediator extends Mediator
	{
		public static const NAME:String = "bossWarMediator";
		public function BossWarMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
							SceneBossWarUpdateEvent.BOSS_WAR_MAIN_INFO_UPDATE,
							SceneBossWarUpdateEvent.BOSS_WAR_LEFT_TIME_UPDATE,
							SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE
						];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneBossWarUpdateEvent.BOSS_WAR_MAIN_INFO_UPDATE:
					break;
				case SceneBossWarUpdateEvent.BOSS_WAR_LEFT_TIME_UPDATE:
					showBossIconView();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE:
				dispose();
				break;
			}
		}
		
		public function showBossIconView():void
		{
			if(sceneModule.bossIconView == null)
			{
				sceneModule.bossIconView = new BossIconView(this);
				GlobalAPI.layerManager.getPopLayer().addChild(sceneModule.bossIconView);
			}
		}
		
		public function hideBossIconView():void
		{
			
		}
		
		public function showBossMainPanel():void
		{
			if(sceneModule.bossMainPanel == null)
			{
				sceneModule.bossMainPanel = new BossWarMainPanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.bossMainPanel);
				sceneModule.bossMainPanel.addEventListener(Event.CLOSE,closeBossMainPanel);
			}
		}
		
		private function closeBossMainPanel(e:Event):void
		{
			if(sceneModule.bossMainPanel)
			{
				sceneModule.bossMainPanel.removeEventListener(Event.CLOSE,closeBossMainPanel);
				sceneModule.bossMainPanel = null;
			}
		}
		
		public function sendMainInfo(argBossType:int):void
		{
			BossWarMainInfoUpdateSocketHandler.send(argBossType);
		}
		
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
		
		public function get bossWarInfo():BossWarInfo
		{
			return sceneModule.bossWarInfo;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}