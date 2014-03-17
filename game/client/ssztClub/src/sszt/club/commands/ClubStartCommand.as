package sszt.club.commands
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.club.ClubModule;
	import sszt.club.mediators.ClubCampMediator;
	import sszt.club.mediators.ClubCreateMediator;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.mediators.ClubWarMediator;
	
	public class ClubStartCommand extends SimpleCommand
	{
		public function ClubStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var module:ClubModule = notification.getBody() as ClubModule;
			facade.registerMediator(new ClubCreateMediator(module));
			facade.registerMediator(new ClubMediator(module));
			facade.registerMediator(new ClubWarMediator(module));
			facade.registerMediator(new ClubCampMediator(module));
		}
	}
}