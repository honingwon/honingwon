package sszt.core.data.mounts
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.manager.LanguageManager;
	import sszt.ui.container.MAlert;

	public class MountsDiamondTemplateList
	{
		public static var infoList:Dictionary = new Dictionary();
		public function MountsDiamondTemplateList()
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
					var info:MountsDiamondTemplate = new MountsDiamondTemplate();
					info.parseData(data);
					if(!infoList[info.templateId])
					{
						infoList[info.templateId] = new Dictionary();
					}
					infoList[info.templateId][info.diamond] = info;
				}
//			}
		}
		
		public static function getDiamondInfo(templateId:int,diamond:int):MountsDiamondTemplate
		{
			return infoList[templateId][diamond];
		}
		
		public static function getDiamondInfoByGrowup(templateId:int,growup:int):MountsDiamondTemplate
		{
			var diamond:int;
			diamond = Math.floor(growup/10);
			return infoList[templateId][diamond];
		}
	}
}