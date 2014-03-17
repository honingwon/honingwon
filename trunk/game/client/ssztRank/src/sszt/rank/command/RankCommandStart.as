package sszt.rank.command
{
	import sszt.rank.RankModule;
	import sszt.rank.mediator.RankMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class RankCommandStart extends SimpleCommand
	{
		public function RankCommandStart()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var rankModule:RankModule = notification.getBody() as RankModule;
			facade.registerMediator(new RankMediator(rankModule));
		}
	}
}