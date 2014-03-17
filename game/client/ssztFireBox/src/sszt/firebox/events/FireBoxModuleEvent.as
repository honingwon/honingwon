package sszt.firebox.events
{
	import sszt.events.ModuleEvent;
	
	public class FireBoxModuleEvent extends ModuleEvent
	{
		/**
		 * 炼制更新
		 */		
		public static const MIN_BTN_UPDATE:String = "mixBtnUpdate";
		
		public function FireBoxModuleEvent(type:String, obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, obj, bubbles, cancelable);
		}
	}
}