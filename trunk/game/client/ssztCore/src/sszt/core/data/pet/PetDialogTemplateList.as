package sszt.core.data.pet
{
	import flash.utils.ByteArray;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class PetDialogTemplateList
	{
		private static var _list:Array = new Array();
		
		public function PetDialogTemplateList()
		{
		}
		
		public static function parseData(data:ByteArray):void
		{
			if(!data.readBoolean())
			{
				MAlert.show(data.readUTF(),LanguageManager.getAlertTitle());
			}
			else
			{
				data.readUTF();
				var len:int = data.readInt();
				for(var i:int = 0; i < len; i++)
				{
					var info:PetDialogTemplate = new PetDialogTemplate();
					info.parseData(data);
					_list.push(info);
				}
			}
		}
		
		public static function getListByQuality(quality:int):Array
		{
			var list:Array = [];
			for each(var i:PetDialogTemplate in _list)
			{
				if(i.quality == quality) list.push(i);
			}
			return list;
		}
	}
}