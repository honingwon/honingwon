package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	/**
	 * 
	 * @author Administrator
	 * 装备升级模板表
	 * 
	 */	
	public class PromotionItemTemplateList
	{
		public static var list:Dictionary = new Dictionary();
		
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
					var info:PromotionItemInfo = new PromotionItemInfo();
					info.parseData(data);
					list[info.oldOrgTempId] = info;
				}
//			}
		}
		
		public static function getPromotionItemInfo(id:int):PromotionItemInfo
		{
			return list[id];
		}
	}
}