package sszt.core.data.activity
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.manager.LanguageManager;
	import sszt.ui.container.MAlert;
	
	/**活动任务模板表**/
	public class ActivityTaskTemplateInfoList
	{
		public static var list:Dictionary = new Dictionary();
		
		public function ActivityTaskTemplateInfoList()
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
					var info:ActivityTaskTemplateInfo = new ActivityTaskTemplateInfo();
					info.parseData(data);
					list[info.taskId] = info;
				}
//			}
		}
		
		public static function getActivityTask(id:int):ActivityTaskTemplateInfo
		{
			return list[id];
		}
	}
}