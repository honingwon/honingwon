package sszt.core.data.activity
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	/**活跃度模板表**/
	public class ActiveTemplateInfoList
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
					var info:ActiveTemplateInfo = new ActiveTemplateInfo();
					info.parseData(data);
					list[info.id] = info;
				}
//			}
		}
		
		public static function getActiveTempalteInfo(id:int):ActiveTemplateInfo
		{
			return list[id];
		}
	}
}