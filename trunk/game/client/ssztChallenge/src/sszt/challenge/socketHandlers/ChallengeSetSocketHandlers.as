package sszt.challenge.socketHandlers
{
	import sszt.challenge.ChallengeModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class ChallengeSetSocketHandlers extends BaseSocketHandler
	{
		public function ChallengeSetSocketHandlers(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function add(challenge:ChallengeModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new ChallengeEnterSocketHandler(challenge));
			
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ENTER_CHALLENGE_BOSS);
		}
	}
}