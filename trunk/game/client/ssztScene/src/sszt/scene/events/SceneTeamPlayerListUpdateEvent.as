package sszt.scene.events
{
	import flash.events.Event;
	
	public class SceneTeamPlayerListUpdateEvent extends Event
	{
		public static const ADDPlAYER:String = "addPlayer";
		public static const REMOVEPLAYER:String = "removePlayer";
		public static const CHANGELEADER:String = "change leader";
		public static const DISBAND:String = "disband";
		public static const CHANGEJOINTYPE:String = "ChangeJoinType";
		
		public static const UPDATE_PLAYER_STYLE:String = "updatePlayerStyle";
		public static const UPDATE_PARTNER_POSITION:String = "updatePartnerPosition";
		public static const UPDATE_TEAMPLAYER_STATE:String = "updateTeamPlayerState";
		
		public static const UPDATE_TEAMPLAYER_LEVEL:String = "teamPlayerLevleUpdate";
		
		public var data:Object;
		
		public function SceneTeamPlayerListUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}