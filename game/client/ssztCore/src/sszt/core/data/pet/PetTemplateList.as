package sszt.core.data.pet
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;

	public class PetTemplateList
	{
		public static var list:Dictionary = new Dictionary();
		
		public static function setup(data:ByteArray):void
		{
//			if(data.readBoolean())
//			{
//				data.readUTF();
				var len:int = data.readInt();
				for(var i:int = 0; i < len; i++)
				{
					var item:PetTemplateInfo = new PetTemplateInfo();
					item.parseData(data);
					list[item.templateId] = item;
				}
//			}
//			else
//			{
//				MAlert.show(data.readUTF());
//			}
		}
		
		public static function getPet(id:int):PetTemplateInfo
		{
			return list[id];
		}
		
		
	}
}