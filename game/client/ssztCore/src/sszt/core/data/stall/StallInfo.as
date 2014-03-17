package sszt.core.data.stall
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.player.PlayerMoneyResInfo;
	import sszt.core.manager.LanguageManager;

	public class StallInfo extends EventDispatcher
	{
		//摆摊名字
		private var _stallName:String;
		//交易信息
		private var _stallContent:String;
		//每页格子数
		public static const PAGE_SIZE:int = 18;
		//所有页的格子总数
		public static const STALL_PAGE_SIZE:int = 18;
		//待购容器
//		public var begBuyInfoVector:Vector.<StallBuyCellInfo> = new Vector.<StallBuyCellInfo>();
//		public var dealItemVector:Vector.<StallDealItemInfo> = new Vector.<StallDealItemInfo>();
//		public var messageItemVector:Vector.<StallMessageItemInfo> = new Vector.<StallMessageItemInfo>();
		public var begBuyInfoVector:Array = [];
		public var dealItemVector:Array = [];
		public var messageItemVector:Array = [];
		
		public function StallInfo()
		{
		}
		
		/**-----------对容器增删改查操作---------------**/
		public function addToBegBuyVector(stallBuyCellInfo:StallBuyCellInfo):void
		{
			begBuyInfoVector.push(stallBuyCellInfo);
			dispatchEvent(new StallGoodsPanelEvents(StallGoodsPanelEvents.STALL_BUY_GOODS_UPDATE,stallBuyCellInfo.templateId));
		}
		
		public function removeFromBegBuyVector(templateId:int):void
		{
			begBuyInfoVector.splice(begBuyInfoVector.indexOf(getBuyItemFromBegBuyVector(templateId)),1);
			
			dispatchEvent(new StallGoodsPanelEvents(StallGoodsPanelEvents.STALL_BUY_GOODS_UPDATE,templateId));
		}
		
		public function updateBegBuyVector(templateId:int,remainCount:int):void
		{
			var tmpStallBuyCellInfo:StallBuyCellInfo = getBuyItemFromBegBuyVector(templateId);
			if(!tmpStallBuyCellInfo)
			{
				MAlert.show(LanguageManager.getWord("ssztl.common.noDataInWaitBuy"));
				return;
			}
			tmpStallBuyCellInfo.num = remainCount;
			if(tmpStallBuyCellInfo.num == 0)
			{
				removeFromBegBuyVector(templateId);
			}
			else
			{
				dispatchEvent(new StallGoodsPanelEvents(StallGoodsPanelEvents.STALL_BUY_GOODS_UPDATE,tmpStallBuyCellInfo.templateId));
			}
		}
		
		public function clearBegBuyVector():void
		{
			for(var i:int = begBuyInfoVector.length - 1;i >= 0;i--)
			{
				removeFromBegBuyVector(begBuyInfoVector[i].templateId);
			}
		}
		
		//解锁清空物品
		public function clearAllVector():void
		{
			clearBegBuyVector();
			GlobalData.clientBagInfo.unLockItemInfoFromStallBegSaleVector();
			GlobalData.clientBagInfo.clearStallBegSaleVector();
		}
		
		public function addToDealItemVector(argStallDealItemInfo:StallDealItemInfo):void
		{
			dealItemVector.push(argStallDealItemInfo);
			dispatchEvent(new StallDealPanelEvents(StallDealPanelEvents.STALL_CONTENT_UPDATE,argStallDealItemInfo));
		}
		
		public function addToMessageItemVector(argStallMessageItemInfo:StallMessageItemInfo):void
		{
			messageItemVector.push(argStallMessageItemInfo);
			dispatchEvent(new StallDealPanelEvents(StallDealPanelEvents.STALL_CONTENT_UPDATE,argStallMessageItemInfo));
		}
		
		public function ClearDealItemVector():void
		{
			for each(var i:StallDealItemInfo in dealItemVector)
			{
				i = null;
			}
//			dealItemVector = new Vector.<StallDealItemInfo>();
			dealItemVector = [];
		}
		
		public function ClearMessageItemVector():void
		{
			for each(var i:StallMessageItemInfo in messageItemVector)
			{
				i = null;
			}
//			messageItemVector = new Vector.<StallMessageItemInfo>();
			messageItemVector = [];
		}
		
		public function clearContentVector():void
		{
			ClearDealItemVector();
			ClearMessageItemVector();
			dispatchEvent(new StallDealPanelEvents(StallDealPanelEvents.STALL_CLEAR_CONTENT));
		}
			
		
		/**-----------------------get方法------------------**/
		
		public function getBuyItemFromBegBuyVector(templateId:int):StallBuyCellInfo
		{
			//从数据层找到数据对象
			for each(var i:StallBuyCellInfo in begBuyInfoVector)
			{
				if(i.templateId == templateId)
				{
					return i;
					break;
				}
			}
			return null;
		}
				
		public function get stallName():String
		{
			return _stallName;
		}

		public function set stallName(value:String):void
		{
			_stallName = value;
			dispatchEvent(new StallDealPanelEvents(StallDealPanelEvents.STALL_NAME_UPDATE));
		}

		public function get stallContent():String
		{
			return _stallContent;
		}

		public function set stallContent(value:String):void
		{
			_stallContent = value;
			dispatchEvent(new StallDealPanelEvents(StallDealPanelEvents.STALL_CONTENT_UPDATE));
		}

	}
}