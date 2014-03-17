package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class FormulaTemplateList
	{
		/**
		 *炼炉模板表 
		 * 
		 */		
//		public static var list:Vector.<FormulaInfo> = new Vector.<FormulaInfo>();
		public static var list:Array = [];
		
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
					var formulaInfo:FormulaInfo = new FormulaInfo();
					formulaInfo.parseData(data);
					list.push(formulaInfo);
				}
//			}
		}
		
		/**切卡ID，分类ID,职业ID**/
		public static function getListByType(argTypeId:int,argSortId:int,argCareerId:int):Array
		{
//			var tmp:Vector.<FormulaInfo> = new Vector.<FormulaInfo>();
			var tmp:Array = new Array();
			for each(var i:FormulaInfo in list)
			{
				if(i.typeId == argTypeId && i.sortId == argSortId && (i.getTempalteInfo().needCareer == argCareerId || i.getTempalteInfo().needCareer == 0))
				{
					tmp.push(i);
				}
			}
			return tmp;
		}
	}
}