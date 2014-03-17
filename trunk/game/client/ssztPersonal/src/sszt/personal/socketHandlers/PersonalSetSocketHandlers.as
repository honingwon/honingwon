package sszt.personal.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.socketHandlers.personal.dynamicInfo.PersonalClubMateDeadSocketHandler;
	import sszt.core.socketHandlers.personal.dynamicInfo.PersonalClubMateUpgradeSocketHandler;
	import sszt.core.socketHandlers.personal.dynamicInfo.PersonalClubTaskShareSocketHandler;
	import sszt.core.socketHandlers.personal.dynamicInfo.PersonalClubUpgradeSocketHandler;
	import sszt.core.socketHandlers.personal.dynamicInfo.PersonalFriendDeadSocketHandler;
	import sszt.core.socketHandlers.personal.dynamicInfo.PersonalFriendTaskShareSocketHandler;
	import sszt.core.socketHandlers.personal.dynamicInfo.PersonalFriendUpgradeSocketHandler;
	import sszt.personal.PersonalModule;
	
	public class PersonalSetSocketHandlers extends BaseSocketHandler
	{
		public function PersonalSetSocketHandlers(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function setSokectHandlers(module:PersonalModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new PersonalMainInoUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PersonalInfoChangeSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PersonalGetRewardsSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PersonalRandomSocketHandler(module));
			
			GlobalAPI.socketManager.addSocketHandler(new PersonalLuckyListUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PersonalLuckySelectUpdateSocketHandler(module));
		}
		
		public static function removeSocketHandlers():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PERSONAL_MAININFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PERSONAL_INFO_CHANGE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PERSONAL_REWARDS);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PERSONAL_RANDOM);
			
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PERSONAL_LUCKY_LISTINFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PERSONAL_LUCKY_SELECTINFO);
		}
	}
}