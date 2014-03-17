package sszt.club.datas
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.club.datas.armyInfo.ClubArmyInfo;
	import sszt.club.datas.contributeInfo.ClubContributeInfo;
	import sszt.club.datas.contributeLogInfo.ClubContributeLogInfo;
	import sszt.club.datas.detailInfo.ClubDetailInfo;
	import sszt.club.datas.deviceInfo.ClubDeviceInfo;
	import sszt.club.datas.dutyInfo.ClubDutyManageInfo;
	import sszt.club.datas.eventInfo.ClubEventInfo;
	import sszt.club.datas.levelup.ClubLevelUpInfo;
	import sszt.club.datas.list.ClubListInfo;
	import sszt.club.datas.lottery.ClubLotteryInfo;
	import sszt.club.datas.manageInfo.ClubExtendInfo;
	import sszt.club.datas.manageInfo.ClubManageInfo;
	import sszt.club.datas.monster.ClubMonsterInfo;
	import sszt.club.datas.shop.ClubShopInfo;
	import sszt.club.datas.storeInfo.ClubStoreInfo;
	import sszt.club.datas.tryin.TryInlist;
	import sszt.club.datas.war.ClubWarInfo;
	import sszt.club.datas.weal.ClubWealInfo;
	import sszt.club.datas.workInfo.ClubWorkInfo;
	import sszt.club.events.ClubMailUpdateEvent;
	import sszt.core.data.player.DetailPlayerInfo;
	
	public class ClubInfo extends EventDispatcher
	{
		/**
		 * 帮会列表数据
		 */		
		public var clubListInfo:ClubListInfo;
		/**
		 * 成员面板数据
		 */		
//		public var clubMemberInfo:ClubMemberInfo;
		/**
		 * 帮会信息数据
		 */		
		public var clubDetailInfo:ClubDetailInfo;
		/**
		 * 申请列表数据
		 */		
		public var clubTryinInfo:TryInlist;
		/**
		 * 帮会仓库数据
		 */		
		public var clubStoreInfo:ClubStoreInfo;
		/**
		 * 帮会记事数据
		 */		
		public var clubEventInfo:ClubEventInfo;
		/**
		 * 帮会管理数据
		 */		
		public var manageInfo:ClubManageInfo;
		/**
		 * 帮会扩展数据
		 */		
		public var extendInfo:ClubExtendInfo;
		/**
		 * 帮会军团数据
		 */		
		public var clubArmyInfo:ClubArmyInfo;
		/**
		 * 帮会职务数据
		 */		
		public var clubDutyInfo:ClubDutyManageInfo;
		/**
		 * 帮会福利数据
		 */		
		public var clubWealInfo:ClubWealInfo;
		/**
		 *帮会事务数据
		 */		
		public var clubWorkInfo:ClubWorkInfo;
		/**
		 * 帮会升级数据
		 */		
		public var clubLevelUpInfo:ClubLevelUpInfo;
		/**
		 * 帮会商城数据
		 */		
		public var clubShopInfo:ClubShopInfo;
		/**
		 *帮会宣战数据 
		 */		
		public var clubWarInfo:ClubWarInfo;
		/**
		 * 帮会贡献数据
		 */		
		public var contributeInfo:ClubContributeInfo;
		/**
		 * 贡献日志数据
		 */		
		public var contributeLogInfo:ClubContributeLogInfo;
		/**
		 *设施管理数据 
		 */		
		public var deviceInfo:ClubDeviceInfo;	
		/**
		 *帮会神兽数据 
		 */		
		public var clubMonsterInfo:ClubMonsterInfo;
		/**
		 * 帮会祈福信息
		 * */
		public var clubLotteryInfo:ClubLotteryInfo = new ClubLotteryInfo();
		
		
		public function ClubInfo()
		{
		}
		
		public  function initClubDeviceInfo():void
		{
			if(deviceInfo == null)
			{
				deviceInfo = new ClubDeviceInfo();
			}
		}
		
		public function clearClubDeviceInfo():void
		{
			if(deviceInfo)
			{
				deviceInfo = null;
			}
		}
		
		public function initClubMonster():void
		{
			if(clubMonsterInfo == null)
			{
				clubMonsterInfo = new ClubMonsterInfo();
			}
		}
		
		public function clearClubMonster():void
		{
			if(clubMonsterInfo)
			{
				clubMonsterInfo = null;
			}
		}
		
		public function initClubList():void
		{
			if(clubListInfo == null)
			{
				clubListInfo = new ClubListInfo();
			}
		}
		public function clearClubList():void
		{
			if(clubListInfo)
			{
				clubListInfo.dispose();
				clubListInfo = null;
			}
		}
		
//		public function initMemeberInfo():void
//		{
//			if(clubMemberInfo == null)
//			{
//				clubMemberInfo = new ClubMemberInfo();
//			}
//		}
//		public function clearMemberInfo():void
//		{
//			if(clubMemberInfo)
//			{
//				clubMemberInfo.dispose();
//				clubMemberInfo = null;
//			}
//		}
		
		public function initDetailInfo():void
		{
			if(clubDetailInfo == null)
			{
				clubDetailInfo = new ClubDetailInfo();
			}
		}
		
		public function initWorkInfo():void
		{
			if(clubWorkInfo == null)
			{
				clubWorkInfo = new ClubWorkInfo();	
			}
		}
		
		public function clearDetailInfo():void
		{
			if(clubDetailInfo)
			{
				clubDetailInfo = null;
			}
		}
		
		public function initTryinInfo():void
		{
			if(clubTryinInfo == null)
			{
				clubTryinInfo = new TryInlist();
			}
		}
		public function clearTryinInfo():void
		{
			if(clubTryinInfo)
			{
				clubTryinInfo.dispose();
				clubTryinInfo = null;
			}
		}
		
		public function initStoreInfo():void
		{
			if(clubStoreInfo == null)
			{
				clubStoreInfo = new ClubStoreInfo();
			}
		}
		public function clearStoreInfo():void
		{
			if(clubStoreInfo)
			{
				clubStoreInfo.dispose();
				clubStoreInfo = null;
			}
		}
		
		public function initEventInfo():void
		{
			if(clubEventInfo == null)
			{
				clubEventInfo = new ClubEventInfo();
			}
		}
		public function clearEventInfo():void
		{
			if(clubEventInfo)
			{
				clubEventInfo.dispose();
				clubEventInfo = null;
			}
		}
		
		public function initManageInfo():void
		{
			if(manageInfo == null)
			{
				manageInfo = new ClubManageInfo();
			}
		}
		public function clearManageInfo():void
		{
			if(manageInfo)
			{
				manageInfo.dispose();
				manageInfo = null;
			}
		}
		
		public function initExtendInfo():void
		{
			if(extendInfo == null)
			{
				extendInfo = new ClubExtendInfo();
			}
		}
		public function clearExtendInfo():void
		{
			if(extendInfo)
			{
				extendInfo = null;
			}
		}
		
		public function initArmyInfo():void
		{
			if(clubArmyInfo == null)
			{
				clubArmyInfo = new ClubArmyInfo();
			}
		}
		public function clearArmyInfo():void
		{
			if(clubArmyInfo)
			{
				clubArmyInfo.dispose();
				clubArmyInfo = null;
			}
		}
		
		public function initDutyInfo():void
		{
			if(clubDutyInfo == null)
			{
				clubDutyInfo = new ClubDutyManageInfo();
			}
		}
		public function clearDutyInfo():void
		{
			if(clubDutyInfo)
			{
				clubDutyInfo.dispose();
				clubDutyInfo = null;
			}
		}
		
		public function initWealInfo():void
		{
			if(clubWealInfo == null)
			{
				clubWealInfo = new ClubWealInfo();
			}
		}
		public function clearWealInfo():void
		{
			if(clubWealInfo)
			{
				clubWealInfo = null;
			}
		}
		
		public function initLevelUpInfo():void
		{
			if(clubLevelUpInfo == null)
			{
				clubLevelUpInfo = new ClubLevelUpInfo();
			}
		}
		public function clearLevelUpInfo():void
		{
			if(clubLevelUpInfo)
			{
				clubLevelUpInfo = null;
			}
		}
		
		public function initShopInfo():void
		{
			if(clubShopInfo == null)
			{
				clubShopInfo = new ClubShopInfo();
			}
		}
		public function clearShopInfo():void
		{
			if(clubShopInfo)
			{
				clubShopInfo = null;
			}
		}
		
		
		public function initClubWarInfo():void
		{
			if(clubWarInfo == null)
			{
				clubWarInfo = new ClubWarInfo();
			}
		}
		
		public function clearClubWarInfo():void
		{
			if(clubWarInfo)
			{
				clubWarInfo = null;
			}
		}
		
		public function initContributeInfo():void
		{
			if(contributeInfo == null)
			{
				contributeInfo = new ClubContributeInfo();
			}
		}
		public function clearContributeInfo():void
		{
			if(contributeInfo)
			{
				contributeInfo.dispose();
				contributeInfo = null;
			}
		}
		
		public function initContributeLogInfo():void
		{
			if(contributeLogInfo == null)
			{
				contributeLogInfo = new ClubContributeLogInfo();
			}
		}
		public function clearContributeLogInfo():void
		{
			if(contributeLogInfo)
			{
				contributeLogInfo.dispose();
				contributeLogInfo = null;
			}
		}
		
		public function sendMailSuccess():void
		{
			dispatchEvent(new ClubMailUpdateEvent(ClubMailUpdateEvent.MAIL_SEND_SUCCESS));
		}
	}
}