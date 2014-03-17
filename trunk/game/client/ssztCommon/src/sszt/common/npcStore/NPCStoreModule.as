package sszt.common.npcStore
{
	import flash.utils.setTimeout;
	
	import sszt.common.npcStore.components.NPCStorePanel;
	import sszt.common.npcStore.controllers.NPCStoreController;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToNpcStoreData;
	import sszt.core.module.BaseModule;
	import sszt.core.utils.SetModuleUtils;
	import sszt.interfaces.module.IModule;
	
	public class NPCStoreModule extends BaseModule
	{
		public var npcStorePanel:NPCStorePanel;
		public var npcStoreController:NPCStoreController;
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			npcStoreController = new NPCStoreController(this);
			npcStoreController.startup(data);
			GlobalData.clientBagInfo.npcStoreIsOpen = true;
			setTimeout(addBag,50);
			function addBag():void
			{
				SetModuleUtils.addBag(GlobalAPI.layerManager.getTopPanelRec());
			}
		}
		
		override public  function get moduleId():int
		{
			return ModuleType.NPCSTORE;
		}
		
		override public function dispose():void
		{
			if(npcStorePanel)
			{
				npcStorePanel.dispose();
				npcStorePanel = null;
			}
			if(npcStoreController)
			{
				npcStoreController.dispose();
				npcStoreController = null;
			}
			GlobalData.clientBagInfo.npcStoreIsOpen = false;
			super.dispose();
		}
	}
}