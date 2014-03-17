package sszt.skill
{
	import sszt.skill.commands.SkillEndCommand;
	import sszt.skill.commands.SkillStartCommand;
	import sszt.skill.events.SkillMediatorEvent;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class SkillFacade extends Facade
	{
		public static function getInstance(key:String):SkillFacade
		{
			if(!(instanceMap[key] is SkillFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new SkillFacade(key);
			}
			return instanceMap[key];
		}
		
		private var _key:String;
		public var skillModule:SkillModule;
		
		public function SkillFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(SkillMediatorEvent.SKILL_COMMAND_START,SkillStartCommand);
			registerCommand(SkillMediatorEvent.SKILL_COMMAND_END,SkillEndCommand);
		}
		
		public function startup(module:SkillModule,data:Object=null):void
		{
			skillModule = module;
			sendNotification(SkillMediatorEvent.SKILL_COMMAND_START,module);
			sendNotification(SkillMediatorEvent.SKILL_MEDIATOR_START,data);
		}
		
		public function dispose():void
		{
			sendNotification(SkillMediatorEvent.SKILL_MEDIATOR_DISPOSE);
			sendNotification(SkillMediatorEvent.SKILL_COMMAND_END);
			removeCommand(SkillMediatorEvent.SKILL_COMMAND_START);
			removeCommand(SkillMediatorEvent.SKILL_COMMAND_END);
			delete instanceMap[_key];
			skillModule = null;
		}
	}
}
