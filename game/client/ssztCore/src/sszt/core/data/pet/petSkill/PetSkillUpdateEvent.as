package sszt.core.data.pet.petSkill
{
	import flash.events.Event;
	
	public class PetSkillUpdateEvent extends Event
	{
		public var data:Object;
		public function PetSkillUpdateEvent(type:String,obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}