package sszt.role.command
{
	import sszt.role.RoleModule;
	import sszt.role.mediator.RoleMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class RoleCommandStart extends SimpleCommand
	{
		public function RoleCommandStart()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var tmpRoleModule:RoleModule = notification.getBody() as RoleModule;
			facade.registerMediator(new RoleMediator(tmpRoleModule));
		}
	}
}