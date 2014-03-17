package sszt.common.bagSell
{
	import sszt.common.bagSell.component.BagSellPanel;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.ModuleType;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	
	public class BagSellModule extends BaseModule
	{
		public var bagSellPanel:BagSellPanel;
		public var controller:BagSellController;
		
		override public function configure(data:Object):void
		{
			// TODO Auto Generated method stub
			super.configure(data);
			if(bagSellPanel)
			{
				if(GlobalAPI.layerManager.getTopPanel()!= bagSellPanel)
				{
//					bagSellPanel.setToTop();
				}else
				{
					bagSellPanel.dispose();
				}
			}
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			if(bagSellPanel)
			{
				bagSellPanel.dispose();
				bagSellPanel = null;
			}
			if(controller)
			{
				controller = null;
			}
			GlobalData.clientBagInfo.bagSellIsOpen = false;
			super.dispose();
		}
		
		override public function get moduleId():int
		{
			// TODO Auto Generated method stub
			return ModuleType.BAGSELL;
		}
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			// TODO Auto Generated method stub
			super.setup(prev, data);
			controller = new BagSellController(this);
			controller.startUp();
			GlobalData.clientBagInfo.bagSellIsOpen = true;
		}
		
	}
}