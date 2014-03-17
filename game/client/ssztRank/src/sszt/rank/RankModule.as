package sszt.rank
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.ModuleType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.module.BaseModule;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.module.IModule;
	import sszt.rank.components.RankPanel;
	import sszt.rank.data.RankInfo;
	import sszt.rank.events.RankMediatorEvents;
	import sszt.rank.socketHandlers.RankSetSocketHandler;
	
	public class RankModule extends BaseModule
	{
		public var rankPanel:RankPanel;
		public var facade:RankFacade;
		
		public var rankInfos:RankInfo;
		
		public function RankModule()
		{
			super();
		}
		
		override public function setup(prev:IModule, data:Object = null):void
		{
			rankInfos = new RankInfo();
			RankSetSocketHandler.addHandlers(this);
			
			facade = RankFacade.getInstance(moduleId.toString());
			facade.setup(this);
			
			configure(data);
		}
		
		override public function configure(data:Object):void
		{
			if(GlobalData.selfPlayer.level < 35) 
			{
				QuickTips.show(LanguageManager.getWord('ssztl.rank.notEnoughLevel'));
				return;
			}
			if(rankPanel)
			{
				if(GlobalAPI.layerManager.getTopPanel() != rankPanel)
				{
					rankPanel.setToTop();
				}
				else
				{
					rankPanel.dispose();
					return;
				}
			}
			facade.sendNotification(RankMediatorEvents.SHOW_RANK_PANEL);
		}
		
		override public function get moduleId():int
		{
			return ModuleType.RANK;
		}
		
		override public function dispose():void
		{
			RankSetSocketHandler.removeHandlers();
			if(rankPanel)
			{
				rankPanel.dispose();
				rankPanel = null;
			}
			
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
			
			rankInfos = null;
			super.dispose();
		}
	}
}