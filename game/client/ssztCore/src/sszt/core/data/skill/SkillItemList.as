package sszt.core.data.skill
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.socketHandlers.task.TaskClientSocketHandler;
	
	public class SkillItemList extends EventDispatcher
	{
		private var _list:Array;
		private var _defaultSkill:SkillItemInfo;
		public var hasInit:Boolean;
		
		public function SkillItemList()
		{
			_list = [];
		}
		
		public function addSkill(skill:SkillItemInfo):void
		{
			_list.push(skill);
			if(skill.getTemplate().isDefault && skill.getTemplate().needCareer == GlobalData.selfPlayer.career)
			{
				_defaultSkill = skill;
			}
			dispatchEvent(new SkillListUpdateEvent(SkillListUpdateEvent.ADD_SKILL,skill));
			
			if(!skill.getTemplate().isDefault)
			{
				var taskInfo:TaskItemInfo = GlobalData.taskInfo.getTask(550108);
				if(taskInfo == null)taskInfo = GlobalData.taskInfo.getTask(550008);
				if(taskInfo == null)taskInfo = GlobalData.taskInfo.getTask(550208);
				if(taskInfo != null && taskInfo.isExist == true && taskInfo.isFinish == false)
				{
					TaskClientSocketHandler.send(taskInfo.taskId,0);
				}
			}
		}
		
		public function removeSkill(id:int):void
		{
			var skill:SkillItemInfo;
			for(var i:int = 0; i < _list.length; i++)
			{
				if(_list[i].templateId == id)
				{
					skill = _list.splice(i,1)[0];
					dispatchEvent(new SkillListUpdateEvent(SkillListUpdateEvent.REMOVE_SKILL,id));
				}
			}
		}
		
		public function getSkillById(id:int):SkillItemInfo
		{
			for each(var i:SkillItemInfo in _list)
			{
				if(i.templateId == id)return i;
			}
			return null;
		}
		
		public function getDefaultSkill():SkillItemInfo
		{
			return _defaultSkill;
		}
		
//		public function getSkillByPlace(places:Vector.<int>):Vector.<SkillItemInfo>
		public function getSkillByPlace(places:Array):Array
		{
//			var list:Vector.<SkillItemInfo> = new Vector.<SkillItemInfo>();
			var list:Array = [];
			for each(var i:int in places)
			{
				for each(var j:SkillItemInfo in _list)
				{
					if(j.getTemplate().place == i)
					{
						list.push(j);
						break;
					}
				}
			}
			return list;
		}
		
		public function getSkillByLevel(id:int,level:int):SkillItemInfo
		{
			var skillInfo:SkillItemInfo = getSkillById(id);
			if(skillInfo && skillInfo.level >= level)
			{
				return skillInfo;
			}
			else
			{
				return null;
			}
		}
			
		
//		public function getSkills():Vector.<SkillItemInfo>
		public function getSkills():Array
		{
			return _list;
		}
	}
}