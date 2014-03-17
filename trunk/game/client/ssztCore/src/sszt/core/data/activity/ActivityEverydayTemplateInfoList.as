package sszt.core.data.activity
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class ActivityEverydayTemplateInfoList
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
					var info:ActivityEverydayTemplateInfo = new ActivityEverydayTemplateInfo();
					info.parseData(data);
					list[info.id] = info;
				}
			}
		}
		
		public static function getActivityEverydayTemplateInfo(id:int):ActivityEverydayTemplateInfo
		{
			return list[id];
		}
		
		public static function getActivityEveryDayListByType(argType:int):Array
		{
			var tmpList:Array = [];
			for(var i:int = 0;i < list.length;i++)
			{
				if(list[i].type == argType)
				{
					tmpList.push(list[i]);
				}
			}
			return tmpList;
		}
	}
}