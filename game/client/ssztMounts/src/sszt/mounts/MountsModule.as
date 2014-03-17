package sszt.mounts
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToMountsData;
	import sszt.core.data.module.changeInfos.ToPetData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.module.BaseModule;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.module.IModule;
	import sszt.mounts.component.MountShowPanel;
	import sszt.mounts.component.MountsFeedPanel;
	import sszt.mounts.component.MountsPanel;
	import sszt.mounts.component.MountsRefreshSkillBooksPanel;
	import sszt.mounts.component.popup.MountShowDevelop;
	import sszt.mounts.component.popup.UpgradeQualityLevelPanel;
	import sszt.mounts.component.popup.UpgradeQualityPanel;
	import sszt.mounts.component.popup.RefinedPanel;	
	import sszt.mounts.data.MountsInfo;
	import sszt.mounts.event.MountsMediatorEvent;
	import sszt.mounts.socketHandler.MountsSetSocketHandler;

	
	public class MountsModule extends BaseModule
	{
		public var facade:MountsFacade;
		public var mountsPanel:MountsPanel; 
		public var mountsFeedPanel:MountsFeedPanel;
		public var evolutionPanel:UpgradeQualityPanel;
		public var upgradeIntelligencePanel:UpgradeQualityPanel;
		public var refinedPanel:RefinedPanel;
		public var upgradeQualityLevelPanel:UpgradeQualityLevelPanel;
		public var getSkillBooksPanel:MountsRefreshSkillBooksPanel;
		public var mountShowPanel:MountShowPanel;
		public var showMountDevelop:MountShowDevelop;
		public var mountsInfo:MountsInfo;
		public var assetsReady:Boolean;
		
		public var toMountsData:ToMountsData;
		public function MountsModule()
		{
			super();
		}
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			
			MountsSetSocketHandler.add(this);
			
			mountsInfo = new MountsInfo();
			facade = MountsFacade.getInstance(String(moduleId));
			facade.startup(this);
			
			configure(data);
		}
		
		override public function configure(data:Object):void
		{
			toMountsData = data as ToMountsData;
			/**
			 * 配置坐骑主面板
			 */
			if(toMountsData==null || toMountsData.type == 0)
			{
				if(mountsPanel)
				{
					if(GlobalAPI.layerManager.getTopPanel() != mountsPanel && toMountsData && !toMountsData.isClose)
					{
						mountsPanel.setToTop();
					}
					else
					{
						mountsPanel.dispose();
						if(mountsFeedPanel)
						{
							mountsFeedPanel.dispose();
						}
					}
					return;
				}
				facade.sendNotification(MountsMediatorEvent.MOUNTS_START,data);
			}
			/**
			 * 配置坐骑升级面板
			 */
			else if(toMountsData==null || toMountsData.type == 1)
			{
				if(mountsFeedPanel)
				{
					if(GlobalAPI.layerManager.getTopPanel() != mountsFeedPanel)
					{
						mountsFeedPanel.setToTop();
					}
					else
					{
						mountsFeedPanel.dispose();
					}
					return;
				}
					
				facade.sendNotification(MountsMediatorEvent.MOUNTS_FEED_START);
			}
			//显示坐骑展示面板
			else if(toMountsData==null || toMountsData.type == 2)
			{
				facade.sendNotification(MountsMediatorEvent.SHOW_MOUNT, data);
			}
		}
		
		override public function get moduleId():int
		{
			return ModuleType.PET;
		}
		
		override public function assetsCompleteHandler():void
		{
			assetsReady = true;
			//若面板打开后，assets还未加载完成，那么为了保证面板资源加载，在assets加载完成后，进行面板打开与否的检测。
			//若面板打开，则进行相应资源加载。
			if(mountsPanel)
			{
				mountsPanel.assetsCompleteHandler();
			}
			if(mountShowPanel)
			{
				mountShowPanel.assetsCompleteHandler();
			}
//			if(petShowPanel)
//			{
//				petShowPanel.assetsCompleteHandler();
//			}
		}
		
		override public function dispose():void
		{
			MountsSetSocketHandler.remove();
			if(mountsPanel)
			{
				mountsPanel.dispose();
				mountsPanel = null;
			}
			if(mountsFeedPanel)
			{
				mountsFeedPanel.dispose();
				mountsFeedPanel = null;
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