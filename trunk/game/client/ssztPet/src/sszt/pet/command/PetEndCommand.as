package sszt.pet.command
{
	import sszt.pet.mediator.PetMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class PetEndCommand extends SimpleCommand
	{
		public function PetEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(PetMediator.NAME);
		}
	}
}