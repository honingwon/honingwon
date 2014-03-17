package sszt.core.data.bag
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;

	/**
	 * 背包临时存储
	 * @author Administrator
	 * 
	 */	
	public class ClientBagInfo extends EventDispatcher
	{

		public var npcStoreIsOpen:Boolean = false;
		/**
		 * 背包出售 true:打开，false:关闭 
		 */
		public var bagSellIsOpen:Boolean = false;
		public var mailCount:int = 4;
		public var npcStoreCount:int = 12;
//		public var mailList:Vector.<ItemInfo>;
		public var mailList:Array;
//		public var npcStoreList:Vector.<ItemInfo>;
		public var npcStoreList:Array;
//		public var stallShoppingSaleVector:Vector.<StallShopBuySaleInfo>;
		public var stallShoppingSaleVector:Array;
//		public var stallBegSaleVector:Vector.<ItemInfo>;
		public var stallBegSaleVector:Array;
		
		
		public function ClientBagInfo()
		{
//			npcStoreList = new Vector.<ItemInfo>();
			npcStoreList = [];
//			mailList = new Vector.<ItemInfo>(mailCount);
			mailList = new Array(mailCount);
//			stallShoppingSaleVector = new Vector.<StallShopBuySaleInfo>();
			stallShoppingSaleVector = [];
//			stallBegSaleVector = new Vector.<ItemInfo>();
			stallBegSaleVector = [];
		}
		
		/**--------------------其他------------------------**/
		public function clearMailList():void
		{
			for each(var i:ItemInfo in mailList)
			{
				if(i)
					i.lock = false;
			}
//			mailList = new Vector.<ItemInfo>(mailCount);
			mailList = new Array(mailCount);
		}
		
		public function addToMail(info:ItemInfo,place:int):void
		{
			if(mailList[place])
			{
				removeFromMail(place);
			}
			mailList[place] = info;
			mailList[place].lock = true;
//			dispatchEvent(new ClientBagInfoUpdateEvent(ClientBagInfoUpdateEvent.UPDATEMAIL,place));
		}
		
		public function removeFromMail(place:int):void
		{
			if(mailList[place])
			{
				mailList[place].lock = false;
				mailList[place] = null;
			}
//			dispatchEvent(new ClientBagInfoUpdateEvent(ClientBagInfoUpdateEvent.UPDATEFURNACE,place));
		}
		
		
		/**-------------------npc商店出售列表----------------**/
		public function addToNPCStore(info:ItemInfo):void
		{
			var index:int = npcStoreList.length;
			if(index >= npcStoreCount) return;
			npcStoreList.push(info);
			info.lock = true;
			dispatchEvent(new ClientBagInfoUpdateEvent(ClientBagInfoUpdateEvent.ADDTONPCSTORE,info));
		}
		
		/**
		 * 背包出售物品 
		 * @param info
		 * 
		 */
		public function addToBagSell(info:ItemInfo):void
		{
			var index:int = npcStoreList.length;
			if(index >= npcStoreCount) return;
			npcStoreList.push(info);
			info.lock = true;
			dispatchEvent(new ClientBagInfoUpdateEvent(ClientBagInfoUpdateEvent.ADDTONPCSTORE,info));
		}
		
		public function removeFromNPCStore(id:int):void
		{
			for(var i:int = 0;i<npcStoreList.length;i++)
			{
				if(npcStoreList[i] && npcStoreList[i].itemId == id)
				{
					var item:ItemInfo = npcStoreList.splice(i,1)[0];
					item.lock = false;
				}
			}
		}
		
		public function clearNPCStore():void
		{
			for each(var i:ItemInfo in npcStoreList)
			{
				if(i)
					i.lock = false;
			}
//			npcStoreList = new Vector.<ItemInfo>();
			npcStoreList = [];
		}
		
		/**------------以下是摆摊维护的背包数据-----------**/
		
		public function addToStallBegSaleVector(itemInfo:ItemInfo):void
		{
			stallBegSaleVector.push(itemInfo);
			dispatchEvent(new ClientBagInfoUpdateEvent(ClientBagInfoUpdateEvent.STALL_SALE_VECTOR_UPDATE,itemInfo.place));
		}
		
		public function removeFromStallBegSaleVector(place:int):void
		{
			stallBegSaleVector.splice(stallBegSaleVector.indexOf(getItemInfoFromSallSaleVector(place)),1);
			dispatchEvent(new ClientBagInfoUpdateEvent(ClientBagInfoUpdateEvent.STALL_SALE_VECTOR_UPDATE,place));
		}
		
		public function updateToStallBegSaleVector(place:int):void
		{
			var tmpItemInfoFromBegSaleVector:ItemInfo = getItemInfoFromSallSaleVector(place);
			if(tmpItemInfoFromBegSaleVector)
			{
				stallBegSaleVector[stallBegSaleVector.indexOf(tmpItemInfoFromBegSaleVector)] = GlobalData.bagInfo.getItem(place);
				if(!GlobalData.bagInfo.getItem(place))
				{
					removeFromStallBegSaleVector(place);
				}
				else
				{
					dispatchEvent(new ClientBagInfoUpdateEvent(ClientBagInfoUpdateEvent.STALL_SALE_VECTOR_UPDATE,place));
				}
			}
		}
		
		public function addToStallshoppingSaleVector(stallShopSaleInfo:StallShopBuySaleInfo):void
		{
			stallShoppingSaleVector.push(stallShopSaleInfo);
			dispatchEvent(new ClientBagInfoUpdateEvent(ClientBagInfoUpdateEvent.STALL_SHOPPING_SALE_VECTOR_UPDATE,stallShopSaleInfo.itemInfo.place));
		}
		
		public function updateToStallshoppingSaleVector(cellItemInfo:ItemInfo,saleCount:int):void
		{
			var tmpStallShopBuySaleInfo:StallShopBuySaleInfo = getStallShopBuySaleInfoFromStallShoppingSaleVector(cellItemInfo.place);
			if(tmpStallShopBuySaleInfo)
			{
				tmpStallShopBuySaleInfo.count += saleCount;
				dispatchEvent(new ClientBagInfoUpdateEvent(ClientBagInfoUpdateEvent.STALL_SHOPPING_SALE_VECTOR_UPDATE,tmpStallShopBuySaleInfo.itemInfo.place));
			}
			else
			{
				addToStallshoppingSaleVector(new StallShopBuySaleInfo(cellItemInfo,saleCount));
			}
		}
		
		public function removeFromStallShoppingSaleVector(place:int):void
		{
			stallShoppingSaleVector.splice(stallShoppingSaleVector.indexOf(getStallShopBuySaleInfoFromStallShoppingSaleVector(place)),1);
			dispatchEvent(new ClientBagInfoUpdateEvent(ClientBagInfoUpdateEvent.STALL_SHOPPING_SALE_VECTOR_UPDATE,place));
		}
		
		public function clearStallShoppingSaleVector():void
		{
			for(var i:int = stallShoppingSaleVector.length - 1; i >= 0; i--)
			{
				removeFromStallShoppingSaleVector(stallShoppingSaleVector[i].itemInfo.place);
			}
		}
		
		public function clearStallBegSaleVector():void
		{
			for(var i:int = stallBegSaleVector.length - 1;i >= 0;i--)
			{
				if(stallBegSaleVector[i])
				{
					removeFromStallBegSaleVector(stallBegSaleVector[i].place);
				}
			}
		}
		
		public function unLockItemInfoFromStallShoppingSaleVector():void
		{
			for each(var i:StallShopBuySaleInfo in stallShoppingSaleVector)
			{
				i.itemInfo.lock = false;
			}
		}
		
		public function unLockItemInfoFromStallBegSaleVector():void
		{
			for each(var i:ItemInfo in stallBegSaleVector)
			{
				if(i)
				{
					i.lock = false;
				}
			}
		}
		
		public function lockItemInfoToStallBegSaleVector():void
		{
			for each(var i:ItemInfo in stallBegSaleVector)
			{
				if(i)
				{
					i.lock = true;
				}
			}
		}
		//**-------------get方法------------------------**/
		public function getItemInfoFromSallSaleVector(place:int):ItemInfo
		{
			var tmpItemInfo:ItemInfo = null;
			for each(var i:ItemInfo in stallBegSaleVector)
			{
				if(i)
				{
					if(i.place == place)
					{
						tmpItemInfo = i;
						break;
					}
				}
			}
			return tmpItemInfo;
		}
		
		public function getStallShopBuySaleInfoFromStallShoppingSaleVector(place:int):StallShopBuySaleInfo
		{ 
			var tmpStallShopBuySaleInfo:StallShopBuySaleInfo = null;
			for each(var i:StallShopBuySaleInfo in stallShoppingSaleVector)
			{
				if(i.itemInfo.place == place)
				{
					tmpStallShopBuySaleInfo = i;
					break;
				}
			}
			return tmpStallShopBuySaleInfo;
		}
		
		public function getSameItemCountFromShoppingBuyVector(templateId:int):int
		{
			var tmpCount:int;
			for each(var i:StallShopBuySaleInfo in stallShoppingSaleVector)
			{
				if(i.itemInfo.templateId == templateId)
				{
					tmpCount +=i.count;
				}
			}
			return tmpCount;
		}
		

			
	}
}