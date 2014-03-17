package sszt.scene.events
{
	import flash.events.Event;
	
	public class SceneAcroSerUpdateEvent extends Event
	{
		public static var ACROSER_ICON_UPDATE:String = "acroserIconUpdate";
		/**
		 *显示主界面 
		 */		
		public static var ACROSER_SHOW_MAIN_PANEL:String = "acroserShowMainPanel";
		/**面板时间更新**/
		public static const ACROSER_BOSS_WAR_MAIN_INFO_UPDATE:String = "acroserBossWarMainInfoUpdate";
		/**boss关注**/
		public static const ACROSER_BOSS_FOCUSE_UPDATE:String = "acroserBossFocuseUpdate";
		public var data:Object;
		
		public function SceneAcroSerUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}