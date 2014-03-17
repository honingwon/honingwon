package sszt.core.data.mounts
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class MountsStarTemplateList
	{
		public static var infoList:Dictionary = new Dictionary();
		public function MountsStarTemplateList()
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
					var info:MountsStarTemplate = new MountsStarTemplate();
					info.parseData(data);
					if(!infoList[info.templateId])
					{
						infoList[info.templateId] = new Dictionary();
					}
					infoList[info.templateId][info.star] = info;
				}
//			}
		}
		
		public static function getStarInfo(templateId:int,star:int):MountsStarTemplate
		{
			return infoList[templateId][star];
		}
		
		public static function getStarInfoByQuality(templateId:int,quality:int):MountsStarTemplate
		{
			var star:int;
			star = Math.floor(quality/10);
			return infoList[templateId][star];
		}
		
	}
}