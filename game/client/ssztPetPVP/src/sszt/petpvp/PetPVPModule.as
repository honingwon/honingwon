package sszt.petpvp
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.ModuleType;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	import sszt.petpvp.components.PetPVPMainPanel;
	import sszt.petpvp.data.PetPVPInfo;
	import sszt.petpvp.socketHandlers.SetPetPVPSocketHandlers;
	
	/**
	 * 宠物斗坛模块
	 * */
	public class PetPVPModule extends BaseModule
	{
		public var facade:PetPVPFacade;
		
		public var petPVPInfo:PetPVPInfo = new PetPVPInfo();
		
		public var mainPanel:PetPVPMainPanel;
		
		public function PetPVPModule()
		{
			super();
		}
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			SetPetPVPSocketHandlers.add(this);
			facade = PetPVPFacade.getInstance(String(moduleId));
			facade.startup(this,data);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			
			if(mainPanel)
			{
				if(GlobalAPI.layerManager.getTopPanel() != mainPanel)
					mainPanel.setToTop();
				else 
					mainPanel.dispose();
			}
		}
		
		override public function get moduleId():int
		{
			return ModuleType.PET_PVP;
		}
		
		override public function assetsCompleteHandler():void
		{
		}
		
		override public function dispose():void
		{
			super.dispose();
			SetPetPVPSocketHandlers.remove();
			petPVPInfo = null;
			if(mainPanel)
			{
				mainPanel.dispose();
				mainPanel = null;
			}
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
		}
	}
}