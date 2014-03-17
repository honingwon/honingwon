package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	/**宝石合成铜币消耗**/
	public class StoneComposeTemplateList
	{
//		public static var list:Vector.<StoneComposeInfo> = new Vector.<StoneComposeInfo>();
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
					var info:StoneComposeInfo = new StoneComposeInfo();
					info.parseData(data);
					list.push(info);
				}
//			}
		}
		
		public static function getStoneComposeInfo(argStoneLevel:int):StoneComposeInfo
		{
			for each(var i:StoneComposeInfo in list)
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