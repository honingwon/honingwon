package sszt.skill
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToSkillData;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	import sszt.skill.components.SkillPanel;
	
	public class SkillModule extends BaseModule
	{
		public var skillFacade:SkillFacade;
		public var skillPanel:SkillPanel;
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			skillFacade = SkillFacade.getInstance(String(moduleId));
			skillFacade.startup(this,data);
		}
		
		override public function get moduleId():int
		{
			return ModuleType.SKILL;
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			if(skillPanel)
			{				
				if(GlobalAPI.layerManager.getTopPanel() != skillPanel)
				{
					skillPanel.setToTop();
				}
				else
				{
					if(data && ToSkillData(data).forciblyOpen)
					{}
					else
					{
						skillPanel.dispose();
						skillPanel = null;
					}
				}
			}
		}
		
		
		override public function assetsCompleteHandler():void
		{
			if(skillPanel)
			{
				skillPanel.assetsCompleteHandler();
			}
			
		}
		
		
		override public function dispose():void
		{
			if(skillFacade)
			{
				skillFacade.dispose();
				skillFacade = null;
			}
			if(skillPanel)
			{
				skillPanel.dispose();
				skillPanel = null;
			}
			super.dispose();
		}
	}
}