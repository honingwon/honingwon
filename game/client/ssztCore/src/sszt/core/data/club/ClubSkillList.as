package sszt.core.data.club
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ClubSkillList extends EventDispatcher
	{
		private var _list:Array;
		
		public function ClubSkillList(target:IEventDispatcher=null)
		{
			super(target);
			_list = [];
		}
		
		public function addSkill(skill:ClubSkillItemInfo):void
		{
			_list.push(skill);
			dispatchEvent(new ClubSkillEvent(ClubSkillEvent.ADD_CLUB_SKILL,skill));
		}
		
		public function clear():void
		{
			_list = [];
		}
		
		public function removeSkill(id:int):void
		{
			for(var i:int = 0;i<_list.length;i++)
			{
				if(id == _list[i].templateId)
				{
					_list.splice(i,1);
				}
			}
		}
		
		public function getSkill(id:int):ClubSkillItemInfo
		{
			for each(var i:ClubSkillItemInfo in _list)
			{
				if(i.templateId == id) return i;
			}
			return null;
		}
		
		public function getList():Array
		{
			return _list;
		}
	}
}