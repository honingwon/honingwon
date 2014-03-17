package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	/**重铸成功几率表**/
	public class RebuildTemplateList
	{
//		public static var list:Vector.<RebuildInfo> = new Vector.<RebuildInfo>();
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
					var info:RebuildInfo = new RebuildInfo();
					info.parseData(data);
					list.push(info);
				}
			}
		}
		
		public static function getRebuildInfo(argType:int,argQuality:int):RebuildInfo
		{
			for each(var i:RebuildInfo in list)
			{
				if(i.categoryId == argType && i.quality == argQuality)
				{
					return i;
				}
			}
			return null;
		}
	}
}