package sszt.navigation.commands
{
	import sszt.navigation.NavigationModule;
	import sszt.navigation.mediators.NavigationMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NavigationStartCommand extends SimpleCommand
	{
		public function NavigationStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var module:NavigationModule = notification.getBody() as NavigationModule;
			facade.registerMediator(new NavigationMediator(module));
		}
	}
}