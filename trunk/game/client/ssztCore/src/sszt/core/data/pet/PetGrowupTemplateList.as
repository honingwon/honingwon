package sszt.core.data.pet
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class PetGrowupTemplateList
	{
		public static var infoList:Dictionary = new Dictionary();
		public function PetGrowupTemplateList()
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
					var info:PetGrowupTemplate = new PetGrowupTemplate();
					info.parseData(data);
					if(!infoList[info.templateId])
					{
						infoList[info.templateId] = new Dictionary();
					}
					infoList[info.templateId][info.grow_up] = info;
				}
//			}
		}
		
		public static function getGrowup(templateId:int,grow_up:int):PetGrowupTemplate
		{
			return infoList[templateId][grow_up];
		}
		
		
	}
}