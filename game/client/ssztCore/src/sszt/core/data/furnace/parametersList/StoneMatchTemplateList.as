package sszt.core.data.furnace.parametersList
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	/**装备类型对应镶嵌的石头类型 **/
	public class StoneMatchTemplateList
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
					var info:StoneMatchInfo = new StoneMatchInfo();
					info.parseData(data);
					list[info.equipCategoryId] = info;
				}
//			}
		}
		
		public static function getStoneMatchInfo(id:int):StoneMatchInfo
		{
			return list[id];
		}
	}
}