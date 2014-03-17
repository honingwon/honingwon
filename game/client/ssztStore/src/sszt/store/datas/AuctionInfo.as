package sszt.store.datas
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.store.event.StoreEvent;
	
	public class AuctionInfo extends EventDispatcher
	{
		public var list:Array;
		
		public function AuctionInfo(target:IEventDispatcher=null)
		{
			super(target);
			list = [];
		}
		
		public function setData(list:Array):void
		{
			this.list = list;
			dispatchEvent(new StoreEvent(StoreEvent.AUCTION_UPDATE));
		}
		
		public function getItem(auctionId:int):AuctionItem
		{
			for each(var i:AuctionItem in list)
			{
				if(i.auctionId == auctionId)
					return i;
			}
			return null;
		}
	}
}