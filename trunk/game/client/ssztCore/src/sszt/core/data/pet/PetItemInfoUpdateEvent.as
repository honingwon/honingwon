package sszt.core.data.pet
{
	import flash.events.Event;
	
	public class PetItemInfoUpdateEvent extends Event
	{
		/**
		 * 更新单个宠物信息，用于更新宠物攻击、防御类、战斗力品阶、进化、资质属性。
		 */
		public static const UPDATE:String = "update";
		public static const SKILL_UPDATE:String = "skillUpdate";
		public static const UPDATE_GROW_EXP:String = "updateGrowExp";	
		public static const UPDATE_QUALITY_EXP:String = "updateQualityExp";
		public static const UPDATE_ENERGY:String = "updateEnergy";
		public static const UPDATE_EXP:String = "updateExp";
		public static const CHANGE_STATE:String = "changeState";
		public static const RENAME:String = "rename";
		public static const UPGRADE:String = "upgrade";
		public static const REMOVE_SKILL:String = "removeSkill";
		
		public static const UPDATE_STYLE:String = "updateStyle";
		public static const UPDATE_PROPERTY_RATE:String = "updatePropertyRate";
		
		public var data:Object;
		
		public function PetItemInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}