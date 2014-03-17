package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.manager.LanguageManager;
	import sszt.ui.container.MAlert;

	public class FuseTemplateList
	{
		public static var list:Dictionary = new Dictionary();
		
		public function FuseTemplateList()
		{
			
		}
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
				for(var i:int = 0; i < len; i++)
				{
					var info:FuseTemplate = new FuseTemplate();
					info.parseData(data);
					if(!list[info.item_template_id1])
					{
						list[info.item_template_id1] = new Dictionary();
					}
					list[info.item_template_id1][info.item_template_id2] = info;
				}
		}
		
		public static function getFuseTemplate(item_template_id1:int,item_template_id2:int):FuseTemplate
		{
			var r:FuseTemplate;
			if(list[item_template_id1])
			{
				r = list[item_template_id1][item_template_id2];
			}
			else if(list[item_template_id2])
			{
				r = list[item_template_id2][item_template_id1];
			}
			return r;
		}
	}
}