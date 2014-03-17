package sszt.core.data.friendship
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class FriendshipTemplateList
	{
		public static var _friendshipDic:Dictionary = new Dictionary();
		public static var _friendshipArray:Array = [];
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var info:FriendshipTemplateInfo = new FriendshipTemplateInfo();
				info.parseData(data);
				_friendshipDic[info.level] = info;
				_friendshipArray[i] = info;
			}
		}
	}
}