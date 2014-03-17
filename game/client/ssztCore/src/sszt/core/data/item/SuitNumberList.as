package sszt.core.data.item
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class SuitNumberList
	{
		public static var list:Dictionary = new Dictionary();
		
		public function SuitNumberList()
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
					var info:SuitNumberInfo = new SuitNumberInfo();
					info.parseData(data);
					list[info.suitId] = info;
				}
//			}
		}
		
		public static function getSuitNumberInfo(id:int):SuitNumberInfo
		{
			return list[id];
		}
	}
}