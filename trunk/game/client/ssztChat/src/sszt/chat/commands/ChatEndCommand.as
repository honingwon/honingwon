package sszt.chat.commands
{
	import sszt.chat.mediators.ChatMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ChatEndCommand extends SimpleCommand
	{
		public function ChatEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(ChatMediator.NAME);
		}
	}
}