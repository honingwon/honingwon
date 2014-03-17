package sszt.pet.event
{
	import flash.events.Event;
	
	public class PetEvent extends Event
	{
		public var data:Object;
		/**
		 * 切换宠物 
		 */
		public static const PET_SWITCH:String = 'petSwitch';
		public static const GET_SKILL_BOOK_LIST:String = 'getSkillBookList';
		public static const GET_SKILL_BOOK_SUCCESSED:String = 'getSkillBooksuccessed';
		
		
		
		public function PetEvent(type:String, obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data =obj;
			super(type, bubbles, cancelable);
		}
	}
}