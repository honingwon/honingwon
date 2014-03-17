package sszt.navigation.commands
{
	import sszt.navigation.mediators.NavigationMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NavigationEndCommand extends SimpleCommand
	{
		public function NavigationEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(NavigationMediator.NAME);
		}
	}
}