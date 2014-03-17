package sszt.core.data.buff
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class BuffTemplateList
	{
		private static var _buffList:Dictionary = new Dictionary();
		
		public static function setup(data:ByteArray):void
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
					var buff:BuffTemplateInfo = new BuffTemplateInfo();
					buff.parseData(data);
					_buffList[buff.templateId] = buff;
				}
//			}
		}
		
		public static function getBuff(id:int):BuffTemplateInfo
		{
			return _buffList[id];
		}
	}
}