package sszt.consign.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.consign.events.ConsignEvent;
	
	public class GoldConsignInfo extends EventDispatcher
	{
//		public var sellList:Vector.<GoldConsignItem>;
//		public var buyList:Vector.<GoldConsignItem>;
//		public var selfSellList:Vector.<GoldConsignItem>;
//		public var selfBuyList:Vector.<GoldConsignItem>;
		public var sellList:Array;
		public var buyList:Array;
		public var selfSellList:Array;
		public var selfBuyList:Array;
		
		public function GoldConsignInfo()
		{
			super();
//			sellList = new Vector.<GoldConsignItem>();
//			buyList = new Vector.<GoldConsignItem>();
//			selfSellList = new Vector.<GoldConsignItem>();
//			selfBuyList = new Vector.<GoldConsignItem>();
			sellList = [];
			buyList = [];
			selfSellList = [];
			selfBuyList = [];
		}
		
//		public function updates(list:Vector.<GoldConsignItem>):void
//		{
//			for each(var i:GoldConsignItem in list)
//			{
//				switch (i.type)
//				{
//					case 0:
//						sellList.push(i);
//						break;
//					case 1:
//						buyList.push(i);
//						break;
//					case 2:
//						selfSellList.push(i);
//						break;
//					case 3:
//						selfBuyList.push(i);
//						break
//				}
//			}
//		}
		
		public function getItem(argListId:int):GoldConsignItem
		{
			var i:GoldConsignItem;
			for each(i in sellList)
			{
				if(i.listId == argListId)
					return i;
			}
			for each(i in buyList)
			{
					if(i.listId == argListId)
					return i;
		    }
			for each(i in selfSellList)
			{
					if(i.listId == argListId)
					return i;
			}
			for each(i in selfBuyList)
			{
					if(i.listId == argListId)
					return i;
			}
			return null;
		}
		
		public function addItem(item:GoldConsignItem):void
		{
			switch (item.type)
			{
				case 0:
					sellList.push(item);
					break;
				case 1:
					buyList.push(item);
					break;
				case 2:
					selfSellList.push(item);
					break;
				case 3:
					selfBuyList.push(item);
					break
			}
			dispatchEvent(new ConsignEvent(ConsignEvent.ADD_GOLD_ITEM,item));
		}
		
		
		public function removeItem(argListId:Number):void
		{
			var tmpItem:GoldConsignItem = getItem(argListId);
			if(!tmpItem)return;
			switch(tmpItem.type)
			{
				case 0:
					sellList.splice(sellList.indexOf(tmpItem),1);
					dispatchEvent(new ConsignEvent(ConsignEvent.REMOVE_GOILD_ITEM,tmpItem));
					return;
				case 1:
					buyList.splice(buyList.indexOf(tmpItem),1);
					dispatchEvent(new ConsignEvent(ConsignEvent.REMOVE_GOILD_ITEM,tmpItem));
					return;
				case 2:
					selfSellList.splice(selfSellList.indexOf(tmpItem),1);
					dispatchEvent(new ConsignEvent(ConsignEvent.REMOVE_GOILD_ITEM,tmpItem));
					return;
				case 3:
					selfBuyList.splice(selfBuyList.indexOf(tmpItem),1);
					dispatchEvent(new ConsignEvent(ConsignEvent.REMOVE_GOILD_ITEM,tmpItem));
					return;
			}
		}
		
		
//		public function removeItem(price:int):void
//		{
//			var item:GoldConsignItem;
//			for(var i:int =0;i<sellList.length;i++)
//			{
//				if(sellList[i].price == price)
//				{
//					item = sellList.splice(i,1)[0];
//					dispatchEvent(new ConsignEvent(ConsignEvent.REMOVE_GOILD_ITEM,item));
//					return;
//				}
//			}
//			for(i = 0;i<buyList.length;i++)
//			{
//				if(buyList[i].price == price)
//				{
//					item = sellList.splice(i,1)[0];
//					dispatchEvent(new ConsignEvent(ConsignEvent.REMOVE_GOILD_ITEM,item));
//					return;
//				}
//			}
//			for(i = 0;i<selfSellList.length;i++)
//			{
//				if(selfSellList[i].price == price)
//				{
//					item = sellList.splice(i,1)[0];
//					dispatchEvent(new ConsignEvent(ConsignEvent.REMOVE_GOILD_ITEM,item));
//					return;
//				}
//			}
//			for(i = 0;i<selfBuyList.length;i++)
//			{
//				if(selfBuyList[i].price == price)
//				{
//					item = sellList.splice(i,1)[0];
//					dispatchEvent(new ConsignEvent(ConsignEvent.REMOVE_GOILD_ITEM,item));
//					return;
//				}
//			}
//		}
	}
}