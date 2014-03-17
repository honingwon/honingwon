package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class DecomposeCopperTemplateList
	{
		/**洗练花费金钱表 **/
//		public static var list:Vector.<DecomposeCopperInfo> = new Vector.<DecomposeCopperInfo>();
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
					var info:DecomposeCopperInfo = new DecomposeCopperInfo();
					info.parseData(data);
					list.push(info);
				}
//			}
		}
		
		public static function getDecomposeCopper(argQuality:int):DecomposeCopperInfo
		{
			for each(var i:DecomposeCopperInfo in list)
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