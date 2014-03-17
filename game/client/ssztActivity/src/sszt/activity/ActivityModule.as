package sszt.activity
{
	import flash.utils.Dictionary;
	
	import sszt.activity.components.ActivityPanel;
	import sszt.activity.components.EnterCodePanel;
	import sszt.activity.components.panels.ActivityBossPanel;
	import sszt.activity.components.panels.EntrustmentPanel;
	import sszt.activity.components.panels.GetSilverPanel;
	import sszt.activity.data.ActivityInfo;
	import sszt.activity.events.ActivityMediatorEvents;
	import sszt.activity.socketHandlers.ActivitySetSocketHandlers;
	import sszt.constData.moduleViewType.ActivityModuleViewType;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.module.IModule;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;

	public class ActivityModule extends BaseModule
	{
		public var facade:ActivityFacade;
		public var activityPanel:ActivityPanel;
		public var bossPanel:ActivityBossPanel;
		public var codePanel:EnterCodePanel;
		public var activityInfo:ActivityInfo;
		public var levelPromptPanelDic:Dictionary = new Dictionary();
		public var activityStartRemainingPanelDic:Dictionary = new Dictionary();
		public var exchangeSilverMoney:GetSilverPanel;
		public var entrustmentPanel:sszt.interfaces.layer.IPanel;
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			ActivitySetSocketHandlers.addSocketHandler(this);
			activityInfo = new ActivityInfo();
			facade = ActivityFacade.getInstance(moduleId.toString());
			facade.setup(this,data);
			configure(data);
		}
		
		override public function configure(data:Object):void
		{
			var toActivityData:ToActivityData = data as ToActivityData;
			if(toActivityData.type == ActivityModuleViewType.MAIN)
			{
				facade.sendNotification(ActivityMediatorEvents.ACTIVITY_MEDIATOR_START,data);
			}
			else if(toActivityData.type == ActivityModuleViewType.BOSS)
			{
				facade.sendNotification(ActivityMediatorEvents.SHOW_BOSS_PANEL,data);
			}
			else if(toActivityData.type == ActivityModuleViewType.LEVEL_PROMPT)
			{
				facade.sendNotification(ActivityMediatorEvents.SHOW_LEVEL_PROMPT_PANEL,data);
			}
			else if(toActivityData.type == ActivityModuleViewType.ACTIVITY_START_REMAINING)
			{
				facade.sendNotification(ActivityMediatorEvents.SHOW_ACTIVITY_START_REMAINING_PANEL,data);
			}
			else if(toActivityData.type == ActivityModuleViewType.EXCHANGE)
			{
				facade.sendNotification(ActivityMediatorEvents.SHOW_EXCHANGE_PANEL,data);
			}
		}
		
		override public function get moduleId():int
		{
			return ModuleType.ACTIVITY;
		}
		
		override public function dispose():void
		{
			ActivitySetSocketHandlers.removeSocketHandler();
			activityInfo = null;
			if(activityPanel)
			{
				activityPanel.dispose();
				activityPanel = null;
			}
			if(codePanel)
			{
				codePanel.dispose();
				codePanel = null;
			}
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
			super.dispose();
		}
	}
}