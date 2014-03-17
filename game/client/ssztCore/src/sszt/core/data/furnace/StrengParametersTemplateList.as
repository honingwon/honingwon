package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class StrengParametersTemplateList
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
					var info:StrengParametersInfo = new StrengParametersInfo();
					info.parseData(data);
					list[info.id] = info;
				}
			}
		}
		
		public static function getStrengParametersInfo(id:int):StrengParametersInfo
		{
			return list[id];
		}
		
		public static function getStrengParametersInfoByQuality(argQuality:int,argLevel:int):StrengParametersInfo
		{
			for each(var i:StrengParametersInfo in list)
			{
				if(i.equipQuality == argQuality && argLevel >= i.equipMinLevel && argLevel <= i.equipMaxLevel)
				{
					return i;
				}
			}
			return null;
		}
		
	}
}