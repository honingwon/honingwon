package sszt.consign.data
{
	import flash.events.EventDispatcher;
	import sszt.consign.data.Item.MyItemInfo;
	import sszt.consign.data.Item.SearchItemInfo;
	import sszt.consign.events.ConsignEvent;
	import sszt.core.data.item.ItemInfo;

	public class ConsignInfo extends EventDispatcher
	{
		public static const PAGE_SIZE:int = 5;
		public var currentPage:int;
		public var totalRecords:int;
//		private var _searchItemList:Vector.<SearchItemInfo>;
//		private var _myItemList:Vector.<MyItemInfo>;
		private var _searchItemList:Array;
		private var _myItemList:Array;
		public var place:int = -1;
		
		public static const MYCONSIGN_PAGE_SIZE:int = 4;
		public var myConsignCurPage:int;
		public var myConsignTotalRecords:int;
		
		public function ConsignInfo()
		{
//			_searchItemList = new Vector.<SearchItemInfo>();
//			_myItemList = new Vector.<MyItemInfo>();
			_searchItemList = [];
			_myItemList = [];
		}
		
		/**-----------增删改查------------**/
		public function addToSearchItemList(searchItemInfo:SearchItemInfo):void
		{
			_searchItemList.push(searchItemInfo);
			dispatchEvent(new ConsignEvent(ConsignEvent.SEARCHLIST_UPDATE,searchItemInfo.listId));
		}
		
		public function removeFromSearchItemList(argListId:Number):void
		{
			_searchItemList.splice(_searchItemList.indexOf(getSearchItemInfoFromSearchList(argListId)),1);
			dispatchEvent(new ConsignEvent(ConsignEvent.SEARCHLIST_UPDATE,argListId));
		}
		
		public function addToMyItemList(myItemInfo:MyItemInfo):void
		{
			_myItemList.push(myItemInfo);
			dispatchEvent(new ConsignEvent(ConsignEvent.MYLIST_UPDATE,myItemInfo.listId));
		}
		
		public function removeFromMyItemList(argListId:Number):void
		{
			_myItemList.splice(_myItemList.indexOf(getMyItemInfoFromMyList(argListId)),1);
			dispatchEvent(new ConsignEvent(ConsignEvent.MYLIST_UPDATE,argListId));
		}
		
		public function clearSearchItemList():void
		{
			for(var i:int = _searchItemList.length - 1;i >= 0;i--)
			{
				if(_searchItemList[i])removeFromSearchItemList(_searchItemList[i].listId);
			}
		}
		public function clearMyItemList():void
		{
			for(var i:int = _myItemList.length - 1;i >= 0;i--)
			{
				if(_myItemList[i])removeFromMyItemList(_myItemList[i].listId);
			}
		}
		
		/**-------------get方法----------------**/
		public function getMyItemInfoFromMyList(argListId:Number):MyItemInfo
		{
			for(var i:int = _myItemList.length - 1;i >= 0;i--)
			{
				if(_myItemList[i].listId == argListId)
				{
					return _myItemList[i];
				}
			}
			return null;
		}
		
		public function getSearchItemInfoFromSearchList(argListId:Number):SearchItemInfo
		{
			for(var i:int = _searchItemList.length - 1;i >= 0;i--)
			{
				if(_searchItemList[i].listId == argListId)
				{
					return _searchItemList[i];
				}
			}
			return null;
		}

//		public function get myItemList():Vector.<MyItemInfo>
		public function get myItemList():Array
		{
			return _myItemList;
		}

		public function setPage(argTotoalRecords:int,argCurrentPage:int):void
		{
			currentPage = argCurrentPage;
			totalRecords = argTotoalRecords;
			dispatchEvent(new ConsignEvent(ConsignEvent.PAGE_UPDATE));
		}
		
		public function setMyConsignPage(argTotoalRecords:int,argCurrentPage:int):void
		{
			myConsignCurPage = argCurrentPage;
			myConsignTotalRecords = argTotoalRecords;
			dispatchEvent(new ConsignEvent(ConsignEvent.MYCONSIGN_PAGE_UPDATE));
		}
		
		public function updatePlace(value:int):void
		{
			if(place == value)return;
			place = value;
			dispatchEvent(new ConsignEvent(ConsignEvent.INFO_PLACE_UPDATE));
		}
	}
}