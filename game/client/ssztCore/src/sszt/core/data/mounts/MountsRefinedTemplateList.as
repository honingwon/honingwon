package sszt.core.data.mounts
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.manager.LanguageManager;
	import sszt.ui.container.MAlert;

	public class MountsRefinedTemplateList
	{
		public static var list:Dictionary = new Dictionary();
		
		public function MountsRefinedTemplateList()
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
					var info:MountsRefinedTemplate = new MountsRefinedTemplate();
					info.parseData(data);
					if(!list[info.templateId])
					{
						list[info.templateId] = new Dictionary();
					}
					list[info.templateId][info.level] = info;
				}
//			}
		}
		
		public static function getMountsRefinedTemplate(templateId:int,level:int):MountsRefinedTemplate
		{
			if(level ==0)
				return new MountsRefinedTemplate();
			return list[templateId][level];
		}
	}
}