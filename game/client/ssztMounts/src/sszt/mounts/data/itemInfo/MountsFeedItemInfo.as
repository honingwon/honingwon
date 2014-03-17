package sszt.mounts.data.itemInfo
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.mounts.event.MountsEvent;

	public class MountsFeedItemInfo extends EventDispatcher
	{
		private var _bagItemInfo:ItemInfo;
		public var count:int;
		public var type:int;
		public var placeList:Array = [];
		public function MountsFeedItemInfo(argBagItemInfo:ItemInfo,argType:int = -1)
		{
			_bagItemInfo = argBagItemInfo;
			count = _bagItemInfo.count;
			type = argType;
		}
		

		public function get bagItemInfo():ItemInfo
		{
			return _bagItemInfo;
		}

		public function set bagItemInfo(value:ItemInfo):void
		{
			_bagItemInfo = value;
//			if(placeList.length > 0)
//			{
				count =  _bagItemInfo.count - placeList.length;
//			}
//			else
//			{
//				count = _bagItemInfo.count;
//			}
			dispatchEvent(new MountsEvent(MountsEvent.ITEMINFO_CELL_UPDATE));
		}
		
		public function removePlace(argPlace:int):void
		{
			for(var i:int = placeList.length - 1;i >= 0;i--)
			{
				if(placeList[i] == argPlace)
				{
					placeList.splice(i,1);
					break;
				}
			}
		}
		
		//放回资源库时操作(数量，锁定等变化)
		public function setBack():void
		{
			count++;
			dispatchEvent(new MountsEvent(MountsEvent.ITEMINFO_CELL_UPDATE));
		}
		
		//放上炉上时操作(数量，锁定等变化)
		public function setTo():void
		{
			count--;
			dispatchEvent(new MountsEvent(MountsEvent.ITEMINFO_CELL_UPDATE));
		}
		
		public function addPlace(argPlace:int):void
		{
			placeList.push(argPlace);
		}
	}
}