package sszt.scene.events
{
	import flash.events.Event;
	
	public class SceneClubUpdateEvent extends Event
	{
		public static const CLUB_FIRE_ICON_UPDATE:String = "clubFireIconUpdate";
		
		public var data:Object;
		public function SceneClubUpdateEvent(type:String, obj:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}