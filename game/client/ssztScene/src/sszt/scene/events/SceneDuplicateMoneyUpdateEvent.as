package sszt.scene.events
{
	import flash.events.Event;
	
	public class SceneDuplicateMoneyUpdateEvent extends Event
	{		
		public static const DUPLICATE_MONEY_UPDATE_COMBO:String = "duplicateMoneyUpdateCombo";
//		public static const DUPLICATE_MONEY_UPDATE_KILL_NUM:String = "duplicateMoneyUpdateKillNum";
		public static const DUPLICATE_MONEY_UPDATE_KILL_BOSS:String = "duplicateMoneyUpdateBoss";
		public static const DUPLICATE_MONEY_UPDATE_PICKUP_MONEY:String = "duplicateMoneyUpdatePickUpMoney";
		public static const DUPLICATE_MONEY_UPDATE_COMBO_STATE:String = "duplicateMoneyUpdateComboState";
//		public static const DUPLICATE_MONEY_RAND_MONEY_START:String = "duplicateMoneyRandMoneyStart";在更新boss的时候同时使用
		public static const DUPLICATE_MONEY_RAND_MONEY_STOP:String = "duplicateMoneyRandMoneyStop";
		
		public var data:Object;
		public function SceneDuplicateMoneyUpdateEvent(type:String, obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}