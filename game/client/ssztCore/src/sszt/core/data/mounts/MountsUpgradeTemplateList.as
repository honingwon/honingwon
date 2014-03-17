package sszt.core.data.mounts
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.manager.LanguageManager;
	import sszt.ui.container.MAlert;

	public class MountsUpgradeTemplateList
	{
		public static var list:Dictionary = new Dictionary();
		
		public function MountsUpgradeTemplateList()
		{
			
		}
		
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
					var info:MountsUpgradeTemplate = new MountsUpgradeTemplate();
					info.parseData(data);
					list[info.level] = info;
				}
//			}
		}
		
		public static function getMountsUpgradeTemplate(level:int):MountsUpgradeTemplate
		{
			return list[level];
		}
	}
}