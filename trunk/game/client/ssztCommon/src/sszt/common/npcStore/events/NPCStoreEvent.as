package sszt.common.npcStore.events
{
	import flash.events.Event;
	
	public class NPCStoreEvent extends Event
	{
		public static const BUYGOOD:String = "buyGood";
		public static const SALEGOOD:String = "saleGood";
		
		public static const CLOSE_PANEL:String = "closePanel";
		
		public var data:Object;
		
		public function NPCStoreEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}