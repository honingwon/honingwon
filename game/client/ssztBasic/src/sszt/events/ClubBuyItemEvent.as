package sszt.events
{
	import sszt.events.ModuleEvent;
	
	public class ClubBuyItemEvent extends ModuleEvent
	{
		/**
		 *帮会商城购买物品
		 */		
		public static const CLUB_BUY_ITEM:String = "clubBuyItem";
		
		public function ClubBuyItemEvent(type:String, obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, obj, bubbles, cancelable);
		}
	}
}