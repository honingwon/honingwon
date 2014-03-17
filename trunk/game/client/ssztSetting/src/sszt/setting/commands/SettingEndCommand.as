package sszt.setting.commands
{
	import sszt.setting.mediators.SettingMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class SettingEndCommand extends SimpleCommand
	{
		public function SettingEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(SettingMediator.NAME);
		}
	}
}