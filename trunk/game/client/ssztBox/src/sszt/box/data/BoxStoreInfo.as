package sszt.box.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.box.events.ShenMoStoreEvent;
	import sszt.core.data.item.ItemInfo;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class BoxStoreInfo extends EventDispatcher
	{
		public var itemList:Array;
		private static var _gainItemList:Array = [];
		public static const MAX_SIZE:int = 300;
		
		public function BoxStoreInfo(target:IEventDispatcher=null)
		{
			super(target);
			itemList = [];
		}
		
		public function get gainItemList():Array
		{
			return _gainItemList;
		}
		
		public function set gainItemList(list:Array):void
		{
			_gainItemList = list;
			dispatchEvent(new ShenMoStoreEvent(ShenMoStoreEvent.GAIN_ITEM_UPDATE,_gainItemList));
		}
		
		public function clearList():void
		{
			itemList = [];
		}
		
		public function getItemsByPage(page:int,pageSize:int):Array
		{
			return itemList.slice((page - 1) * pageSize,page * pageSize);
		}
		
		public function addItem(item:ItemInfo):void
		{
//			for(var i:int=0;i<MAX_SIZE;i++)
//			{
//				if(itemList[i] && itemList[i].itemId == item.itemId)
//				{
//					itemList[i] = item;
//					dispatchEvent(new ShenMoStoreEvent(ShenMoStoreEvent.UPDATE,i));
//						return;
//				}
//			}
			var tmp:ItemInfo = getItem(item.itemId);
			if(tmp)
			{
				tmp.count = item.count;
				dispatchEvent(new ShenMoStoreEvent(ShenMoStoreEvent.ITEM_UPDATE,item.itemId));
				return;
			}
			itemList.push(item);
			dispatchEvent(new ShenMoStoreEvent(ShenMoStoreEvent.ADD_ITEM,item));
		}
		
		public function getItem(id:Number):ItemInfo
		{
			for each(var i:ItemInfo in itemList)
			{
				if(i.itemId == id)
				{
					return i;
				}
			}
			return null;
		}
		
		public function removeItem(itemId:Number):void
		{
//			for(var i:int=0; i<MAX_SIZE;i++)
//			{
//				if(itemList[i] && itemList[i].itemId == itemId)
//				{
//					itemList[i] = null;
//					dispatchEvent(new ShenMoStoreEvent(ShenMoStoreEvent.UPDATE,i));
//				}
//			}
			
			for(var i:int = itemList.length - 1; i >= 0; i--)
			{
				if(itemList[i] && itemList[i].itemId == itemId)
				{
					itemList.splice(i,1);
					dispatchEvent(new ShenMoStoreEvent(ShenMoStoreEvent.REMOVE_ITEM,itemId));
				}
			}
		}
		
		public function removeAll():void
		{
//			for(var i:int=0;i<itemList.length;i++)
//			{
//				if(itemList[i])
//				{
//					removeItem(itemList[i].itemId);
//				}
//			}
			itemList.length = 0;
			dispatchEvent(new ShenMoStoreEvent(ShenMoStoreEvent.CLEAR,null));
		}
		
//		public function getItem(place:int):ItemInfo
//		{
//			if(place<0 || place>MAX_SIZE)
//				return null;
//			return itemList[place];
//		}
		
//		public function getEmptyPlace():int
//		{
//			for(var i:int=0;i<MAX_SIZE;i++)
//			{
//				if(itemList[i] == null)
//					return i;
//			}
//			return -1;
//		}
		
		public function getItemsCount():int
		{
//			var count:int = 0;
//			for(var i:int=0;i<MAX_SIZE;i++)
//			{
//				if(itemList[i])
//				{
//					count++;
//				}
//			}
//			return count;
			return itemList.length;
		}
	}
}