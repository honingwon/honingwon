package sszt.core.data.expList
{
	import flash.utils.ByteArray;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class ExpList
	{

//		public static var list:Vector.<ExpInfo> = new Vector.<ExpInfo>(162);
		public static var list:Array = new Array(162);
		
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
					var info:ExpInfo = new ExpInfo();
					info.parseData(data);
					list[i + 1] = info;
				}
//			}
		}
	}
}