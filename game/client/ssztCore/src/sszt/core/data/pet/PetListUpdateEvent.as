package sszt.core.data.pet
{
	import flash.events.Event;
	
	public class PetListUpdateEvent extends Event
	{
		/**
		 * 添加宠物to列表
		 */
		public static const ADD_PET:String = "addpet";
		/**
		 * 删除宠物from列表
		 */
		public static const REMOVE_PET:String = "removePet";

		public var data:Object;
		
		public function PetListUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}