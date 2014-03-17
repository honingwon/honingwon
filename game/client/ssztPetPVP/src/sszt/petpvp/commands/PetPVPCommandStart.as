package sszt.petpvp.commands
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.petpvp.PetPVPModule;
	import sszt.petpvp.mediator.PetPVPMediator;
	
	public class PetPVPCommandStart extends SimpleCommand
	{
		public function PetPVPCommandStart()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{ 
			var module:PetPVPModule=notification.getBody() as PetPVPModule;
			facade.registerMediator(new PetPVPMediator(module));
		}
	}
}