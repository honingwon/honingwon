package sszt.box.commands
{
	import sszt.box.BoxModule;
	import sszt.box.mediators.BoxMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class BoxCommandStart extends SimpleCommand
	{
		public function BoxCommandStart()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var boxModule:BoxModule = notification.getBody() as BoxModule;
			facade.registerMediator(new BoxMediator(boxModule));
		}
	}
}