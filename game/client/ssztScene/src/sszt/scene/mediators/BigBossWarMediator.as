package sszt.scene.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.map.MapTemplateList;
	import sszt.events.SceneModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	import sszt.scene.components.bigBossWar.BigBossWarPanel;
	import sszt.scene.components.bigBossWar.BigBossWarResultPanel;
	import sszt.scene.data.bigBossWar.BigBossWarInfo;
	import sszt.scene.data.bigBossWar.BigBossWarInfoUpdateEvent;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.ui.container.MAlert;
	
	public class BigBossWarMediator extends Mediator
	{
		public static const NAME:String = "bigBossWarMediator";
		
		public function BigBossWarMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.BIG_BOSS_WAR_START,
				SceneMediatorEvent.BIG_BOSS_WAR_END,
				SceneMediatorEvent.BIG_BOSS_WAR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.BIG_BOSS_WAR_START:
					showMainPanel();
			}
		}
		
		private function showMainPanel():void
		{
			if(sceneModule.bigBossWarPanel) return;
			sceneModule.bigBossWarPanel = new BigBossWarPanel();
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CLOSE_FOLLOW_COMPLETE));//隐藏任务栏
			GlobalAPI.layerManager.getPopLayer().addChild(sceneModule.bigBossWarPanel);
			
			bigBossWarInfo.addEventListener(BigBossWarInfoUpdateEvent.DAMAGE_RANK_UPDATE,bigBossWarDamageRankUpdateHandler);
			bigBossWarInfo.addEventListener(BigBossWarInfoUpdateEvent.RESULT_UPDATE,bigBossWarResultUpdateHandler);
			
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_SCENE, changeSceneHandler);
			function changeSceneHandler(e:Event):void
			{
				if(!MapTemplateList.isBigBossWar())
				{
					ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE, changeSceneHandler);
					if(sceneModule.bigBossWarPanel)
					{
						sceneModule.bigBossWarPanel.dispose();
						sceneModule.bigBossWarPanel = null;
					}
					bigBossWarInfo.removeEventListener(BigBossWarInfoUpdateEvent.DAMAGE_RANK_UPDATE,bigBossWarDamageRankUpdateHandler);
					bigBossWarInfo.removeEventListener(BigBossWarInfoUpdateEvent.RESULT_UPDATE,bigBossWarResultUpdateHandler);
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_SHOW_FOLLOW_COMPLETE));//显示任务栏
				}
			}
		}
		
		private function bigBossWarResultUpdateHandler(event:Event):void
		{
			showBigBossResultPanel();
		}
		
		private function showBigBossResultPanel():void
		{
			var panel:BigBossWarResultPanel = new BigBossWarResultPanel(bigBossWarInfo.isLive,bigBossWarInfo.rewardItemId,bigBossWarInfo.myDamage);
			GlobalAPI.layerManager.addPanel(panel);
		}
		
		private function bigBossWarDamageRankUpdateHandler(event:Event):void
		{
			sceneModule.bigBossWarPanel.updateView(bigBossWarInfo.damageRank,bigBossWarInfo.myDamage,bigBossWarInfo.totalDamage,bigBossWarInfo.nick);
		}
		
		public function get bigBossWarInfo():BigBossWarInfo
		{
			return sceneModule.bigBossWarInfo;
		}
		
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
	}
}