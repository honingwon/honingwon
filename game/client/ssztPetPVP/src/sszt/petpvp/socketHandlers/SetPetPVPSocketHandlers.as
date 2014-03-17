package sszt.petpvp.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.petpvp.PetPVPModule;

	public class SetPetPVPSocketHandlers
	{
		public static function add(module:PetPVPModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new PetPVPChallengeInfoUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PetPVPInfoSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PetPVPChallengeTimesUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PetPVPStartChallengingSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PetPVPStartChallengingWithClearCDSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PetPVPMyPetsInfoUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PetPVPRankInfoUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PetPVPLogListUpdateSocketHandler(module));
			
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_PVP_LOG_LIST);
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_PVP_GET_DAILY_REWARD);
//			GlobalAPI.socketManager.addSocketHandler(new PetPVPGetDailyRewardSocketHandler(module));
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_PVP_CHALLENGE_INFO_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_PVP_INFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_PVP_START_CHALLENGING);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_PVP_START_CHALLENGING_WITH_CLEAR_CD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_PVP_CHALLENGE_TIMES_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_PVP_MY_PET_INFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_PVP_RANK_INFO);	
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_PVP_LOG_LIST);	
			
			//添加一个全局的监听器
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_PVP_GET_DAILY_REWARD);
//			GlobalAPI.socketManager.addSocketHandler(new PetPVPLogListUpdateSocketHandler());
//			GlobalAPI.socketManager.addSocketHandler(new PetPVPGetDailyRewardSocketHandler());
		}
	}
}