package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	/**打孔模板表**/
	public class HoleTemplateList
	{
//		public static var list:Vector.<HoleInfo> = new Vector.<HoleInfo>();
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
					var info:HoleInfo = new HoleInfo();
					info.parseData(data);
					list.push(info);
				}
			}
		}
		
		public static function getHoleInfoNum(argHoleFlag:int,argHolePlace:int):int
		{
			for each(var i:HoleInfo in list)
			{
				if(i.holeflag == argHoleFlag)
				{
					return i.enchaseVector[argHolePlace - 1];
				}
			}
			return -1;
		}
	}
}