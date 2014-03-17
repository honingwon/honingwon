package sszt.skill.commands
{
	import sszt.skill.mediators.SkillMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class SkillEndCommand extends SimpleCommand
	{
		public function SkillEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(SkillMediator.NAME);
		}
	}
}