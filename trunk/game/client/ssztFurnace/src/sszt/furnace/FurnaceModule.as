package sszt.furnace
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToFurnaceData;
	import sszt.core.module.BaseModule;
	import sszt.core.utils.SetModuleUtils;
	import sszt.furnace.components.FurnacePanel;
	import sszt.furnace.data.FurnaceInfo;
	import sszt.furnace.events.FurnaceMediatorEvent;
	import sszt.furnace.socketHandlers.FurnaceSetSocketHandler;
	import sszt.interfaces.module.IModule;
	
	/**
	 * 锻造 
	 * @author chendong
	 * 
	 */	
	public class FurnaceModule extends BaseModule
	{
		public var facade:FurnaceFacade; 
		public var furnacePanel:FurnacePanel;
		public var furnaceInfo:FurnaceInfo;
		public var toData:ToFurnaceData;
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			toData = data as ToFurnaceData;
			furnaceInfo = new FurnaceInfo();
			FurnaceSetSocketHandler.addFurnaceSocketHandlers(this);
			facade = FurnaceFacade.getInstance(String(moduleId));
			facade.startup(this);
			configure(data);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			var argIndex:int = (data as ToFurnaceData).selectIndex;
			if(argIndex == 8)
			{
			}
			else
			{
				if(furnacePanel)
				{
					if(GlobalAPI.layerManager.getTopPanel() != furnacePanel)
					{
						furnacePanel.setToTop();
						furnacePanel.setIndex(argIndex);
						furnaceInfo.putAgainHandler((data as ToFurnaceData).itemId);
					}
					else 
					{
						furnacePanel.dispose();
						furnacePanel = null;
						return;
					}
				}
				else
				{
					facade.sendNotification(FurnaceMediatorEvent.FURNACE_MEDIATOR_START);
					if(furnacePanel) furnacePanel.setIndex(argIndex);
					furnaceInfo.putAgainHandler((data as ToFurnaceData).itemId);
				}
			}
			if(furnacePanel)
			{
				GlobalData.furnaceState = 1;
			}
		}
		override public function assetsCompleteHandler():void
		{
			if(furnacePanel) furnacePanel.addAssets();
		}
		
		override public function get moduleId():int
		{
			return ModuleType.FURNACE;
		}
		
		override public function dispose():void
		{
			FurnaceSetSocketHandler.removeFurnaceSocketHandlers();
			if(furnacePanel)
			{
				furnacePanel.dispose();
				furnacePanel = null;
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