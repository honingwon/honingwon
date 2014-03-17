package sszt.stall.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.StallShopBuySaleInfo;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.stall.StallBuyCellInfo;
	
	public class StallShopInfo extends EventDispatcher
	{
		public static var PAGE_SIZE:int = 18;
		
//		private var _stallBegBuyVector:Vector.<StallBuyCellInfo> = new Vector.<StallBuyCellInfo>();
//		private var _stallBegSaleVector:Vector.<ItemInfo> = new Vector.<ItemInfo>();
//		private var _shoppingBuyVector:Vector.<StallShopBuySaleInfo> = new Vector.<StallShopBuySaleInfo>();
		private var _stallBegBuyVector:Array = [];
		private var _stallBegSaleVector:Array = [];
		private var _shoppingBuyVector:Array = [];
		
		public function StallShopInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function addToStallBegBuyVector(stallBuyCellInfo:StallBuyCellInfo):void
		{
			_stallBegBuyVector.push(stallBuyCellInfo);
			dispatchEvent(new StallShopEvents(StallShopEvents.STALLSHOP_BEG_BUY_VECTOR_UPDATE,stallBuyCellInfo.templateId));
		}
		
		public function removeFromStallBegBuyVector(templateId:int):void
		{
			_stallBegBuyVector.splice(_stallBegBuyVector.indexOf(getStallBuyCellInfoFromStallBegBuyVector(templateId)),1);
			dispatchEvent(new StallShopEvents(StallShopEvents.STALLSHOP_BEG_BUY_VECTOR_UPDATE,templateId));
		}
		
		public function updateToStallBegBuyVector(templateId:int,buyCount:int):void
		{
			var tmpStallBuyCellInfo:StallBuyCellInfo = getStallBuyCellInfoFromStallBegBuyVector(templateId);
			tmpStallBuyCellInfo.num -= buyCount;
			if(tmpStallBuyCellInfo.num == 0)
			{
				removeFromStallBegBuyVector(tmpStallBuyCellInfo.templateId);
			}
			else
			{
				dispatchEvent(new StallShopEvents(StallShopEvents.STALLSHOP_BEG_BUY_VECTOR_UPDATE,templateId));
			}
		}
		
		public function addToStallBegSaleVector(itemInfo:ItemInfo):void
		{
			_stallBegSaleVector.push(itemInfo);
			dispatchEvent(new StallShopEvents(StallShopEvents.STALLSHOP_BEG_SALE_VECTOR_UPDATE,itemInfo.place));
		}
		
		public function updateToStallBegSaleVector(itemInfo:ItemInfo,backCount:int):void
		{
			var tmpItemInfo:ItemInfo = getItemInfoFromStallBegSaleVector(itemInfo.place);
			if(tmpItemInfo)
			{
				tmpItemInfo.count += backCount;
				dispatchEvent(new StallShopEvents(StallShopEvents.STALLSHOP_BEG_SALE_VECTOR_UPDATE,itemInfo.place));
			}
			else
			{
				itemInfo.count += backCount;
				addToStallBegSaleVector(itemInfo);
			}
		}
		
		public function removeFromStallBegSaleVector(place:int):void
		{
			_stallBegSaleVector.splice(_stallBegSaleVector.indexOf(getItemInfoFromStallBegSaleVector(place)),1);
			dispatchEvent(new StallShopEvents(StallShopEvents.STALLSHOP_BEG_SALE_VECTOR_UPDATE,place));
		}
		
		public function updateFromStallBegSaleVector(place:int,saleCount:int):void
		{
			var tmpItemInfo:ItemInfo = getItemInfoFromStallBegSaleVector(place);
			tmpItemInfo.count -= saleCount;
			tmpItemInfo.lock = false;
			if(tmpItemInfo.count == 0)
			{
				removeFromStallBegSaleVector(place);
			}
			else
			{
				dispatchEvent(new StallShopEvents(StallShopEvents.STALLSHOP_BEG_SALE_VECTOR_UPDATE,place));
			}
		}
		
		
		public function addToShoppingBuyVector(stallShopBuyInfo:StallShopBuySaleInfo):void
		{
			_shoppingBuyVector.push(stallShopBuyInfo);
			dispatchEvent(new StallShopEvents(StallShopEvents.STALLSHOP_BUY_VECTOR_UPDATE,stallShopBuyInfo.itemInfo.place));
		}
		
		public function updateToShoppingBuyVector(itemInfo:ItemInfo,buyCount:int):void
		{
			var tmpStallShopBuySaleInfo:StallShopBuySaleInfo = getStallShopBuyInfoFromShoppingBuyVector(itemInfo.place);
			if(tmpStallShopBuySaleInfo)
			{
				tmpStallShopBuySaleInfo.count += buyCount;
				dispatchEvent(new StallShopEvents(StallShopEvents.STALLSHOP_BUY_VECTOR_UPDATE,tmpStallShopBuySaleInfo.itemInfo.place));
			}
			else
			{
				addToShoppingBuyVector(new StallShopBuySaleInfo(itemInfo,buyCount));
			}
		}
		
		public function removeFromShoppingBuyVector(place:int):void
		{
			_shoppingBuyVector.splice(_shoppingBuyVector.indexOf(getStallShopBuyInfoFromShoppingBuyVector(place)),1);
			dispatchEvent(new StallShopEvents(StallShopEvents.STALLSHOP_BUY_VECTOR_UPDATE,place));
		}
		
		public function updateFromShoppingBuyVector(place:int,backCount:int):void
		{
			var tmpStallShopBuySaleInfo:StallShopBuySaleInfo = getStallShopBuyInfoFromShoppingBuyVector(place);
			tmpStallShopBuySaleInfo.count -= backCount;
			if(tmpStallShopBuySaleInfo.count == 0)
			{
				removeFromShoppingBuyVector(place);
			}
			else
			{
				dispatchEvent(new StallShopEvents(StallShopEvents.STALLSHOP_BUY_VECTOR_UPDATE,place));
			}
		}
		
		
		/**-----------------------get方法-------------**/
		
		public function getStallBuyCellInfoFromStallBegBuyVector(templateId:int):StallBuyCellInfo
		{ 
			var temStallBuyCellInfo:StallBuyCellInfo = null;
			for each(var i:StallBuyCellInfo in _stallBegBuyVector)
			{
				if(i.templateId == templateId)
				{
					temStallBuyCellInfo = i;
					break;
				}
			}
			return temStallBuyCellInfo;
		}
		
		public function getItemInfoFromStallBegSaleVector(place:int):ItemInfo
		{ 
			var tmpItemInfo:ItemInfo = null;
			for each(var i:ItemInfo in _stallBegSaleVector)
			{
				if(i.place == place)
				{
					tmpItemInfo = i;
					break;
				}
			}
			return tmpItemInfo;
		}
		
		
		public function getStallShopBuyInfoFromShoppingBuyVector(place:int):StallShopBuySaleInfo
		{ 
			var tmpStallShopBuyInfo:StallShopBuySaleInfo = null;
			for each(var i:StallShopBuySaleInfo in _shoppingBuyVector)
			{
				if(i.itemInfo.place == place)
				{
					tmpStallShopBuyInfo = i;
					break;
				}
			}
			return tmpStallShopBuyInfo;
		}
		
		public function getSameItemCountFromShoppingBuyVector(templateId:int):int
		{
			var tmpCount:int;
			for each(var i:StallShopBuySaleInfo in GlobalData.clientBagInfo.stallShoppingSaleVector)
			{
				if(i.itemInfo.templateId == templateId)
				{
					tmpCount +=i.count;
				}
			}
			return tmpCount;
		}
		
		public function getAllPriceFromShoppingBuyVector():int
		{
			var tmpPrice:int;
			for each(var i:StallShopBuySaleInfo in _shoppingBuyVector)
			{
				tmpPrice +=i.itemInfo.stallSellPrice * i.count;
			}
			return tmpPrice;
		}
		
		public function getAllPriceFromShoppingSaleVector():int
		{
			var tmpPrice:int;
			for each(var i:StallBuyCellInfo in _stallBegBuyVector)
			{
				tmpPrice += i.price * GlobalData.clientBagInfo.getSameItemCountFromShoppingBuyVector(i.templateId);
			}
			return tmpPrice;
		}
		
//		public function get shoppingBuyVector():Vector.<StallShopBuySaleInfo>
		public function get shoppingBuyVector():Array
		{
			return _shoppingBuyVector;
		}
		
		public function buySuccessUpdate():void
		{
			for(var i:int = _shoppingBuyVector.length - 1;i >= 0;i--)
			{
				updateFromStallBegSaleVector(_shoppingBuyVector[i].itemInfo.place,_shoppingBuyVector[i].count);
				removeFromShoppingBuyVector(_shoppingBuyVector[i].itemInfo.place);
			}
		}
		
		public function saleSuccessUpdate():void
		{
			var tmpStallShopBuySaleInfo:StallShopBuySaleInfo;
			for(var i:int = GlobalData.clientBagInfo.stallShoppingSaleVector.length - 1;i >= 0;i--)
			{
				tmpStallShopBuySaleInfo = GlobalData.clientBagInfo.stallShoppingSaleVector[i];
				tmpStallShopBuySaleInfo.itemInfo.lock = false;
				updateToStallBegBuyVector(tmpStallShopBuySaleInfo.itemInfo.templateId,tmpStallShopBuySaleInfo.count);
				GlobalData.clientBagInfo.removeFromStallShoppingSaleVector(tmpStallShopBuySaleInfo.itemInfo.place);
			}
		}
		
		public function clearBegBuyVector():void
		{
			for(var i:int  = _stallBegBuyVector.length - 1;i >= 0;i--)
			{
				removeFromStallBegBuyVector(_stallBegBuyVector[i].templateId);
			}
		}
		
		public function clearBegSaleVector():void
		{
			for(var i:int = _stallBegSaleVector.length - 1;i >= 0;i--)
			{
				removeFromStallBegSaleVector(_stallBegSaleVector[i].place);
			}
		}
		
		public function clearShoppingBuyVector():void
		{
			for(var i:int = _shoppingBuyVector.length - 1;i >= 0;i--)
			{
				removeFromShoppingBuyVector(_shoppingBuyVector[i].itemInfo.place);
			}
		}
		
		public function clearAllVector():void
		{
			clearBegBuyVector();
			clearBegSaleVector();
			clearShoppingBuyVector();
			GlobalData.clientBagInfo.clearStallShoppingSaleVector();
		}
		
	}
}