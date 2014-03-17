package sszt.stall.data
{
	import flash.events.Event;
	
	public class StallShopEvents extends Event
	{
		public var _data:Object;
		public static var STALLSHOP_BEG_SALE_VECTOR_UPDATE:String = "stallShopBegSaleVectorUpdate";
		public static var STALLSHOP_BEG_BUY_VECTOR_UPDATE:String = "stallShopBegBuyVectorUpdate";
		public static var STALLSHOP_BUY_VECTOR_UPDATE:String = "stallShopBuyVectorUpdate";
		
		public function StallShopEvents(type:String, data:Object,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
	}
}