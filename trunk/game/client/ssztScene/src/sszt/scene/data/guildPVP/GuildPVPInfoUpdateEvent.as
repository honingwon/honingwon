package sszt.scene.data.guildPVP
{
	import flash.events.Event;
	
	public class GuildPVPInfoUpdateEvent extends Event
	{
		public static const KILL_UPDATE:String = 'killUpdate';
		public static const RESULT_UPDATE:String = 'resultUpdate';
		public static const RELOAD_UPDATE:String = 'reloadUpdate';
		public static const NICK_UPDATE:String = 'nickUpdate';
		
		public function GuildPVPInfoUpdateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}