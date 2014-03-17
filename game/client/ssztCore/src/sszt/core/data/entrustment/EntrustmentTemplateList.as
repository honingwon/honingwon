package sszt.core.data.entrustment
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class EntrustmentTemplateList
	{
		public static var list:Dictionary = new Dictionary();
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			var item:EntrustmentTemplateItem;
			for(var i:int = 0; i < len; i++)
			{
				item = new EntrustmentTemplateItem();
				item.parseData(data);
				list[item.id] = item;
			}
		}
		
		public static function getEntrustable(duplicateId:int):Boolean
		{
			var ret:Boolean;
			var item:EntrustmentTemplateItem;
			for each(item in list)
			{
				if(item.duplicateId == duplicateId)
				{
					ret = true;
					break;
				}
			}
			return ret;
		}
		
		public static function getFightNeed(duplicateId:int,floor:int):int
		{
			var ret:int;
			var item:EntrustmentTemplateItem;
			for each(item in list)
			{
				if(item.duplicateId == duplicateId && item.floor == floor)
				{
					ret = item.fightNeeded;
					break;
				}
			}
			return ret;
		}
		
		public static function getTemplateById(id:int):EntrustmentTemplateItem
		{
			return list[id];
		}
		
		public static function getTemplate(duplicateId:int,floor:int):EntrustmentTemplateItem
		{
			var ret:EntrustmentTemplateItem;
			var item:EntrustmentTemplateItem;
			for each(item in list)
			{
				if(item.duplicateId == duplicateId && item.floor == floor)
				{
					ret = item;
					break;
				}
			}
			return ret;
		}
		
		public static function getTemplateCollection(duplicate:int):Array
		{
			var ret:Array = [];
			for each(var i:EntrustmentTemplateItem in list)
			{
				if(i.duplicateId == duplicate)
				{
					ret.push(i);
				}
			}
			return ret;
		}
	}
}