package sszt.core.data.box
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.ui.container.MAlert;
	
	public class BoxTemplateList extends EventDispatcher
	{
		private static var _boxTemplateList:Dictionary;
		
				
		public static function setup(data:ByteArray):void
		{
			_boxTemplateList = new Dictionary();
			
//			if(!data.readBoolean())
//			{
//				MAlert.show(data.readUTF());
//				return;
//			}
//			data.readUTF();
			var len:int = data.readInt();
			for(var i:int=0; i<len; i++)
			{
				var type:int = data.readInt();
				var itemsStr:String = data.readUTF();
				var list:Array = [];
				var itemTemplateIds:Array = itemsStr.split(",");
				for(var j:int=0;j<itemTemplateIds.length;j++)
				{
					var itemTemplate:ItemTemplateInfo = ItemTemplateList.getTemplate(parseInt(itemTemplateIds[j]));
					list.push(itemTemplate);
				}
				_boxTemplateList[type] = list;
			}
		}
		
		public static function getTemplateArray(type:int):Array
		{
			return _boxTemplateList[type] as Array;
		}
	}
}