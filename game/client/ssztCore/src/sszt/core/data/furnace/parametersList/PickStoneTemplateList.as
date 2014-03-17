package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	/**宝石摘取成功率表**/
	public class PickStoneTemplateList
	{
//		public static var list:Vector.<PickStoneInfo> = new Vector.<PickStoneInfo>();
		public static var list:Array = [];
		
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
					var info:PickStoneInfo = new PickStoneInfo();
					info.parseData(data);
					list.push(info);
				}
//			}
		}
		
		public static function getPickStoneInfo(argStoneLevel:int):PickStoneInfo
		{
			for each(var i:PickStoneInfo in list)
			{
				if(i.stoneLevel == argStoneLevel)
				{
					return i;
				}
			}
			return null;
		}
	}
}