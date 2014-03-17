package sszt.stall
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToStallData;
	import sszt.core.data.stall.StallInfo;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	import sszt.stall.compoments.StallPanel;
	import sszt.stall.compoments.StallShopPanel;
	import sszt.stall.compoments.popUpPanel.StallBuyPopUpPanel;
	import sszt.stall.compoments.popUpPanel.StallSalePopUpPanel;
	import sszt.stall.compoments.popUpPanel.StallShopBegSalePopUpPanel;
	import sszt.stall.compoments.popUpPanel.StallShopBuyPopUpPanel;
	import sszt.stall.compoments.popUpPanel.StallShopSalePopUpPanel;
	import sszt.stall.data.StallShopInfo;
	import sszt.stall.socketHandlers.StallSetSocketHandlers;


	public class StallModule extends BaseModule
	{
		public var stallFacade:StallFacade;
		public var stallPanel:StallPanel;
		public var stallSalePopUpPanel:StallSalePopUpPanel;
		public var stallBuyPopUpPanel:StallBuyPopUpPanel;
		public var stallShopPanel:StallShopPanel;
		
		public var stallShopBegSalePopUpPanel:StallShopBegSalePopUpPanel;
		public var stallShopBuyPopUpPanel:StallShopBuyPopUpPanel;
		public var stallShopSalePopUpPanel:StallShopSalePopUpPanel;
		
		public var stallShopInfo:StallShopInfo;
		public var isMyselfTag:Boolean;
		public var userId:Number;
		public var userName:String;
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			var toSallData:ToStallData = data as ToStallData;
			userId = toSallData.playerId;
			userName = toSallData.playerName;
			stallShopInfo = new StallShopInfo();
			
			if(GlobalData.selfPlayer.userId == userId)
			{
				isMyselfTag = true;
				StallSetSocketHandlers.addStall(this);
			}
			else
			{
				isMyselfTag = false;
				StallSetSocketHandlers.addStallShop(this);
			}
			stallFacade = StallFacade.getInstance(moduleId.toString());
			stallFacade.setup(this);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			if(stallPanel)
			{				
				if(GlobalAPI.layerManager.getTopPanel() != stallPanel)
				{
					stallPanel.setToTop();
				}
				else
				{
					stallPanel.dispose();
					stallPanel = null;
				}
			}
			if(stallShopPanel)
			{				
				if(GlobalAPI.layerManager.getTopPanel() != stallShopPanel)
				{
					stallShopPanel.setToTop();
				}
				else
				{
					stallShopPanel.dispose();
					stallShopPanel = null;
				}
			}
		}
		
		
		override public function get moduleId():int
		{
			return ModuleType.STALL;
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(stallFacade)
			{
				stallFacade.dispose();
				stallFacade = null;
			}
			if(isMyselfTag)
			{
				StallSetSocketHandlers.removeStall();
			}
			else
			{
				StallSetSocketHandlers.removeStallShop();
			}
			if(stallPanel)
			{
				stallPanel.dispose()
				stallPanel = null;
			}
			if(stallSalePopUpPanel)
			{
				stallSalePopUpPanel.dispose();
				stallSalePopUpPanel = null;
			}
			if(stallBuyPopUpPanel)
			{
				stallBuyPopUpPanel.dispose();
				stallBuyPopUpPanel = null;
			}
			if(stallShopPanel)
			{
				stallShopPanel.dispose();
				stallShopPanel = null;
			}
			if(stallShopBegSalePopUpPanel)
			{
				stallShopBegSalePopUpPanel.dispose();
				stallShopBegSalePopUpPanel = null;
			}
			if(stallShopBuyPopUpPanel)
			{
				stallShopBuyPopUpPanel.dispose();
				stallShopBuyPopUpPanel = null;
			}
			if(stallShopSalePopUpPanel)
			{
				stallShopSalePopUpPanel.dispose();
				stallShopSalePopUpPanel = null;
			}
			stallShopInfo = null;
		}
	}
}