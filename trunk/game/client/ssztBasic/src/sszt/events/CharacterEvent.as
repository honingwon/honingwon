package sszt.events
{
	import flash.events.Event;
	
	public class CharacterEvent extends Event
	{
		public static const CHARACTER_UPDATE:String = "characterUpdate";
		
		public static const CHARACTER_ACTIONCOMPLETE:String = "characterActionComplete";
		
		public static const DIR_UPDATE:String = "dirUpdate";
		
		public var data:Object;
		
		public function CharacterEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}