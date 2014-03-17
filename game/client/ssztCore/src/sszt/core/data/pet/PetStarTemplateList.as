package sszt.core.data.pet
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class PetStarTemplateList
	{
		public static var infoList:Dictionary = new Dictionary();
		public function PetStarTemplateList()
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
					var info:PetStarTemplate = new PetStarTemplate();
					info.parseData(data);
					if(!infoList[info.templateId])
					{
						infoList[info.templateId] = new Dictionary();
					}
					infoList[info.templateId][info.star] = info;
				}
//			}
		}
		
		public static function getStarInfo(templateId:int,star:int):PetStarTemplate
		{
			return infoList[templateId][star];
		}
		
		
	}
}