package sszt.scene.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.cityCraft.CityCraftEvent;
	import sszt.core.data.cityCraft.CityCraftInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.cityCraft.CityCraftEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	import sszt.scene.components.cityCraft.CityCraftPanel;
	import sszt.scene.components.cityCraft.CityCraftResultPanel;
	import sszt.scene.components.guildPVP.GuildPVPResultPanel;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class CityCraftMediator extends Mediator
	{
		public static const NAME:String = "cityCraftMediator";
		
		public function CityCraftMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.CITY_CRAFT_START
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.CITY_CRAFT_START:
					showMainPanel();
			}
		}
		
		private function showMainPanel():void
		{
			if(sceneModule.cityCraftPanel) return;
			sceneModule.cityCraftPanel = new CityCraftPanel();
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CLOSE_FOLLOW_COMPLETE));//隐藏任务栏
			GlobalAPI.layerManager.getPopLayer().addChild(sceneModule.cityCraftPanel);
			cityCraftInfo.addEventListener(CityCraftEvent.RANK_LIST_UPDATE,rankListUpdateHandler);
			cityCraftInfo.addEventListener(CityCraftEvent.RESULT_UPDATE,guildPVPResultUpdateHandler);
			
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_SCENE, changeSceneHandler);
			function changeSceneHandler(e:Event):void
			{
				if(!MapTemplateList.isGuildPVP())
				{
					ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE, changeSceneHandler);
					if(sceneModule.cityCraftPanel)
					{
						sceneModule.cityCraftPanel.dispose();
						sceneModule.cityCraftPanel = null;
					}
					cityCraftInfo.removeEventListener(CityCraftEvent.RANK_LIST_UPDATE,rankListUpdateHandler);
					cityCraftInfo.removeEventListener(CityCraftEvent.RESULT_UPDATE,guildPVPResultUpdateHandler);
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_SHOW_FOLLOW_COMPLETE));//显示任务栏
				}
			}
		}
		
		private function guildPVPResultUpdateHandler(event:Event):void
		{
			var panel:CityCraftResultPanel = new CityCraftResultPanel(cityCraftInfo.selfPoint,cityCraftInfo.selfIndex,cityCraftInfo.awardItem,cityCraftInfo.result,cityCraftInfo.guildNick,cityCraftInfo.rankList);
			GlobalAPI.layerManager.addPanel(panel);
		}		
		
		private function rankListUpdateHandler(event:Event):void
		{
			sceneModule.cityCraftPanel.updateRankList(cityCraftInfo.HP,cityCraftInfo.selfPoint,cityCraftInfo.selfCamp,cityCraftInfo.rankList);
		}
		
		public function get cityCraftInfo():CityCraftInfo
		{
			return GlobalData.cityCraftInfo;
		}
		
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
	}
}