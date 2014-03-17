package sszt.common.npcStore.controllers
{
	import flash.events.Event;
	
	import sszt.common.npcStore.NPCStoreModule;
	import sszt.common.npcStore.components.NPCStorePanel;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.module.changeInfos.ToNpcStoreData;
	import sszt.core.data.shop.ShopItemInfo;

	public class NPCStoreController
	{
		private var npcStoreModule:NPCStoreModule;
		
		public function NPCStoreController(module:NPCStoreModule)
		{
			npcStoreModule = module;
		}
		
		public function startup(data:Object):void
		{
			var temp:ToNpcStoreData = data as ToNpcStoreData;
			if(npcStoreModule.npcStorePanel == null)
			{
				npcStoreModule.npcStorePanel = new NPCStorePanel(this,temp);
				GlobalAPI.layerManager.addPanel(npcStoreModule.npcStorePanel);
				npcStoreModule.npcStorePanel.addEventListener(Event.CLOSE,storePanelCloseHandler);
			}
		}
		
		private function storePanelCloseHandler(evt:Event):void
		{
			if(npcStoreModule.npcStorePanel)
			{
				npcStoreModule.npcStorePanel.removeEventListener(Event.CLOSE,storePanelCloseHandler);
				npcStoreModule.npcStorePanel = null;
				npcStoreModule.dispose();
			}
		}
				
		public function dispose():void
		{
			npcStoreModule = null;
		}
	}
}