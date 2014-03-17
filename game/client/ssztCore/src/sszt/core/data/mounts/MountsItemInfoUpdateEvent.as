package sszt.core.data.mounts
{
	import flash.events.Event;
	
	public class MountsItemInfoUpdateEvent extends Event
	{
		public static const CHANGE_STATE:String = "changeState";		
		public static const UPDATE:String = "update";		
		public static const UPDATE_EXP:String = "updateExp";
		public static const UPDATE_GROW:String = "updateGrow";		
		public static const UPDATE_REFIEDN:String = "updateRefined";
		public static const UPDATE_QUALITY:String = "updateQuality";
		public static const ADD_SKILL:String = "addSkill";
		public static const REMOVE_SKILL:String = "removeSkill";
		public static const SKILL_UPDATE:String = "skillUpdate";
		public static const UPDATE_PROPERTY_RATE:String = "updatePropertyRate";
		public static const UPDATE_STAIRS:String = "updateStairs";
		
		public var data:Object;
		
		public function MountsItemInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}