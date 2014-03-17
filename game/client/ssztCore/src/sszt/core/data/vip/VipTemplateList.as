package sszt.core.data.vip
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class VipTemplateList
	{
		public static var list:Dictionary = new Dictionary();
		
		public function VipTemplateList()
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
					var info:VipTemplateInfo = new VipTemplateInfo();
					info.parseData(data);
					list[info.id] = info;
				}
//			}
		}
		
		public static function getVipTemplateInfo(argId:int):VipTemplateInfo
		{
			return list[argId];
		}
	}
}