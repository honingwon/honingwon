package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.manager.LanguageManager;
	import sszt.ui.container.MAlert;

	/**
	 * 
	 * @author Administrator
	 *物品合成模板表 
	 */	
	public class LuckComposeTemplateList
	{
		public static var list:Dictionary = new Dictionary();
		
		public static var vecter:Array = [[],[],[],[]]; 
		
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
					var info:LuckComposeTemplateInfo = new LuckComposeTemplateInfo();
					info.parseData(data);
					list[info.formulaId] = info;
					if(info.bigType < 5)
						vecter[info.bigType - 1].push(info);
				}
//			}
		}
		
		public static function getLuckComposeTemplateInfo(id:int):LuckComposeTemplateInfo
		{
			return list[id];
		}
		public static function getLuckComposeTemplateVecter(bigType:int):Array
		{
			if(bigType > 0 && bigType < 5)
				return vecter[bigType - 1];
			else
				return [];
		}
	}
}