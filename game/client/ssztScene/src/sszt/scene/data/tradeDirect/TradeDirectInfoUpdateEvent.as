package sszt.scene.data.tradeDirect
{
	import flash.events.Event;
	
	public class TradeDirectInfoUpdateEvent extends Event
	{
		public static const ADDSELFITEM:String = "addSelfItem";
		public static const REMOVESELFITEM:String = "removeSelfItem";
		
		public static const ADDOTHERITEM:String = "addOtherItem";
		public static const REMOVEOTHERITEM:String = "removeOtherItem";
		
		public static const SELFLOCK_UPDATE:String = "selfLockUpdate";
		public static const OTHERLOCK_UPDATE:String = "otherLockUpdate";
		
		public static const SELFSURE_UPDATE:String = "selfSureUpdate";
		public static const OTHERSURE_UPDATE:String = "otherSureUpdate";
		
		public static const DOCANCEL:String = "doCancel";
		public static const DOCOMPLETE:String = "doComplete";
		
		public static const OTHERCOPPER_CHANGE:String = "otherCopperChange";
		
		public var data:Object;
		
		public function TradeDirectInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}