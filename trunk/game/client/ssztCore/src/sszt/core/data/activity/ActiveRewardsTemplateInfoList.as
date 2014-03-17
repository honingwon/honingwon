package sszt.core.data.activity
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.manager.LanguageManager;
	import sszt.ui.container.MAlert;

	public class ActiveRewardsTemplateInfoList
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
					var info:ActiveRewardsTemplateInfo = new ActiveRewardsTemplateInfo();
					info.parseData(data);
					list[info.id] = info;
				}
//			}
		}
		
		public static function getActiveRewardsTemplateInfo(id:int):ActiveRewardsTemplateInfo
		{
			return list[id];
		}
		
		public static function getActiveRewardByCount(count:int):ActiveRewardsTemplateInfo
		{
			for(var i:int = list.length - 1;i >= 0;i--)
			{
				if(count - list[i].activeNum >= 0) return list[i];
			}
			return list[0];
		}
	}
}