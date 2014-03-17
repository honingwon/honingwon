package sszt.core.data.pet
{
	import flash.events.Event;
	
	public class PetShowInfoUpdateEvent extends Event
	{
		public static const PET_SHOW_INFO_LOAD_COMPLETE:String = 'petShowInfoLoadComplete';
		
		public function PetShowInfoUpdateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}