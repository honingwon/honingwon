package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	/**宝石镶嵌表**/
	public class StoneEnchaseTemplateList
	{
//		public static var list:Vector.<StoneEnchaseInfo> = new Vector.<StoneEnchaseInfo>();
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
					var info:StoneEnchaseInfo = new StoneEnchaseInfo();
					info.parseData(data);
					list.push(info);
				}
//			}
		}
		
		public static function getStoneEnchaseInfo(argStoneLevel:int):StoneEnchaseInfo
		{
			for each(var i:StoneEnchaseInfo in list)
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