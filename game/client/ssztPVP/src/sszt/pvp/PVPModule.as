package sszt.pvp
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToPvPData;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	import sszt.pvp.components.PVP1Panel;
	import sszt.pvp.components.PVPCluePanel;
	import sszt.pvp.components.PVPResultPanel;
	import sszt.pvp.events.PVPMediatorEvent;
	import sszt.pvp.socketHandlers.PVPExploitInfoSocketHandler;
	import sszt.pvp.socketHandlers.PVPSetsocketHandlers;
	
	
	public class PVPModule extends BaseModule
	{
		public var pvpFacade:PVPFacade;
		public var pvp1Panel:PVP1Panel;
		public var pvpResultPanel:PVPResultPanel;
		public var pvpCluePanel:PVPCluePanel;
		public var toPvPData:ToPvPData;
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			toPvPData = data as ToPvPData;
			PVPSetsocketHandlers.add(this);
			pvpFacade = PVPFacade.getInstance(String(moduleId));
			pvpFacade.setup(this,toPvPData);
		}
		
		override public function get moduleId():int
		{
			return ModuleType.PVP1;
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			toPvPData = data as ToPvPData;
			if(pvp1Panel)
				pvp1Panel.dispose();
			if(!toPvPData || toPvPData.openPanel == 0)
			{
				pvpFacade.sendNotification(PVPMediatorEvent.PVP_MEDIATOR_START);
			}
			else if(toPvPData.openPanel == 1)
			{
				pvpFacade.sendNotification(PVPMediatorEvent.PVP_RESULT_PANEL_INIT);
			}
			else if(toPvPData.openPanel == 2)
			{
				pvpFacade.sendNotification(PVPMediatorEvent.PVP_CLUE_PANEL_INIT);
			}
//			if(!pvp1Panel)
//			{				
//				if(GlobalAPI.layerManager.getTopPanel() != pvp1Panel)
//				{
//					pvp1Panel.setToTop();
//				}
//				else
//				{
//					pvp1Panel.dispose();
//					pvp1Panel = null;
//				}
//			}
//			if(pvp1Panel)
//				pvp1Panel.dispose();
//			else
//			{
//				pvpFacade.sendNotification(PVPMediatorEvent.PVP_MEDIATOR_START);
//				
//			}
		}
		
		public function pvpResultPanelShow():void
		{
			if(!pvpResultPanel)
			{
//				pvpResultPanel = new PVPResultPanel();
			}
		}
		
		override public function assetsCompleteHandler():void
		{
			if(pvp1Panel)
			{
				pvp1Panel.assetsCompleteHandler();
			}
			
		}
		override public function dispose():void
		{
			PVPSetsocketHandlers.remove();
			if(pvpFacade)
			{
				pvpFacade.dispose();
				pvpFacade = null;
			}
			if(pvp1Panel)
			{
				pvp1Panel.dispose();
				pvp1Panel = null;
			}
			if(pvpCluePanel)
			{
				pvpCluePanel.dispose();
				pvpCluePanel = null;
			}
			super.dispose();
		}
	}
}