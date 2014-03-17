package sszt.common.wareHouse
{
	import flash.events.Event;
	
	import sszt.ui.event.CloseEvent;
	
	import sszt.common.wareHouse.component.PopUpPanel;
	import sszt.common.wareHouse.component.WareHousePanel;
	import sszt.core.data.GlobalAPI;

	public class WareHouseController
	{
		public var module:WareHouseModule;
		
		public function WareHouseController(module:WareHouseModule)
		{
			this.module = module;
		}
		
		public function startup(data:Object = null):void
		{
			if(module.warehousePanel == null)
			{
				module.warehousePanel = new WareHousePanel(this,data);
				GlobalAPI.layerManager.addPanel(module.warehousePanel);
				module.warehousePanel.addEventListener(Event.CLOSE,warehousePanelCloseHandler);
			}
		}
		
		private function warehousePanelCloseHandler(evt:Event):void
		{
			if(module.warehousePanel)
			{
				module.warehousePanel.removeEventListener(Event.CLOSE,warehousePanelCloseHandler);
				module.warehousePanel = null;
				module.dispose();
			}
		}
				
		public function dispose():void
		{
			module = null;
		}
	}
}