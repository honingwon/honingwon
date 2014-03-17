package sszt.bag
{
	import flash.utils.setTimeout;
	
	import sszt.bag.component.BagPanel;
	import sszt.bag.component.BagSplitPanel;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToBagData;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;

	public class BagModule extends BaseModule
	{
		public var facade:BagFacade;
		public var bagPanel:BagPanel;
		public var splitPanel:BagSplitPanel;
		
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			var toBagData:ToBagData = data as ToBagData;
			facade = BagFacade.getInstance(String(moduleId));
			facade.startup(this,data);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			if(bagPanel)
			{
				if(GlobalAPI.layerManager.getTopPanel() != bagPanel)
					bagPanel.setToTop();
				else if(data.rect!=null)
					bagPanel.setToTop();
				else bagPanel.dispose();
			}
		}
		
		override public function get moduleId():int
		{
			return ModuleType.BAG;
		}
		
		override public function assetsCompleteHandler():void
		{
			if(bagPanel)
			{
				bagPanel.assetsCompleteHandler();
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(bagPanel)
			{
				bagPanel.dispose();
				bagPanel = null;
			}
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
		}
		
		

	}
}