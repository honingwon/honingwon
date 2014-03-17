package sszt.petpvp.events
{
	import flash.events.Event;
	
	public class PetPVPMediatorEvent extends Event
	{
		public static const PET_PVP_COMMAND_START:String = 'petPVPCommandStart';
		public static const PET_PVP_COMMAND_END:String = 'petPVPCommandEnd';
		
		public static const PET_PVP_START:String = 'petPVPStart';
		public static const PET_PVP_DISPOSE:String = 'petPVPDispose';
		
		public function PetPVPMediatorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}