package sszt.core.data.equipStrength
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class EquipStrengthTemplateList
	{
		public static var _list:Dictionary = new Dictionary();
		
		public function EquipStrengthTemplateList()
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
					var info:EquipStrengthTemplate = new EquipStrengthTemplate();
					info.parseData(data);
					_list[info.level] = info;
				}
//			}
		}
		
		public static function getTemplate(level:int):EquipStrengthTemplate
		{
			return _list[level];
		}
	}
}