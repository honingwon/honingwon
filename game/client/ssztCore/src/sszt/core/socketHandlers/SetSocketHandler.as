package sszt.core.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.socketHandlers.activity.ExchangeSilverMoneySocketHandler;
	import sszt.core.socketHandlers.activity.SevenActivityInfoSocketHandler;
	import sszt.core.socketHandlers.bag.BagExtendSocketHandler;
	import sszt.core.socketHandlers.bag.ItemArrangeSocketHandler;
	import sszt.core.socketHandlers.bag.ItemLockUpdateSocketHandler;
	import sszt.core.socketHandlers.bag.ItemMoveSocketHandler;
	import sszt.core.socketHandlers.bag.ItemPlaceUpdateSocketHandler;
	import sszt.core.socketHandlers.bag.ItemReferSocketHandler;
	import sszt.core.socketHandlers.bag.ItemRetrieveSocketHandler;
	import sszt.core.socketHandlers.bag.ItemScoreSocketHandler;
	import sszt.core.socketHandlers.bag.ItemSplitSocketHandler;
	import sszt.core.socketHandlers.bag.PetItemPlaceUpdateSocketHandler;
	import sszt.core.socketHandlers.bigBossWar.BigBossWarEnterSocketHandler;
	import sszt.core.socketHandlers.box.BoxChatInfoAddHandler;
	import sszt.core.socketHandlers.box.GainItemInitHandler;
	import sszt.core.socketHandlers.box.OpenBoxSocketHandler;
	import sszt.core.socketHandlers.challenge.ChallengeInfoSocketHandler;
	import sszt.core.socketHandlers.challenge.ChallengeTopInfoSocketHandler;
	import sszt.core.socketHandlers.chat.ChatSockethandler;
	import sszt.core.socketHandlers.cityCraft.CityCraftAuctionSocketHandler;
	import sszt.core.socketHandlers.cityCraft.CityCraftAuctionStateSocketHandler;
	import sszt.core.socketHandlers.club.ClubArmyInviteResponseSocketHandler;
	import sszt.core.socketHandlers.club.ClubArmyInviteSocketHandler;
	import sszt.core.socketHandlers.club.ClubCallSocketHandler;
	import sszt.core.socketHandlers.club.ClubGetNoticeSocketHandler;
	import sszt.core.socketHandlers.club.ClubInviteResponseSocketHandler;
	import sszt.core.socketHandlers.club.ClubInviteSocketHandler;
	import sszt.core.socketHandlers.club.ClubMemberListSocketHandler;
	import sszt.core.socketHandlers.club.ClubNewcomerSocketHandler;
	import sszt.core.socketHandlers.club.ClubNewcomerSocketHandler2;
	import sszt.core.socketHandlers.club.ClubSelfExploitUpdateSocketHandler;
	import sszt.core.socketHandlers.club.ClubSetNoticeSocketHandler;
	import sszt.core.socketHandlers.club.ClubSkillInitSocketHandler;
	import sszt.core.socketHandlers.club.ClubTransferResponseSocketHandler;
	import sszt.core.socketHandlers.club.ClubTransferSocketHandler;
	import sszt.core.socketHandlers.club.ItemUserShopBuySocketHandler;
	import sszt.core.socketHandlers.club.ItemUserShopSocketHandler;
	import sszt.core.socketHandlers.club.camp.ClubCampCallAttentionSocket;
	import sszt.core.socketHandlers.club.camp.ClubCampEnterSocketHandler;
	import sszt.core.socketHandlers.club.camp.ClubCampLeaveSocketHandler;
	import sszt.core.socketHandlers.common.AccountHeartBeatSocketHandler;
	import sszt.core.socketHandlers.common.HideFashionSocketHandler;
	import sszt.core.socketHandlers.common.ItemBuyByExploitHandler;
	import sszt.core.socketHandlers.common.ItemBuyExchangeHandler;
	import sszt.core.socketHandlers.common.ItemBuySocketHandler;
	import sszt.core.socketHandlers.common.ItemRepairSocketHandler;
	import sszt.core.socketHandlers.common.ItemSellSocketHandler;
	import sszt.core.socketHandlers.common.ItemUseSocketHandler;
	import sszt.core.socketHandlers.common.PingSocketHandler;
	import sszt.core.socketHandlers.common.PlayerActiveNumSocketHandler;
	import sszt.core.socketHandlers.common.PlayerClubFurnaceInitSocketHandler;
	import sszt.core.socketHandlers.common.PlayerPKModeChangeSocketHandler;
	import sszt.core.socketHandlers.common.PlayerSelfLifeexpSocketHandler;
	import sszt.core.socketHandlers.common.SysDateSocketHandler;
	import sszt.core.socketHandlers.common.SysMessSocketHandler;
	import sszt.core.socketHandlers.common.UpdateClubExploitSocketHandler;
	import sszt.core.socketHandlers.common.UpdateSelfExpSocketHandler;
	import sszt.core.socketHandlers.common.UpdateSelfInfoSocketHandler;
	import sszt.core.socketHandlers.common.UpdateSelfPhysicalSocketHandler;
	import sszt.core.socketHandlers.common.UpdateSelfReduceExpSocketHandler;
	import sszt.core.socketHandlers.common.UpdateUserInfoSocketHandler;
	import sszt.core.socketHandlers.common.UseTransferShoeSocketHandler;
	import sszt.core.socketHandlers.common.YuanBaoScoreUpdateSocketHandler;
	import sszt.core.socketHandlers.copy.CopyEnterCountSocketHandler;
	import sszt.core.socketHandlers.copy.CopyLimitNumResetSocketHandler;
	import sszt.core.socketHandlers.enthral.EnthralControlSocketHandler;
	import sszt.core.socketHandlers.enthral.EnthralNoticeSocketHandler;
	import sszt.core.socketHandlers.enthral.EnthralOffLineSocketHandler;
	import sszt.core.socketHandlers.enthral.EnthralSendStateSocketHandler;
	import sszt.core.socketHandlers.enthral.EnthralSubmitSocketHandler;
	import sszt.core.socketHandlers.entrustment.QuickEntrustmentSocketHandler;
	import sszt.core.socketHandlers.entrustment.StartEntrustingSocketHandler;
	import sszt.core.socketHandlers.entrustment.StopEntrustingSocketHandler;
	import sszt.core.socketHandlers.firework.FireworkPlaySocketHandler;
	import sszt.core.socketHandlers.firework.RosePlaySocketHandler;
	import sszt.core.socketHandlers.gm.GMSendMessageSocketHandler;
	import sszt.core.socketHandlers.guildPVP.GuildPVPEnterSocketHandler;
	import sszt.core.socketHandlers.im.FriendAcceptSocketHandler;
	import sszt.core.socketHandlers.im.FriendAmityUpdateSocketHandler;
	import sszt.core.socketHandlers.im.FriendDeleteSocketHandler;
	import sszt.core.socketHandlers.im.FriendGetListSocketHandler;
	import sszt.core.socketHandlers.im.FriendGroupDeleteSocketHandler;
	import sszt.core.socketHandlers.im.FriendGroupMoveSocketHandler;
	import sszt.core.socketHandlers.im.FriendGroupUpdateSocketHandler;
	import sszt.core.socketHandlers.im.FriendResponseSocketHandler;
	import sszt.core.socketHandlers.im.FriendStateSocketHandler;
	import sszt.core.socketHandlers.im.FriendUpdateSocketHandler;
	import sszt.core.socketHandlers.im.QueryFriendInfoSocketHandler;
	import sszt.core.socketHandlers.login.AccountLostConnectSocketHandler;
	import sszt.core.socketHandlers.login.GuestLoginSocketHandler;
	import sszt.core.socketHandlers.login.LoginSocketHandler;
	import sszt.core.socketHandlers.loginWelfare.LoginRewardUpdateSocketHandler;
	import sszt.core.socketHandlers.mail.MailResponseSocketHandler;
	import sszt.core.socketHandlers.mail.MailUpdateSocketHandler;
	import sszt.core.socketHandlers.marriage.MarryEchoNoticeSocketHandler;
	import sszt.core.socketHandlers.marriage.MarryRequestNoticeSocketHandler;
	import sszt.core.socketHandlers.marriage.WeddingInfoUpdateSocketHandler;
	import sszt.core.socketHandlers.marriage.WeddingSendInvitationCardSocketHandler;
	import sszt.core.socketHandlers.mounts.MountsGetMountShowItemSocketHandler;
	import sszt.core.socketHandlers.mounts.MountsInheritSocketHandler;
	import sszt.core.socketHandlers.mounts.MountsListUpdateSocketHandler;
	import sszt.core.socketHandlers.mounts.MountsStateChangeSocketHandler;
	import sszt.core.socketHandlers.notice.PlayerNoticeHandler;
	import sszt.core.socketHandlers.openActivity.OpenActivityGetAwardSocketHandler;
	import sszt.core.socketHandlers.openActivity.OpenActivityInfoSocketHandler;
	import sszt.core.socketHandlers.openActivity.YellowBoxGetRewardSocketHandler;
	import sszt.core.socketHandlers.openActivity.YellowBoxInfoSocketHandler;
	import sszt.core.socketHandlers.pay.QQBugGoodsSocketHandler;
	import sszt.core.socketHandlers.personal.dynamicInfo.PersonalClubMateDeadSocketHandler;
	import sszt.core.socketHandlers.personal.dynamicInfo.PersonalClubMateUpgradeSocketHandler;
	import sszt.core.socketHandlers.personal.dynamicInfo.PersonalClubTaskShareSocketHandler;
	import sszt.core.socketHandlers.personal.dynamicInfo.PersonalClubUpgradeSocketHandler;
	import sszt.core.socketHandlers.personal.dynamicInfo.PersonalFriendDeadSocketHandler;
	import sszt.core.socketHandlers.personal.dynamicInfo.PersonalFriendTaskShareSocketHandler;
	import sszt.core.socketHandlers.personal.dynamicInfo.PersonalFriendUpgradeSocketHandler;
	import sszt.core.socketHandlers.pet.PetAttUpdateSocketHandler;
	import sszt.core.socketHandlers.pet.PetAttackSocketHandler;
	import sszt.core.socketHandlers.pet.PetCallSocketHandler;
	import sszt.core.socketHandlers.pet.PetChangeStyleSocketHandler;
	import sszt.core.socketHandlers.pet.PetFeedSocketHandler;
	import sszt.core.socketHandlers.pet.PetGetPetShowItemSocketHandler;
	import sszt.core.socketHandlers.pet.PetInheritSocketHandler;
	import sszt.core.socketHandlers.pet.PetListUpdateSocketHandler;
	import sszt.core.socketHandlers.pet.PetNameUpdateSocketHandler;
	import sszt.core.socketHandlers.pet.PetQualityUpdateSocketHandler;
	import sszt.core.socketHandlers.pet.PetReleaseSocketHandler;
	import sszt.core.socketHandlers.pet.PetRemoveSkillSocketHandler;
	import sszt.core.socketHandlers.pet.PetSealSkillSocketHandler;
	import sszt.core.socketHandlers.pet.PetSkillUpdateSocketHandler;
	import sszt.core.socketHandlers.pet.PetStateChangeSocketHandler;
	import sszt.core.socketHandlers.pet.PetStudySkillSocketHandler;
	import sszt.core.socketHandlers.pet.PetUpgradeSocketHandler;
	import sszt.core.socketHandlers.pet.PetXisuiUpdateSocketHandler;
	import sszt.core.socketHandlers.petPVP.PetPVPGetDailyRewardSocketHandler;
	import sszt.core.socketHandlers.petPVP.PetPVPSelfLogUpdateSocketHandler;
	import sszt.core.socketHandlers.pvp.ActivePvpFirstEnterSocketHandler;
	import sszt.core.socketHandlers.pvp.ActivePvpFirstLeaveSocketHandler;
	import sszt.core.socketHandlers.pvp.ActiveResourceWarEnterSocketHandler;
	import sszt.core.socketHandlers.pvp.ActiveResourceWarLeaveSocketHandler;
	import sszt.core.socketHandlers.quiz.QuizPushSocketHandler;
	import sszt.core.socketHandlers.quiz.QuizResultSocketHandler;
	import sszt.core.socketHandlers.role.FirstRoleTitleSocketHandler;
	import sszt.core.socketHandlers.role.QuaryRoleNameSocketHandler;
	import sszt.core.socketHandlers.role.RoleInfoSocketHandler;
	import sszt.core.socketHandlers.role.RoleNameRemoveSocketHandler;
	import sszt.core.socketHandlers.role.RoleNameSaveSocketHandler;
	import sszt.core.socketHandlers.scene.MapEnterSocketHandler;
	import sszt.core.socketHandlers.shenmoling.RefreshTaskStateHandler;
	import sszt.core.socketHandlers.shenmoling.UseShenMoLingHandler;
	import sszt.core.socketHandlers.skill.PlayerDragSkillSocketHandler;
	import sszt.core.socketHandlers.skill.SkillBarInitSocketHandler;
	import sszt.core.socketHandlers.skill.SkillInitSocketHandler;
	import sszt.core.socketHandlers.skill.SkillLearnOrUpdateSocketHandler;
	import sszt.core.socketHandlers.store.ItemBuyBackSocketHandler;
	import sszt.core.socketHandlers.store.ItemBuyBackUpdateSocketHandler;
	import sszt.core.socketHandlers.store.MysteryShopChatInfoAddSocketHandler;
	import sszt.core.socketHandlers.store.MysteryShopLastUpdateDateSocketHandler;
	import sszt.core.socketHandlers.swordsman.UserInfoSocketHandler;
	import sszt.core.socketHandlers.target.TargetFinishSocketHandler;
	import sszt.core.socketHandlers.target.TargetGetAwardSocketHandler;
	import sszt.core.socketHandlers.target.TargetHistoryUpdateSocketHandler;
	import sszt.core.socketHandlers.target.TargetListUpdateSocketHandler;
	import sszt.core.socketHandlers.task.StartClubTransportSocketHandler;
	import sszt.core.socketHandlers.task.TaskAcceptSocketHandler;
	import sszt.core.socketHandlers.task.TaskCancelSocketHandler;
	import sszt.core.socketHandlers.task.TaskClientSocketHandler;
	import sszt.core.socketHandlers.task.TaskQuickCompleteSocketHandler;
	import sszt.core.socketHandlers.task.TaskSubmitSocketHandler;
	import sszt.core.socketHandlers.task.TaskTransportAddSocketHandler;
	import sszt.core.socketHandlers.task.TaskTrustSocketHandler;
	import sszt.core.socketHandlers.task.TaskUpdateSocketHandler;
	import sszt.core.socketHandlers.tradeDirect.TradeItemRemoveSocketHandler;
	import sszt.core.socketHandlers.veins.AcupointUpdateSocketHandler;
	import sszt.core.socketHandlers.veins.GenguUpdateSocketHandler;
	import sszt.core.socketHandlers.veins.VeinsClearCDSocketHandler;
	import sszt.core.socketHandlers.veins.VeinsInitSocketHandler;
	import sszt.core.socketHandlers.vip.PlayerVipAwardSocketHandler;
	import sszt.core.socketHandlers.vip.PlayerVipDetailSocketHandler;
	import sszt.core.socketHandlers.vip.VipMapEnterSocketHandler;
	import sszt.core.socketHandlers.vip.VipMapLeaveSocketHandler;
	import sszt.core.socketHandlers.worldBoss.GetWorldBossNumSocketHandler;

	public class SetSocketHandler
	{
		public static function add():void
		{
			//bag
			GlobalAPI.socketManager.addSocketHandler(new BagExtendSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ItemArrangeSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ItemLockUpdateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ItemMoveSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ItemPlaceUpdateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ItemReferSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ItemRetrieveSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ItemSplitSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ItemScoreSocketHandler());
			
			//chat
			GlobalAPI.socketManager.addSocketHandler(new ChatSockethandler());
			//challenge
			GlobalAPI.socketManager.addSocketHandler(new ChallengeTopInfoSocketHandler());
			//club
			GlobalAPI.socketManager.addSocketHandler(new ClubArmyInviteResponseSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ClubArmyInviteSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ClubCallSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ClubInviteResponseSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ClubInviteSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ClubSkillInitSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ClubTransferResponseSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ClubTransferSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ClubSelfExploitUpdateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ClubGetNoticeSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ClubMemberListSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ClubSetNoticeSocketHandler());
			
			GlobalAPI.socketManager.addSocketHandler(new ItemUserShopSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ItemUserShopBuySocketHandler());
			
			
			//common
			GlobalAPI.socketManager.addSocketHandler(new AccountHeartBeatSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new HideFashionSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ItemBuySocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ItemBuyByExploitHandler());
			GlobalAPI.socketManager.addSocketHandler(new ItemBuyExchangeHandler());
			GlobalAPI.socketManager.addSocketHandler(new ItemRepairSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ItemSellSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ItemUseSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PingSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PlayerClubFurnaceInitSocketHandler());
//			GlobalAPI.socketManager.addSocketHandler(new PlayerDynamicInfoUpdateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PlayerPKModeChangeSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PlayerSelfLifeexpSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new SysDateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new SysMessSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new UpdateClubExploitSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new UpdateSelfExpSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new UpdateSelfReduceExpSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new UpdateSelfInfoSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new UpdateSelfPhysicalSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new UpdateUserInfoSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new YuanBaoScoreUpdateSocketHandler());
			
			//邮件
			GlobalAPI.socketManager.addSocketHandler(new MailResponseSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new MailUpdateSocketHandler());
			
			//烟花
			GlobalAPI.socketManager.addSocketHandler(new FireworkPlaySocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new RosePlaySocketHandler());
			
			//pet
			GlobalAPI.socketManager.addSocketHandler(new PetListUpdateSocketHandler());		
			GlobalAPI.socketManager.addSocketHandler(new PetCallSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetSkillUpdateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetAttUpdateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetQualityUpdateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetRemoveSkillSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetSealSkillSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetNameUpdateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetReleaseSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetStateChangeSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetFeedSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetUpgradeSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetStudySkillSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetAttackSocketHandler());		
			GlobalAPI.socketManager.addSocketHandler(new PetChangeStyleSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetInheritSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetXisuiUpdateSocketHandler());
			
			//mounts
			GlobalAPI.socketManager.addSocketHandler(new MountsListUpdateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new MountsStateChangeSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new MountsInheritSocketHandler());
				
			//login
			GlobalAPI.socketManager.addSocketHandler(new AccountLostConnectSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new GuestLoginSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new LoginSocketHandler());
			
			//role
			GlobalAPI.socketManager.addSocketHandler(new QuaryRoleNameSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new RoleNameRemoveSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new FirstRoleTitleSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new RoleNameSaveSocketHandler());
			
			//scene
			GlobalAPI.socketManager.addSocketHandler(new MapEnterSocketHandler());
			
			//skill
			GlobalAPI.socketManager.addSocketHandler(new PlayerDragSkillSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new SkillBarInitSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new SkillInitSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new SkillLearnOrUpdateSocketHandler());
			
			//veins
			GlobalAPI.socketManager.addSocketHandler(new VeinsInitSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new VeinsClearCDSocketHandler());
			
			GlobalAPI.socketManager.addSocketHandler(new AcupointUpdateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new GenguUpdateSocketHandler());
			
			//task
			GlobalAPI.socketManager.addSocketHandler(new StartClubTransportSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new TaskAcceptSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new TaskCancelSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new TaskClientSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new TaskSubmitSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new TaskTransportAddSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new TaskTrustSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new TaskUpdateSocketHandler());
			
			//store			
			GlobalAPI.socketManager.addSocketHandler(new ItemBuyBackSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ItemBuyBackUpdateSocketHandler());
			
			//好友
			GlobalAPI.socketManager.addSocketHandler(new FriendUpdateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new FriendDeleteSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new FriendGetListSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new FriendGroupDeleteSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new FriendGroupMoveSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new FriendGroupUpdateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new FriendResponseSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new FriendStateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new FriendAcceptSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new QueryFriendInfoSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new FriendAmityUpdateSocketHandler());
			
			//防沉迷
			GlobalAPI.socketManager.addSocketHandler(new EnthralControlSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new EnthralNoticeSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new EnthralSubmitSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new EnthralOffLineSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new EnthralSendStateSocketHandler());
			
			//直接交易
			GlobalAPI.socketManager.addSocketHandler(new TradeItemRemoveSocketHandler());
			
			//GM联系
			GlobalAPI.socketManager.addSocketHandler(new GMSendMessageSocketHandler());
			
			//副本
			GlobalAPI.socketManager.addSocketHandler(new CopyEnterCountSocketHandler());
			
			//双击神魔令时发送随机任务
			GlobalAPI.socketManager.addSocketHandler(new UseShenMoLingHandler());
			
			//神魔令刷新品质
			GlobalAPI.socketManager.addSocketHandler(new RefreshTaskStateHandler());
			
			//vip
			GlobalAPI.socketManager.addSocketHandler(new PlayerVipAwardSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PlayerVipDetailSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new VipMapEnterSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new VipMapLeaveSocketHandler());
			
			//开箱子开出极品装备广播信息
			GlobalAPI.socketManager.addSocketHandler(new BoxChatInfoAddHandler());
			GlobalAPI.socketManager.addSocketHandler(new OpenBoxSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new GainItemInitHandler());
			
			//神秘商店最后时间更新
			GlobalAPI.socketManager.addSocketHandler(new MysteryShopLastUpdateDateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new MysteryShopChatInfoAddSocketHandler());
			
			//个人中心
			GlobalAPI.socketManager.addSocketHandler(new PersonalClubMateDeadSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PersonalClubMateUpgradeSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PersonalClubTaskShareSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PersonalClubUpgradeSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PersonalFriendDeadSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PersonalFriendTaskShareSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PersonalFriendUpgradeSocketHandler());
			
			//玩家行为公告
			GlobalAPI.socketManager.addSocketHandler(new PlayerNoticeHandler());
			
			//活跃度
			GlobalAPI.socketManager.addSocketHandler(new PlayerActiveNumSocketHandler());
			
			//登录福利
			GlobalAPI.socketManager.addSocketHandler(new LoginRewardUpdateSocketHandler());
			
			//目标系统
			GlobalAPI.socketManager.addSocketHandler(new TargetListUpdateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new TargetGetAwardSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new TargetFinishSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new TargetHistoryUpdateSocketHandler());
			
			//江湖令接受发布
			GlobalAPI.socketManager.addSocketHandler(new UserInfoSocketHandler());
			
			//查询用户信息
			GlobalAPI.socketManager.addSocketHandler(new RoleInfoSocketHandler());
			
			GlobalAPI.socketManager.addSocketHandler(new UseTransferShoeSocketHandler());
			
			//答题活动
			GlobalAPI.socketManager.addSocketHandler(new QuizPushSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new QuizResultSocketHandler());
			
			//开服活动
			GlobalAPI.socketManager.addSocketHandler(new OpenActivityInfoSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new OpenActivityGetAwardSocketHandler());
			
			GlobalAPI.socketManager.addSocketHandler(new YellowBoxInfoSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new YellowBoxGetRewardSocketHandler());
			
			GlobalAPI.socketManager.addSocketHandler(new ClubCampEnterSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ClubCampLeaveSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ClubCampCallAttentionSocket());
			
			GlobalAPI.socketManager.addSocketHandler(new GetWorldBossNumSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ChallengeInfoSocketHandler());
			
			GlobalAPI.socketManager.addSocketHandler(new MountsGetMountShowItemSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetGetPetShowItemSocketHandler());
			
			GlobalAPI.socketManager.addSocketHandler(new SevenActivityInfoSocketHandler());
			
			GlobalAPI.socketManager.addSocketHandler(new CopyLimitNumResetSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new GetGameReleaseTimeSocketHandler());
			
			GlobalAPI.socketManager.addSocketHandler(new ActiveResourceWarEnterSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ActiveResourceWarLeaveSocketHandler());
			
			GlobalAPI.socketManager.addSocketHandler(new ActivePvpFirstEnterSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ActivePvpFirstLeaveSocketHandler());
			
			GlobalAPI.socketManager.addSocketHandler(new QQBugGoodsSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new TaskQuickCompleteSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ExchangeSilverMoneySocketHandler());
			
			GlobalAPI.socketManager.addSocketHandler(new MarryRequestNoticeSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new MarryEchoNoticeSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new WeddingSendInvitationCardSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new WeddingInfoUpdateSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ClubNewcomerSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new ClubNewcomerSocketHandler2());
			
			GlobalAPI.socketManager.addSocketHandler(new BigBossWarEnterSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new GuildPVPEnterSocketHandler());
			
			GlobalAPI.socketManager.addSocketHandler(new QuickEntrustmentSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new StartEntrustingSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new StopEntrustingSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetItemPlaceUpdateSocketHandler());
			
			//宠物斗坛
			GlobalAPI.socketManager.addSocketHandler(new PetPVPGetDailyRewardSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new PetPVPSelfLogUpdateSocketHandler());
			
			//王城争霸
			GlobalAPI.socketManager.addSocketHandler(new CityCraftAuctionSocketHandler());
			GlobalAPI.socketManager.addSocketHandler(new CityCraftAuctionStateSocketHandler());
			
		}
	}
}