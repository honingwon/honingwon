package sszt.petpvp.commands
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.petpvp.mediator.PetPVPMediator;
	
	public class PetPVPCommandEnd extends SimpleCommand
	{
		public function PetPVPCommandEnd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(PetPVPMediator.NAME);
		}
	}
}