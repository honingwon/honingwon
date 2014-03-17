package sszt.core.data.club
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ClubSkillItemInfo extends EventDispatcher
	{
		public var templateId:int;
		private var _template:ClubSkillTemplate;
		public var level:int;           //等级
		
		public function ClubSkillItemInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function get template():ClubSkillTemplate
		{
			if(_template == null)
			{
				_template = ClubSkillTemplateList.getClubSkill(templateId);
			}
			return _template;
		}
		
		public function update():void
		{
			dispatchEvent(new ClubSkillEvent(ClubSkillEvent.CLUB_SKILL_UPDATE));
		}
	}
}