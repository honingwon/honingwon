package sszt.club.components.clubMain.pop.sec
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	
	import sszt.club.components.clubMain.pop.MasterFunctionPanel;
	import sszt.club.components.clubMain.pop.items.MClubCacheAssetBtn;
	import sszt.club.datas.detailInfo.ClubDetailInfo;
	import sszt.club.events.ClubDetailInfoUpdateEvent;
	import sszt.club.events.ClubDeviceUpdateEvent;
	import sszt.club.events.ClubMediatorEvent;
	import sszt.club.events.ClubWealUpdateEvent;
	import sszt.club.mediators.ClubCampMediator;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubBackCampSocketHandler;
	import sszt.club.socketHandlers.ClubChargeMasterSocketHandler;
	import sszt.club.socketHandlers.ClubEnterClubScenceSocketHandler;
	import sszt.club.socketHandlers.ClubGetDeviceInfoSocketHandler;
	import sszt.club.socketHandlers.ClubWealUpdateSocketHandler;
	import sszt.constData.CategoryType;
	import sszt.constData.VipType;
	import sszt.core.caches.VipIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.data.club.memberInfo.ClubMemberInfoUpdateEvent;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToSkillData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.club.ClubSetNoticeSocketHandler;
	import sszt.core.socketHandlers.club.camp.ClubCampEnterSocketHandler;
	import sszt.core.socketHandlers.club.camp.ClubCampLeaveSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ChatModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.MCacheAssetBtn2;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	
	import ssztui.club.ClubBtnDonateAsset;
	import ssztui.club.ClubBtnFunAsset1;
	import ssztui.club.ClubBtnFunAsset2;
	import ssztui.club.ClubBtnFunAsset3;
	import ssztui.club.ClubBtnFunAsset4;
	import ssztui.club.ClubBtnFunAsset5;
	import ssztui.club.ClubBtnFunAsset6;
	import ssztui.club.ClubBtnFunAsset7;
	import ssztui.club.ClubBtnGetAsset;
	import ssztui.club.ClubTagFunAsset;
	import ssztui.club.ClubTagInfoAsset;
	
	public class ClubInfoPanel extends MSprite implements IClubMainPanel
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _bg2:Bitmap;
		
		//帮会信息
		private var _clubName:MAssetLabel;
		private var _clubMaster:MAssetLabel;
		private var _clubLevel:MAssetLabel;
		private var _clubRank:MAssetLabel;
		private var _menberNum:MAssetLabel;
		private var _clubAsset:MAssetLabel;  //帮会财富即帮会物资
		private var _maintainFee:MAssetLabel;
		
//		private var _qq:TextField;
//		private var _voice:TextField;
		
		private var _notice:TextField;
		private var _noticeTip:MAssetLabel;
		
		//个人信息
		private var _clubJob:MAssetLabel;
		private var _selfExploit:MAssetLabel;
		private var _clubWelf:MAssetLabel;
		private var _clubWelfTip:MAssetLabel;
		
		private var _qqSetBtn:MCacheAssetBtn1;
		private var _voiceSetBtn:MCacheAssetBtn1;
		private var _noticeSetBtn:MCacheAssetBtn1;
		private var _getWelfBtn:MAssetButton1;
		
		private var _contributeBtn:MAssetButton1;
		
		private var _shopBtnLevel:MAssetLabel;
		private var _furnaceBtnLevel:MAssetLabel;
		private var _unopenedTip:MSprite;
		
		private var _masterBtn:MCacheAssetBtn1;
		private var _goClubBtn:MCacheAssetBtn1;
		private var _chargeMasterBtn:MCacheAssetBtn1;
		private var _exitBtn:MCacheAssetBtn1;
		private var _dismissBtn:MCacheAssetBtn1;
		private var _enterIntoCampBtn:MCacheAssetBtn1;
		private var _leaveCampBtn:MCacheAssetBtn1;
		private var _chatBtn:MCacheAssetBtn1;
		private var _btns:Array;
		
		private var _funTile:MTile;
		private var _funBtns:Array;
		
//		private var _bg1:Bitmap;
		
//		private var _shopLevel:TextField;
//		private var _furnaceLevel:TextField;
//		
		
		private var _tf:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xfffccc,null,null,null,null,null,null,null,null,null,5);
		public function ClubInfoPanel(mediator:ClubMediator)
		{
			_mediator = mediator;
			super();
			_mediator.clubInfo.initDetailInfo();
			_mediator.clubInfo.initWealInfo();
			_mediator.clubInfo.initClubDeviceInfo();
			init();
			_mediator.getDetailInfo();
			ClubWealUpdateSocketHandler.send();
			ClubGetDeviceInfoSocketHandler.send();
		}
		
		private function init():void
		{		
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(5,4,220,353)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(227,4,403,122)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(227,128,403,229)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(229,7,400,26)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(229,131,400,26)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(229,305,400,25),new MCacheCompartLine2()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(389,11,71,17),new Bitmap(new ClubTagInfoAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(388,135,72,17),new Bitmap(new ClubTagFunAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(325,232,62,62),new Bitmap(new ClubBtnFunAsset5())),
			]);
			addChild(_bg as DisplayObject);
			
			_bg2 = new Bitmap();
			_bg2.x = 7;
			_bg2.y = 6;
			addChild(_bg2);
			
			var label:MAssetLabel;
			var tf:TextFormat = new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,10)
			
			label = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.RIGHT);
			label.setLabelType([tf]);
			label.move(80,86);
			addChild(label);
			label.setHtmlValue(
				LanguageManager.getWord("ssztl.club.curClubLeader")+ "：\n" +
				LanguageManager.getWord("ssztl.club.clubRank") + "：\n" +
				LanguageManager.getWord("ssztl.club.clubMember")+ "：\n" +
				LanguageManager.getWord("ssztl.common.clubMoney") + "："
			);
			
			label = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			label.setLabelType([tf]);
			label.move(242,47);
			addChild(label);
			label.setHtmlValue(
				LanguageManager.getWord("ssztl.club.clubJob")+ "：\n" +
				LanguageManager.getWord("ssztl.club.selfAllContribute")+"/" + LanguageManager.getWord("ssztl.club.selfAllContribute1") + "：\n" +
				LanguageManager.getWord("ssztl.club.clubWelFare")+ "：\n"
			);
			
//			_bg1 = new Bitmap();
//			_bg1.x = 85;
//			_bg1.y = 43;
//			addChild(_bg1);
		
			_clubName = new MAssetLabel("",MAssetLabel.LABEL_TYPE21B,TextFormatAlign.LEFT);
			_clubName.move(90,33);
			addChild(_clubName);
			_clubLevel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_clubLevel.setLabelType([new TextFormat("Tahoma",24,0xf5e1c0,true)]);
			_clubLevel.move(44,22);
			addChild(_clubLevel);
			
			_clubMaster = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_clubMaster.move(82,86);
			addChild(_clubMaster);			
			_clubRank = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_clubRank.move(82,108);
			addChild(_clubRank);
			_menberNum = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_menberNum.move(82,130);
			addChild(_menberNum);
			_clubAsset = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_clubAsset.move(82,152);
			addChild(_clubAsset);
			
			_maintainFee = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_maintainFee.move(80,150);
//			addChild(_maintainFee);
			
			
			//personal Info
			_clubJob = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_clubJob.move(302,47);
			addChild(_clubJob);
			
			_selfExploit = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_selfExploit.move(344,69);
			addChild(_selfExploit);
			_clubWelf = new MAssetLabel("",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			_clubWelf.move(302,91);
			addChild(_clubWelf);
			_clubWelfTip = new MAssetLabel(LanguageManager.getWord("ssztl.club.welfTip"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT);
			_clubWelfTip.move(380,91);
			addChild(_clubWelfTip);
			
			_noticeTip = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_noticeTip.move(115,267);
			addChild(_noticeTip);
			_noticeTip.setHtmlValue(LanguageManager.getWord("ssztl.club.editNoticeClub"));
			_noticeTip.alpha = 0.5;
			_noticeTip.mouseEnabled = false;
			
			_notice = new TextField();
			_notice.setTextFormat(_tf);
			_notice.defaultTextFormat = _tf;
			_notice.type = TextFieldType.INPUT;
			_notice.maxChars = 75;
			_notice.width = 200;
			_notice.height = 100;
			_notice.x = 16;
			_notice.y = 219;
			_notice.textColor = 0xfffccc;
			_notice.wordWrap = true;
			_notice.text = LanguageManager.getWord("ssztl.club.welcomeJionClub");
			addChild(_notice);
			
			_noticeSetBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.club.changeNotice"));
			_noticeSetBtn.move(80,318);
			addChild(_noticeSetBtn);
			_noticeSetBtn.visible = false;
			
			_qqSetBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.change"));
			_qqSetBtn.move(178,168);
			_qqSetBtn.visible = false;
			addChild(_qqSetBtn);
			_voiceSetBtn =  new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.change"));
			_voiceSetBtn.move(178,190);
			_voiceSetBtn.visible = false;
			addChild(_voiceSetBtn);
			
			_contributeBtn = new MAssetButton1(new ClubBtnDonateAsset() as MovieClip);
			_contributeBtn.move(528,50);
			addChild(_contributeBtn);
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(528,56,84,15),new MAssetLabel(LanguageManager.getWord("ssztl.club.contribute"),MAssetLabel.LABEL_TYPE20)));
				
			_getWelfBtn =new MAssetButton1(new ClubBtnGetAsset() as MovieClip);
			_getWelfBtn.move(528,82);
			addChild(_getWelfBtn);
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(528,88,84,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.getWelfare"),MAssetLabel.LABEL_TYPE20)));
			
			_exitBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.club.exitClub"));
			_exitBtn.move(322,318);
			addChild(_exitBtn);
			_dismissBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.club.releaseClub"));
			_dismissBtn.move(322,318);
			addChild(_dismissBtn);
			
			_enterIntoCampBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.club.enterIntoCamp"));
			_enterIntoCampBtn.move(394,318);
			addChild(_enterIntoCampBtn);
			
			_chatBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.club.clubChat"));
			_chatBtn.move(466,318);
			addChild(_chatBtn);
			
			_leaveCampBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.club.leaveCamp"));
			_leaveCampBtn.move(465,318);
//			addChild(_leaveCampBtn);
			
			_btns = [
				_chatBtn,_voiceSetBtn,_noticeSetBtn,
				_contributeBtn,_getWelfBtn,_exitBtn,_dismissBtn,_enterIntoCampBtn,_leaveCampBtn];
			
			_funTile = new MTile(62,62,5);
			_funTile.setSize(342,130);
			_funTile.move(255,165);
			_funTile.itemGapW = 8;
			_funTile.itemGapH = 5;
			_funTile.verticalScrollPolicy = _funTile.horizontalScrollPolicy = "off";
			addChild(_funTile);
			
			var btnClass:Array = new Array(ClubBtnFunAsset1,ClubBtnFunAsset2,ClubBtnFunAsset3,ClubBtnFunAsset4,ClubBtnFunAsset7,ClubBtnFunAsset6);
			for(var i:int=0; i<btnClass.length; i++)
			{
				var btns:MAssetButton1 = new MAssetButton1(new btnClass[i]() as MovieClip);
				_funTile.appendItem(btns);
				_btns.push(btns);
			}
			_shopBtnLevel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE,TextFormatAlign.LEFT);
			_shopBtnLevel.move(260,171);
			addChild(_shopBtnLevel);
			
			_furnaceBtnLevel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE,TextFormatAlign.LEFT);
			_furnaceBtnLevel.move(330,171);
			addChild(_furnaceBtnLevel);
			
			_unopenedTip = new MSprite();
			_unopenedTip.graphics.beginFill(0,0);
			_unopenedTip.graphics.drawRect(325,232,62,62);
			_unopenedTip.graphics.endFill();
			addChild(_unopenedTip);
			
			
			if(!ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty))
			{
				_notice.mouseEnabled = false;
				_noticeSetBtn.visible = false;
				_noticeTip.setHtmlValue("");
			}
			if(ClubDutyType.getIsMaster(GlobalData.selfPlayer.clubDuty))
			{
				_dismissBtn.visible = true;
				_exitBtn.visible = false;
			}
			else
			{
				_dismissBtn.visible = false;
				_exitBtn.visible = true;
			}
			initEvent();
		}
		
		private function initEvent():void
		{
			for(var i:int = 0;i<_btns.length;i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,clickHandler);
			}
			_mediator.clubInfo.clubDetailInfo.addEventListener(ClubDetailInfoUpdateEvent.DETAILINFO_UPDATE,detailInfoUpdateHandler);
			_mediator.clubInfo.clubWealInfo.addEventListener(ClubWealUpdateEvent.WEAL_INFO_UPDATE,welfInfoUpdateHandler);
			_mediator.clubInfo.deviceInfo.addEventListener(ClubDeviceUpdateEvent.DEVICE_UPDATE,deviceInfoUpdateHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.SELFEXPLOIT_UPDATE,exploitUpdateHandler);
			GlobalData.clubMemberInfo.addEventListener(ClubMemberInfoUpdateEvent.CLUB_NOTICE_UPDATE, noticeUpdateHandler);
			_notice.addEventListener(Event.CHANGE,noticeChangeHandler);
			_notice.addEventListener(FocusEvent.FOCUS_IN,noticeFocusInHandler),
			
			_unopenedTip.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_unopenedTip.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0;i<_btns.length;i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,clickHandler);
			}
			_mediator.clubInfo.clubDetailInfo.removeEventListener(ClubDetailInfoUpdateEvent.DETAILINFO_UPDATE,detailInfoUpdateHandler);
			_mediator.clubInfo.clubWealInfo.removeEventListener(ClubWealUpdateEvent.WEAL_INFO_UPDATE,welfInfoUpdateHandler);
			_mediator.clubInfo.deviceInfo.removeEventListener(ClubDeviceUpdateEvent.DEVICE_UPDATE,deviceInfoUpdateHandler);
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.SELFEXPLOIT_UPDATE,exploitUpdateHandler);
			GlobalData.clubMemberInfo.removeEventListener(ClubMemberInfoUpdateEvent.CLUB_NOTICE_UPDATE, noticeUpdateHandler);
			_notice.removeEventListener(Event.CHANGE,noticeChangeHandler);
			_notice.removeEventListener(FocusEvent.FOCUS_IN,noticeFocusInHandler),
			
			_unopenedTip.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_unopenedTip.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		public function assetsCompleteHandler():void
		{
			_bg2.bitmapData = AssetUtil.getAsset("ssztui.club.ClubInfoBgAsset",BitmapData) as BitmapData;
			for(var i:int = 0;i<8;++i)
			{
//				(_btns[i+3] as MClubCacheAssetBtn).setImg(AssetUtil.getAsset("ssztui.club.ClubIconAsset"+i,BitmapData) as BitmapData,9,9);
			}
			
		}
		
		private function overHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.scene.functionNoOpen"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function outHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function noticeChangeHandler(evt:Event):void
		{
			_noticeSetBtn.visible = true;
			if(_notice.length >= 75)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.contentOver75"));
			}
		}
		private function noticeFocusInHandler(evt:FocusEvent):void
		{
			_noticeTip.visible = false;
			_notice.addEventListener(FocusEvent.FOCUS_OUT,noticeFocusOutHandler);
		}
		private function noticeFocusOutHandler(evt:FocusEvent):void
		{
			var info:String = GlobalData.clubMemberInfo.clubNotice;
			_notice.removeEventListener(FocusEvent.FOCUS_OUT,noticeFocusOutHandler);
			if(_notice.text == "")
			{
				if(info == "")
				{
					_noticeTip.visible = true;
				}
				else
				{
					_noticeTip.visible = false;
					_notice.text = info;
				}
				_noticeSetBtn.visible = false;
			}
			else
			{
				_noticeTip.visible = false;
			}
		}
		private function noticeUpdateHandler(evt:ClubMemberInfoUpdateEvent):void{
			_notice.text = GlobalData.clubMemberInfo.clubNotice;
			if(GlobalData.clubMemberInfo.clubNotice == "")
				_noticeTip.visible = true;
			else
				_noticeTip.visible = false;
		}
		
		private function exploitUpdateHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			_selfExploit.setValue(GlobalData.selfPlayer.selfExploit + "/" + GlobalData.selfPlayer.totalExploit);
		}
		
		private function deviceInfoUpdateHandler(evt:ClubDeviceUpdateEvent):void
		{
//			_shopBtn.setLevel(_mediator.clubInfo.deviceInfo.shopLevel);
//			_furnaceBtn.setLevel(_mediator.clubInfo.deviceInfo.furnaceLevel);
			_shopBtnLevel.setValue(LanguageManager.getWord("ssztl.common.levelValue",_mediator.clubInfo.deviceInfo.shopLevel));
			_furnaceBtnLevel.setValue(LanguageManager.getWord("ssztl.common.levelValue",_mediator.clubInfo.deviceInfo.furnaceLevel));
		}
		
		private function detailInfoUpdateHandler(evt:ClubDetailInfoUpdateEvent):void
		{
			var info:ClubDetailInfo = _mediator.clubInfo.clubDetailInfo;
			
			_clubName.setValue(info.clubName);
			_clubMaster.setValue(info.masterName);
//			_bg1.bitmapData = VipIconCaches.vipCache[VipType.getVipType(info.masterType)];
//			_bg1.x = _clubMaster.width + 2;
//			if(info.viceMasterName == "") _viceMaster.setValue(LanguageManager.getWord("ssztl.common.none"));
//			else _viceMaster.setValue("[" + info.viceMasterServerId + "]" + info.viceMasterName);
//			_bg2.bitmapData = VipIconCaches.vipCache[VipType.getVipType(info.viceMasterType)];
			_clubLevel.setValue(info.clubLevel.toString());
			if(info.clubRank == 0) _clubRank.setValue(LanguageManager.getWord("ssztl.common.unrank"));
			else _clubRank.setValue(info.clubRank.toString());
			_menberNum.setValue(info.currentCount + "/" + info.totalCount);
			_clubAsset.setValue(info.clubRich.toString());
			_maintainFee.setValue(info.maintainFee.toString());
			
			_notice.text = info.notice;
			if(_notice.text == "")
				_noticeTip.visible = true;
			else
				_noticeTip.visible = false;
			
			_clubJob.setValue(ClubDutyType.getDutyName(GlobalData.selfPlayer.clubDuty));
			_selfExploit.setValue(GlobalData.selfPlayer.selfExploit + "/" + GlobalData.selfPlayer.totalExploit);
		}
		
		private function welfInfoUpdateHandler(evt:ClubWealUpdateEvent):void
		{
			_clubWelf.setValue(_mediator.clubInfo.clubWealInfo.dayWeal.toString() + LanguageManager.getWord("ssztl.common.experience"));
			if(_mediator.clubInfo.clubWealInfo.canGetWeal) _getWelfBtn.enabled = true;
			else _getWelfBtn.enabled = false;
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			var info:ClubDetailInfo = _mediator.clubInfo.clubDetailInfo;
			var index:int = _btns.indexOf(evt.currentTarget);
			switch (index)
			{
				case 0:
					/*
					if(!ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty))
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.noPopedom"));
						return;
					}
					ClubSetNoticeSocketHandler.send(info.notice);
					_qqSetBtn.visible = false;
					*/
					ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.SHOW_CLUB_CHAT));
					break;
				case 1:
					if(!ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty))
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.noPopedom"));
						return;
					}
					ClubSetNoticeSocketHandler.send(info.notice);
					_voiceSetBtn.visible = false;
					break;
				case 2:
					if(!ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty))
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.noPopedom"));
						return;
					}
					_noticeSetBtn.visible = false;
					ClubSetNoticeSocketHandler.send(_notice.text);
					break;
				case 3:
					_mediator.showNewContributePanel();
					break;
				case 4:
					MAlert.show(LanguageManager.getWord("ssztl.club.isSureGetClubFare"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,getAlertCloseHandler);
					break;
				case 5:
					_mediator.showExitPanel();
					break;
				case 6:
					_mediator.showDismissPanel();
					break;
				case 7:
					ClubCampEnterSocketHandler.send()
					break;
				case 8:
					ClubCampLeaveSocketHandler.send();
					break;
				case 9:		//商店
//					MAlert.show(LanguageManager.getWord("ssztl.scene.functionNoOpen"));
					_mediator.showShopPanel();
					break;
				case 10:			//技能
					SetModuleUtils.addSkill(new ToSkillData(1));
					break;
				case 11:			//仓库
					_mediator.showStorePanel();
					break;
				case 12:			//祈福
					_mediator.showLotteryPanel();
					break;
				case 13:			//BOSS
					_mediator.sendNotification(ClubMediatorEvent.SHOW_CLUB_BOSS_PANEL);
					break;
				case 14:			//采集
					_mediator.sendNotification(ClubMediatorEvent.SHOW_CLUB_COLLECTION_PANEL);
					break;
				
				/*
				case 3:
					_mediator.showShopPanel();
					trace('call boss');
					_mediator.sendNotification(ClubMediatorEvent.SHOW_CLUB_BOSS_PANEL);
					break;
				case 4:
//					SetModuleUtils.addFurnace(0);
					_mediator.clubModule.newClubMainPanel.setIndex(3);
					ClubManagerPanel(_mediator.clubModule.newClubMainPanel.panels[3]).setIndex(2);
					trace('call collections');
					_mediator.sendNotification(ClubMediatorEvent.SHOW_CLUB_COLLECTION_PANEL);
					break;
				case 5:
					_mediator.showStorePanel();
					trace('call collections');
					_mediator.sendNotification(ClubMediatorEvent.SHOW_CLUB_COLLECTION_PANEL);
					break;
				case 6:
//					_mediator.showNewLevelUpPanel();
					break;
				case 7:
					SetModuleUtils.addSkill(new ToSkillData(1));
					break;
				case 8:
					break;
				case 9:
					break;
				case 13:
				*/
				
				
//				case 3:
//					MAlert.show(LanguageManager.getWord("ssztl.club.isSureGetClubFare"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,getAlertCloseHandler);
//					break;
//				case 4:
//					_mediator.showDeviceMangePanel();
//					break;
//				case 5:
//					_mediator.showNewContributePanel();
//					break;
//				case 6:
//					_mediator.showShopPanel();
//					break;
//				case 7:
//					SetModuleUtils.addFurnace(0);
//					break;
//				case 8:
//					_mediator.showStorePanel();
//					break;
//				case 9:
//					if(!ClubDutyType.getIsMaster(GlobalData.selfPlayer.clubDuty))
//					{
//						QuickTips.show(LanguageManager.getWord("ssztl.club.noClubLeaderPopedom"));
//						return;
//					}
//					_mediator.showMasterFunction(new Point(evt.stageX,evt.stageY));
//					break;
//				case 10:
//					if(MapTemplateList.getIsPrison())
//					{
//						QuickTips.show(LanguageManager.getWord("ssztl.common.cannotDoInPrison"));
//						return;
//					}
//					if(GlobalData.copyEnterCountList.isInCopy || MapTemplateList.getIsInSpaMap() || MapTemplateList.getIsInVipMap()||MapTemplateList.isShenMoMap())
//					{
//						QuickTips.show(LanguageManager.getWord("ssztl.common.noTransferInSpeacialScene"));
//						return;
//					}
//					if(GlobalData.taskInfo.getTransportTask() != null)
//					{
//						QuickTips.show(LanguageManager.getWord("ssztl.common.noTransferInTransportState"));
//						return;
//					}
//					if(GlobalData.selfScenePlayerInfo.getIsFight())
//					{
//						QuickTips.show(LanguageManager.getWord("ssztl.common.noTransferInWarState"));
//						return;
//					}
//					if(MapTemplateList.isAcrossBossMap())
//					{
//						QuickTips.show(LanguageManager.getWord("ssztl.common.crossServerBoss"));
//						return;
//					}
//					MAlert.show(LanguageManager.getWord("ssztl.common.isSureQuickBackClub"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,closeHandler);
//					break;
//				case 11:
//					var list:Array = GlobalData.bagInfo.getItemById(CategoryType.CLUB_CHARGE_ID);
//					if(list.length == 0)
//					{
//						BuyPanel.getInstance().show([CategoryType.CLUB_CHARGE_ID],new ToStoreData(103));
//						return;
//					}
//					ClubChargeMasterSocketHandler.send();
//					break;
//				case 12:
//					_mediator.showExitPanel();
//					break;
//				case 13:
//					_mediator.showDismissPanel();
//					break;
			}
		}
		private function getAlertCloseHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				_mediator.getWeal();
			}
		}
		
		private function closeHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.CLEAR_WALK_PATH));
				ClubBackCampSocketHandler.send();
			}
		}
		
		public function show():void
		{
			
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		override public function dispose():void
		{
			removeEvent();
//			_mediator.clubInfo.clearDetailInfo();
			_mediator.clubInfo.clearWealInfo();
//			_mediator.clubInfo.clearClubDeviceInfo();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bg2 && _bg2.bitmapData)
			{
				_bg2.bitmapData.dispose();
				_bg2 = null;
			}
			_clubName = null;
			_clubMaster = null;
			_clubLevel = null;
			_clubRank = null;
			_menberNum = null;
			_clubAsset = null;
			_maintainFee = null;
			_notice = null;
			_clubJob = null;
			_selfExploit = null;
			_clubWelf = null;
			
			
			for(var i:int = 0;i<_btns.length;i++)
			{
				if(_btns[i])
				{
					_btns[i].dispose();
					_btns[i] = null;
				}
			}
			_btns = null;
			_btns = null;
//			_bg1 = null;
			if(_unopenedTip && _unopenedTip.parent)
			{
				_unopenedTip.graphics.clear();
				_unopenedTip.parent.removeChild(_unopenedTip);
				_unopenedTip = null;
			}
			if(parent) parent.removeChild(this);
		}
	}
}