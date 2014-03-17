package sszt.box.commands
{
	import sszt.box.mediators.BoxMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class BoxCommandEnd extends SimpleCommand
	{
		public function BoxCommandEnd()
		{
			super();
		}
		
		override public function execute(notificaton:INotification):void
		{
			facade.removeMediator(BoxMediator.NAME);
		}
	}
}