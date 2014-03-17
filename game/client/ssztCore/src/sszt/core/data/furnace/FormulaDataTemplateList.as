package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	/**
	 *配方表 
	 * 
	 */		
	public class FormulaDataTemplateList
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
					var info:FormulaDataInfo = new FormulaDataInfo();
					info.parseData(data);
					list[info.id] = info;
				}
//			}
		}
		
		public static function getFormularDataInfo(id:int):FormulaDataInfo
		{
			return list[id];
		}
	}
}