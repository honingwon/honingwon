package sszt.core.data.personal.template
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class PersonalProvinceTemplateList
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
					var info:PersonalProvinceTemplateInfo = new PersonalProvinceTemplateInfo();
					info.parseData(data);
					list[info.provinceId] = info;
				}
			}
		}
		
		public static function getProvinceTemplateInfo(id:int):PersonalProvinceTemplateInfo
		{
			return list[id];
		}
	}
}