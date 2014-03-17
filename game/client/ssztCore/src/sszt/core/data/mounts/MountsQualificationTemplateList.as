package sszt.core.data.mounts
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class MountsQualificationTemplateList
	{
		public static var infoList:Dictionary = new Dictionary();
		public function MountsQualificationTemplateList()
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
					var info:MountsQualificationTemplate = new MountsQualificationTemplate();
					info.parseData(data);
					if(!infoList[info.templateId])
					{
						infoList[info.templateId] = new Dictionary();
					}
					infoList[info.templateId][info.qualification] = info;
				}
//			}
		}
		
		public static function getGrowup(templateId:int,qualification:int):MountsQualificationTemplate
		{
			return infoList[templateId][qualification];
		}
		
		
	}
}