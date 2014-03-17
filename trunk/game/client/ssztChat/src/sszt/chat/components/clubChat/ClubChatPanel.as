/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-9-3 下午2:01:52 
 * 
 */ 

package  sszt.chat.components.clubChat
{
	import fl.controls.CheckBox;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.chat.mediators.ChatMediator;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.KeyType;
	import sszt.core.data.chat.ChannelType;
	import sszt.core.data.chat.ChatInfoUpdateEvent;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.chat.club.ClubChatItemInfo;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.data.club.memberInfo.ClubMemberInfoUpdateEvent;
	import sszt.core.data.club.memberInfo.ClubMemberItemInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.player.SelfPlayerInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.chat.ChatSockethandler;
	import sszt.core.socketHandlers.club.ClubGetNoticeSocketHandler;
	import sszt.core.socketHandlers.club.ClubMemberListSocketHandler;
	import sszt.core.socketHandlers.club.ClubSetNoticeSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.RichTextUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.utils.StringUtils;
	import sszt.core.utils.WordFilterUtils;
	import sszt.core.view.chat.FaceView;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.richTextField.RichTextField;
	import sszt.core.view.tips.ChatPlayerTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MTextArea;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.chat.ChatBtnMinAsset;
	import ssztui.chat.ClubChatTitleAsset;
	import ssztui.chat.ClubPostBgAsset;
	import ssztui.chat.FaceBtnAsset;
	
	public class ClubChatPanel extends MPanel  {
		
		private static const GAP:int = 6;
		
		private var _mediator:ChatMediator;
		private var _scrollPanel:MScrollPanel;
		private var _inputText:MTextArea;
		private var _itemList:Array;
		private var _faceView:FaceView;
		private var _sendBtn:MCacheAssetBtn1;
		private var _minBtn:MAssetButton1;
		private var _faceBtn:MBitmapButton;
		private var _count:int = 0;
		private var _seconds:int = 30;
		private var _noticeTip:MAssetLabel;
		private var _noticeLabel:TextField;
		private var _memberListLabel:MAssetLabel;
		private var _checkBox:CheckBox;
		private var _minIconBtn:MBitmapButton;
		private var _posBtn:MBitmapButton;
		private var _contributeBtn:MBitmapButton;
		private var _wheelBtn:MBitmapButton;
		private var _storeBtn:MBitmapButton;
		private var _welfareBtn:MBitmapButton;
		private var _shopBtn:MBitmapButton;
		private var _signBtn:MBitmapButton;
		private var _btns:Array;
		private var _linkField:MAssetLabel;
		private var _tile:MTile;
		private var _playerList:Array;
		private var _currentItem:ClubPlayerView;
		private var _currentHeight:int = 0;
		private var _facePattern:RegExp;
		private var _timeoutIndex:int = -1;
		private var _isFirstInit:Boolean = true;
		
		public function ClubChatPanel(mediator:ChatMediator){
			_facePattern = /\#[0-9][0-9]/g;
			_mediator = mediator;
			super(new MCacheTitle1("",new Bitmap(new ClubChatTitleAsset())),true,-1,true,true);
		}
		override protected function configUI():void{
			super.configUI();
			setContentSize(522, 396);
			setToBackgroup([
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(10, 2, 322, 301)), 
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(10, 306, 322, 48)), 
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(334, 2, 178, 383)), 
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(337, 31, 172, 122),new Bitmap(new ClubPostBgAsset())), 
				new BackgroundInfo(BackgroundType.BAR_2, new Rectangle(334, 5, 178, 25)),
				new BackgroundInfo(BackgroundType.BAR_2, new Rectangle(334, 153, 178, 25)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(334, 9, 178, 16), 	new MAssetLabel(LanguageManager.getWord("ssztl.club.clubNoticeLabel"), MAssetLabel.LABEL_TYPE_TITLE2 ))
			]);
			_sendBtn = new MCacheAssetBtn1(0,3, LanguageManager.getWord("ssztl.common.send"));
			_sendBtn.move(257, 360);
			addContent(_sendBtn);
			_minBtn = new MAssetButton1(new ChatBtnMinAsset());
			_minBtn.move(471,-24);
			addContent(_minBtn);
//			_minIconBtn = new MBitmapButton(new MinIconAsset());
//			_minIconBtn.move(490, -25);
//			addContent(_minIconBtn);
			_faceBtn =  new MBitmapButton(new FaceBtnAsset() as BitmapData);
			_faceBtn.move(232, 364);
			addContent(_faceBtn);
//			_posBtn = new MBitmapButton(new ClubChatBtnAsset1());
//			_posBtn.move(68, 308);
//			addContent(_posBtn);
//			_contributeBtn = new MBitmapButton(new ClubChatBtnAsset2());
//			_contributeBtn.move(98, 307);
//			addContent(_contributeBtn);
//			_wheelBtn = new MBitmapButton(new ClubChatBtnAsset3());
//			_wheelBtn.move(128, 307);
//			addContent(_wheelBtn);
//			_storeBtn = new MBitmapButton(new ClubChatBtnAsset4());
//			_storeBtn.move(158, 307);
//			addContent(_storeBtn);
//			_welfareBtn = new MBitmapButton(new ClubChatBtnAsset5());
//			_welfareBtn.move(188, 307);
//			addContent(_welfareBtn);
//			_shopBtn = new MBitmapButton(new ClubShopBtnAsset());
//			_shopBtn.move(218, 307);
//			addContent(_shopBtn);
//			_signBtn = new MBitmapButton(new ClubChatBtnAsset6());
//			_signBtn.move(248, 306);
//			addContent(_signBtn);
			_btns = [];
//			_btns = [_posBtn, _contributeBtn, _wheelBtn, _storeBtn, _welfareBtn, _shopBtn, _signBtn];
			_noticeTip = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_noticeTip.move(423,72);
			addContent(_noticeTip);
			_noticeTip.setHtmlValue(LanguageManager.getWord("ssztl.club.editNoticeClub"));
			_noticeTip.alpha = 0.5;
			_noticeTip.mouseEnabled = false;
			
			_noticeLabel = new TextField();
			_noticeLabel.defaultTextFormat = new TextFormat("Microsoft Yahei",12,0xFFFccc);
			_noticeLabel.type = TextFieldType.INPUT;
			_noticeLabel.maxChars = 75;
			_noticeLabel.width = 162;
			_noticeLabel.height = 112;
			_noticeLabel.x = 342;
			_noticeLabel.y = 36;
			_noticeLabel.wordWrap = true;
			_noticeLabel.text = GlobalData.clubMemberInfo.clubNotice;
			if(GlobalData.clubMemberInfo.clubNotice == "")
				_noticeTip.visible = true;
			else
				_noticeTip.visible = false;
			
			addContent(_noticeLabel);
			
			_linkField = new MAssetLabel("", MAssetLabel.LABEL_TYPE7);
			_linkField.mouseEnabled = true;
			_linkField.move(423, 130);
			addContent(_linkField);
			_linkField.visible = false;
			_linkField.htmlText = (("<u><a href = 'event:0'>" + LanguageManager.getWord("ssztl.club.changeNotice")) + "</a></u>");
			if (ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty)){
				_noticeLabel.mouseEnabled = true;
			} else {
				_noticeLabel.mouseEnabled = false;
				_noticeTip.setHtmlValue("");
			}
			_memberListLabel = new MAssetLabel("", MAssetLabel.LABEL_TYPE_TITLE2);
			_memberListLabel.move(423, 158);
			_memberListLabel.setValue((LanguageManager.getWord("ssztl.club.clubMemberList") + "(0/0)"));
			addContent(_memberListLabel);
			_itemList = [];
			_scrollPanel = new MScrollPanel();
//			_scrollPanel.mouseEnabled = (_scrollPanel.getContainer().mouseEnabled = false);
			_scrollPanel.setSize(314, 297);
			_scrollPanel.move(15, 4);
			addContent(_scrollPanel);
			_inputText = new MTextArea();
			_inputText.textField.textColor = 0xfffccc;
			_inputText.setSize(323, 42);
			_inputText.move(15, 309);
			_inputText.editable = (_inputText.enabled = true);
			addContent(_inputText);
			_playerList = [];
			_tile = new MTile(172, 22);
			_tile.setSize(172, 205);
			_tile.move(338, 178);
			_tile.verticalScrollPolicy = ScrollPolicy.AUTO;
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.itemGapH = 0;
			_tile.verticalLineScrollSize = 22;
			addContent(_tile);
			_checkBox = new CheckBox();
			_checkBox.setSize(94, 19);
			_checkBox.label = LanguageManager.getWord("ssztl.common.cancelFlash");
			_checkBox.move(15, 363);
			addContent(_checkBox);
			_checkBox.selected = !(GlobalData.clubChatInfo.isFlash);
			initEvent();
			getMemberList();
		}
		
		private function getMemberList():void{
			ClubMemberListSocketHandler.send();
			ClubGetNoticeSocketHandler.send();
//			ClubWelfareUpdateSocketHandler.send();
		}
		private function initData():void{
			var list:Array = GlobalData.clubChatInfo.list;
			var i:int;
			while (i < list.length) {
				addItem(list[i]);
				i++;
			}
		}
		
		private function initEvent():void{
			_checkBox.addEventListener(Event.CHANGE, checkBoxChangeHandler);
			_sendBtn.addEventListener(MouseEvent.CLICK, sendBtnClickHandler);
			_minBtn.addEventListener(MouseEvent.CLICK, minBtnClickHandler);
//			_minIconBtn.addEventListener(MouseEvent.CLICK, minBtnClickHandler);
			_faceBtn.addEventListener(MouseEvent.CLICK, faceBtnClickHandler);
			GlobalAPI.keyboardApi.getKeyListener().addEventListener(KeyboardEvent.KEY_DOWN, keyIsDownHandler);
			GlobalData.clubMemberInfo.addEventListener(ClubMemberInfoUpdateEvent.MEMBERINFO_UPDATE, memberInfoUpdate);
			GlobalData.clubChatInfo.addEventListener(ChatInfoUpdateEvent.ADD_CLUB_CHATINFO, addClubChatHandler);
			GlobalData.clubMemberInfo.addEventListener(ClubMemberInfoUpdateEvent.MEMBER_ONLINE_CHANGE, onlineChangeHandler);
			GlobalData.clubMemberInfo.addEventListener(ClubMemberInfoUpdateEvent.CLUB_NOTICE_UPDATE, noticeUpdateHandler);
			for(var  i:int = 0 ;i < _btns.length ; ++i)
			{
				_btns[i].addEventListener(MouseEvent.CLICK, btnClickHandler);
				_btns[i].addEventListener(MouseEvent.MOUSE_OVER, btnOverHandler);
				_btns[i].addEventListener(MouseEvent.MOUSE_OUT, btnOutHandler);
			}
			addEventListener(TextEvent.LINK, linkFieldClickHandler);
			
			_noticeLabel.addEventListener(Event.CHANGE,noticeChangeHandler);
			_noticeLabel.addEventListener(FocusEvent.FOCUS_IN,noticeFocusInHandler);
		}
		private function removeEvent():void{
			_checkBox.removeEventListener(Event.CHANGE, checkBoxChangeHandler);
			_sendBtn.removeEventListener(MouseEvent.CLICK, sendBtnClickHandler);
			_minBtn.removeEventListener(MouseEvent.CLICK, minBtnClickHandler);
//			_minIconBtn.removeEventListener(MouseEvent.CLICK, minBtnClickHandler);
			_faceBtn.removeEventListener(MouseEvent.CLICK, faceBtnClickHandler);
			GlobalAPI.keyboardApi.getKeyListener().removeEventListener(KeyboardEvent.KEY_DOWN, keyIsDownHandler);
			GlobalData.clubMemberInfo.removeEventListener(ClubMemberInfoUpdateEvent.MEMBERINFO_UPDATE, memberInfoUpdate);
			GlobalData.clubChatInfo.removeEventListener(ChatInfoUpdateEvent.ADD_CLUB_CHATINFO, addClubChatHandler);
			GlobalData.clubMemberInfo.removeEventListener(ClubMemberInfoUpdateEvent.MEMBER_ONLINE_CHANGE, onlineChangeHandler);
			GlobalData.clubMemberInfo.removeEventListener(ClubMemberInfoUpdateEvent.CLUB_NOTICE_UPDATE, noticeUpdateHandler);
			for(var  i:int = 0 ;i < _btns.length ; ++i)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK, btnClickHandler);
				_btns[i].removeEventListener(MouseEvent.MOUSE_OVER, btnOverHandler);
				_btns[i].removeEventListener(MouseEvent.MOUSE_OUT, btnOutHandler);
			}
			removeEventListener(TextEvent.LINK, linkFieldClickHandler);
			
			_noticeLabel.removeEventListener(Event.CHANGE,noticeChangeHandler);
			_noticeLabel.removeEventListener(FocusEvent.FOCUS_IN,noticeFocusInHandler);
		}
		private function noticeChangeHandler(evt:Event):void
		{
			_linkField.visible = true;
			if(_noticeLabel.length >= 75)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.contentOver75"));
			}
		}
		private function noticeFocusInHandler(evt:FocusEvent):void
		{
			_noticeTip.visible = false;
			_noticeLabel.addEventListener(FocusEvent.FOCUS_OUT,noticeFocusOutHandler);
		}
		private function noticeFocusOutHandler(evt:FocusEvent):void
		{
			var info:String = GlobalData.clubMemberInfo.clubNotice;
			_noticeLabel.removeEventListener(FocusEvent.FOCUS_OUT,noticeFocusOutHandler);
			if(_noticeLabel.text == "")
			{
				if(info == "")
				{
					_noticeTip.visible = true;
				}
				else
				{
					_noticeTip.visible = false;
					_noticeLabel.text = info;
				}
				_linkField.visible = false;
			}
			else
			{
				_noticeTip.visible = false;
			}
		}
		
		private function linkFieldClickHandler(evt:TextEvent):void{
			switch (evt.text){
				case "0":
					if (ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty)){
						ClubSetNoticeSocketHandler.send(WordFilterUtils.filterChatWords(_noticeLabel.text));
						_linkField.visible = false;
					}
					else 
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.noPopedom"));
					}
					break;
			}
		}
		
		private function btnOverHandler(evt:MouseEvent):void{
			var msg:String = "";
			switch (evt.currentTarget){
				case _posBtn:
					msg = LanguageManager.getWord("ssztl.club.posBtnTip");
					break;
				case _contributeBtn:
					msg = LanguageManager.getWord("ssztl.club.donate");
					break;
				case _wheelBtn:
					msg = LanguageManager.getWord("ssztl.club.clubWheelTitle");
					break;
				case _storeBtn:
					msg = LanguageManager.getWord("ssztl.club.ClubStoreTips");
					break;
				case _welfareBtn:
					msg = LanguageManager.getWord("ssztl.chat.clubWelFare");
					break;
				case _shopBtn:
					msg = LanguageManager.getWord("ssztl.club.ClubShopBtnTips");
					break;
				case _signBtn:
					msg = LanguageManager.getWord("ssztl.club.flagSignTip");
					break;
			};
			TipsUtil.getInstance().show(msg, null, new Rectangle(evt.stageX, evt.stageY, 0, 0));
		}
		private function btnOutHandler(evt:MouseEvent):void{
			TipsUtil.getInstance().hide();
		}
		private function btnClickHandler(evt:MouseEvent):void{
			switch (evt.currentTarget){
				case _posBtn:
//					doSendPosition();
					break;
				case _contributeBtn:
					SetModuleUtils.addClub(9);
					break;
				case _wheelBtn:
					SetModuleUtils.addClub(10);
					break;
				case _storeBtn:
					SetModuleUtils.addClub(8);
					break;
//				case _welfareBtn:
//					if (GlobalData.clubWelfareInfo.canGetWeal){
//						MAlert.show(LanguageManager.getWord("ssztl.club.isSureGetClubFare", GlobalData.clubWelfareInfo.dayWeal), AssetUtil.getAsset("mhsm.common.AlertTitleAsset"), (MAlert.OK | MAlert.CANCEL), null, getAlertCloseHandler);
//					} else {
//						QuickTips.show(LanguageManager.getWord("ssztl.chat.clubWelfarehadGet"));
//					};
//					break;
				case _shopBtn:
					SetModuleUtils.addClub(6);
					break;
				case _signBtn:
					SetModuleUtils.addClub(13);
					break;
			}
		}
//		private function getAlertCloseHandler(evt:CloseEvent):void{
//			if (evt.detail == MAlert.OK){
//				ClubGetWealSocketHandler.send();
//			}
//		}
//		private function doSendPosition():void{
//			var sendCloseHandler:Function;
//			sendCloseHandler = function (evt:CloseEvent):void{
//				if (evt.detail == MAlert.OK){
//					if (GlobalData.selfPlayer.selfExploit < 5){
//						MAlert.show(LanguageManager.getWord("ssztl.club.isClubContribution"), AssetUtil.getAsset("ssztui.common.AlertTitleAsset"), (MAlert.OK | MAlert.CANCEL), null, getContributeAlertCloseHandler);
//					} else {
//						ClubSendPositionSocketHandler.send();
//					}
//				}
//			}
//				
////			if (GlobalData.securityType == SecurityType.LOCKED){
////				SecurityUnlockPanel.show();
////				return;
////			}
//			
//			if ( GlobalData.copyEnterCountList.isInCopy || MapTemplateList.isClubMap(GlobalData.currentMapId) )
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
//				return;
//			}
//			if (GlobalData.selfPlayer.isFly()){
//				QuickTips.show(LanguageManager.getWord("ssztl.scene.unOperateInHitDownState"));
//				return;
//			}
//			var content:String = (("<p align = 'center'>" + LanguageManager.getWord("ssztl.club.isSureCostContributeSendPos")) + "</p>");
//			GlobalData.noAlertType.show(content, AssetUtil.getAsset("ssztui.common.AlertTitleAsset"), (MAlert.OK | MAlert.CANCEL), null, sendCloseHandler, NoAlertType.CLUB_SEND_POSITION, LanguageManager.getWord("ssztl.common.noAlertInThisLogin"), "center", -1, true, false);
//		}
		
		private function getContributeAlertCloseHandler(evt:CloseEvent):void{
			if (evt.detail == MAlert.OK){
				SetModuleUtils.addClub(9);
			}
		}
		
//		private function closeHandler(evt:CloseEvent):void{
//			if (evt.detail == MAlert.OK){
//				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.CLEAR_WALK_PATH));
//				ClubBackCampSocketHandler.send();
//			}
//		}
		
		private function checkBoxChangeHandler(evt:Event):void{
			GlobalData.clubChatInfo.isFlash = !(_checkBox.selected);
		}
		private function noticeUpdateHandler(evt:ClubMemberInfoUpdateEvent):void{
			_noticeLabel.text = GlobalData.clubMemberInfo.clubNotice;
			if(GlobalData.clubMemberInfo.clubNotice == "")
				_noticeTip.visible = true;
			else
				_noticeTip.visible = false;
		}
		private function onlineChangeHandler(evt:ClubMemberInfoUpdateEvent):void{
			memberInfoUpdate(null);
		}
		private function addClubChatHandler(evt:ChatInfoUpdateEvent):void{
			var item:ClubChatItemInfo = (evt.data as ClubChatItemInfo);
			addItem(item);
		}
		
		private function memberInfoUpdate(evt:ClubMemberInfoUpdateEvent):void{
			var item:ClubPlayerView;
			if (_isFirstInit){
				initData();
				_isFirstInit = false;
			}
			clearMemberList();
			var list:Array = GlobalData.clubMemberInfo.getSortListByOnLine();
			var i:int;
			while (i < list.length) {
				item = new ClubPlayerView(list[i]);
				item.addEventListener(MouseEvent.CLICK, itemClickHandler);
				_tile.appendItem(item);
				_playerList.push(item);
				i++;
			}
			var onlineCount:int = GlobalData.clubMemberInfo.getOnlineCount();
			var total:int = list.length;
			_memberListLabel.setValue(LanguageManager.getWord("ssztl.club.clubMemberList") + "(" + onlineCount + "/" + total + ")");
		}
		
		private function clearMemberList():void{
			_tile.clearItems();
			var i:int;
			while (i < _playerList.length) {
				_playerList[i].removeEventListener(MouseEvent.CLICK, itemClickHandler);
				_playerList[i].dispose();
				i++;
			}
			_playerList = [];
			_currentItem = null;
		}
		
		private function itemClickHandler(evt:MouseEvent):void{
			if (_currentItem){
				_currentItem.selected = false;
			}
			_currentItem = (evt.currentTarget as ClubPlayerView);
			_currentItem.selected = true;
			var info:ClubMemberItemInfo = _currentItem.info;
			if (GlobalData.selfPlayer.userId != info.id){
				ChatPlayerTip.getInstance().show(info.serverId, info.id, info.name, new Point(evt.stageX, evt.stageY));
			}
		}
		
		private function keyIsDownHandler(evt:KeyboardEvent):void{
			if (_inputText && evt.target == _inputText.textField)
			{
				if ((evt.keyCode == KeyType.ENTER && GlobalAPI.keyboardApi.keyIsDown(KeyType.CTRL)) || (evt.keyCode == KeyType.CTRL && GlobalAPI.keyboardApi.keyIsDown(KeyType.ENTER)))
				{
					sendMessage(_inputText.text);
					_inputText.text = "";
					stage.focus = _inputText.textField;
				}
			}
		}
		private function minBtnClickHandler(evt:MouseEvent):void{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_mediator.showClubChatIcon(false);
			hide();
		}
		
		private function faceBtnClickHandler(evt:MouseEvent):void{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			evt.stopImmediatePropagation();
			if (_faceView == null){
				_faceView = new FaceView();
				_faceView.addEventListener(CommonModuleEvent.ADD_FACE, addFaceHandler);
			}
			_faceView.move(evt.stageX, (evt.stageY - 100));
			if (_faceView && _faceView.parent){
				_faceView.hide();
			} else {
				_faceView.show();
			}
		}
		
		private function addFaceHandler(evt:CommonModuleEvent):void{
			var backHandler:Function;
			var evt:CommonModuleEvent = evt;
			backHandler = function ():void{
				stage.focus = _inputText.textField;
				_inputText.textField.setSelection(_inputText.textField.text.length, _inputText.textField.text.length);
				if (_timeoutIndex != -1){
					clearTimeout(_timeoutIndex);
				}
			}
			var index:int = (evt.data as int);
			var mes:String = (((index < 10)) ? ("0" + index) : String(index));
			_inputText.appendText(("#" + mes));
			if (_timeoutIndex != -1){
				clearTimeout(_timeoutIndex);
			}
			_timeoutIndex = setTimeout(backHandler, 50);
		}
		
		private function sendBtnClickHandler(evt:MouseEvent):void{
			var backHandler:Function;
			var evt:MouseEvent = evt;
			backHandler = function ():void{
				stage.focus = _inputText.textField;
				if (_timeoutIndex != -1){
					clearTimeout(_timeoutIndex);
				}
			}
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			sendMessage(_inputText.text);
			_inputText.text = "";
			if (_timeoutIndex != -1){
				clearTimeout(_timeoutIndex);
			}
			_timeoutIndex = setTimeout(backHandler, 50);
		}
		
		private function sendMessage(message:String):void{
			if (message == "" || StringUtils.checkIsAllSpace(message))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.unableSendNullMsg"));
				return;
			}
			message = WordFilterUtils.filterChatWords(message);
			var facelist:Array = message.match(_facePattern);
			var i:int;
			while (i < facelist.length) 
			{
				if (int(String(facelist[i]).slice(1)) < 73 && int(String(facelist[i]).slice(1)) > 0)
				{
					if (i < 5){
						message = message.replace(facelist[i], (("{F" + String(facelist[i]).slice(1)) + "}"));
					} 
					else {
						message = message.replace(facelist[i], "");
					}
				}
				i++;
			}
		
			if (message.length > 100){
				message = WordFilterUtils.getLenString(message, 100);
			}
//			var self:SelfPlayerInfo = GlobalData.selfPlayer;
//			var info:ChatItemInfo = new ChatItemInfo();
//			info.serverId = self.serverId;
////			info.currentServerId = self.currentServerId;
//			info.type = ChannelType.CLUB;
//			info.vipType = self.vipType;
//			info.fromNick = self.nick;
////			info.fromCamp = self.camp;
//			info.fromId = self.userId;
//			info.fromSex = int(self.sex);
//			info.message = message;
////			GlobalData.chatInfo.appendMessage(info);
//			var clubChatItem:ClubChatItemInfo = new ClubChatItemInfo();
//			clubChatItem.info = info;
//			clubChatItem.time = GlobalData.systemDate.getSystemDate().toLocaleTimeString();
//			GlobalData.clubChatInfo.addItem(clubChatItem);
			ChatSockethandler.sendMessage(ChannelType.CLUB, message);
		}
		
		private function processMessageFormat(item:ClubChatItemInfo):RichTextField{
			return (RichTextUtil.getClubChatRichText(item, 300));
		}
		
		private function addItem(item:ClubChatItemInfo):void{
			var i:int;
			var richItem:RichTextField = processMessageFormat(item);
			_itemList.push(richItem);
			richItem.y = _scrollPanel.getContainer().height + GAP;
			_scrollPanel.getContainer().addChild(richItem);
			_currentHeight = _currentHeight + (richItem.height);
			_scrollPanel.getContainer().height = _currentHeight;
			if (_itemList.length > 30){
				richItem = _itemList.splice(0, 1)[0];
				if (richItem.parent){
					richItem.parent.removeChild(richItem);
				}
				_currentHeight = 0;
				_scrollPanel.getContainer().height = 0;
				i = 0;
				while (i < _itemList.length) {
					_itemList[i].y = _scrollPanel.getContainer().height;
					_currentHeight = (_currentHeight + (_itemList[i].height + GAP));
					_scrollPanel.getContainer().height = _currentHeight;
					i++;
				}
			}
			_scrollPanel.update();
			_scrollPanel.verticalScrollPosition = _scrollPanel.maxVerticalScrollPosition;
		}
		
		public function hide():void{
			if (parent){
				parent.removeChild(this);
			}
		}
		
//		public function update(time:int, dt:Number=0.04):void{
//			_count++;
//			if (_count >= 25){
//				_seconds--;
//				if (_seconds == 0){
//					_seconds = 30;
//					GlobalAPI.tickManager.removeTick(this);
//					_daisBtn.labelField.text = "";
//					_daisBtn.enabled = true;
//				} 
//				else {
//					_daisBtn.labelField.text = _seconds.toString();
//				}
//				_count = 0;
//			}
//		}
		
		override public function dispose():void{
			var i:int;
			removeEvent();
			_mediator = null;
			if (_scrollPanel){
				_scrollPanel.dispose();
				_scrollPanel = null;
			}
			if (_inputText){
				_inputText.dispose();
				_inputText = null;
			}
			if (_itemList){
				i = 0;
				while (i < _itemList.length) {
					_itemList[i].dispose();
					i++;
				}
				_itemList = null;
			}
			if (_faceView){
				_faceView.removeEventListener(CommonModuleEvent.ADD_FACE,addFaceHandler);
				_faceView.dispose();
				_faceView = null;
			}
			if (_sendBtn){
				_sendBtn.dispose();
				_sendBtn = null;
			}
			if (_minBtn){
				_minBtn.dispose();
				_minBtn = null;
			}
			if (_minIconBtn){
				_minIconBtn.dispose();
				_minIconBtn = null;
			}
			if (_faceBtn){
				_faceBtn.dispose();
				_faceBtn = null;
			}
			if (_btns){
				i = 0;
				while (i < _btns.length) {
					_btns[i].dispose();
					i++;
				}
				_btns = null;
			}
			_noticeLabel = null;
			_memberListLabel = null;
			if (_tile){
				_tile.dispose();
				_tile = null;
			}
			
			if (_playerList){
				i = 0;
				while (i < _playerList.length) {
					_playerList[i].removeEventListener(MouseEvent.CLICK, itemClickHandler);
					_playerList[i].dispose();
					i++;
				}
				_playerList = null;
			}
			_checkBox = null;
			_currentItem = null;
			super.dispose();
		}
		
	}
}
