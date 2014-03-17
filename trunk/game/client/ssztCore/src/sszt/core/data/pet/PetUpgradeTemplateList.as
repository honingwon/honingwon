package sszt.core.data.pet
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.manager.LanguageManager;
	import sszt.ui.container.MAlert;

	public class PetUpgradeTemplateList
	{
		public static var list:Dictionary = new Dictionary();
		
		public function PetUpgradeTemplateList()
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
					var info:PetUpgradeTemplate = new PetUpgradeTemplate();
					info.parseData(data);
					list[info.level] = info;
				}
//			}
		}
		
		public static function getMountsUpgradeTemplate(level:int):PetUpgradeTemplate
		{
			return list[level];
		}
	}
}