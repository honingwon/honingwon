package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.manager.LanguageManager;
	import sszt.ui.container.MAlert;
	
	public class StrengthenTemplateList
	{
		public static var list:Dictionary = new Dictionary();
		public static function parseData(data:ByteArray):void
		{
//			if(!data.readBoolean())
//			{
//				MAlert.show(data.readUTF(),LanguageManager.getAlertTitle());
//			}
//			else
//			{
//				data.readUTF();
				var len:int = data.readInt();
				for(var i:int = 0; i < len; i++)
				{
					var info:StrengthenInfo = new StrengthenInfo();
					info.parseData(data);
					list[info.level] = info;
				}
//			}
		}
		
		public static function getStrengthenInfo(level:int):StrengthenInfo
		{
			return list[level];
		}
		
		public static function getStrengthenAddition(level:int, perfect:int):int
		{
			var addition:int = 0;
			if(	list[level])
			{
				addition = list[level].growUp + list[level].addition * perfect / 100;
			}
			return addition;
		}
		
	}
}