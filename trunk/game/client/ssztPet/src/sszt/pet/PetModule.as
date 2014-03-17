package sszt.pet
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToPetData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.module.BaseModule;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.module.IModule;
	import sszt.pet.component.PetPanel;
	import sszt.pet.component.PetShowPanel;
	import sszt.pet.component.popup.PetRefreshSkillBooksPanel;
	import sszt.pet.component.popup.PetShowDevelop;
	import sszt.pet.component.popup.PetUpgradeQualityLevelPanel;
	import sszt.pet.component.popup.PetUpgradeQualityPanel;
	import sszt.pet.component.popup.PetXisuPanel;
	import sszt.pet.data.PetsInfo;
	import sszt.pet.event.PetMediatorEvent;
	import sszt.pet.socketHandler.PetSetSocketHandler;
	
	public class PetModule extends BaseModule
	{
		public var facade:PetFacade;
		public var petsInfo:PetsInfo;
		public var petPanel:PetPanel;
		public var petShowPanel:PetShowPanel;
		public var evolutionPanel:PetUpgradeQualityPanel;
		public var upgradeIntelligencePanel:PetUpgradeQualityPanel;
		public var upgradeQualityLevelPanel:PetUpgradeQualityLevelPanel;
		public var getSkillBooksPanel:PetRefreshSkillBooksPanel;
		public var xisuPanel:PetXisuPanel;
		public var showPetDevelop:PetShowDevelop;
		
		public var assetsReady:Boolean;
		
		public var toPetData:ToPetData;
		
		public function PetModule()
		{
			super();
		}
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			
			PetSetSocketHandler.add(this);
			petsInfo = new PetsInfo();
			
			facade = PetFacade.getInstance(String(moduleId));
			facade.startup(this);
			
			configure(data);
		}
		
		override public function configure(data:Object):void
		{
			toPetData = data as ToPetData;
			if(toPetData && toPetData.type == 2)
			{
				facade.sendNotification(PetMediatorEvent.SHOW_PET, data);
			}
			else if(!toPetData || toPetData.showPanel != -1 || !toPetData.isClose)
			{
				facade.sendNotification(PetMediatorEvent.PET_START, data);
			}
		}
		
		override public function assetsCompleteHandler():void
		{
			assetsReady = true;
			//若面板打开后，assets还未加载完成，那么为了保证面板资源加载，在assets加载完成后，进行面板打开与否的检测。
			//若面板打开，则进行相应资源加载。
			if(petPanel)
			{
				petPanel.assetsCompleteHandler();
			}
			if(xisuPanel)
			{
				xisuPanel.assetsCompleteHandler();
			}
			if(petShowPanel)
			{
				petShowPanel.assetsCompleteHandler();
			}
		}
		
		override public function get moduleId():int
		{
			return ModuleType.PET;
		}
		
		override public function dispose():void
		{
			PetSetSocketHandler.remove();
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
			if(petPanel)
			{
				petPanel.dispose();
				petPanel = null;
			}
			petsInfo = null;
			super.dispose();
		}
	}
}