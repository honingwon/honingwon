package sszt.mounts.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToMountsData;
	import sszt.core.data.mounts.MountShowInfoUpdateEvent;
	import sszt.core.socketHandlers.mounts.MountsGetMountShowItemSocketHandler;
	import sszt.mounts.MountsModule;
	import sszt.mounts.component.MountShowPanel;
	import sszt.mounts.component.MountsFeedPanel;
	import sszt.mounts.component.MountsPanel;
	import sszt.mounts.component.MountsRefreshSkillBooksPanel;
	import sszt.mounts.component.UpgradeQualityPanelType;
	import sszt.mounts.component.popup.MountShowDevelop;
	import sszt.mounts.component.popup.UpgradeQualityLevelPanel;
	import sszt.mounts.component.popup.UpgradeQualityPanel;
	import sszt.mounts.component.popup.RefinedPanel;
	import sszt.mounts.event.MountsMediatorEvent;
	import sszt.ui.container.MPanel;
	
	public class MountsMediator extends Mediator
	{
		public static const NAME:String = "mountsMediator";
		
		public function MountsMediator(viewComponent:Object = null)
		{
			super(NAME,viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				MountsMediatorEvent.MOUNTS_START,
				MountsMediatorEvent.SHOW_MOUNT,
				MountsMediatorEvent.MOUNTS_FEED_START,
				MountsMediatorEvent.SHOW_CALL_PANEL,
				MountsMediatorEvent.MOUNTS_DISPOSE
				];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var data:Object = notification.getBody();
			switch (notification.getName())
			{
				case MountsMediatorEvent.MOUNTS_START:
					initMountsPanel(notification.getBody());
					break;
				case MountsMediatorEvent.SHOW_MOUNT:
					showMount(notification.getBody());
					break;
				case MountsMediatorEvent.MOUNTS_FEED_START:
					initMountsFeedPanel(notification.getBody());
					break;
				case MountsMediatorEvent.MOUNTS_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function closeSomePanel():void
		{
			var panels:Array = [
				module.evolutionPanel,
				module.upgradeIntelligencePanel,
				module.upgradeQualityLevelPanel,
				module.refinedPanel
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
		
		/**
		 * 打开坐骑展示面板
		 */
		public function showMount(data:Object):void
		{
			//如果面板存在，清空之
			if(module.mountShowPanel)
			{
				module.mountShowPanel.clear();
			}
			var mountId:int = (data as ToMountsData).itemId;
			
			
			if(module.mountShowPanel)
			{
				if(GlobalAPI.layerManager.getTopPanel() != module.mountShowPanel)
				{
					module.mountShowPanel.setToTop();
				}
			}
			else
			{
				module.mountShowPanel = new MountShowPanel(this);
				module.mountShowPanel.addEventListener(Event.CLOSE,mountShowPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(module.mountShowPanel);
			}
			var showMountUserId:int = (data as ToMountsData).showMountUserId;
			MountsGetMountShowItemSocketHandler.send(showMountUserId, mountId);
			
			GlobalData.mountShowInfo.addEventListener(MountShowInfoUpdateEvent.MOUNT_SHOW_INFO_LOAD_COMPLETE,mountShowInfoLoadCompleteHander);
			
		}
		
		/**
		 * 坐骑展示面板坐骑信息加载完毕
		 */
		private function mountShowInfoLoadCompleteHander(e:Event):void
		{
			GlobalData.mountShowInfo.removeEventListener(MountShowInfoUpdateEvent.MOUNT_SHOW_INFO_LOAD_COMPLETE,mountShowInfoLoadCompleteHander);
//			if(module.mountShowPanel)
//			{
//				if(GlobalAPI.layerManager.getTopPanel() != module.mountShowPanel)
//				{
//					module.mountShowPanel.setToTop();
//				}
//			}
//			else
//			{
//				module.mountShowPanel = new MountShowPanel(this);
//				module.mountShowPanel.addEventListener(Event.CLOSE,mountShowPanelCloseHandler);
//				GlobalAPI.layerManager.addPanel(module.mountShowPanel);
//			}
			module.mountShowPanel.mountItemInfo = GlobalData.mountShowInfo.mountShowItemInfo;
		}
		
		private function mountShowPanelCloseHandler(event:Event):void
		{
			if(module.mountShowPanel)
			{
				module.mountShowPanel.removeEventListener(Event.CLOSE,mountShowPanelCloseHandler);
				module.mountShowPanel = null;
			}
		}
		
		public function initMountsPanel(data:Object):void
		{
			var toData:ToMountsData = data as ToMountsData;
			if(module.mountsPanel == null)
			{
				module.mountsPanel = new MountsPanel(this,toData);
				module.mountsPanel.addEventListener(Event.CLOSE,mountsPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(module.mountsPanel);
				
				if(module.toMountsData.showPanel != -1)
				{
					setTop(module.toMountsData.showPanel);
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
		
		private function mountsPanelCloseHandler(evt:Event):void
		{
			if(module.mountsPanel)
			{
				module.mountsPanel.removeEventListener(Event.CLOSE,mountsPanelCloseHandler);
				module.mountsPanel = null;
				closeSomePanel();
			}
		}
		
		public function initMountsFeedPanel(data:Object):void
		{
			var toData:ToMountsData = data as ToMountsData;
			if(module.mountsFeedPanel == null)
			{
				module.mountsFeedPanel = new MountsFeedPanel(this,toData);
				module.mountsFeedPanel.addEventListener(Event.CLOSE,mountsFeedPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(module.mountsFeedPanel);
			}
		}
		
		private function mountsFeedPanelCloseHandler(evt:Event):void
		{
			if(module.mountsFeedPanel)
			{
				module.mountsFeedPanel.removeEventListener(Event.CLOSE,mountsFeedPanelCloseHandler);
				module.mountsFeedPanel = null;
			}
		}
		
		public function initEvolutionPanel():void
		{
			if(module.evolutionPanel == null)
			{
				closeSomePanel();
				module.evolutionPanel = new UpgradeQualityPanel(this, UpgradeQualityPanelType.EVOLUTION);
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
				module.upgradeIntelligencePanel = new UpgradeQualityPanel(this, UpgradeQualityPanelType.UPGRADE_INTELLIGENCE);
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
		
		public function initRefinedPanel():void
		{
			if(module.refinedPanel == null)
			{
				closeSomePanel();
				module.refinedPanel = new RefinedPanel(this);
				module.refinedPanel.addEventListener(Event.CLOSE, refinedPanelCloseHandler);
				GlobalAPI.layerManager.addPanel(module.refinedPanel);
			}
			else
			{
				module.refinedPanel.setToTop();
			}
		}
		
		private function refinedPanelCloseHandler(evt:Event):void
		{
			if(module.refinedPanel)
			{
				module.refinedPanel.removeEventListener(Event.CLOSE, refinedPanelCloseHandler);
				module.refinedPanel = null;
			}
		}
		
		public function initUpgradeQualityLevelPanel():void
		{
			if(module.upgradeQualityLevelPanel == null)
			{
				closeSomePanel();
				module.upgradeQualityLevelPanel = new UpgradeQualityLevelPanel(this);
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
		public function initShowMountDevelop():void
		{
			if(module.showMountDevelop == null)
			{
				module.showMountDevelop = new MountShowDevelop(this);
				module.showMountDevelop.addEventListener(Event.CLOSE, getshowMountDevelopCloseHandler);
				GlobalAPI.layerManager.addPanel(module.showMountDevelop);
			}
			else
			{
				module.getSkillBooksPanel.setToTop();
			}
		}
		
		private function getshowMountDevelopCloseHandler(evt:Event):void
		{
			if(module.showMountDevelop)
			{
				module.showMountDevelop.removeEventListener(Event.CLOSE, getshowMountDevelopCloseHandler);
				module.showMountDevelop = null;
			}
		}
		
		public function initGetSkillBooksPanel():void
		{
			if(module.getSkillBooksPanel == null)
			{
				module.getSkillBooksPanel = new MountsRefreshSkillBooksPanel(this);
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
			
		public function get module():MountsModule
		{
			return viewComponent as MountsModule;
		}
		
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}