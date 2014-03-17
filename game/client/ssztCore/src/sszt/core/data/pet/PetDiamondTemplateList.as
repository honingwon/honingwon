package sszt.core.data.pet
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class PetDiamondTemplateList
	{
		public static var infoList:Dictionary = new Dictionary();
		public function PetDiamondTemplateList()
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
					var info:PetDiamondTemplate = new PetDiamondTemplate();
					info.parseData(data);
					if(!infoList[info.templateId])
					{
						infoList[info.templateId] = new Dictionary();
					}
					infoList[info.templateId][info.diamond] = info;
				}
//			}
		}
		
		public static function getDiamondInfo(templateId:int,diamond:int):PetDiamondTemplate
		{
			return infoList[templateId][diamond];
		}
		
		
	}
}