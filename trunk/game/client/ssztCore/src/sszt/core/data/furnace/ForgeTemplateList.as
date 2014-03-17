package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class ForgeTemplateList
	{
		/**
		 *炼炉名称表 
		 * 
		 */		
//		public static var list:Vector.<ForgeInfo> = new Vector.<ForgeInfo>();
		public static var list:Array = new Array();
		
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
					var forgeInfo:ForgeInfo = new ForgeInfo();
					forgeInfo.parseData(data);
					list.push(forgeInfo);
				}
//			}
		}
		
	}
}