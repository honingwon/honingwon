package sszt.rank.command
{
	import sszt.rank.mediator.RankMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	public class RankCommandEnd extends SimpleCommand
	{
		public function RankCommandEnd()
		{
			super();
		}
		
		override public function execute(notificaton:INotification):void
		{
			facade.removeMediator(RankMediator.NAME);
		}
	}
}