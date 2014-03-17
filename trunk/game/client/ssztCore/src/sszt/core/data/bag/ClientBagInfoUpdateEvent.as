package sszt.core.data.bag
{
	import flash.events.Event;
	
	public class ClientBagInfoUpdateEvent extends Event
	{
		public static const UPDATEFURNACE:String = "updateFurnace";
		public static const UPDATEMAIL:String = "updateMail";
		public static const ADDTONPCSTORE:String = "addToNpcStore";
		public static const STALL_SHOPPING_SALE_VECTOR_UPDATE:String = "stallShoppingSaleVectorUpdate";
		public static const STALL_SALE_VECTOR_UPDATE:String = "stallSaleVectorUpdate";
		public static const CLEAR:String = "clear";
		public var data:Object;
		
		public function ClientBagInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}