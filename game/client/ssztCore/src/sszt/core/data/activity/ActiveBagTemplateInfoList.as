package sszt.core.data.activity
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class ActiveBagTemplateInfoList
	{
		public static var list:Array = new Array();
		
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
					var info:ActiveBagTemplateInfo = new ActiveBagTemplateInfo();
					info.parseData(data);
					list.push(info);
				}
			}
		}
		
		public static function getActiveRewardsTemplateInfo(id:int):ActiveBagTemplateInfo
		{
			return list[id];
		}
		
		public static function getTemplateByCount(count:int):ActiveBagTemplateInfo
		{
			for(var i:int = list.length - 1;i >= 0;i--)
			{
				if(count - list[i].activeNum >= 0) return list[i];
			}
			return list[0];
		}
	}
}