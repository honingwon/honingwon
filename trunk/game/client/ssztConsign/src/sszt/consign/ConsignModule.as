package sszt.consign
{
	import sszt.consign.components.SearchConsignPanel;
	import sszt.consign.components.popupPanel.YuanBaoPopUpPanel;
	import sszt.consign.components.quickConsign.QuickConsignPanel;
	import sszt.consign.data.ConsignInfo;
	import sszt.consign.data.GoldConsignInfo;
	import sszt.consign.events.ConsignMediatorEvents;
	import sszt.consign.socketHandlers.ConsignSetSocketHandler;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToConsignData;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	
	public class ConsignModule extends BaseModule
	{
		public var consignPanel:SearchConsignPanel;
		public var facade:ConsignFacade;
		public var quickPanel:QuickConsignPanel;
		
		public var goldConsignInfo:GoldConsignInfo;
		public var consignInfo:ConsignInfo;
		
		private var _assetsComplete:Boolean;
		
		public function get assetsComplete():Boolean
		{
			return _assetsComplete;
		}
		
		public function ConsignModule()
		{
			super();
		}
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			goldConsignInfo = new GoldConsignInfo();
			consignInfo = new ConsignInfo();
			ConsignSetSocketHandler.addHandlers(this);
			
			facade = ConsignFacade.getInstance(moduleId.toString());
			facade.setup(this);
			
			configure(data);
		}
		
		
		override public function assetsCompleteHandler():void
		{
			_assetsComplete = true;
			if(quickPanel)
			{
				quickPanel.assetsCompleteHandler();
			}
			
			if(consignPanel)
			{
				consignPanel.assetsCompleteHandler();
			}
			
		}
		
		
		override public function configure(data:Object):void
		{
			var toConsignData:ToConsignData = data as ToConsignData;
			
			if(toConsignData == null || toConsignData.type == 1)
			{
				if(consignPanel)
				{
					if(GlobalAPI.layerManager.getTopPanel() != consignPanel)
					{
						consignPanel.setToTop();
					}
					else
					{
						consignPanel.dispose();
						return;
					}	
				}
				consignInfo.updatePlace(-1);
				facade.sendNotification(ConsignMediatorEvents.SHOW_SEARCH_PANEL);
			}
			else if(toConsignData.type == 2)
			{
				if(quickPanel)
				{
					if(GlobalAPI.layerManager.getTopPanel() != quickPanel)
					{
						quickPanel.setToTop();
					}
					else
					{
						quickPanel.dispose();
						return;
					}	
				}
				
				facade.sendNotification(ConsignMediatorEvents.SHOW_QUICKCONSIGN_PANEL,toConsignData.index);
				consignInfo.updatePlace(toConsignData.place);
			}
		}
		
		override public function get moduleId():int
		{
			return ModuleType.CONSIGN;
		}
		
		override public function dispose():void
		{
			ConsignSetSocketHandler.removeHandlers();
			if(consignPanel)
			{
				consignPanel.dispose();
				consignPanel = null;
			}
			if(quickPanel)
			{
				quickPanel.dispose();
				quickPanel = null;
			}
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
			goldConsignInfo = null;
			consignInfo = null;
			super.dispose();
		}
	}
}