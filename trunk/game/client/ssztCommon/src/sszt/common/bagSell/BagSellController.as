package sszt.common.bagSell
{
	import flash.events.Event;
	
	import sszt.common.bagSell.component.BagSellPanel;
	import sszt.core.data.GlobalAPI;

	public class BagSellController
	{
		public var module:BagSellModule;
		
		public function BagSellController(module:BagSellModule)
		{
			this.module = module;
		}
		
		public function startUp():void
		{
			if(module.bagSellPanel == null)
			{
				module.bagSellPanel = new BagSellPanel(this);
				module.bagSellPanel.addEventListener(Event.CLOSE,closeHandler);
				GlobalAPI.layerManager.addPanel(module.bagSellPanel);
			}
		}
		
		private function closeHandler(evt:Event):void
		{
			if(module.bagSellPanel)
			{
				module.bagSellPanel.removeEventListener(Event.CLOSE,closeHandler);
				module.bagSellPanel = null;
				module.dispose();
			}
		}
	}
}