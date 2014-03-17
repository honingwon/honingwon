package sszt.core.data.personal.template
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class PersonalCityTemplateList
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
					var info:PersonalCityTemplateInfo = new PersonalCityTemplateInfo();
					info.parseData(data);
					list[info.cityId] = info;
				}
			}
		}
		
		
		public static function getCityTemplateList(argProvinceId:int):Array
		{
			var tmpList:Array = [];
			for each(var i:PersonalCityTemplateInfo in list)
			{
				if(i.provinceId == argProvinceId)
				{
					tmpList.push(i);
				}
			}
			return tmpList;
		}
		
		public static function getCityTemplateInfo(id:int):PersonalCityTemplateInfo
		{
			return list[id];
		}
	}
}