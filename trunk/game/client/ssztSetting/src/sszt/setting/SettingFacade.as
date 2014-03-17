package sszt.setting
{
	import sszt.setting.commands.SettingEndCommand;
	import sszt.setting.commands.SettingStartCommand;
	import sszt.setting.events.SettingMediatorEvent;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class SettingFacade extends Facade
	{
		public static function getInstance(key:String):SettingFacade
		{
			if(!(instanceMap[key] is SettingFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new SettingFacade(key);
			}
			return instanceMap[key];
		}
		
		private var _key:String;
		public var settingModule:SettingModule;
		
		public function SettingFacade(key:String)
		{
			_key = key;
			super(_key);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(SettingMediatorEvent.SETTING_COMMAND_START,SettingStartCommand);
			registerCommand(SettingMediatorEvent.SETTING_COMMAND_END,SettingEndCommand);
		}
		
		public function startup(module:SettingModule,data:Object):void
		{
			settingModule = module;
			sendNotification(SettingMediatorEvent.SETTING_COMMAND_START,settingModule);
			sendNotification(SettingMediatorEvent.SETTING_MEDIATOR_START,data);
		}
		
		public function dispose():void
		{
			sendNotification(SettingMediatorEvent.SETTING_COMMAND_END);
			sendNotification(SettingMediatorEvent.SETTING_MEDIATOR_DISPOSE);
			removeCommand(SettingMediatorEvent.SETTING_COMMAND_START);
			removeCommand(SettingMediatorEvent.SETTING_COMMAND_END);
			delete instanceMap[_key];
			settingModule = null;
		}
	}
}