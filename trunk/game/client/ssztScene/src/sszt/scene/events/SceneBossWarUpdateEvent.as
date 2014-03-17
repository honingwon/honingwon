package sszt.scene.events
{
	import flash.events.Event;
	
	public class SceneBossWarUpdateEvent extends Event
	{
		/**小图标**/
		public static const BOSS_WAR_LEFT_TIME_UPDATE:String = "bossWarLeftTimeUpdate";
		/**面板时间更新**/
		public static const BOSS_WAR_MAIN_INFO_UPDATE:String = "bossWarMainInfoUpdate";
		/**boss关注**/
		public static const BOSS_FOCUSE_UPDATE:String = "bossFocuseUpdate";
		
		public var data:Object;
		public function SceneBossWarUpdateEvent(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}