package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	/**强化花费金钱表**/
	public class StrengCopperTemplateList
	{
//		public static var list:Vector.<StrengCopperInfo> = new Vector.<StrengCopperInfo>();
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
					var info:StrengCopperInfo = new StrengCopperInfo();
					info.parseData(data);
					list.push(info);
				}
			}
		}
		
		public static function getStrengCopperInfo(argStrengthLevel:int):StrengCopperInfo
		{
			for each(var i:StrengCopperInfo in list)
			{
				if(i.strengLevel == argStrengthLevel)
				{
					return i;
				}
			}
			return null;
		}
	}
}