package sszt.core.data.item
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class SuitTemplateList
	{
		public static var list:Dictionary = new Dictionary();
		
		public function SuitTemplateList()
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
					var info:SuitTemplateInfo = new SuitTemplateInfo();
					info.parseData(data);
					list[info.id] = info;
				}
//			}
		}
		
		public static function getSuitTemplateList(suitId:int):Array
		{
			var result:Array = [];
			for each(var i:SuitTemplateInfo in list)
			{
				if(i.suitId == suitId)
					result.push(i);
			}
			return result;
		}
	}
}