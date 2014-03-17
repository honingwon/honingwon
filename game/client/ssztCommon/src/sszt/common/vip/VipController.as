package sszt.common.vip
{
	import flash.events.Event;
	
	import sszt.common.vip.component.VipPanel;
	import sszt.common.vip.component.pop.BuyVipPanel;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.changeInfos.ToVipData;

	public class VipController
	{
		public var module:VipModule;
		
		public function VipController(module:VipModule)
		{
			this.module = module;
		}
		
		public function startUp(data:ToVipData):void
		{
			if(data.type == 0)
			{
				showVipPanel();
			}
			else if(data.type == 1)
			{
				showBuyVipPanel();
			}
		}
		
		public function showVipPanel():void
		{
			if(module.vipPanel == null)
			{
				module.vipPanel = new VipPanel(this);
				module.vipPanel.addEventListener(Event.CLOSE,vipPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(module.vipPanel);
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel()!= module.vipPanel)
				{
					module.vipPanel.setToTop();
				}
				else
				{
					module.vipPanel.dispose();
				}
			}
		}
		
		private function vipPanelCloseHandler(evt:Event):void
		{
			if(module.vipPanel)
			{
				module.vipPanel.removeEventListener(Event.CLOSE,vipPanelCloseHandler);
				module.vipPanel = null;
				if(!module.buyVipPanel)
				{
					module.dispose();
				}
			}
		}
		
		public function showBuyVipPanel():void
		{
			if(module.buyVipPanel == null)
			{
				module.buyVipPanel = new BuyVipPanel(this);
				module.buyVipPanel.addEventListener(Event.CLOSE,buyVipPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(module.buyVipPanel);
			}
		}
		
		private function buyVipPanelCloseHandler(evt:Event):void
		{
			if(module.buyVipPanel)
			{
				module.buyVipPanel.removeEventListener(Event.CLOSE,buyVipPanelCloseHandler);
				module.buyVipPanel = null;
				if(!module.vipPanel)
				{
					module.dispose();
				}
			}
		}
		
		public function dispose():void
		{
		}
	}
}