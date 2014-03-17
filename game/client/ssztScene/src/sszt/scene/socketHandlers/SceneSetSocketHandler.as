package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.cityCraft.CityCraftAuctionSocketHandler;
	import sszt.core.socketHandlers.itemDiscount.ItemDiscountBuySocketHandler;
	import sszt.core.socketHandlers.itemDiscount.ItemDiscountSocketHandler;
	import sszt.core.socketHandlers.itemDiscount.ItemDiscountUpdateSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.socketHandlers.acrossServer.AcroSerBossEnterSocketHandler;
	import sszt.scene.socketHandlers.acrossServer.AcroSerBossLeaveSocketHandler;
	import sszt.scene.socketHandlers.bank.BankBuySocketHandler;
	import sszt.scene.socketHandlers.bank.BankGetSocketHandler;
	import sszt.scene.socketHandlers.bank.BankInfoListSocketHandler;
	import sszt.scene.socketHandlers.bigBossWar.BigBossWarInfoSocketHandler;
	import sszt.scene.socketHandlers.bigBossWar.BigBossWarQuitSocketHandler;
	import sszt.scene.socketHandlers.bigBossWar.BigBossWarResultSocketHandler;
	import sszt.scene.socketHandlers.bossWar.BossWarMainInfoUpdateSocketHandler;
	import sszt.scene.socketHandlers.bossWar.BossWarSingleBossUpdateSocketHandler;
	import sszt.scene.socketHandlers.challenge.ChallengePassSocketHandler;
	import sszt.scene.socketHandlers.cityCraft.CityCraftAuctionInfoSocketHandler;
	import sszt.scene.socketHandlers.cityCraft.CityCraftBOSSCallSocketHandler;
	import sszt.scene.socketHandlers.cityCraft.CityCraftContinueTimeSocketHandler;
	import sszt.scene.socketHandlers.cityCraft.CityCraftDaysInfoSocketHandler;
	import sszt.scene.socketHandlers.cityCraft.CityCraftEnterSocketHandler;
	import sszt.scene.socketHandlers.cityCraft.CityCraftGuardInfoSocketHandler;
	import sszt.scene.socketHandlers.cityCraft.CityCraftResultSocketHandler;
	import sszt.scene.socketHandlers.cityCraft.CityCraftTopListSocketHandler;
	import sszt.scene.socketHandlers.clubFire.ClubFireIconUpdateSocketHandler;
	import sszt.scene.socketHandlers.clubPointWar.ClubPointWarEnterSocketHandler;
	import sszt.scene.socketHandlers.clubPointWar.ClubPointWarLeaveSocketHandler;
	import sszt.scene.socketHandlers.clubPointWar.ClubPointWarLeftTimeSocketHandler;
	import sszt.scene.socketHandlers.clubPointWar.ClubPointWarMainSocketHandler;
	import sszt.scene.socketHandlers.clubPointWar.ClubPointWarPersonalUpdateSocketHandler;
	import sszt.scene.socketHandlers.clubPointWar.ClubPointWarRankSocketHandler;
	import sszt.scene.socketHandlers.clubPointWar.ClubPointWarRewardsSocketHandler;
	import sszt.scene.socketHandlers.crystalWar.CrystalWarEnterSocketHandler;
	import sszt.scene.socketHandlers.crystalWar.CrystalWarLeaveSocketHandler;
	import sszt.scene.socketHandlers.crystalWar.CrystalWarLeftTimeSocketHandler;
	import sszt.scene.socketHandlers.crystalWar.CrystalWarMainSocketHandler;
	import sszt.scene.socketHandlers.crystalWar.CrystalWarPersonalUpdateSocketHandler;
	import sszt.scene.socketHandlers.crystalWar.CrystalWarRankSocketHandler;
	import sszt.scene.socketHandlers.crystalWar.CrystalWarReliveSocketHandler;
	import sszt.scene.socketHandlers.crystalWar.CrystalWarRewardsSocketHandler;
	import sszt.scene.socketHandlers.duplicate.CopyCanOpenNextMonsterSocketHandler;
	import sszt.scene.socketHandlers.duplicate.CopyGuardKillAwardSocketHandler;
	import sszt.scene.socketHandlers.duplicate.CopyPassRemainMonsterSocketHandle;
	import sszt.scene.socketHandlers.duplicate.CopyPassSocketHandler;
	import sszt.scene.socketHandlers.duplicateLottery.DuplicateLotterySocketHandler;
	import sszt.scene.socketHandlers.guildPVP.GuildPVPKillSocketHandler;
	import sszt.scene.socketHandlers.guildPVP.GuildPVPOwnerSocketHandler;
	import sszt.scene.socketHandlers.guildPVP.GuildPVPReloadSocketHandler;
	import sszt.scene.socketHandlers.guildPVP.GuildPVPResultSocketHandler;
	import sszt.scene.socketHandlers.perWar.PerWarEnterSocketHandler;
	import sszt.scene.socketHandlers.perWar.PerWarGetAwardSocketHandler;
	import sszt.scene.socketHandlers.perWar.PerWarLeaveSocketHandler;
	import sszt.scene.socketHandlers.perWar.PerWarLeftTimeSocketHandler;
	import sszt.scene.socketHandlers.perWar.PerWarMemberListUpdateSocketHandler;
	import sszt.scene.socketHandlers.perWar.PerWarMyWarInfoUpdateSocketHandler;
	import sszt.scene.socketHandlers.perWar.PerWarSceneListUpdateSocketHandler;
	import sszt.scene.socketHandlers.pk.PkInviteSocketHandler;
	import sszt.scene.socketHandlers.pk.PkResponseSocketHandler;
	import sszt.scene.socketHandlers.pk.PkResultSocketHandler;
	import sszt.scene.socketHandlers.pvpFirst.ActivePvpFirstInfoSocketHandler;
	import sszt.scene.socketHandlers.pvpFirst.ActivePvpFirstResultSocketHandler;
	import sszt.scene.socketHandlers.resourceWar.ResourceWarCampChangeSocketHandler;
	import sszt.scene.socketHandlers.resourceWar.ResourceWarPointAddSocketHandler;
	import sszt.scene.socketHandlers.resourceWar.ResourceWarResultSocketHandler;
	import sszt.scene.socketHandlers.resourceWar.ResourceWarTopListSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarEnterSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarLeaveSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarLeftTimeSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarMemberListUpdateSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarMyWarInfoUpdateSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarResultUpdateSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarSceneListUpdateSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.UpdateSelfHonorSocketHandler;
	import sszt.scene.socketHandlers.smIsland.CopyIslandDoorEnterSocketHandler;
	import sszt.scene.socketHandlers.smIsland.CopyIslandKingInfoSocketHandler;
	import sszt.scene.socketHandlers.smIsland.CopyIslandLeaveSocketHandler;
	import sszt.scene.socketHandlers.smIsland.CopyIslandMainInfoSocketHandler;
	import sszt.scene.socketHandlers.smIsland.CopyIslandMonsterCountSocketHandler;
	import sszt.scene.socketHandlers.smIsland.CopyIslandReliveSocketHandler;
	import sszt.scene.socketHandlers.smIsland.CopyIslandShowRewardSocketHandler;
	import sszt.scene.socketHandlers.smIsland.beforeEnter.CopyIslandCleanSocketHandler;
	import sszt.scene.socketHandlers.smIsland.beforeEnter.CopyIslandEneterSokcetHandler;
	import sszt.scene.socketHandlers.smIsland.beforeEnter.CopyIslandLeaderEnterSocketHandler;
	import sszt.scene.socketHandlers.smIsland.beforeEnter.CopyIslandTeamerEnterSocketHandler;
	import sszt.scene.socketHandlers.spa.SpaIconLeaveTimeSocketHandler;
	import sszt.scene.socketHandlers.spa.SpaPondSocketHandler;
	import sszt.scene.socketHandlers.spa.SpaSceneEnterSocketHandler;
	import sszt.scene.socketHandlers.spa.SpaSceneLeaveSocketHandler;
	import sszt.scene.socketHandlers.transport.ServerTransportLeftTimeHandler;
	import sszt.scene.socketHandlers.transport.TransportHelpSocketHandler;
	import sszt.scene.socketHandlers.transport.TransportQualityInitHandler;
	import sszt.scene.socketHandlers.transport.TransportQualityRefreshHandler;

//	import sszt.store.socket.ItemDiscountBuySocketHandler;
//	import sszt.store.socket.ItemDiscountSocketHandler;
//	import sszt.store.socket.ItemDiscountUpdateSocketHandler;

	public class SceneSetSocketHandler
	{
		public static function add(module:SceneModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new BuffControlSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new BuffUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyEnterSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyLeaveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ChallengeNextBossSocketHandler(module)); //挑战下一个试炼boss
			GlobalAPI.socketManager.addSocketHandler(new CopyNextMonsterTimeSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyInfoSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyTeamEnterSocketHandler(module));
			
			GlobalAPI.socketManager.addSocketHandler(new CopyClearDropItemAllSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyClearMonsterAllSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyUpdateBatterNumSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyPickUpMoneySocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyRandMoneySocketHandler(module));
			
			GlobalAPI.socketManager.addSocketHandler(new CopyCanOpenNextMonsterSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyGuardKillAwardSocketHandler(module));
			
			GlobalAPI.socketManager.addSocketHandler(new CopyPassRemainMonsterSocketHandle(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyPassSocketHandler(module));	
			
			GlobalAPI.socketManager.addSocketHandler(new PVPEndSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ActiveFinishSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ActiveStartSocketHandler(module));
			
			GlobalAPI.socketManager.addSocketHandler(new ActiveStartTimeListSocketHandler(module));
			
			//神魔岛
			GlobalAPI.socketManager.addSocketHandler(new CopyIslandLeaveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyIslandLeaderEnterSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyIslandTeamerEnterSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyIslandEneterSokcetHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyIslandCleanSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyIslandDoorEnterSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyIslandMainInfoSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyIslandKingInfoSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyIslandShowRewardSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyIslandMonsterCountSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CopyIslandReliveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new DuplicateLotterySocketHandler(module));
			
			GlobalAPI.socketManager.addSocketHandler(new DefenceListSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new MapCollectUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new MapMonsterInfoUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new MapMonsterRemoveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new MapPetInfoUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new MapPetRemoveHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new MapRoundInfoSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new MapUserAddSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new MapUserRemoveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PetChangeStyleReplySocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PetNameRelaySocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerAttackSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerCollectSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerDairyAwardSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerDairyAwardListSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerFollowSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerGetDropItemSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerHangupDataSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerBreakAwaySocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerInviteSitRelaySocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerInviteSitSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerMoveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerMoveStepSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerPKValueChangeSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerPlaceUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerReliveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerSetHouseSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerSitSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerStyleUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new SkillReliveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new NewSkillAddSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new StallStateUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TargetAttackedUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TargetAttackWaitingSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TargetDropItemAddSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TargetDropItemRemoveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TargetDropItemUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TargetRepelSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TargetUpdateBloodSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TeamBattleInfoSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TeamChangeSettingSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TeamCreateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TeamDisbandSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TeamInviteMsgSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TeamInviteSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TeamKickSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TeamLeaderChangeSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TeamLeaveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TeamLevelUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TeamPositionUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TeamNofullMsgSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TeamStopFollowSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TeamUpdateMsgSocketHandler(module));
			
			//交易系统
			GlobalAPI.socketManager.addSocketHandler(new TradeAcceptSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TradeAcceptResponseSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TradeCancelResponseSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TradeCancelSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TradeCopperSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TradeItemAddResponseSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TradeItemAddSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TradeItemRemoveResponseSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TradeLockResponseSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TradeLockSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TradeRequestResponseSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TradeRequestSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TradeResultSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TradeStartSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TradeSureResponseSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TradeSureSocketHandler(module));
			
			
			GlobalAPI.socketManager.addSocketHandler(new UpdatePlayerLevelSocketHandler(module));
			
			
			GlobalAPI.socketManager.addSocketHandler(new RemoveMonsterSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubWarRequestResponseSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubEnemyListUpdateHandler());
			
			
			GlobalAPI.socketManager.addSocketHandler(new ShenMoWarEnterSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ShenMoWarLeaveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ShenMoWarLeftTimeSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ShenMoWarMemberListUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ShenMoWarMyWarInfoUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ShenMoWarResultUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ShenMoWarSceneListUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new UpdateSelfHonorSocketHandler(module));

			//帮派据点战
			GlobalAPI.socketManager.addSocketHandler(new ClubPointWarEnterSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubPointWarLeaveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubPointWarMainSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubPointWarRankSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubPointWarRewardsSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubPointWarLeftTimeSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ClubPointWarPersonalUpdateSocketHandler(module));
			//水晶争夺战
			GlobalAPI.socketManager.addSocketHandler(new CrystalWarEnterSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CrystalWarLeaveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CrystalWarMainSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CrystalWarRankSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CrystalWarRewardsSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CrystalWarLeftTimeSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CrystalWarPersonalUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CrystalWarReliveSocketHandler(module));
			
			//跨服战
			GlobalAPI.socketManager.addSocketHandler(new AcroSerBossEnterSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new AcroSerBossLeaveSocketHandler(module));
			//个人乱斗
			GlobalAPI.socketManager.addSocketHandler(new PerWarEnterSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PerWarLeaveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PerWarSceneListUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PerWarMemberListUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PerWarGetAwardSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PerWarMyWarInfoUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PerWarLeftTimeSocketHandler(module));

			
			GlobalAPI.socketManager.addSocketHandler(new PkResponseSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PkInviteSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PkResultSocketHandler(module));
			
			GlobalAPI.socketManager.addSocketHandler(new SpaPondSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new SpaSceneEnterSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new SpaSceneLeaveSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new SpaIconLeaveTimeSocketHandler(module));
			
			GlobalAPI.socketManager.addSocketHandler(new TransportHelpSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TransportQualityInitHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new TransportQualityRefreshHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ServerTransportLeftTimeHandler(module));
			
			GlobalAPI.socketManager.addSocketHandler(new BossWarMainInfoUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new BossWarSingleBossUpdateSocketHandler(module));
			
			GlobalAPI.socketManager.addSocketHandler(new ClubFireIconUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new PlayerLifeExpSitSocketHandler(module));
			
			//抢购特区 在商城、天予恩赐共用
			GlobalAPI.socketManager.addSocketHandler(new ItemDiscountSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ItemDiscountUpdateSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ItemDiscountBuySocketHandler(module));
			
			//试炼结果
			GlobalAPI.socketManager.addSocketHandler(new ChallengePassSocketHandler(module));
			//开服活动
			GlobalAPI.socketManager.addSocketHandler(new PlayerActivityFirstPayHandler(module));
			
			//资源战
			GlobalAPI.socketManager.addSocketHandler(new ResourceWarPointAddSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ResourceWarTopListSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ResourceWarCampChangeSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ResourceWarResultSocketHandler(module));
			//天下第一战
			GlobalAPI.socketManager.addSocketHandler(new ActivePvpFirstResultSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new ActivePvpFirstInfoSocketHandler(module));
			
			//魔头现世
			GlobalAPI.socketManager.addSocketHandler(new BigBossWarInfoSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new BigBossWarResultSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new BigBossWarQuitSocketHandler(module));
			
			//帮会乱斗
			GlobalAPI.socketManager.addSocketHandler(new GuildPVPReloadSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new GuildPVPResultSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new GuildPVPKillSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new GuildPVPOwnerSocketHandler(module));
			
			//王城争霸
			GlobalAPI.socketManager.addSocketHandler(new CityCraftAuctionInfoSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CityCraftBOSSCallSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CityCraftContinueTimeSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CityCraftResultSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CityCraftTopListSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CityCraftDaysInfoSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CityCraftGuardInfoSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new CityCraftEnterSocketHandler(module));
			
			//投资计划
			GlobalAPI.socketManager.addSocketHandler(new BankGetSocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new BankBuySocketHandler(module));
			GlobalAPI.socketManager.addSocketHandler(new BankInfoListSocketHandler(module));
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.BUFF_CONTROL);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.BUFF_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_ENTER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_LEAVE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CHALLENGE_NEXT_BOSS);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_NEXT_MONSTER_TIME);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_INFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_TEAM_ENTER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_ENTER_SCENCE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_LEAVE_SCENCE);
			
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_CLEAR_DROPITEM_ALL);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_CLEAR_MOUNSTER_ALL);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_UPDATE_BATTER_NUM);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_PICKUP_MONEY_AMOUNT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_RAND_MONEY);
			
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_CAN_OPEN_NEXT_MONSTER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_GUARD_KILL_AWARD);
			
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_PASS_REMAIN_MONSTER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_PASS);			
			
			///水晶战
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CRYSTAL_WAR_ENTER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CRYSTAL_WAR_LEAVE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CRYSTAL_WAR_PERSONINFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CRYSTAL_WAR_RANK);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CRYSTAL_WAR_REWARDS);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CRYSTAL_WAR_SCENE_INFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CRYSTAL_WAR_TIME);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CRYSTAL_WAR_RELIVE);
			
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PVP_END);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ACTIVE_FINISH);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ACTIVE_START);
			//神魔岛
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_ISLAND_LEAVE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_ISLAND_LEADER_ENTER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_ISLAND_TEAMER_ENTER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_ISLAND_ENTER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_ISLAND_CLEAN);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_ISLAND_DOOR_ENTER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_ISLAND_MAININFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_ISLAND_KINGINFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_ISLAND_SHOWREWARD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_ISLAND_MONSTERCOUNT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_ISLAND_RELIVE);
			
			
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.DEFENCE_LIST);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MAP_COLLECT_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MAP_MONSTER_INFO_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MAP_MONSTER_REMOVE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MAP_ROUND_INFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MAP_USER_ADD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.MAP_USER_REMOVE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_CHANGE_STYLE_REPLY);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PET_NAME_RELY);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_ATTACK);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_COLLECT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_BREAK_AWAY);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_DAILY_AWARD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_DAILY_AWARD_LIST);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_GET_DROPITEM);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_HANGUPDATA);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PALYER_INVITE_SIT_RELAY);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_INVITE_SIT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_MOVE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_MOVE_STEP);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_PK_VALUE_CHANGE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_PLACE_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_SET_HOUSE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_SIT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_STYLE_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SKILL_RELIVE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.NEW_SKILL_ADD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.STALL_STATE_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TARGET_ATTACKED_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TARGET_ATTACKED_WAITING);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TARGET_DROPITEM_ADD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TARGET_DROPITEM_REMOVE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TARGET_DROPITEM_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TARGET_REPEL);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TARGET_UPDATE_BLOOD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TEAM_BATTLEINFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TEAM_CHANGE_SETTING);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TEAM_CREATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TEAM_DISBAND);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TEAM_INVITE_MSG);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TEAM_INVITE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TEAM_KICK)
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TEAM_LEADER_CHANGE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TEAM_LEAVE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TEAM_LEVEL_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TEAM_POSITION_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TEAM_NOFULL_MSG);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TEAM_STOPFOLLOW);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TEAM_UPDATE_MSG);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRADE_ACCEPT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRADE_CANCEL_RESPONSE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRADE_CANCEL);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRADE_COPPER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRADE_ITEM_ADD_RESPONSE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRADE_ITEM_ADD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRADE_ITEM_REMOVE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRADE_LOCK_RESPONSE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRADE_LOCK);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRADE_REQUEST_RESPONSE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRADE_REQUEST);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRADE_RESULT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRADE_START);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRADE_SURE_RESPONSE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRADE_SURE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.UPDATE_PLAYER_LEVEL);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_WAR_REQUEST_RESPONSE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_WAR_ENEMY_LIST_UPDATE);
			
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SHENMO_ENTER_WAR);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SHENMO_LEAVE_WAR);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SHENMO_WARLIST_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SHENMO_MEMBERLIST_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SHENMO_MYWAR_INFO_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SHENMO_WARTIME_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SHENMO_WARRESULT_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.UPDATE_SELF_HONOR);
			
			//个人乱斗
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PERWAR_ENTER_WAR);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PERWAR_LEAVE_WAR);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PERWAR_WARLIST_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PERWAR_MEMBERLIST_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PERWAR_WARAWARD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PERWAR_MYWAR_INFO_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PERWAR_WARTIME_UPDATE);
			

			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_POINT_ENTER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_POINT_LEAVE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_POINT_SCENE_INFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_POINT_RANK);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_POINT_REWARDS);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_POINT_TIME);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_POINT_PERSONINFO);
			
			//跨服boss
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ACROSS_SERVER_BOSS_ENTER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ACROSS_SERVER_BOSS_LEAVE);
			
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PK_RESPONSE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PK_INVITE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PK_RESULT);
			
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SPA_POND);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SPA_ENTER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SPA_LEAVE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SPA_ICON_TIME);
			
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.BOSS_WAR_MAIN_INFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.BOSS_WAR_SINGLE_BOSS_UPDATE);
			
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRANSPORT_HELP);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRANSPORT_QUALITY_INIT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TRANSPORT_QUALITY_REFRESH);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ALLSERVICE_TRANSPORT_TIME);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CLUB_FIRE_ICON_LEFT_TIME);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_LIFE_EXP_SIT);
			
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.COPY_LOTTERY);
			
			//抢购特区 在商城、天予恩赐共用
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_DISCOUNT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_DISCOUNT_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_DISCOUNT_BUY);
			
			//试炼结果
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CHALLENGE_BOSS_PASS);
			//开服活动
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PLAYER_ACTIVE_FIRST_PAY);
			
			//资源战
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ACTIVE_RESOURCE_POINT_ADD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ACTIVE_RESOURCE_TOP_LIST);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ACTIVE_RESOURCE_CAMP_CHANGE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ACTIVE_RESOURCE_RESULT);
			//天下第一战
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ACTIVE_PVP_FIRST_RESULT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ACTIVE_PVP_FIRST_INFO);
			
			//魔头现世
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.BIG_BOSS_WAR_INFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.BIG_BOSS_WAR_RESULT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.BIG_BOSS_WAR_QUIT);
			
			//帮会乱斗
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.GUILD_PVP_THEFIRAST);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.GUILD_PVP_RELOAD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.GUILD_PVP_RESULT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.GUILD_PVP_KILL);
			
			//王城争霸
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CITY_CRAFT_AUCTION_INFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CITY_CRAFT_CONTINUE_TIME);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CITY_CRAFT_RESULT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CITY_CRAFT_TOP_LIST);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CITY_CRAFT_ENTER);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CITY_CRAFT_GUARD_INFO);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.CITY_CRAFT_GUARD_INFO);
			
			//投资计划
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.BANK_BUY);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.BANK_GET);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.BANK_LIST);
		}
	}
}