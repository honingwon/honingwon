package sszt.core.data.club
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class ClubShopLevelTemplateList
	{
		private static var _list:Dictionary = new Dictionary();
		
		public function ClubShopLevelTemplateList()
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
					var info:ClubShopLevelTemplate = new ClubShopLevelTemplate();
					info.parseData(data);
					_list[info.shopLevel] = info;
				}
//			}
		}
		
		public static function getTemplate(level:int):ClubShopLevelTemplate
		{
			return _list[level];
		}
	}
}