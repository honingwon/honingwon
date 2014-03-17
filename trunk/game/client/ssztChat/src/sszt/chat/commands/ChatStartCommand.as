package sszt.chat.commands
{
	import sszt.chat.ChatModule;
	import sszt.chat.mediators.ChatMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ChatStartCommand extends SimpleCommand
	{
		public function ChatStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var module:ChatModule = notification.getBody() as ChatModule;
			facade.registerMediator(new ChatMediator(module));
		}
	}
}