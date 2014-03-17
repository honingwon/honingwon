package sszt.core.data.veins
{
	import flash.events.Event;
	
	public class VeinsListUpdateEvent extends Event
	{
		public static const ADD_VEINS:String = "addVeins";
		public static const UPDATE_VEINS:String = "updateVeins";
		public static const UPDATE_GENGU:String = "updateGengu";
		/**
		 * 穴位信息更新
		 * */
		public static const REFASH_VEINS:String = "refashVeins";
		public static const REFASH_VEINS_CD:String = "refashVeinsCD"
		
		public var data:Object;
		
		public function VeinsListUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}