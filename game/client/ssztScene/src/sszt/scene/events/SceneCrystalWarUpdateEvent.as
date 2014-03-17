package sszt.scene.events
{
	import flash.events.Event;
	
	public class SceneCrystalWarUpdateEvent extends Event
	{
		public static const CRYSTAL_MAIN_INFO_UPDATE:String = "crystalMainInfoUpdate";
		public static const CRYSTAL_MAIN_INFO_PERSONALINFO_UPDATE:String = "crystalMainInfoPersonalInfoUpdate";
		
		public static const CRYSTAL_SCORE_INFO_UPDATE:String = "crystalScoreInfoUpdate";
		public static const CRYSTAL_LEFT_TIME_UPDATE:String = "crystalLeftTimeUpdate";
		public var data:Object;
		public function SceneCrystalWarUpdateEvent(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}