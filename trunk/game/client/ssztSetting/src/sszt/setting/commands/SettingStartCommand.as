package sszt.setting.commands
{
	import sszt.setting.SettingModule;
	import sszt.setting.mediators.SettingMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class SettingStartCommand extends SimpleCommand
	{
		public function SettingStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var module:SettingModule = notification.getBody() as SettingModule;
			facade.registerMediator(new SettingMediator(module));
		}
	}
}