package sszt.pet.command
{
	import sszt.pet.PetModule;
	import sszt.pet.mediator.PetMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class PetStartCommand extends SimpleCommand
	{
		public function PetStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var module:PetModule = notification.getBody() as PetModule;
			facade.registerMediator(new PetMediator(module));
		}
	}
}