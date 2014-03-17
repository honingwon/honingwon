package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.events.ClubDutyInfoUpdateEvent;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;

	public class SetClubSocketHandlers
	{
		public static function add(module:ClubModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new ClubArmyAppointSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubArmyCreateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubArmyEnounceSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubArmyKickOutSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubArmyRenameSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubArmyUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubBackCampSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubChargeMasterSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubClearTryinPageSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubClearTryinSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubContributeLogSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubContributeUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubContributionSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubCreateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubDetailSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubDismissSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubDutyChangeSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubDutyUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubEnterClubScenceSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubEventAddSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubEventUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubExitSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubExtendAddSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubExtendUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubGetDeviceInfoSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubGetPaySocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubGetWealSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubKickOutSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubLevelUpSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubLevelupUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubMailSendSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubOnlineUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubQueryListSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubQueryMemberSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubQueryTryinSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubSkillActiveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubSkillLearnSocketHandler(module));			
			GlobalAPI.socketManager.addSocketHandler(new ClubStoreAppliedItemRecordsSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubStoreExamineAndVerifySocketHandler(module));			
			GlobalAPI.socketManager.addSocketHandler(new ClubStoreEventSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubStoreApplyforItemSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubStoreCancelItemRequestSocketHandler(module));	
			GlobalAPI.socketManager.addSocketHandler(new ClubStoreDealItemRequestSocketHandler(module));	
			GlobalAPI.socketManager.addSocketHandler(new ClubStoreGetSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubStoreOpenStateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubStorePageUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubStorePutSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubTaskUsableSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubTryInResponseSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubTryinSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubUpdateDeviceInfoSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubUpgradeDeviceSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubWarDealQueryListSockethandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubWarDealSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubWarDeclearBtnSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubWarDeclearQueryListSockethandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubWarEnemyQueryListSockethandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubWarEnemyStopSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubWealUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubMonsterUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubMonsterUpgradeSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubRemoveMemeberReturnInfoSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new GetMailNumSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubCampCallSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubCampCallRemainingTimesSockectHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubLotterySocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubLotteryGetTimesSocketHandler(module));
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_ARMY_APPOINT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_ARMY_CREATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_ARMY_ENOUNCE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_ARMY_KICKOUT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_ARMY_RENAME);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_ARMY_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_BACK_CAMP);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_CHARGE_MASTER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_CLEARTRYIN_PAGE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_CLEARTRYIN);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_CONTRIBUTE_LOG);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_CONTRIBUTE_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_CONTRIBUTION);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_CREATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_DETAIL);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_DISMISS);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_DUTY_CHANGE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_DUTY_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_ENTER_SCENCE);
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_EVENT_ADD);
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_EVENT_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_EXIT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_EXTEND_ADD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_EXTEND_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_GET_DEVICE_INFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_GETPAY);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_GETWEAL);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_KICKOUT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_LEVELUP);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_LEVELUP_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MAIL_GUILD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_ONLINE_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_QUERYLIST);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_QUERYMEMBER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_QUERYTRYIN);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_SELF_EXPLOIT_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_SKILL_ACTIVE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_SKILL_LEARN);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_STORE_EVENT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_STORE_GET);
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_STORE_OPEN_STATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_STORE_PAGEUPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_STORE_PUT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_TASK_USABLE_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_TRYINRESPONSE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_TRYIN);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ClUB_UPDATE_DEVICE_INFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_UPGRADE_DEVICE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_WAR_DEAL_INIT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_WAR_DEAL);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_WAR_DECLEAR);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_WAR_DECLEAR_INIT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_WAR_ENEMY_INIT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_WAR_STOP);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_WEAL_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_MONSTER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_MONSTER_UPGRADE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_REMOVE_MEMBER_RETURN_INFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.GET_MAIL_GUILD_NUM);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_SUMMON);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_SUMMON_REMAINING_TIMES);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_PRAYER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_PRAYER_TIMES);
		}
	}
}