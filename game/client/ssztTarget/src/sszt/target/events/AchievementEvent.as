package sszt.target.events
{
	import sszt.events.ModuleEvent;
	
	public class AchievementEvent extends ModuleEvent
	{
		/**
		 * 选择成就分类按钮 
		 */		
		public static const SELECT_ACH_TYPE_BTN:String = "selectAchTypeBtn";
		/**
		 * 更新成就点数 
		 */		
		public static const UPDATE_ACH_NUM:String = "updateAchNum";
		
		public function AchievementEvent(type:String, obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, obj, bubbles, cancelable);
		}
	}
}