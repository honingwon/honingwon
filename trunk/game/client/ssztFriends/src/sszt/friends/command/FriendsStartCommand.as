package sszt.friends.command
{
	import sszt.friends.FriendsModule;
	import sszt.friends.mediator.FriendsMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class FriendsStartCommand extends SimpleCommand
	{
		public function FriendsStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var module:FriendsModule = notification.getBody() as FriendsModule;
			facade.registerMediator(new FriendsMediator(module));
		}
	}
}