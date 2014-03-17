package sszt.store.datas
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import sszt.store.event.StoreEvent;

	public class AuctionItem extends EventDispatcher
	{
		public var auctionId:int;
		public var type:int;
		public var templateId:int;
		public var count:int;
		public var time:int;
		public var lowPrice:int;
		public var highPrice:int;
		public var messages:Array;
		
		public function AuctionItem()
		{
			messages = [];
		}
		
		public function appendMessage(serverId:int,nick:String,price:int):void
		{
			var message:AuctionMessageItem = new AuctionMessageItem();
			message.serverId = serverId;
			message.nick = nick;
			message.price = price;
			messages.push(message);
			dispatchEvent(new StoreEvent(StoreEvent.APPEND_AUCTION_MESSAGE,message));
		}
	}
}