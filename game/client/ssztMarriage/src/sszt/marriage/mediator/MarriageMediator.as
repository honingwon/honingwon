package sszt.marriage.mediator
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.constData.WeddingCandiesType;
	import sszt.constData.WeddingType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.marriage.MarriageInfo;
	import sszt.core.data.marriage.MarriageInfoUpdateEvent;
	import sszt.core.data.marriage.WeddingInfoUpdateEvent;
	import sszt.core.data.module.changeInfos.ToMarriageData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.marriage.WeddingSendInvitationCardSocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SceneModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.marriage.MarriageModule;
	import sszt.marriage.componet.MarriageEntrancePanel;
	import sszt.marriage.componet.MarryRefuseView;
	import sszt.marriage.componet.MarryTargetPanel;
	import sszt.marriage.componet.WeddingBlessingPanel;
	import sszt.marriage.componet.WeddingCheckCashGiftPanel;
	import sszt.marriage.componet.WeddingGuestPanel;
	import sszt.marriage.componet.WeddingHostPanel;
	import sszt.marriage.componet.WeddingInvitationCardView;
	import sszt.marriage.componet.WeddingInvitationPanel;
	import sszt.marriage.event.MarriageMediatorEvent;
	import sszt.marriage.event.WeddingUIEvent;
	import sszt.marriage.socketHandlers.MarryEchoSocketHandler;
	import sszt.marriage.socketHandlers.MarryRequestSocketHandler;
	import sszt.marriage.socketHandlers.WeddingCeremonySocketHandler;
	import sszt.marriage.socketHandlers.WeddingGetGiftSocketHandler;
	import sszt.marriage.socketHandlers.WeddingGiftListUpdateSocketHandler;
	import sszt.marriage.socketHandlers.WeddingLeaveSocketHandler;
	import sszt.marriage.socketHandlers.WeddingPresentCandiesSocketHandler;
	import sszt.marriage.socketHandlers.WeddingPresentGiftSocketHandler;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.page.PageEvent;
	
	public class MarriageMediator extends Mediator
	{
		public static const NAME:String = "marriageMediator";
		
		public function MarriageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				MarriageMediatorEvent.MARRIAGE_START,
				MarriageMediatorEvent.MARRIAGE_DISPOSE,
				MarriageMediatorEvent.SHOW_MARRY_TARGET_PANEL,
				MarriageMediatorEvent.SHOW_WEDDING_BLESSING_PANEL,
				MarriageMediatorEvent.SHOW_MARRY_REFUSE_PANEL,
				MarriageMediatorEvent.SHOW_WEDDING_PANEL,
				MarriageMediatorEvent.SHOW_WEDDING_INVITATION_CARD
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var data:Object = notification.getBody();
			switch(notification.getName())
			{
				case MarriageMediatorEvent.MARRIAGE_START:
					showMarriageEntrancePanel();
					break;
				case MarriageMediatorEvent.MARRIAGE_DISPOSE:
					dispose();
					break;
				case MarriageMediatorEvent.SHOW_MARRY_TARGET_PANEL:
					showMarryTargetPanel(data as ToMarriageData);
					break;
				case MarriageMediatorEvent.SHOW_WEDDING_BLESSING_PANEL:
					showWeddingBlessingPanel();
					break;
				case MarriageMediatorEvent.SHOW_MARRY_REFUSE_PANEL:
					MarryRefuseView.getInstance().show();
					break;
				case MarriageMediatorEvent.SHOW_WEDDING_PANEL:
					showWeddingPanel();
					break;
				case MarriageMediatorEvent.SHOW_WEDDING_INVITATION_CARD:
					showWeddingInvitationCard(data as ToMarriageData);
					break;
			}
		}
		
		private function showWeddingInvitationCard(data:ToMarriageData):void
		{
			if(marriageModule.marriageUIStateList.weddingInvitationCardView || MapTemplateList.isWeddingMap())return;
			marriageModule.marriageUIStateList.weddingInvitationCardView = new WeddingInvitationCardView(data.weddingInvitationInfo,presentCashGiftHandler);
			marriageModule.marriageUIStateList.weddingInvitationCardView.addEventListener(Event.CLOSE, cardHideHandler);
			GlobalAPI.layerManager.getPopLayer().addChild(marriageModule.marriageUIStateList.weddingInvitationCardView);
		}
		
		private function presentCashGiftHandler(userId:Number, type:int):void
		{
			//send data
			WeddingPresentGiftSocketHandler.send(userId,type);
		}
		
		private function cardHideHandler(e:Event):void
		{
			var card:WeddingInvitationCardView = e.currentTarget as WeddingInvitationCardView;
			card.removeEventListener(Event.CLOSE, cardHideHandler);
			marriageModule.marriageUIStateList.weddingInvitationCardView = null;
		}
		
		private function showWeddingPanel():void
		{
			//如果玩家是新郎或新娘
			var id:Number = GlobalData.selfPlayer.userId;
			if(id == GlobalData.weddingInfo.bridegroomId || id == GlobalData.weddingInfo.brideId)
			{
				if(!marriageModule.marriageUIStateList.weddingHostPanel)
				{
					marriageModule.marriageUIStateList.weddingHostPanel = new WeddingHostPanel();
					GlobalAPI.layerManager.getPopLayer().addChild(marriageModule.marriageUIStateList.weddingHostPanel);
					marriageModule.marriageUIStateList.weddingHostPanel.addEventListener(Event.CLOSE,weddingHostPanelCloseHandler);
					marriageModule.marriageUIStateList.weddingHostPanel.addEventListener(WeddingUIEvent.SHOW_WEDDING_CHECK_GIFT_PANEL, showWeddingCheckGiftPanel);
					marriageModule.marriageUIStateList.weddingHostPanel.addEventListener(WeddingUIEvent.SHOW_WEDDING_INVITATION_PANEL, showWeddingInvitationPanel);
					marriageModule.marriageUIStateList.weddingHostPanel.addEventListener(WeddingUIEvent.PRESENT_WEDDING_CANDIES, presentWeddingCandies);
					marriageModule.marriageUIStateList.weddingHostPanel.addEventListener(WeddingUIEvent.LEAVE, leaveWeddingHandler);
					marriageModule.marriageUIStateList.weddingHostPanel.addEventListener(WeddingUIEvent.WEDDING_CEREMONY, weddingCeremonyHandler);
					var seconds:Number = GlobalData.weddingInfo.seconds;
					if(seconds > 0)
					{
						marriageModule.marriageUIStateList.weddingHostPanel.updateCountDownView(seconds);
						marriageModule.marriageUIStateList.weddingHostPanel.countDownView.addEventListener(Event.COMPLETE,countDownCompletehandler);
					}
					marriageModule.marriageUIStateList.weddingHostPanel.updateFreeWeddingCandiesNum(GlobalData.weddingInfo.freeNum);
					if(GlobalData.weddingInfo.inCeremony) inceremonyHandler(null);
					GlobalData.weddingInfo.addEventListener(WeddingInfoUpdateEvent.FREE_CANDIES_NUM_UPDATE, freeCandiesNumUpdateHandler);
					GlobalData.weddingInfo.addEventListener(WeddingInfoUpdateEvent.IN_CEREMONY, inceremonyHandler);
					GlobalData.weddingInfo.addEventListener(WeddingInfoUpdateEvent.SECONDS_UPDATE, secondsUpdateHandler);
				}
			}
			else
			{
				if(!marriageModule.marriageUIStateList.weddingGuestPanel)
				{
					marriageModule.marriageUIStateList.weddingGuestPanel = new WeddingGuestPanel();
					GlobalAPI.layerManager.getPopLayer().addChild(marriageModule.marriageUIStateList.weddingGuestPanel);
					marriageModule.marriageUIStateList.weddingGuestPanel.addEventListener(Event.CLOSE,weddingGuestPanelCloseHandler);
					marriageModule.marriageUIStateList.weddingGuestPanel.addEventListener(WeddingUIEvent.SHOW_WEDDING_CHECK_GIFT_PANEL, showWeddingCheckGiftPanel);
					marriageModule.marriageUIStateList.weddingGuestPanel.addEventListener(WeddingUIEvent.LEAVE, leaveWeddingHandler);
					marriageModule.marriageUIStateList.weddingGuestPanel.addEventListener(WeddingUIEvent.PRESENT_WEDDING_CANDIES, presentWeddingCandies);
					seconds = GlobalData.weddingInfo.seconds;
					if(seconds > 0)
					{
						marriageModule.marriageUIStateList.weddingGuestPanel.updateCountDownView(seconds);
					}
					if(GlobalData.weddingInfo.inCeremony) inceremonyHandler(null);
					GlobalData.weddingInfo.addEventListener(WeddingInfoUpdateEvent.IN_CEREMONY, inceremonyHandler);
					GlobalData.weddingInfo.addEventListener(WeddingInfoUpdateEvent.SECONDS_UPDATE, secondsUpdateHandler);
					marriageModule.marriageUIStateList.weddingGuestPanel.updateNewlywedsName(GlobalData.weddingInfo.bridegroom,GlobalData.weddingInfo.bride);
				}
			}
			
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_SCENE, changeSceneHandler);
			function changeSceneHandler(e:Event):void
			{
				ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE, changeSceneHandler);
				if(!MapTemplateList.isWeddingMap())
				{
					GlobalData.weddingInfo.inCeremony = false;
					GlobalData.weddingInfo.isInit = false;
					ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE, changeSceneHandler);
					if(marriageModule.marriageUIStateList.weddingHostPanel)
					{
						marriageModule.marriageUIStateList.weddingHostPanel.dispose();
						marriageModule.marriageUIStateList.weddingHostPanel = null;
					}
					if(marriageModule.marriageUIStateList.weddingGuestPanel)
					{
						marriageModule.marriageUIStateList.weddingGuestPanel.dispose();
						marriageModule.marriageUIStateList.weddingGuestPanel = null;
					}
					ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_SHOW_FOLLOW_COMPLETE));//显示任务栏
				}
			}
		}
		
		protected function secondsUpdateHandler(event:Event):void
		{
			var seconds:Number = GlobalData.weddingInfo.seconds;
			if(seconds > 0)
			{
				if(marriageModule.marriageUIStateList.weddingHostPanel)
					marriageModule.marriageUIStateList.weddingHostPanel.updateCountDownView(seconds);
				if(marriageModule.marriageUIStateList.weddingGuestPanel)
					marriageModule.marriageUIStateList.weddingGuestPanel.updateCountDownView(seconds);
			}
		}
		
		protected function inceremonyHandler(event:Event):void
		{
			if(marriageModule.marriageUIStateList.weddingHostPanel)
			{
				marriageModule.marriageUIStateList.weddingHostPanel.countDownView.removeEventListener(Event.COMPLETE,countDownCompletehandler);
//				marriageModule.marriageUIStateList.weddingHostPanel.removeCountDownView();
				marriageModule.marriageUIStateList.weddingHostPanel.updateText();
				if(marriageModule.marriageUIStateList.weddingHostPanel.btnWeddingCeremony)
				{
					marriageModule.marriageUIStateList.weddingHostPanel.btnWeddingCeremony.enabled =false;
				}
			}
			
			if(marriageModule.marriageUIStateList.weddingGuestPanel)
			{
//				marriageModule.marriageUIStateList.weddingGuestPanel.removeCountDownView();
//				marriageModule.marriageUIStateList.weddingGuestPanel.updateText();
			}
		}
		
		protected function countDownCompletehandler(event:Event):void
		{
			WeddingCeremonySocketHandler.send();
		}
		
		protected function freeCandiesNumUpdateHandler(event:Event):void
		{
			marriageModule.marriageUIStateList.weddingHostPanel.updateFreeWeddingCandiesNum(GlobalData.weddingInfo.freeNum);
		}
		
		private function weddingGuestPanelCloseHandler(event:Event):void
		{
			marriageModule.marriageUIStateList.weddingGuestPanel.removeEventListener(Event.CLOSE,weddingGuestPanelCloseHandler);
			marriageModule.marriageUIStateList.weddingGuestPanel.removeEventListener(WeddingUIEvent.SHOW_WEDDING_CHECK_GIFT_PANEL, showWeddingCheckGiftPanel);
			marriageModule.marriageUIStateList.weddingGuestPanel.removeEventListener(WeddingUIEvent.LEAVE, leaveWeddingHandler);
			marriageModule.marriageUIStateList.weddingGuestPanel.removeEventListener(WeddingUIEvent.PRESENT_WEDDING_CANDIES, presentWeddingCandies);
			GlobalData.weddingInfo.removeEventListener(WeddingInfoUpdateEvent.SECONDS_UPDATE, secondsUpdateHandler);
			marriageModule.marriageUIStateList.weddingGuestPanel = null;
		}
		
		private function weddingHostPanelCloseHandler(event:Event):void
		{
			marriageModule.marriageUIStateList.weddingHostPanel.removeEventListener(Event.CLOSE,weddingHostPanelCloseHandler);
			marriageModule.marriageUIStateList.weddingHostPanel.removeEventListener(WeddingUIEvent.SHOW_WEDDING_CHECK_GIFT_PANEL, showWeddingCheckGiftPanel);
			marriageModule.marriageUIStateList.weddingHostPanel.removeEventListener(WeddingUIEvent.SHOW_WEDDING_INVITATION_PANEL, showWeddingInvitationPanel);
			marriageModule.marriageUIStateList.weddingHostPanel.removeEventListener(WeddingUIEvent.PRESENT_WEDDING_CANDIES, presentWeddingCandies);
			marriageModule.marriageUIStateList.weddingHostPanel.removeEventListener(WeddingUIEvent.LEAVE, leaveWeddingHandler);
			marriageModule.marriageUIStateList.weddingHostPanel.removeEventListener(WeddingUIEvent.WEDDING_CEREMONY, weddingCeremonyHandler);
			marriageModule.marriageUIStateList.weddingHostPanel.countDownView.removeEventListener(Event.COMPLETE,countDownCompletehandler);
			GlobalData.weddingInfo.removeEventListener(WeddingInfoUpdateEvent.FREE_CANDIES_NUM_UPDATE, freeCandiesNumUpdateHandler);
			GlobalData.weddingInfo.removeEventListener(WeddingInfoUpdateEvent.SECONDS_UPDATE, secondsUpdateHandler);
			marriageModule.marriageUIStateList.weddingHostPanel = null;
		}
		
		private function weddingCeremonyHandler(e:Event):void
		{
			//发送数据
			//拜堂
			WeddingCeremonySocketHandler.send();
		}
		
		private function leaveWeddingHandler(e:Event):void
		{
			var id:Number = GlobalData.selfPlayer.userId;
			if((id == GlobalData.weddingInfo.bridegroomId || id == GlobalData.weddingInfo.brideId) && !GlobalData.weddingInfo.inCeremony)
			{
				MAlert.show('拜堂后才能离开');
			}
			else
			{
				WeddingLeaveSocketHandler.send();
			}
		}
		
		private function presentWeddingCandies(e:WeddingUIEvent):void
		{
			//WeddingCandiesType
			var type:int = e.data as int;
			var cost:int;
			var candyName:String
			switch(type)
			{
				case WeddingCandiesType.FREE :
					cost = MarriageInfo.WEDDING_FREE_CANDIES_COST;
					candyName = LanguageManager.getWord('ssztl.marriage.weddingFreeCandiesName');
					break;
				case WeddingCandiesType.GOOD :
					cost = MarriageInfo.WEDDING_GOOD_CANDIES_COST;
					candyName = LanguageManager.getWord('ssztl.marriage.weddingGoodCandiesName');
					break;
				case WeddingCandiesType.BETTER :
					cost = MarriageInfo.WEDDING_BETTER_CANDIES_COST;
					candyName = LanguageManager.getWord('ssztl.marriage.weddingBetterCandiesName');
					break;
				case WeddingCandiesType.BEST :
					cost = MarriageInfo.WEDDING_BEST_CANDIES_COST;
					candyName = LanguageManager.getWord('ssztl.marriage.weddingBestCandiesName');
					break;
				case WeddingCandiesType.SUPER :
					cost = MarriageInfo.WEDDING_SUPER_CANDIES_COST;
					candyName = LanguageManager.getWord('ssztl.marriage.weddingSuperCandiesName');
					break;
			}
			var message:String = LanguageManager.getWord('ssztl.marriage.presentWeddingCandiesAlert',cost.toString(),candyName,candyName);
			
			MAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,confirmHandler);
			function confirmHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					//发送数据
					//type
					WeddingPresentCandiesSocketHandler.send(type);
				}
			}
		}
		
		/**
		 * 邀请好友面板
		 * */
		private function showWeddingInvitationPanel(event:Event):void
		{
			if(!marriageModule.marriageUIStateList.weddingInvitationPanel)
			{
				marriageModule.marriageUIStateList.weddingInvitationPanel = new WeddingInvitationPanel(oneClickInvitationHandler,inviteHandler,pageChangeHandler);
				GlobalAPI.layerManager.addPanel(marriageModule.marriageUIStateList.weddingInvitationPanel);
				var friends:Array = getOnlineFriendsByPage();
				var total:int = GlobalData.imPlayList.checkFriendCount();
				marriageModule.marriageUIStateList.weddingInvitationPanel.updateView(friends, total);
				marriageModule.marriageUIStateList.weddingInvitationPanel.addEventListener(Event.CLOSE,weddingInvitationPanelCloseHandler);
			}
			
			function weddingInvitationPanelCloseHandler():void
			{
				marriageModule.marriageUIStateList.weddingInvitationPanel.removeEventListener(Event.CLOSE,weddingInvitationPanelCloseHandler);
				marriageModule.marriageUIStateList.weddingInvitationPanel = null;
			}
		}
		
		private function pageChangeHandler(e:PageEvent):void
		{
			//send data
		}
		
		private function inviteHandler(data:ImPlayerInfo):void
		{
			//send data
			var userId:Number = data.info.userId;
			var list:Array = [userId];
			WeddingSendInvitationCardSocketHandler.send(list);
		}
		
		private function oneClickInvitationHandler(e:MouseEvent):void
		{
			var btnOneClickInvitation:MCacheAssetBtn1 = e.currentTarget as MCacheAssetBtn1;
			if(btnOneClickInvitation) 
			{
				btnOneClickInvitation.enabled = false;
			}
			if(marriageModule.marriageUIStateList.weddingInvitationPanel)
			{
				marriageModule.marriageUIStateList.weddingInvitationPanel.disableAllBtn();
			}
			var list:Array = [];
			var dic:Dictionary = GlobalData.imPlayList.friends;
			var item:ImPlayerInfo;
			for each(item in dic)
			{
				list.push(item.info.userId);
			}
			//send data
			WeddingSendInvitationCardSocketHandler.send(list);
		}
		
		private function getOnlineFriendsByPage():Array
		{
			var friendsDic:Dictionary = GlobalData.imPlayList.friends;
			var friendsItem:ImPlayerInfo;
			var friendsArr:Array = [];
			for each(friendsItem in friendsDic)
			{
				if(friendsItem.online && friendsItem.info.userId != GlobalData.weddingInfo.bridegroomId && friendsItem.info.userId != GlobalData.weddingInfo.brideId )
				{
					friendsArr.push(friendsItem);
				}
			}
			return friendsArr;
		}
		
		/**
		 * 查看随礼面板
		 * */
		private function showWeddingCheckGiftPanel(event:Event):void
		{
			if(!marriageModule.marriageUIStateList.weddingCheckGiftPanel)
			{
				marriageModule.marriageUIStateList.weddingCheckGiftPanel = new WeddingCheckCashGiftPanel(oneClickGetGiftHandler);
				GlobalAPI.layerManager.addPanel(marriageModule.marriageUIStateList.weddingCheckGiftPanel);
				marriageModule.marriageUIStateList.weddingCheckGiftPanel.addEventListener(Event.CLOSE,weddingCheckGiftPanelCloseHandler);
				marriageInfo.addEventListener(MarriageInfoUpdateEvent.WEDDING_GIFT_LIST_UPDATE,weddingGiftListUpdateHandler);
				WeddingGiftListUpdateSocketHandler.send();
			}
			
			function weddingCheckGiftPanelCloseHandler():void
			{
				marriageModule.marriageUIStateList.weddingCheckGiftPanel.removeEventListener(Event.CLOSE,weddingCheckGiftPanelCloseHandler);
				marriageModule.marriageUIStateList.weddingCheckGiftPanel = null;
			}
		}
		
		private function weddingGiftListUpdateHandler(event:Event):void
		{
			var list:Array = marriageInfo.weddingGiftList;
			marriageModule.marriageUIStateList.weddingCheckGiftPanel.updateView(list,list.length);
		}
		
		/**
		 * 一键领取礼金
		 * */
		private function oneClickGetGiftHandler(e:Event):void
		{
			WeddingGetGiftSocketHandler.send();
		}
		
		/**
		 * 结婚祝福
		 * @param type 祝福类型。0 历练 1 经验 2 铜币。
		 * */
		private function blessingHandler(type:int):void
		{
			//发送数据
			//关闭面板
			WeddingBlessingPanel.getInstance().dispose();
		}
		
		/**
		 * 显示结婚祝福面板
		 * */
		private function showWeddingBlessingPanel():void
		{
			WeddingBlessingPanel.getInstance().show(blessingHandler);
		}
		
		private function showMarryTargetPanel(data:ToMarriageData):void
		{
			MarryTargetPanel.getInstance().show(acceptProposalHandler, refuseProposalHandler,data);
		}
		
		/**
		 * 接受求婚
		 * */
		private function acceptProposalHandler():void
		{
			//隐藏面板
//			MarryTargetPanel.getInstance().dispose();
			//发送数据
			MarryEchoSocketHandler.send(1);
		}
		
		/**
		 * 拒绝求婚
		 * */
		private function refuseProposalHandler():void
		{
			//隐藏面板
			MarryTargetPanel.getInstance().dispose();
			//发送数据
			MarryEchoSocketHandler.send(2);
		}
		
		private function showMarriageEntrancePanel():void
		{
			if(!marriageModule.marriageUIStateList.marriageEntrancePanel)
			{
				marriageModule.marriageUIStateList.marriageEntrancePanel = new MarriageEntrancePanel(marryTargetNickChange,submitHandler);
				if(marriageModule.assetReady) marriageModule.marriageUIStateList.marriageEntrancePanel.assetsCompleteHandler();
				GlobalAPI.layerManager.addPanel(marriageModule.marriageUIStateList.marriageEntrancePanel);
				marriageModule.marriageUIStateList.marriageEntrancePanel.addEventListener(Event.CLOSE,marriageEntrancePanelCloseHandler);
			}
		}
		
		private function marriageEntrancePanelCloseHandler(event:Event):void
		{
			marriageModule.marriageUIStateList.marriageEntrancePanel.removeEventListener(Event.CLOSE,marriageEntrancePanelCloseHandler);
			marriageModule.marriageUIStateList.marriageEntrancePanel = null;
		}
		
		/**
		 * 获取求婚对象信息
		 * @return 如果返回为 0，则结婚对象昵称不正确。如果返回为1，则结婚对象已婚。如果返回为2，则昵称正确，且未结婚
		 * */
		private function getFriendInfoCodeByNick(nick:String):int
		{
			var ret:int = 0;
			var targetUserInfo:ImPlayerInfo = GlobalData.imPlayList.getFriendByNick(nick);
			//如果小于1则好友未找到。如果大于1则对象不唯一。
			if(targetUserInfo)
			{
				ret = targetUserInfo.isMarried ? 1 : 2;
			}
			return ret;
		}
		
		/**
		 * 获取求婚对象亲密度
		 * @return 如果返回为-1，则输入结婚对象昵称不正确(未找到唯一对象)。
		 * */
		private function getFriendPointByNick(nick:String):int
		{
			var ret:int = -1;
			var targetUserInfo:ImPlayerInfo = GlobalData.imPlayList.getFriendByNick(nick);
			if(targetUserInfo)
			{
				ret = targetUserInfo.amity;
			}
			return ret;
		}
		
		private function getFriendInfoByNick(nick:String):void
		{
			marriageInfo.targetPlayerFriendPoint = -1;
			marriageInfo.targetPlayerInfoCode = 0;
			
			var targetUserInfo:ImPlayerInfo = GlobalData.imPlayList.getFriendByNick(nick);
			if(targetUserInfo)
			{
				marriageInfo.targetPlayerFriendPoint = targetUserInfo.amity;
				marriageInfo.targetPlayerInfoCode = targetUserInfo.isMarried ? 1 : 2;
				marriageInfo.targetPlayerId = targetUserInfo.info.userId;
			}
		}
		
		/**
		 * 处理结婚对象名称改变事件
		 * */
		private function marryTargetNickChange(nick:String):void
		{
			getFriendInfoByNick(nick);
			if(marriageModule.marriageUIStateList.marriageEntrancePanel)
			{
				marriageModule.marriageUIStateList.marriageEntrancePanel.updateFriendPoint(marriageInfo.targetPlayerFriendPoint);
			}
		}
		
		/**
		 * 提交求婚申请
		 * */
		private function submitHandler(targetPlayerNick:String, weddingType:int):void
		{
			if(targetPlayerNick == '')
			{
				//请输入结婚对象名称
				QuickTips.show(LanguageManager.getWord('ssztl.marriage.targetNickIsEmpty'));
				return;
			}
			if(marriageInfo.targetPlayerInfoCode == 0)
			{
				//结婚对象昵称输入不正确
				QuickTips.show(LanguageManager.getWord('ssztl.marriage.targetNickIncorrect'));
				return;
			}
			if(marriageInfo.targetPlayerInfoCode == 1)
			{
				//对方已结婚
				QuickTips.show(LanguageManager.getWord('ssztl.marriage.targetIsMarried'));
				return;
			}
			//如果能到这一步，则说明输入昵称正确，friendPoint肯定大于-1
			if(marriageInfo.targetPlayerFriendPoint < MarriageInfo.FRIEND_POINT_LEAST)
			{
				//与结婚对象的亲密度不足
				QuickTips.show(LanguageManager.getWord('ssztl.marriage.friendPointAlert'));
				return;
			}
			if(weddingType == WeddingType.NOTHING)
			{
				//请选择婚礼类型
				QuickTips.show(LanguageManager.getWord('ssztl.marriage.weddingTypeAlert'));
				return;
			}
			var yuanbao:int = GlobalData.selfPlayer.userMoney.yuanBao;
			if((weddingType == WeddingType.GOOD && yuanbao < MarriageInfo.GOOD_WEDDING_COST) ||
				(weddingType == WeddingType.BETTER && yuanbao < MarriageInfo.BETTER_WEDDING_COST))
			{
				MAlert.show(LanguageManager.getWord("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,chargeAlertHandler);
				function chargeAlertHandler(evt:CloseEvent):void
				{
					if(evt.detail == MAlert.OK)
					{
						JSUtils.gotoFill();
					}
				}
				return;
			}
			
			//发送数据
			MarryRequestSocketHandler.send(marriageInfo.targetPlayerId, weddingType);
		}
		
		public function get marriageInfo():MarriageInfo
		{
			return marriageModule.marriageInfo;
		}
		
		public function get marriageModule():MarriageModule
		{
			return viewComponent as MarriageModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
		
	}
}