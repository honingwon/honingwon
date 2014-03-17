package sszt.pet.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToPetData;
	import sszt.core.data.pet.PetShowInfo;
	import sszt.core.data.pet.PetShowInfoUpdateEvent;
	import sszt.core.socketHandlers.pet.PetGetPetShowItemSocketHandler;
	import sszt.events.CellEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.pet.PetModule;
	import sszt.pet.component.PetPanel;
	import sszt.pet.component.PetShowPanel;
	import sszt.pet.component.cells.PetEquipCell;
	import sszt.pet.component.popup.PetRefreshSkillBooksPanel;
	import sszt.pet.component.popup.PetShowDevelop;
	import sszt.pet.component.popup.PetUpgradeQualityLevelPanel;
	import sszt.pet.component.popup.PetUpgradeQualityPanel;
	import sszt.pet.component.popup.PetXisuPanel;
	import sszt.pet.data.PetUpgradeQualityPanelType;
	import sszt.pet.event.PetEvent;
	import sszt.pet.event.PetMediatorEvent;
	import sszt.pet.util.PetUtil;
	import sszt.ui.container.MPanel;
	
	public class PetMediator extends Mediator
	{
		public static const NAME:String = "petMediator";
		
		public function PetMediator(viewComponent:Object = null)
		{
			super(NAME,viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				PetMediatorEvent.PET_START,
				PetMediatorEvent.SHOW_PET,
				PetMediatorEvent.PET_DISPOSE
				];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var data:Object = notification.getBody();
			switch (notification.getName())
			{
				case PetMediatorEvent.PET_START:
					initPetPanel(notification.getBody());
					break;
				case PetMediatorEvent.SHOW_PET:
					showPet(notification.getBody());
					break;
				case PetMediatorEvent.PET_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function petEquipCellClickHandler(petEquipCell:PetEquipCell):void
		{
		}
		
		private function petEquipCellDoubleClickHandler(petEquipCell:PetEquipCell):void
		{
			ModuleEventDispatcher.dispatchCellEvent(new CellEvent(CellEvent.CELL_DOUBLECLICK,petEquipCell));
		}
		
		private function closeSomePanel():void
		{
			var panels:Array = [
				module.evolutionPanel,
				module.upgradeIntelligencePanel,
				module.upgradeQualityLevelPanel
			];
			
			var panelItem:MPanel;
			var i:int;
			for(i = 0; i < panels.length; i++)
			{
				if(panels[i] && (panels[i] is MPanel))
				{
					panelItem = panels[i] as MPanel;
					panelItem.dispose();
				}
			}
			panels = null;
		}
		
		public function initPetPanel(data:Object):void
		{
			var toData:ToPetData = data as ToPetData;
			if(module.petPanel == null)
			{
				module.petPanel = new PetPanel(this,toData,petEquipCellDoubleClickHandler);
				module.petPanel.addEventListener(Event.CLOSE, petPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(module.petPanel);
				
				if(module.toPetData && module.toPetData.showPanel != -1 &&  PetUtil.getSelectedPetDefault())
				{
					setTop(module.toPetData.showPanel);
				}
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel() != module.petPanel && toData && !toData.isClose)
				{
					module.petPanel.setToTop();
				}
				else
				{
					module.petPanel.dispose();
				}
			}
		}
		
		/**
		 * 置顶操作 
		 * @param type
		 * 
		 */
		private function setTop(type:int):void
		{
			switch(type)
			{
				case 0:
					initUpgradeQualityLevelPanel();
					break;
				case 1:
					initEvolutionPanel();
					break;
				case 2:
					initUpgradeIntelligencePanel();
					break;	
			}
		}
		
		private function petPanelCloseHandler(evt:Event):void
		{
			if(module.petPanel)
			{
				module.petPanel.removeEventListener(Event.CLOSE,petPanelCloseHandler);
				module.petPanel = null;
				closeSomePanel();
			}
		}
		
		/**
		 * 打开宠物展示面板
		 */
		public function showPet(data:Object):void
		{
			//如果面板存在，清空之
			if(module.petShowPanel)
			{
				module.petShowPanel.clear();
			}
			var petId:int = (data as ToPetData).itemId;
			var showPetUserId:int = (data as ToPetData).showPetUserId;
			GlobalData.petShowInfo.addEventListener(PetShowInfoUpdateEvent.PET_SHOW_INFO_LOAD_COMPLETE, petShowInfoLoadCompleteHander);
			PetGetPetShowItemSocketHandler.send(showPetUserId, petId);
		}
		
		/**
		 * 宠物展示面板宠物信息加载完毕
		 */
		private function petShowInfoLoadCompleteHander(e:Event):void
		{
			GlobalData.petShowInfo.removeEventListener(PetShowInfoUpdateEvent.PET_SHOW_INFO_LOAD_COMPLETE, petShowInfoLoadCompleteHander);
			if(module.petShowPanel)
			{
				if(GlobalAPI.layerManager.getTopPanel() != module.petShowPanel)
				{
					module.petShowPanel.setToTop();
				}
			}
			else
			{
				module.petShowPanel = new PetShowPanel(this);
				if(module.assetsReady)
				{
					module.petShowPanel.assetsCompleteHandler();
				}
				module.petShowPanel.addEventListener(Event.CLOSE, petShowPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(module.petShowPanel);
			}
			module.petShowPanel.petItemInfo = GlobalData.petShowInfo.petShowItemInfo;
			module.petShowPanel.petEquips = GlobalData.petShowInfo.petShowEquipInfo;
		}
		
		private function petShowPanelCloseHandler(event:Event):void
		{
			if(module.petShowPanel)
			{
				module.petShowPanel.removeEventListener(Event.CLOSE, petShowPanelCloseHandler);
				module.petShowPanel = null;
			}
		}
		
		public function initEvolutionPanel():void
		{
			if(module.evolutionPanel == null)
			{
				closeSomePanel();
				module.evolutionPanel = new PetUpgradeQualityPanel(this, PetUpgradeQualityPanelType.EVOLUTION);
				module.evolutionPanel.addEventListener(Event.CLOSE, evolutionPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(module.evolutionPanel);
			}
			else
			{
				module.evolutionPanel.setToTop();
			}
		}
		
		private function evolutionPanelCloseHandler(evt:Event):void
		{
			if(module.evolutionPanel)
			{
				module.evolutionPanel.removeEventListener(Event.CLOSE, evolutionPanelCloseHandler);
				module.evolutionPanel = null;
			}
		}
		
		public function initUpgradeIntelligencePanel():void
		{
			if(module.upgradeIntelligencePanel == null)
			{
				closeSomePanel();
				module.upgradeIntelligencePanel = new PetUpgradeQualityPanel(this, PetUpgradeQualityPanelType.UPGRADE_INTELLIGENCE);
				module.upgradeIntelligencePanel.addEventListener(Event.CLOSE, upgradeIntelligencePanelCloseHandler);
				GlobalAPI.layerManager.addPanel(module.upgradeIntelligencePanel);
			}
			else
			{
				module.upgradeIntelligencePanel.setToTop();
			}
		}
		
		private function upgradeIntelligencePanelCloseHandler(evt:Event):void
		{
			if(module.upgradeIntelligencePanel)
			{
				module.upgradeIntelligencePanel.removeEventListener(Event.CLOSE, upgradeIntelligencePanelCloseHandler);
				module.upgradeIntelligencePanel = null;
			}
		}
		
		public function initUpgradeQualityLevelPanel():void
		{
			if(module.upgradeQualityLevelPanel == null)
			{
				closeSomePanel();
				module.upgradeQualityLevelPanel = new PetUpgradeQualityLevelPanel(this);
				module.upgradeQualityLevelPanel.addEventListener(Event.CLOSE, upgradeQualityLevelPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(module.upgradeQualityLevelPanel);
			}
			else
			{
				module.upgradeQualityLevelPanel.setToTop();
			}
		}
		
		private function upgradeQualityLevelPanelCloseHandler(evt:Event):void
		{
			if(module.upgradeQualityLevelPanel)
			{
				module.upgradeQualityLevelPanel.removeEventListener(Event.CLOSE, upgradeQualityLevelPanelCloseHandler);
				module.upgradeQualityLevelPanel = null;
			}
		}
		
		public function initGetSkillBooksPanel():void
		{
			if(module.getSkillBooksPanel == null)
			{
				module.getSkillBooksPanel = new PetRefreshSkillBooksPanel(this);
				module.getSkillBooksPanel.addEventListener(Event.CLOSE, getSkillBooksPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(module.getSkillBooksPanel);
			}
			else
			{
				module.getSkillBooksPanel.setToTop();
			}
		}
		
		private function getSkillBooksPanelCloseHandler(evt:Event):void
		{
			if(module.getSkillBooksPanel)
			{
				module.getSkillBooksPanel.removeEventListener(Event.CLOSE, getSkillBooksPanelCloseHandler);
				module.getSkillBooksPanel = null;
			}
		}
		public function initShowPetDevelop():void
		{
			if(module.showPetDevelop == null)
			{
				module.showPetDevelop = new PetShowDevelop(this);
				module.showPetDevelop.addEventListener(Event.CLOSE, getShowPetDevelopCloseHandler);
				GlobalAPI.layerManager.addPanel(module.showPetDevelop);
			}
			else
			{
				module.showPetDevelop.setToTop();
			}
		}
		
		private function getShowPetDevelopCloseHandler(evt:Event):void
		{
			if(module.showPetDevelop)
			{
				module.showPetDevelop.removeEventListener(Event.CLOSE, getShowPetDevelopCloseHandler);
				module.showPetDevelop = null;
			}
		}
		public function initXisuPanel():void
		{
			if(module.xisuPanel == null)
			{
				module.xisuPanel = new PetXisuPanel(this);
				module.xisuPanel.addEventListener(Event.CLOSE, xisuPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(module.xisuPanel);
			}
			else
			{
				module.xisuPanel.setToTop();
			}
		}
		
		private function xisuPanelCloseHandler(evt:Event):void
		{
			if(module.xisuPanel)
			{
				module.xisuPanel.removeEventListener(Event.CLOSE, xisuPanelCloseHandler);
				module.xisuPanel = null;
			}
		}
		
		public function get module():PetModule
		{
			return viewComponent as PetModule;
		}
		
		
		public function dispose():void
		{
			viewComponent = null;
		}
		
//		public function showCallPetPanel(data:Object):void
//		{
//			if(module.callPetPanel == null)
//			{
//				module.callPetPanel = new PetCallPanel(this,data);
//				module.callPetPanel.addEventListener(Event.CLOSE,callPetPanelCloseHandler);
//				GlobalAPI.layerManager.addPanel(module.callPetPanel);
//			}
//		}
//		
//		private function callPetPanelCloseHandler(evt:Event):void
//		{
//			if(module.callPetPanel)
//			{
//				module.callPetPanel.removeEventListener(Event.CLOSE,callPetPanelCloseHandler);
//				module.callPetPanel = null;
//			}
//			if(module && module.petPanel == null)
//			{
//				module.dispose();
//			}
//		}
		
//		public function showReNamePanel():void
//		{
//			if(module.reNamePanel == null)
//			{
//				module.reNamePanel = new PetReNamePanel(this);
//				module.reNamePanel.addEventListener(Event.CLOSE,namePanelCloseHandler);
//				GlobalAPI.layerManager.addPanel(module.reNamePanel);
//			}
//		}
//		
//		private function namePanelCloseHandler(evt:Event):void
//		{
//			if(module.reNamePanel)
//			{
//				module.reNamePanel.removeEventListener(Event.CLOSE,namePanelCloseHandler);
//				module.reNamePanel = null;
//			}
//		}
		
//		public function showAlertPanel():void
//		{
//			if(module.alertPanel == null)
//			{
//				module.alertPanel = new PetAlertPanel(this);
//				module.alertPanel.addEventListener(Event.CLOSE,alertPanelCloseHandler);
//				GlobalAPI.layerManager.addPanel(module.alertPanel);
//			}
//		}
//		
//		private function alertPanelCloseHandler(evt:Event):void
//		{
//			if(module.alertPanel)
//			{
//				module.alertPanel.removeEventListener(Event.CLOSE,alertPanelCloseHandler);
//				module.alertPanel = null;
//			}
//		}
		
//		public function showLuckPanel():void
//		{
//			if(module.luckPanel == null)
//			{
//				module.luckPanel = new LuckSymbolPanel(this);
//				module.luckPanel.addEventListener(Event.CLOSE,luckPanelCloseHandler);
//				GlobalAPI.layerManager.addPanel(module.luckPanel);
//			}
//		}
//		
//		private function luckPanelCloseHandler(evt:Event):void
//		{
//			if(module.luckPanel)
//			{
//				module.luckPanel.removeEventListener(Event.CLOSE,luckPanelCloseHandler);
//				module.luckPanel = null;
//			}
//		}
		
//		public function getShopList():void
//		{
//			PetGetShopListSocketHandler.send();
//		}
//		
//		public function getUpgradeTime(id:Number):void
//		{
//			PetGetUpgradeTimeSocketHandler.send(id);
//		}
	}
}