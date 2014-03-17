package sszt.club.events
{
	import flash.events.Event;
	
	public class ClubShopInfoUpdateEvent extends Event
	{
		public static const SELF_EXPLOIT_UPDATE:String = "selfExploitUpdate";
		
		public var data:Object;
		
		public function ClubShopInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}