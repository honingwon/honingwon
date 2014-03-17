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
	import sszt.scene.components.guildPVP.GuildPVPPanel;
	import sszt.scene.components.guildPVP.GuildPVPResultPanel;
	import sszt.scene.data.guildPVP.GuildPVPInfo;
	import sszt.scene.data.guildPVP.GuildPVPInfoUpdateEvent;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.socketHandlers.guildPVP.GuildPVPReloadSocketHandler;
	
	public class GuildPVPMediator extends Mediator
	{
		public static const NAME:String = "guildPVPMediator";
		
		public function GuildPVPMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.GUILD_PVP_START,
				SceneMediatorEvent.GUILD_PVP_END,
				SceneMediatorEvent.GUILD_PVP_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.GUILD_PVP_START:
					showMainPanel();
			}
		}
		
		private function showMainPanel():void
		{
			if(sceneModule.guildPVPPanel) return;
			GuildPVPReloadSocketHandler.send();
			sceneModule.guildPVPPanel = new GuildPVPPanel();
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CLOSE_FOLLOW_COMPLETE));//隐藏任务栏
			GlobalAPI.layerManager.getPopLayer().addChild(sceneModule.guildPVPPanel);
//			sceneModule.guildPVPPanel.updateCountDownView(guildPVPInfo.time);
//			sceneModule.guildPVPPanel.updateReward(guildPVPInfo.totalTime,guildPVPInfo.itemList);
			guildPVPInfo.addEventListener(GuildPVPInfoUpdateEvent.KILL_UPDATE,guildPVPKillUpdateHandler);
			guildPVPInfo.addEventListener(GuildPVPInfoUpdateEvent.RESULT_UPDATE,guildPVPResultUpdateHandler);
			guildPVPInfo.addEventListener(GuildPVPInfoUpdateEvent.RELOAD_UPDATE,guildPVPReloadUpdateHandler);
			guildPVPInfo.addEventListener(GuildPVPInfoUpdateEvent.NICK_UPDATE,guildPVPNickUpdateHandler);
			
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_SCENE, changeSceneHandler);
			function changeSceneHandler(e:Event):void
			{
				if(!MapTemplateList.isGuildPVP())
				{
					ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE, changeSceneHandler);
					if(sceneModule.guildPVPPanel)
					{
						sceneModule.guildPVPPanel.dispose();
						sceneModule.guildPVPPanel = null;
					}
					guildPVPInfo.removeEventListener(GuildPVPInfoUpdateEvent.KILL_UPDATE,guildPVPKillUpdateHandler);
					guildPVPInfo.removeEventListener(GuildPVPInfoUpdateEvent.RESULT_UPDATE,guildPVPResultUpdateHandler);
					guildPVPInfo.removeEventListener(GuildPVPInfoUpdateEvent.RELOAD_UPDATE,guildPVPReloadUpdateHandler);
					guildPVPInfo.removeEventListener(GuildPVPInfoUpdateEvent.NICK_UPDATE,guildPVPNickUpdateHandler);
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_SHOW_FOLLOW_COMPLETE));//显示任务栏
				}
			}
		}
		
		private function guildPVPResultUpdateHandler(event:Event):void
		{
			showGuildPVPResultPanel();
		}
		
		private function showGuildPVPResultPanel():void
		{
			var panel:GuildPVPResultPanel = new GuildPVPResultPanel(guildPVPInfo.totalTime,guildPVPInfo.nick,guildPVPInfo.index,guildPVPInfo.rewardItemId,guildPVPInfo.rankList);
			GlobalAPI.layerManager.addPanel(panel);
		}
		
		private function guildPVPKillUpdateHandler(event:Event):void
		{
			sceneModule.guildPVPPanel.updateView(guildPVPInfo.totalTime);
		}
		
		private function guildPVPNickUpdateHandler(event:Event):void
		{
			sceneModule.guildPVPPanel.updateNick(guildPVPInfo.nick);		
		}
		
		private function guildPVPReloadUpdateHandler(event:Event):void
		{
			sceneModule.guildPVPPanel.updateCountDownView(guildPVPInfo.time);
			sceneModule.guildPVPPanel.updateReward(guildPVPInfo.totalTime,guildPVPInfo.itemList);	
			if(guildPVPInfo.nick.length >1)
				sceneModule.guildPVPPanel.updateNick(guildPVPInfo.nick);
		}
		
		public function get guildPVPInfo():GuildPVPInfo
		{
			return sceneModule.guildPVPInfo;
		}
		
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
	}
}