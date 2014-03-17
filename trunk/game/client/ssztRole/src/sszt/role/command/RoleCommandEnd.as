package sszt.role.command
{
	import sszt.role.mediator.RoleMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class RoleCommandEnd extends SimpleCommand
	{
		public function RoleCommandEnd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(RoleMediator.NAME);
		}
	}
}