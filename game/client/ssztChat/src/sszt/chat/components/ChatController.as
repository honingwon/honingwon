package sszt.chat.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import sszt.chat.components.sec.ChannelView;
	import sszt.chat.components.sec.MessageTypeView;
	import sszt.chat.data.ChatItemData;
	import sszt.chat.data.ChatPetData;
	import sszt.chat.events.ChatInnerEvent;
	import sszt.chat.mediators.ChatMediator;
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChannelType;
	import sszt.core.data.chat.ChatInfoUpdateEvent;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.chat.MessageType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.vip.VipTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.WordFilterUtils;
	import sszt.core.view.chat.FaceView;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.timerEffect.TimerEffect;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	
	import ssztui.chat.ChatBgAsset;
	import ssztui.chat.FaceBtnAsset;
	
	public class ChatController extends MSprite
	{
		private var _facePattern:RegExp = /\#[0-3][0-9]/g;						//表情
		private var _itemPattern:RegExp = /\[\d{1,3},[^\]]*\]/g;				//物品
		private var _petPattern:RegExp = /\[@[^\]]*,\d{1,3}\]/g;				// 宠物
		private var _mountPattern:RegExp = /\[![^\]]*,\d{1,3}\]/g;				// 坐骑
		
		private var _mediator:ChatMediator;
		private var _bg:Bitmap;
		private var _setSizeBtn:MChatAssetBtn,_sendBtn:MChatAssetBtn,_faceBtn:MBitmapButton,_channelBtn:MChatAssetBtn,_setBtn:MChatAssetBtn;
		private var _worldBtn:MCacheTabBtn1,_cmpBtn:MCacheTabBtn1,_clubBtn:MCacheTabBtn1,_groupBtn:MCacheTabBtn1,_currentBtn:MCacheTabBtn1,_privateBtn:MCacheTabBtn1,_speakerBtn:MCacheTabBtn1,_cityBtn:MCacheTabBtn1;
		private var _btnList:Array;
		private var _btn1List:Array;
		private var _selectedBtn:MCacheTabBtn1;
		private var _selectedChannel:int;
		private var _inputField:TextField;
		private var _speakertip:TextField;
		private var _channelView:ChannelView;
		private var _messageTypeView:MessageTypeView;
		private var _faceView:FaceView;
		private var _recordList:Array;
		private var _recordIndex:int;
		private var _itemList:Array;
		private var _mountsList:Array;
		private var _petList:Array;
		private var _lastSendTime:Array;
		private var _timerEffect:TimerEffect;
		
		private const COOLDOWN:Array = [30000,30000,3000,3000,0,0,0,0];
		private const MAX_RECORD:int = 10;
		private var _timeoutIndex:int = -1;
		private var _currentSize:int = 1;
		
		private var _content:Sprite;
		
		public function ChatController(mediator:ChatMediator)
		{
			_mediator = mediator;
			_selectedChannel = ChannelType.WORLD;
			super();
			initView();
			initEvent();
			
			GlobalData.chatInfo.currentChannel = ChannelType.WORLD;
		}
		
		private function initView():void
		{
//			y = CommonConfig.GAME_HEIGHT - 59;
			_content = new Sprite();
			addChild(_content);
			_bg = new Bitmap(new ChatBgAsset(0,0));
			_bg.x = 2;
			_bg.y = 22;
			_content.addChild(_bg);
			
			//尺寸变换
			_setSizeBtn = new MChatAssetBtn(0);
			_setSizeBtn.move(2,0);
			addChild(_setSizeBtn);
			
			//屏蔽
			_setBtn = new MChatAssetBtn(3);
			_setBtn.move(24,0);
			_content.addChild(_setBtn);
			
			_worldBtn = new MCacheTabBtn1(1,0,LanguageManager.getWord("ssztl.common.world") );
			_worldBtn.move(46,0);
			_content.addChild(_worldBtn);
			_cmpBtn =  new MCacheTabBtn1(1,0,LanguageManager.getWord("ssztl.common.camp"));
			_cmpBtn.move(86,0);
			_content.addChild(_cmpBtn);
			_clubBtn =  new MCacheTabBtn1(1,0,LanguageManager.getWord("ssztl.common.club"));
			_clubBtn.move(126,0);
			_content.addChild(_clubBtn);
			_groupBtn =  new MCacheTabBtn1(1,0,LanguageManager.getWord("ssztl.common.team"));
			_groupBtn.move(166,0);
			_content.addChild(_groupBtn);
			_currentBtn =  new MCacheTabBtn1(1,0,LanguageManager.getWord("ssztl.common.near"));
			_currentBtn.move(206,0);
			_content.addChild(_currentBtn);
			_speakerBtn =  new MCacheTabBtn1(1,0,LanguageManager.getWord("ssztl.common.spark"));
			_speakerBtn.move(246,0);
			_content.addChild(_speakerBtn);
//			_cityBtn =  new MCacheTabBtn1(1,0,LanguageManager.getWord("ssztl.cityCraft.chatCity"));
//			_cityBtn.move(286,0);
//			_content.addChild(_cityBtn);
			_btnList = [_worldBtn,_cmpBtn,_clubBtn,_groupBtn,_currentBtn,_speakerBtn];//,_cityBtn
			
			_sendBtn = new MChatAssetBtn(2);
			_sendBtn.move(246,25);
			_content.addChild(_sendBtn);
			
			_faceBtn = new MBitmapButton(new FaceBtnAsset() as BitmapData);
			_faceBtn.move(220,31);
			_content.addChild(_faceBtn);
			
			_channelBtn = new MChatAssetBtn(1,ChannelType.getChannelName(_selectedChannel));
			_channelBtn.move(5,25);
			_content.addChild(_channelBtn);
			_channelBtn.labelField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xfffccc);
			
			
			_btn1List = [_setSizeBtn,_faceBtn,_setBtn];
			
			_speakertip = new TextField();
			_speakertip.width = 170;
			_speakertip.height = 18;
			_speakertip.x = 48;
			_speakertip.y = 31;
//			_speakertip.wordWrap = true;
			_speakertip.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x70715e);
			_speakertip.text = LanguageManager.getWord("ssztl.chat.costOneSpeaker");
			_speakertip.mouseEnabled = false;
			_content.addChild(_speakertip);
			_speakertip.visible = false;
			
			_inputField = new TextField();
			_inputField.width = 170;
			_inputField.height = 18;
			_inputField.x = 48;
			_inputField.y = 31;
//			_inputField.wordWrap = true;
			_inputField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff);
			_inputField.type = TextFieldType.INPUT;
			_content.addChild(_inputField);
			
			_lastSendTime = [0,0,0,0,0,0,0];
			_timerEffect = new TimerEffect(30000,new Rectangle(_sendBtn.x,_sendBtn.y,37,29),1);
			_content.addChild(_timerEffect);
			
			_recordList = [];
			_recordIndex = _recordList.length;
			
			_itemList = [];
			_petList = [];
			_mountsList = [];
			
			gameSizeChangeHandler(null);
		}
		
		private function initEvent():void
		{
			_sendBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_channelBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			var i:int = 0;
			
			for(i=0; i < _btnList.length; i++)
			{
				_btnList[i].addEventListener(MouseEvent.CLICK,channelBtnClickHandler);
			}
			for(i=0; i < _btn1List.length; i++)
			{
				_btn1List[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
				_btn1List[i].addEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
				_btn1List[i].addEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			}
			
			GlobalData.chatInfo.addEventListener(ChatInfoUpdateEvent.CHANNEL_CHANGE,channelChangeHandler);
			this.addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			_inputField.addEventListener(Event.CHANGE,inputChangeHandler);
			_inputField.addEventListener(FocusEvent.FOCUS_IN,focusInHandler);
			_inputField.addEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			_sendBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_channelBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			
			var i:int = 0;
			
			for(i=0; i < _btnList.length; i++)
			{
				_btnList[i].removeEventListener(MouseEvent.CLICK,channelBtnClickHandler);
			}
			for(i=0; i < _btn1List.length; i++)
			{
				_btn1List[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
				_btn1List[i].removeEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
				_btn1List[i].removeEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			}
			
			
			GlobalData.chatInfo.removeEventListener(ChatInfoUpdateEvent.CHANNEL_CHANGE,channelChangeHandler);
			this.removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			if(stage)
			{
				stage.removeEventListener(KeyboardEvent.KEY_UP,inputKeyupHandler);
			}
			_inputField.removeEventListener(Event.CHANGE,inputChangeHandler);
			_inputField.removeEventListener(FocusEvent.FOCUS_IN,focusInHandler);
			_inputField.removeEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function addedToStageHandler(e:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_UP,inputKeyupHandler);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			switch(e.currentTarget)
			{
				case _faceBtn:
					e.stopImmediatePropagation();
					showFaceView();
					break;
				case _channelBtn:
					e.stopImmediatePropagation();
					showChannelView();
					break;
				case _sendBtn:
					sendMessage();
					break;
				case _setSizeBtn:
					e.stopImmediatePropagation();
					//_mediator.setPanelSize();
					setChatSize();
					break;
				case _setBtn:
					e.stopImmediatePropagation();
					showMessageTypeView();
					break;
			}
		}
		
		private function btnOverHandler(e:MouseEvent):void
		{
			var str:String;
			switch(e.currentTarget)
			{
				case _setSizeBtn:
					str = LanguageManager.getWord("ssztl.chat.changeChatPanelSize");
					break;
				case _faceBtn:
					str = LanguageManager.getWord("ssztl.chat.showFacePanel");
					break;
				case _setBtn:
					str = LanguageManager.getWord("ssztl.chat.channelSelect");
					break;
				
				
			}
			TipsUtil.getInstance().show(str,null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		
		private function btnOutHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			var _m:int = CommonConfig.GAME_WIDTH >1250?0:60;
			y = CommonConfig.GAME_HEIGHT - 59 - _m;
			if(_messageTypeView)_messageTypeView.move(_setBtn.x, this.y - _messageTypeView.height);
			if(_channelView)_channelView.move(2,this.y - _channelView.height + 22);
			if(_faceView)_faceView.move(_faceBtn.x-5,this.y -_faceView.height + 25 );
		}
		
		private function faceAddHandler(e:CommonModuleEvent):void
		{
			var index:int = e.data as int;
			var mes:String = index < 10 ? "0" + index : String(index);
			_inputField.appendText("#" + mes);
			
			_timeoutIndex = setTimeout(doSetFocus,100);
			function doSetFocus():void
			{
				if(stage)
				{
					stage.focus = _inputField;
					_inputField.setSelection(_inputField.text.length,_inputField.text.length);
				}
				if(_timeoutIndex != -1)
				{
					clearTimeout(_timeoutIndex);
				}
			}
		}
		
		private function channelBtnClickHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			if(_messageTypeView && _messageTypeView.parent)_messageTypeView.hide();
			GlobalData.chatInfo.currentChannel = _btnList.indexOf(MCacheTabBtn1(e.currentTarget)) + 1;
//			if(_selectedChannel == ChannelType.PRIVATE)
//				_mediator.showPrivatePanel();
		}
		
		private function channelChangeHandler(e:ChatInfoUpdateEvent):void
		{
			_selectedChannel = GlobalData.chatInfo.currentChannel;
			if(_selectedBtn)_selectedBtn.selected = false;
			_selectedBtn = _btnList[_selectedChannel - 1];
			_selectedBtn.selected = true;
			_channelBtn.labelField.text = ChannelType.getChannelName(_selectedChannel);
//			_channelField.text = ChannelType.getChannelName(_selectedChannel);
			if(_selectedChannel == ChannelType.SPEAKER)
			{
				if(_inputField.text.length == 0 && stage && stage.focus != _inputField)
				{
					_speakertip.visible = true;
				}
			}
			else
			{
				if(_speakertip.visible == true)_speakertip.visible = false;
			}
			
			if(COOLDOWN[_selectedChannel - 1] - (getTimer() - _lastSendTime[_selectedChannel - 1]) > 0 && _lastSendTime[_selectedChannel - 1] != 0)
			{
				_timerEffect.setTime(COOLDOWN[_selectedChannel - 1] - (getTimer() - _lastSendTime[_selectedChannel - 1]));
				_timerEffect.begin();
			}
			else
			{
				_timerEffect.setTime(0);
			}
		}
		
		private function inputChangeHandler(e:Event):void
		{
			var lenght:int;
			if(_selectedChannel == ChannelType.SPEAKER)lenght = 60;
			else lenght = 100;
			if(WordFilterUtils.checkLen(_inputField.text) >= lenght)
				_inputField.text = WordFilterUtils.getLenString(_inputField.text,lenght);
		}
		
		private function focusInHandler(e:FocusEvent):void
		{
			if(_selectedChannel == ChannelType.SPEAKER)_speakertip.visible = false;
		}
		
		private function focusOutHandler(e:FocusEvent):void
		{
			if(_selectedChannel == ChannelType.SPEAKER)
			{
				if(_inputField.text.length == 0)
				{
					_speakertip.visible = true;
				}
			}
		}
		
		private function showFaceView():void
		{
			if(_faceView == null)
			{
				_faceView = new FaceView();
				_faceView.move(_faceBtn.x-5,this.y -_faceView.height + 25 );//CommonConfig.GAME_HEIGHT - 158);
				_faceView.addEventListener(CommonModuleEvent.ADD_FACE,faceAddHandler);
			}
			if(_faceView && _faceView.parent)_faceView.hide();
			else _faceView.show();
			if(_channelView && _channelView.parent)_channelView.hide();
			if(_messageTypeView && _messageTypeView.parent)_messageTypeView.hide();
		}
		
		private function showChannelView():void
		{
			if(_channelView == null)
			{
				_channelView = new ChannelView(_mediator);
				_channelView.addEventListener(ChatInnerEvent.CHANNEL_CHANGE,changeChannelHandler);
				_channelView.move(2,this.y - _channelView.height + 22); //CommonConfig.GAME_HEIGHT - 165);
			}
			if(_channelView && _channelView.parent)_channelView.hide();
			else _channelView.show();
			if(_faceView && _faceView.parent)_faceView.hide();
			if(_messageTypeView && _messageTypeView.parent)_messageTypeView.hide();
		}
		
		private function showMessageTypeView():void
		{
			if(_messageTypeView == null)
			{
				_messageTypeView = new MessageTypeView();
			}
//			if(_btnList.indexOf(_selectedBtn) == 0)_messageTypeView.move(4,CommonConfig.GAME_HEIGHT - 133);
//			else _messageTypeView.move(4,CommonConfig.GAME_HEIGHT - 60);
			
			if(_messageTypeView && _messageTypeView.parent)
			{
				_messageTypeView.hide();
			}
			else
			{
				if(_btnList.indexOf(_selectedBtn) == 0)_messageTypeView.show(1);
				else _messageTypeView.show(2);
			}
			
			_messageTypeView.move(_setBtn.x, this.y - _messageTypeView.height);
			if(_channelView && _channelView.parent)_channelView.hide();
			if(_faceView && _faceView.parent)_faceView.hide();
		}
		
		private function changeChannelHandler(e:ChatInnerEvent):void
		{
			_selectedChannel = e.data as int;
			_channelBtn.labelField.text = ChannelType.getChannelName(_selectedChannel);
			
			if(_selectedChannel == ChannelType.SPEAKER)
			{
				if(_inputField.text.length == 0 && stage && stage.focus != _inputField)
				{
					_speakertip.visible = true;
				}
			}
			else
			{
				if(_speakertip.visible == true)_speakertip.visible = false;
			}
			
			if(COOLDOWN[_selectedChannel - 1] - (getTimer() - _lastSendTime[_selectedChannel - 1]) > 0 && _lastSendTime[_selectedChannel - 1] != 0)
			{
				_timerEffect.setTime(COOLDOWN[_selectedChannel - 1] - (getTimer() - _lastSendTime[_selectedChannel - 1]));
				_timerEffect.begin();
			}
			else
			{
				_timerEffect.setTime(0);
			}
		}
		
		private function updatePanelVisible(value:Boolean):void
		{
			_content.visible = value;
			_mediator.updatePanelVisible(value);
		}
		private function setChatSize():void
		{
			if(_currentSize == 2)
			{
				_content.visible = false;
				_mediator.updatePanelVisible(false);
				_currentSize = 0;
			}
			else if(_currentSize == 1)
			{
				_mediator.setPanelSize(true);
				_currentSize = 2;
			}
			else if(_currentSize == 0)
			{
				_content.visible = true;
				_mediator.updatePanelVisible(true);
				_mediator.setPanelSize(false);
				_currentSize = 1;
			}
		}
		
		private function sendMessage():void
		{
			if(GlobalData.selfPlayer.level < 20 && _selectedChannel == ChannelType.WORLD)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.common.speakLimit'));
				return;
			}
			var info:ChatItemInfo;
			if(_inputField.text == "")return;
			var mes:String = _inputField.text;
			
			mes = WordFilterUtils.filterChatWords(mes);
			var toNick:String = "";
			if(mes.charAt(0) == "/" && mes.indexOf(" ") > -1)
			{
				toNick = mes.slice(1,mes.indexOf(" "));
				mes = mes.slice(mes.indexOf(" ")+1,mes.length);
			}
			if(mes == "")
			{
				if(toNick == "")
					_inputField.text = "";
				else 
					_inputField.text = "/" + toNick + " ";
				_inputField.setSelection(_inputField.text.length,_inputField.text.length);
				return;
			}
			if(_selectedChannel == ChannelType.SPEAKER)
				mes = WordFilterUtils.getLenString(mes,60);
			else
				mes = WordFilterUtils.getLenString(mes,100);
			var facelist:Array = mes.match(_facePattern);
			for(var i:int = 0; i < facelist.length; i++)
			{
				if(int(String(facelist[i]).slice(1)) < 37 && int(String(facelist[i]).slice(1)) > 0)
				{
					if(i < 5)mes = mes.replace(facelist[i],"{F" + String(facelist[i]).slice(1) + "}");
					else mes = mes.replace(facelist[i],"");
				}
			}
			var list:Array = mes.match(_itemPattern);
			for(var j:int = 0; j < list.length; j++)
			{
				var parms:Array = String(list[j].slice(1,list[j].length-1)).split(",");
				if((parms[0] < _itemList.length) && (_itemList[parms[0]] != null) && (_itemList[parms[0]].name == parms[1]))
				{
					mes = mes.replace(list[j],"{I" + GlobalData.selfPlayer.userId + "-" + _itemList[parms[0]].itemId + "-" + _itemList[parms[0]].templateId + "-" + _itemList[parms[0]].strengthenLevel + "}");
				}
				else
				{
					mes = mes.replace(list[j],parms[1]);
				}
			}
			
			var petlist:Array = mes.match(_petPattern);
			for(i = 0;i < petlist.length;i++)
			{
				parms = String(petlist[i].slice(2,petlist[i].length - 1)).split(",");
				if((parms[1] < _petList.length) && (_petList[parms[1]] != null) && (_petList[parms[1]].nick == parms[0]))
				{
					mes = mes.replace(petlist[i],"{P" + GlobalData.selfPlayer.userId + "-" + _petList[parms[1]].id + "-" + _petList[parms[1]].templateId + "-" + _petList[parms[1]].nick + "}");
				}else
				{
					mes = mes.replace(petlist[i],parms[0]);
				}
			}
//			['[!xxxx, 0]' , '[!xxxx, 0]']
			
			var mountlist:Array = mes.match(_mountPattern);
			for(i = 0;i < mountlist.length;i++)
			{
				//[xxxxx, 0]
				parms = String(mountlist[i].slice(2,mountlist[i].length - 1)).split(",");
				if((parms[1] < _mountsList.length) && (_mountsList[parms[1]] != null) && (_mountsList[parms[1]].nick == parms[0]))
				{
					mes = mes.replace(mountlist[i], "{M" + GlobalData.selfPlayer.userId + "-" + _mountsList[parms[1]].id + "-" + _mountsList[parms[1]].templateId + "-" + _mountsList[parms[1]].nick + "}");
				}else
				{
					mes = mes.replace(mountlist[i],parms[0]);
				}
			}
			
			if(toNick == "" && _lastSendTime[_selectedChannel - 1] != 0 && (getTimer() - _lastSendTime[_selectedChannel - 1] < COOLDOWN[_selectedChannel - 1]))
			{
				info = new ChatItemInfo();
				info.type = MessageType.SYSTEM;
				info.message = LanguageManager.getWord("ssztl.chat.speakTooQuick",Math.ceil((COOLDOWN[_selectedChannel - 1] - (getTimer() - _lastSendTime[_selectedChannel - 1])) / 1000));
				GlobalData.chatInfo.appendMessage(info);
				return;
			}
			
			if(toNick == "")
			{
				if(_selectedChannel == ChannelType.WORLD)
				{
//					if(GlobalData.selfPlayer.level < 1)
//					{
//						info = new ChatItemInfo();
//						info.type = MessageType.SYSTEM;
//						info.message = LanguageManager.getWord("ssztl.chat.needFifteenLevel");
//						GlobalData.chatInfo.appendMessage(info);
//						return;
//					}
				}
				else if(_selectedChannel == ChannelType.CLUB && GlobalData.selfPlayer.clubId == 0)
				{
					info = new ChatItemInfo();
					info.type = MessageType.SYSTEM;

					info.message = LanguageManager.getWord("ssztl.chat.noClub");

					GlobalData.chatInfo.appendMessage(info);
					return;
				}
//				else if(_selectedChannel == ChannelType.CMP && GlobalData.selfPlayer.camp == 0)
//				{
//					info = new ChatItemInfo();
//					info.type = MessageType.SYSTEM;
//					info.message = LanguageManager.getWord("ssztl.chat.noCamp");
//					GlobalData.chatInfo.appendMessage(info);
//					return;
//				}
				else if(_selectedChannel == ChannelType.GROUP && GlobalData.leaderId == 0)
				{
					info = new ChatItemInfo();
					info.type = MessageType.SYSTEM;
					info.message = LanguageManager.getWord("ssztl.chat.noTeam");
					GlobalData.chatInfo.appendMessage(info);
					return;
				}
				var freeVipSpeakerCount:int;
				freeVipSpeakerCount = GlobalData.selfPlayer.bugle;
				if(_selectedChannel == ChannelType.SPEAKER && (GlobalData.bagInfo.getItemCountById(CategoryType.SPEAKER_ID) + freeVipSpeakerCount) < 1)
				{
					MAlert.show(LanguageManager.getWord("ssztl.chat.speakerNotEnough"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,speakerCloseHandler);
					return;
				}
			}
			
			var time:int = 0;
			if(toNick != "")
			{
				if(toNick != GlobalData.selfPlayer.nick)
				{
					_mediator.sendMessage(ChannelType.PRIVATE,mes,toNick);
					_lastSendTime[ChannelType.PRIVATE - 1] = getTimer();
					time = COOLDOWN[ChannelType.PRIVATE - 1];
				}
				else
				{
					_mediator.sendMessage(ChannelType.CURRENT,mes,"");
					_lastSendTime[ChannelType.CURRENT - 1] = getTimer();
					time = COOLDOWN[ChannelType.CURRENT - 1];
				}
			}
			else if(_selectedChannel == ChannelType.PRIVATE)
			{
				_mediator.sendMessage(ChannelType.CURRENT,mes,toNick);
				_lastSendTime[ChannelType.CURRENT - 1] = getTimer();
				time = COOLDOWN[ChannelType.CURRENT - 1];
			}
			else
			{
				_mediator.sendMessage(_selectedChannel,mes,toNick);
				_lastSendTime[_selectedChannel - 1] = getTimer();
				time = COOLDOWN[_selectedChannel - 1];
			}
			_timerEffect.setTime(time);
			if(time != 0)_timerEffect.begin();
			
			_recordList.push(_inputField.text);
			if(_recordList.length > MAX_RECORD)_recordList.shift();
			_recordIndex = _recordList.length;
			if(toNick == "")
				_inputField.text = "";
			else
				_inputField.text = "/" + toNick + " ";
			_inputField.setSelection(_inputField.text.length,_inputField.text.length);
		}
		
		private function speakerCloseHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				BuyPanel.getInstance().show([CategoryType.SPEAKER_ID],new ToStoreData(ShopID.QUICK_BUY));
			}
		}
		
		private function inputKeyupHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ENTER)
			{
				if(stage && stage.focus != _inputField && !(stage.focus is TextField))
				{
					stage.focus = _inputField;
					if(_speakertip.visible == true)_speakertip.visible = false;
				}
				else if(stage && stage.focus == _inputField)
				{
					if(_inputField.text != "")sendMessage();
					else 
					{
//						stage.focus = null;
						if(_selectedChannel == ChannelType.SPEAKER)_speakertip.visible = true;
					}
				}
			}
			else if(e.keyCode == Keyboard.UP)
			{
				if(stage && stage.focus == _inputField)
				{
					if(_recordList.length == 0)return;
					_recordIndex--;
					if(_recordIndex < 0)_recordIndex = _recordList.length - 1;
					if(_recordList[_recordIndex])_inputField.text = _recordList[_recordIndex];
					_inputField.setSelection(_inputField.text.length,_inputField.text.length);
				}
			}
			else if(e.keyCode == Keyboard.DOWN)
			{
				if(stage && stage.focus == _inputField)
				{
					if(_recordList.length == 0)return;
					_recordIndex++;
					if(_recordIndex > _recordList.length - 1)_recordIndex = 0;
					if(_recordList[_recordIndex])_inputField.text = _recordList[_recordIndex];
					_inputField.setSelection(_inputField.text.length,_inputField.text.length);
				}
			}
		}
		
		public function addItemToField(item:ItemInfo):void
		{
			if(!item)return;
			var itemData:ChatItemData;
			var p:Boolean = true;
			for each(var data:ChatItemData in _itemList)
			{
				if(data && data.itemId == item.itemId && data.strengthenLevel == item.strengthenLevel)
				{
					itemData = data;
					p = false;
				}
			}
			if(p)
			{
				itemData = new ChatItemData();
				itemData.itemId = item.itemId;
				itemData.templateId = item.templateId;
				itemData.name = item.template.name;
				itemData.strengthenLevel = item.strengthenLevel;
				_itemList.push(itemData);
			}
			_inputField.appendText("[" + _itemList.indexOf(itemData) + "," + itemData.name + "]");
			
			if(stage)
			{
				stage.focus = _inputField;
				_inputField.setSelection(_inputField.text.length,_inputField.text.length);
			}
		}
		
		public function addMountToField(mountInfo:MountsItemInfo):void
		{
			if(!mountInfo)return;
			var isExist:Boolean = false;
			for each(var mountInfoItem:MountsItemInfo in _mountsList)
			{
				if(mountInfo.id == mountInfoItem.id)
				{
					isExist = true;
					break;
				}
			}
			if(!isExist)
			{
				_mountsList.push(mountInfo);
			}
			_inputField.appendText("[!" + mountInfo.nick + "," + _mountsList.indexOf(mountInfo) + "]");
			
			if(stage)
			{
				stage.focus = _inputField;
				_inputField.setSelection(_inputField.text.length,_inputField.text.length);
			}
		}
		
		public function addPetToField(petInfo:PetItemInfo):void
		{
			if(!petInfo)return;
			var isExist:Boolean = false;
			for each(var petItemInfo:PetItemInfo in _petList)
			{
				if(petInfo.id == petItemInfo.id)
				{
					isExist = true;
					break;
				}
			}
			if(!isExist)
			{
				_petList.push(petInfo);
			}
			_inputField.appendText("[@" + petInfo.nick + "," + _petList.indexOf(petInfo) + "]");
			
			if(stage)
			{
				stage.focus = _inputField;
				_inputField.setSelection(_inputField.text.length,_inputField.text.length);
			}
		}
		
		public function setToNick(nick:String):void
		{
			_inputField.text = "/" + nick + " ";
		}
		
//		private function doEnd():void
//		{
//			_mediator.doEnd();
//		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			if(_channelView)
			{
				_channelView.removeEventListener(ChatInnerEvent.CHANNEL_CHANGE,changeChannelHandler);
				_channelView.dispose();
				_channelView = null;
			}
			if(_timeoutIndex != -1)
			{
				clearTimeout(_timeoutIndex);
			}
			if(_bg)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			
			var i:int = 0;
			
			
			if(_sendBtn)
			{
				_sendBtn.dispose();
				_sendBtn = null;
			}
			if(_channelBtn)
			{
				_channelBtn.dispose();
				_channelBtn = null;
			}
		
			if(_timerEffect)
			{
				_timerEffect.dispose();
				_timerEffect = null;
			}
			
			
			if(_faceView)
			{
				_faceView.removeEventListener(CommonModuleEvent.ADD_FACE,faceAddHandler);
				_faceView.dispose();
				_faceView = null;
			}
			if(_messageTypeView)
			{
				_messageTypeView.dispose();
				_messageTypeView = null;
			}
			if(_btnList)
			{
				for(i = 0; i < _btnList.length; i++)
				{
					_btnList[i].dispose();
					_btnList[i] = null;
				}
			}
			if(_btn1List)
			{
				for(i = 0; i < _btnList.length; i++)
				{
					_btn1List[i].dispose();
					_btn1List[i] = null;
				}
			}
			_btnList = null;
			_inputField = null;
			_speakertip = null;
			_itemList = null;
			_mountsList = null;
			_recordList = null;
			_lastSendTime = null;
			_petList = null;
			_mediator = null;
			_content = null;
		}
	}
}