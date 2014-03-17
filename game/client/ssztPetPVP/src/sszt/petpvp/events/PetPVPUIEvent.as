package sszt.petpvp.events
{
	import flash.events.Event;
	
	public class PetPVPUIEvent extends Event
	{
		public var data:Object;
		
		public static const PET_CELL_CHANGE:String = 'petCellChange';
		public static const CHALLENGE_PET_ITEM_VIEW_CHANGE:String = 'challengePetItemViewChange';
		
		public function PetPVPUIEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
		}
	}
}