package sszt.setting
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.ModuleType;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	import sszt.setting.components.SettingPanel;
	import sszt.setting.events.SettingMediatorEvent;
	
	public class SettingModule extends BaseModule
	{
		public var facade:SettingFacade;
		public var settingPanel:SettingPanel;
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			
			
			facade = SettingFacade.getInstance(String(moduleId));
			facade.startup(this,data);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			facade.sendNotification(SettingMediatorEvent.SETTING_MEDIATOR_START);
		}
		
		
		override public function get moduleId():int
		{
			return ModuleType.SETTING;
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(settingPanel)
			{
				settingPanel.dispose();
				settingPanel = null;
			}
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
		}
	}
}