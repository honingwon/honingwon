package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	/**装备分解表**/
	public class DecomposeTemplateList
	{
//		public static var list:Vector.<DecomposeInfo> = new Vector.<DecomposeInfo>();
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
					var info:DecomposeInfo = new DecomposeInfo();
					info.parseData(data);
					list.push(info);
				}
			}
		}
		
		public static function getDecomposeInfo(argQuality:int):DecomposeInfo
		{
			for each(var i:DecomposeInfo in list)
			{
				if(i.quality == argQuality)
				{
					return i;
				}
			}
			return null;
		}
	}
}