package sszt.core.data.club
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.manager.LanguageManager;
	
	public class ClubMonsterTemplateList extends EventDispatcher
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
					var info:ClubMonsterTemplateInfo = new ClubMonsterTemplateInfo();
					info.parseData(data);
					list[info.monsterId] = info;
				}
			}
		}
		
		public static function getClubMonsterTemplate(monsterId:int):ClubMonsterTemplateInfo
		{
			return list[monsterId];
		}
		
		public static function getClubMonsterByLevel(argLevel:int):ClubMonsterTemplateInfo
		{
			for each(var i:ClubMonsterTemplateInfo in list)
			{
				if(i.clubMonsterLevel == argLevel)
				{
					return i;
				}
			}
			return null;
		}
	}
}