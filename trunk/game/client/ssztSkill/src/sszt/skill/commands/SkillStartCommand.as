package sszt.skill.commands
{
	import sszt.skill.SkillFacade;
	import sszt.skill.SkillModule;
	import sszt.skill.mediators.SkillMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class SkillStartCommand extends SimpleCommand
	{
		public function SkillStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var module:SkillModule = notification.getBody() as SkillModule;
			facade.registerMediator(new SkillMediator(module));
		}
	}
}