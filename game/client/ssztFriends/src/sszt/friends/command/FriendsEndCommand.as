package sszt.friends.command
{
	import sszt.friends.mediator.FriendsMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class FriendsEndCommand extends SimpleCommand
	{
		public function FriendsEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(FriendsMediator.NAME);
		}
	}
}