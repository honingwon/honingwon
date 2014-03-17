package sszt.consign.data
{
	import flash.events.EventDispatcher;
	
	import sszt.consign.events.ConsignEvent;

	public class GoldConsignItem extends EventDispatcher
	{
		public var listId:Number;
		public var price:int;
		public var count:int;
		/**
		 *0出售，1求购，2我的出售，3我的求购 
		 */		
		public var type:int;
		
		public function GoldConsignItem(listId:Number,price:int,count:int,type:int)
		{
			this.listId = listId;
			this.price = price;
			this.count = count;
			this.type = type;
		}
		
		public function update(price:int,count:int,type:int):void
		{
			this.price = price;
			this.count = count;
			this.type = type;
			dispatchEvent(new ConsignEvent(ConsignEvent.GOLD_ITEM_UPDATE));
		}
	}
}