package sszt.common.wareHouse.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.common.wareHouse.event.WareHouseEvent;
	import sszt.core.data.item.ItemInfo;
	
	public class WareHouseInfo extends EventDispatcher
	{
//		public var itemList:Vector.<ItemInfo>;
		public var itemList:Array;
		public static const MAX_SIZE:int = 108;
		public var currentDrag:ItemInfo;
		
		public function WareHouseInfo()
		{
			super();
//			itemList = new Vector.<ItemInfo>(MAX_SIZE);
			itemList = new Array();
		}
		
//		public function setCopper(value:int):void
//		{
//			copper = value;
//			dispatchEvent(new WareHouseEvent(WareHouseEvent.COPPER_CHANGE));
//		}
		
//		public function updates(list:Vector.<ItemInfo>):void
		public function updates(list:Array):void
		{
//			var updates:Vector.<int> = new Vector.<int>();
			var updates:Array = new Array();
			for each(var i:ItemInfo in list)
			{
				if(!i.isExist)
				{
					itemList[i.place] = null;
				}
				else
				{
					itemList[i.place] = i;
					itemList[i.place].updateInfo();
				}
				updates.push(i.place);
			}
			dispatchEvent(new WareHouseEvent(WareHouseEvent.UPDATE,updates));
		}
		
		public function addItem(item:ItemInfo):void
		{
			if(itemList.indexOf(item) == -1)
			{
				itemList[item.place] = item;
				dispatchEvent(new WareHouseEvent(WareHouseEvent.ADD_ITEM,item));
			}
		}
		
		public function getItem(place:int):ItemInfo
		{
			if(place<0||place>MAX_SIZE) return null;
			return itemList[place];
		}
		
		public function remove(place:int):void
		{
			if(place<0||place>= itemList.length) return;
			itemList[place] = null;
			dispatchEvent(new WareHouseEvent(WareHouseEvent.REMOVE_ITEM,place));
		}
	}
}