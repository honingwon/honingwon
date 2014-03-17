package sszt.pet.event
{
	import flash.events.Event;
	
	public class PetMediatorEvent extends Event
	{
		public var data:Object;
		public static const PET_START_COMMAND:String = "petStartCommand";
		public static const PET_END_COMMAND:String = "petEndCommand";
		public static const PET_START:String = "petStart";
		public static const SHOW_PET:String = "petShow";
		public static const PET_DISPOSE:String = "petDispose";
		
		public function PetMediatorEvent(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}