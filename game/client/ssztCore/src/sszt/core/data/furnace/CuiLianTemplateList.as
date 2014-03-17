package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;
	public class CuiLianTemplateList
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
					var info:CuiLianTemplateInfo = new CuiLianTemplateInfo();
					info.parseData(data);
					list[info.id] = info;
				}
			}
		}
		
		public static function getCuiLianTemplateInfo(id:int):CuiLianTemplateInfo
		{
			return list[id];
		}
		
		public static function getCuiLianByCategoryId(argPlace:int,argLevel:int):CuiLianTemplateInfo
		{
			for each(var i:CuiLianTemplateInfo in list)
			{
				if(i.place == argPlace && i.level == argLevel)
				{
					return i;
				}
			}
			return null;
		}
	}
}