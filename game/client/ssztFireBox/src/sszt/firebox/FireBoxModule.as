package sszt.firebox
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToFireBoxData;
	import sszt.core.module.BaseModule;
	import sszt.core.utils.SetModuleUtils;
	import sszt.firebox.components.FireBoxPanel;
	import sszt.firebox.data.FireBoxMaterialInfo;
	import sszt.firebox.events.FireBoxMediatorEvent;
	import sszt.firebox.socketHandlers.FireBoxSetSocketHandler;
	import sszt.interfaces.module.IModule;
	
	/**
	 * 炼制 
	 * @author chendong
	 * 
	 */	
	public class FireBoxModule extends BaseModule
	{
		public var facade:FireBoxFacade; 
		public var fireBoxPanel:FireBoxPanel;
//		public var fireboxInfo:FireBoxMaterialInfo;
		public var toData:ToFireBoxData;
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
//			fireboxInfo = new FireBoxMaterialInfo();
			toData = data as ToFireBoxData;
			FireBoxSetSocketHandler.addFireBoxSocketHandlers(this);
			facade = FireBoxFacade.getInstance(String(moduleId));
			facade.startup(this);
			configure(data);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			toData = data as ToFireBoxData;
			if(fireBoxPanel)
			{
//				if(GlobalAPI.layerManager.getTopPanel() != fireBoxPanel)
//				{
//					fireBoxPanel.setToTop();
//				}
//				else
//				{
					fireBoxPanel.dispose();
					fireBoxPanel = null;
					return;
//				}	
			}
			else
			{
				facade.sendNotification(FireBoxMediatorEvent.FIREBOX_MEDIATOR_START);
			} 
			if(fireBoxPanel)
			{
				GlobalData.furnaceState = 2;
			}
		}
		override public function assetsCompleteHandler():void
		{
			if(fireBoxPanel) fireBoxPanel.addAssets();
		}
		
		override public function get moduleId():int
		{
			return ModuleType.FIREBOX;
		}
		
		override public function dispose():void
		{
			FireBoxSetSocketHandler.removeFireBoxSocketHandlers();
			if(fireBoxPanel)
			{
				fireBoxPanel.dispose();
				fireBoxPanel = null;
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