package sszt.core.data.item
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.constData.CategoryType;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.socket.IPackageIn;
	
	public class PlaceCategoryTemaplteList
	{
		public static var list:Dictionary = new Dictionary();
		
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
					var info:PlaceCategoryTemaplteInfo = new PlaceCategoryTemaplteInfo();
					info.parseData(data);
					list[info.categoryId] = info;
				}
//			}
		}
		
		public static function getPlaceCategoryTemaplteInfo(categoryId:int):PlaceCategoryTemaplteInfo
		{
			return list[categoryId];
		}
		
		public static function categoryToPlace(categoryId:int):int
		{
			var place:int;
			var info:PlaceCategoryTemaplteInfo = getPlaceCategoryTemaplteInfo(categoryId);
			if(info)
			{
				place = info.place;
			}
			else
			{
				place = -1;
			}
			return place;
		}
	}
}