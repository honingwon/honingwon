package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	/**强化失败附加成功率表**/
	public class StrengAddsuccrateTemplateList
	{
//		public static var list:Vector.<StrengAddsuccrateInfo> = new Vector.<StrengAddsuccrateInfo>();
		public static var list:Array = [];
		
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
					var info:StrengAddsuccrateInfo = new StrengAddsuccrateInfo();
					info.parseData(data);
					list.push(info);
				}
			}
		}
		
		public static function getStrengAddsuccrateInfo(argFailCount:int):StrengAddsuccrateInfo
		{
			for each(var i:StrengAddsuccrateInfo in list)
			{
				if(i.failCount == argFailCount)
				{
					return i;
				}
			}
			return null;
		}
	}
}