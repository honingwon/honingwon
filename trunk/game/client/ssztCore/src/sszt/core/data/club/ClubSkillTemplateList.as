package sszt.core.data.club
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class ClubSkillTemplateList
	{
		public static var list:Dictionary = new Dictionary();
		
		public static function parseData(data:ByteArray):void
		{
			if(!data.readBoolean())
			{
				MAlert.show(data.readUTF(),LanguageManager.getAlertTitle());
			}
			else
			{
				data.readUTF();
				var len:int = data.readInt();
				for(var i:int = 0; i < len; i++)
				{
					var info:ClubSkillTemplate = new ClubSkillTemplate();
					info.parseData(data);
					list[info.templateId] = info;
				}
			}
		}
		
		public static function getClubSkill(id:int):ClubSkillTemplate
		{
			return list[id];
		}
	}
}