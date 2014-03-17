package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class StrengTemplateList
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
					var info:StrengInfo = new StrengInfo();
					info.parseData(data);
					list[info.id] = info;
				}
			}
		}
		
		public static function getStrengInfo(id:int):StrengInfo
		{
			return list[id];
		}
		
		public static function getStrengInfoByTypeLevel(argCategoryId:int,argLevel:int):StrengInfo
		{
			for each(var i:StrengInfo in list)
			{
				if(i.equipType == argCategoryId && i.equipLevel == argLevel)
				{
					return i;	
				}
			}
			return null;
		}
		
		
	}
}