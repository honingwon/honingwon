package sszt.core.data.skill
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalData;
	import sszt.ui.container.MAlert;

	public class SkillTemplateList
	{
		private static var _list:Dictionary = new Dictionary();
//		private static var _selfActiveCareerList:Vector.<SkillTemplateInfo> = new Vector.<SkillTemplateInfo>(16);
//		private static var _selfPassiveCareerList:Vector.<SkillTemplateInfo> = new Vector.<SkillTemplateInfo>(16);
		private static var _selfActiveCareerList:Array = new Array(9);
		private static var _petActiveList:Array = new Array(9);
		private static var _petPassList:Array = new Array(9);
		private static var _petAssistList:Array = new Array(9);
		private static var _petPassListt:Array = new Array(9);
		private static var _mountActiveList:Array = new Array(9);
		private static var _selfPassiveCareerList:Array = new Array(6);
		
		private static var _selfGuildList:Array = new Array(6);
		
		public static function parseData(data:ByteArray):void
		{
//			if(!data.readBoolean())
//			{
//				MAlert.show(data.readUTF(),"");
//			}
//			else
//			{
//				data.readUTF();
				var len:int = data.readInt();
				for(var i:int = 0; i < len; i++)
				{
					var skill:SkillTemplateInfo = new SkillTemplateInfo();
					skill.parseData(data);
					_list[skill.templateId] = skill;
				}
//			}
		}
		
		/**
		 * 添加模板时自身职业值还没有
		 * 
		 */		
		public static function setCareerList():void
		{
			for each(var skill:SkillTemplateInfo in _list)
			{
				if(skill.needCareer == 4)
				{
					_selfGuildList[skill.place] = skill;
				}
				else if(skill.needCareer == 0 && skill.place >= 0 && skill.templateId != 0)
				{
					if(skill.activeType == 1)
						_mountActiveList[skill.templateId] = skill;
					else if(skill.activeType == 3)
					{
						_petAssistList[skill.templateId] = skill;
					}
					else if(skill.activeType == 4)
					{
						_petPassListt[skill.templateId] = skill;
					}
					else if(skill.activeType == 0 )
					{
						_petActiveList[skill.templateId] = skill;
					}
				}
				else
				{
					if(skill.activeType == 0 || skill.activeType == 2)
					{
						if(skill.needCareer == GlobalData.selfPlayer.career && skill.place >= 0)
						{
							_selfActiveCareerList[skill.place] = skill;
						}
						
					}
					else if(skill.activeType == 1)
					{
						if(skill.needCareer == -1 || (skill.needCareer != -1 && skill.needCareer == GlobalData.selfPlayer.career))
						{
							_selfPassiveCareerList[skill.place] = skill;
						}
					}
					
				}
				
			}
		}
		
		/**
		 * 获取主动技能 
		 * @return 
		 * 
		 */		
		public static function getSelfActiveSkills():Array
		{
			return _selfActiveCareerList;
		}
		/**
		 * 获取宠物主动技能 
		 * @return 
		 * 
		 */		
		public static function getPetActiveSkills():Array
		{
			return _petActiveList;
		}
		/**
		 * 获取宠物被动技能 
		 * @return 
		 * 
		 */		
		public static function getPetPassSkills():Array
		{
			return _petPassListt;
		}
		/**
		 * 获取宠物辅助技能 
		 * @return 
		 * 
		 */		
		public static function getPetAssistSkills():Array
		{
			return _petAssistList;
		}
		/**
		 * 获取坐骑技能 
		 * @return 
		 * 
		 */		
		public static function getMountSkills():Array
		{
			return _mountActiveList;
		}
		
		/**
		 * 获取被动技能 
		 * @return 
		 * 
		 */		
		public static function getSelfPassiveSkills():Array
		{
			return _selfPassiveCareerList;
		}
		
		/**
		 * 获取帮会技能 
		 * @return 
		 * 
		 */		
		public static function getSelfGuildSkills():Array
		{
			return _selfGuildList;
		}
		
		
		
		public static function getSkill(id:int):SkillTemplateInfo
		{
			return _list[id];
		}
	}
}