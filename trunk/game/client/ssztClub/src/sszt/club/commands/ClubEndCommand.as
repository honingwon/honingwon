package sszt.club.commands
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.club.mediators.ClubCampMediator;
	import sszt.club.mediators.ClubCreateMediator;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.mediators.ClubWarMediator;
	
	public class ClubEndCommand extends SimpleCommand
	{
		public function ClubEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(ClubMediator.NAME);
			facade.removeMediator(ClubCreateMediator.NAME);
			facade.removeMediator(ClubWarMediator.NAME);
			facade.removeMediator(ClubCampMediator.NAME);
		}
	}
}