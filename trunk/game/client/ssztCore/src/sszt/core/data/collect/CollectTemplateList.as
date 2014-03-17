package sszt.core.data.collect
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;

	public class CollectTemplateList
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
					var item:CollectTemplateInfo = new CollectTemplateInfo();
					item.parseData(data);
					list[item.id] = item;
				}
//			}
//			else
//			{
//				MAlert.show(data.readUTF());
//			}
		}
		
		public static function getCollect(id:int):CollectTemplateInfo
		{
			return list[id];
		}
		
		public static function getMapCollects(argMapId:int):Array
		{
			var tmpList:Array = [];
			for each(var i:CollectTemplateInfo in list)
			{
				if(i.sceneId == argMapId)
				{
					tmpList.push(i);
				}
			}
			return tmpList;
		}
	}
}