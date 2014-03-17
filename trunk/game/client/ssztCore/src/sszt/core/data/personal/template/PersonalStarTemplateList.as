package sszt.core.data.personal.template
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class PersonalStarTemplateList
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
					var info:PersonalStarTemplateInfo = new PersonalStarTemplateInfo();
					info.parseData(data);
					list[info.starId] = info;
				}
			}
		}
		
		public static function getStarTemplateInfo(id:int):PersonalStarTemplateInfo
		{
			return list[id];
		}
	}
}