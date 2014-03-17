package sszt.friends.component
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import fl.containers.ScrollPane;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.CareerType;
	import sszt.constData.CommonConfig;
	import sszt.core.caches.PlayerIconCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.KeyType;
	import sszt.core.data.chat.ChannelType;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.im.FriendEvent;
	import sszt.core.data.im.ImMessage;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.data.richTextField.RichTextFormatInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.chat.ChatSockethandler;
	import sszt.core.socketHandlers.im.FriendUpdateSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.utils.WordFilterUtils;
	import sszt.core.view.FlashIcon;
	import sszt.core.view.chat.FaceView;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.richTextField.RichTextField;
	import sszt.core.view.tips.PlayerTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.friends.mediator.FriendsMediator;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTextArea;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.friends.ChatBtnAddAsset;
	import ssztui.friends.ChatBtnFlowerAsset;
	import ssztui.friends.ChatBtnMinAsset;
	import ssztui.friends.ChatBtnTeamAsset;
	import ssztui.friends.ChatBtnViewAsset;
	import ssztui.friends.ChatInputBgAsset;
	import ssztui.friends.ChatTitleAsset;
	import ssztui.friends.FaceAsset;
	import ssztui.ui.BtnAssetClose;
	
	public class ChatPanel extends MPanel
	{
		private var _mediator:FriendsMediator;
		private var _bg:IMovieWrapper;
		private var _minBtn:MAssetButton1;
		
		private var _addBtn:MAssetButton1;
		private var _inviteToTeamBtn:MAssetButton1;
		private var _checkInfoBtn:MAssetButton1;
		private var _flowerBtn:MAssetButton1;
		
		private var _clearBtn:MCacheAsset1Btn;
		private var _sendBtn:MCacheAssetBtn1;
		private var _deliverBtn:MBitmapButton;
		private var _faceBtn:MBitmapButton;
		
		private var _inputText:MTextArea;
		private var _player:ImPlayerInfo;
		
		private var _playerName:MAssetLabel;
		
		private var _myselfName:MAssetLabel;
		private var _myselfInfo:MAssetLabel;

		private var _autoReply:Boolean;
		private var _replyContext:String;
		private var _lastItem:ImMessage;
		
		private var _faceView:FaceView;
		private var _scrollPanel:MScrollPanel;
//		private var _itemList:Vector.<RichTextField>;
		private var _itemList:Array;
		private static const GAP:int = 0;
		private var _currentHeight:int = 0;
		private var _timeoutIndex:int = -1;
		
		private var _facePattern:RegExp = /\#[0-4][0-9]/g;						//表情
		
		public static const WIDTH:int = 322;
		public static const HEIGHT:int = 385;
		
		public function ChatPanel(mediator:FriendsMediator,player:ImPlayerInfo)
		{
			_mediator = mediator;
			_player = player;
			_autoReply = _mediator.friendsModule.autoReply;
			_replyContext =_mediator.friendsModule.replyContext;
			
			super(new Bitmap(new ChatTitleAsset()), true, -1);
			initEvent();
		}
		
		public function set auto(flag:Boolean):void
		{
			_autoReply = flag;
		}
		
		public function set replyContext(str:String):void
		{
			_replyContext = str;
		}
		
		public function set info(item:ImPlayerInfo):void
		{
			_player = item;
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(382,355);
			
			_bg = BackgroundUtils.setBackground([				
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(10, 2, 362, 43)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(10, 46, 362, 213)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(10, 261, 362, 48)),
				new BackgroundInfo(BackgroundType.BAR_1, new Rectangle(13, 5, 356, 37)),
				]);
			addContent(_bg as DisplayObject);
			
			addContent(
				MBackgroundLabel.getDisplayObject(
					new Rectangle(15,324,226,16),
					new MAssetLabel(LanguageManager.getWord("ssztl.friends.sendMsgPrompt"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)
				)
			);
			
			_minBtn = new MAssetButton1(new ChatBtnMinAsset());
			_minBtn.move(331,-24);
			addContent(_minBtn);
			
			_scrollPanel = new MScrollPanel();
			_scrollPanel.setSize(350,210);
			_scrollPanel.move(20,48);
			addContent(_scrollPanel);
			
			_inputText = new MTextArea();
			_inputText.textField.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,1);
			_inputText.setSize(356, 40);
			_inputText.move(20, 266);
			_inputText.editable = true;
			_inputText.enabled = true;
			addContent(_inputText);
			
			_sendBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.common.send'));
			_sendBtn.move(294, 317);
			addContent(_sendBtn);	
			
			//添加好友	LanguageManager.getWord('ssztl.friends.addFriend')
			_addBtn = new MAssetButton1(new ChatBtnAddAsset());
			_addBtn.move(275, 10);
			addContent(_addBtn);
			
			//邀请组队	LanguageManager.getWord('ssztl.scene.inviteTeam2')
			_inviteToTeamBtn = new MAssetButton1(new ChatBtnTeamAsset());
			_inviteToTeamBtn.move(305, 10);
			addContent(_inviteToTeamBtn);
			
			//查看资料	LanguageManager.getWord('ssztl.common.checkInfo')
			_checkInfoBtn = new MAssetButton1(new ChatBtnViewAsset());
			_checkInfoBtn.move(335, 10);
			addContent(_checkInfoBtn);
			
			//赠送鲜花
			_flowerBtn = new MAssetButton1(new ChatBtnFlowerAsset());
			_flowerBtn.move(183, 10);
//			addContent(_flowerBtn);
			
//			if(_player.isFriend){
//				_addBtn.visible = false;
//				_inviteToTeamBtn.move(93,40);
//				_checkInfoBtn.move(123,40);
//				_flowerBtn.move(153, 40);
//			}
			
			//表情
			_faceBtn = new MBitmapButton(new FaceAsset());
			_faceBtn.move(264,320);
			addContent(_faceBtn);
			
			//清屏
			_clearBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.common.cleanScreen"));
			_clearBtn.move(0,0);
			addContent(_clearBtn);
			_clearBtn.visible = false;
			
			_playerName = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_playerName.move(26, 17);
			addContent(_playerName);
			
			_playerName.setHtmlValue(LanguageManager.getWord("ssztl.common.talkSb", "<font color='#ffcc00'>" + _player.info.nick + "</font>"));
//				LanguageManager.getWord('ssztl.common.levelValue', _player.info.level>0?_player.info.level:"?") + " " + 
//				CareerType.getNameByCareer(_player.career)
			
			_myselfName = new MAssetLabel("",MAssetLabel.LABEL_TYPE21);
			_myselfName.move(363, 190);
			_myselfName.setValue(GlobalData.selfPlayer.nick);
//			addContent(_myselfName);
			
			_myselfInfo = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG);
			_myselfInfo.move(363, 208);
			_myselfInfo.setValue(
				CareerType.getNameByCareer(GlobalData.selfPlayer.career) + ' ' + 
				LanguageManager.getWord('ssztl.common.levelValue', GlobalData.selfPlayer.level)
			);
//			addContent(_myselfInfo);
			
//			_itemList = new Vector.<RichTextField>();
			_itemList = new Array();
			
			initData();
		}
		
		private function initEvent():void
		{
			_inviteToTeamBtn.addEventListener(MouseEvent.CLICK, inviteToTeamBtnClickHander);
			_checkInfoBtn.addEventListener(MouseEvent.CLICK, checkInfoBtnClickHander);
			_clearBtn.addEventListener(MouseEvent.CLICK,clearBtnClickHandler);
			_sendBtn.addEventListener(MouseEvent.CLICK,sendBtnClickHandler);
			_player.addEventListener(FriendEvent.CHATINFO_UPDATE,infoUpdateHandler);
			GlobalData.imPlayList.addEventListener(FriendEvent.DELETE_CHATPANEL,disposeHandler);
			_addBtn.addEventListener(MouseEvent.CLICK,addClickHandler);
//			_deliverBtn.addEventListener(MouseEvent.CLICK,deliverClickHandler);
			_minBtn.addEventListener(MouseEvent.CLICK,minBtnClickHandler);
			_faceBtn.addEventListener(MouseEvent.CLICK,faceBtnClickHandler);
//			this.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler); 
			_mediator.friendsModule.addEventListener(FriendEvent.SET_CHANGE,setChangeHandler);
			GlobalAPI.keyboardApi.getKeyListener().addEventListener(KeyboardEvent.KEY_DOWN,keyIsDownHandler);
			GlobalData.imPlayList.addEventListener(FriendEvent.CHAT_PLAYER_CHANGE,changeHandler);
			
			_addBtn.addEventListener(MouseEvent.MOUSE_OVER,btnOverHander);
			_addBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOutHander);
			_inviteToTeamBtn.addEventListener(MouseEvent.MOUSE_OVER,btnOverHander);
			_inviteToTeamBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOutHander);
			_checkInfoBtn.addEventListener(MouseEvent.MOUSE_OVER,btnOverHander);
			_checkInfoBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOutHander);
			_flowerBtn.addEventListener(MouseEvent.MOUSE_OVER,btnOverHander);
			_flowerBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOutHander);
		}	
		
		private function removeEvent():void
		{
			_inviteToTeamBtn.removeEventListener(MouseEvent.CLICK, inviteToTeamBtnClickHander);
			_checkInfoBtn.removeEventListener(MouseEvent.CLICK, checkInfoBtnClickHander);
			_clearBtn.removeEventListener(MouseEvent.CLICK,clearBtnClickHandler);
			_sendBtn.removeEventListener(MouseEvent.CLICK,sendBtnClickHandler);
			_player.removeEventListener(FriendEvent.CHATINFO_UPDATE,infoUpdateHandler);
			GlobalData.imPlayList.removeEventListener(FriendEvent.DELETE_CHATPANEL,disposeHandler);
			_addBtn.removeEventListener(MouseEvent.CLICK,addClickHandler);
			_minBtn.removeEventListener(MouseEvent.CLICK,minBtnClickHandler);
			_faceBtn.removeEventListener(MouseEvent.CLICK,faceBtnClickHandler);
//			this.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			_mediator.friendsModule.removeEventListener(FriendEvent.SET_CHANGE,setChangeHandler);
			GlobalAPI.keyboardApi.getKeyListener().removeEventListener(KeyboardEvent.KEY_DOWN,keyIsDownHandler);
			GlobalData.imPlayList.removeEventListener(FriendEvent.CHAT_PLAYER_CHANGE,changeHandler);
			
			_addBtn.removeEventListener(MouseEvent.MOUSE_OVER,btnOverHander);
			_addBtn.removeEventListener(MouseEvent.MOUSE_OUT,btnOutHander);
			_inviteToTeamBtn.removeEventListener(MouseEvent.MOUSE_OVER,btnOverHander);
			_inviteToTeamBtn.removeEventListener(MouseEvent.MOUSE_OUT,btnOutHander);
			_checkInfoBtn.removeEventListener(MouseEvent.MOUSE_OVER,btnOverHander);
			_checkInfoBtn.removeEventListener(MouseEvent.MOUSE_OUT,btnOutHander);
			_flowerBtn.removeEventListener(MouseEvent.MOUSE_OVER,btnOverHander);
			_flowerBtn.removeEventListener(MouseEvent.MOUSE_OUT,btnOutHander);
		}
		private function btnOverHander(e:MouseEvent):void
		{
			var str:String = "";
			switch(e.target)
			{
				case _addBtn:
					str = LanguageManager.getWord('ssztl.friends.addFriend');
					break;
				case _inviteToTeamBtn:
					str = LanguageManager.getWord('ssztl.scene.inviteTeam2');
					break;
				case _checkInfoBtn:
					str = LanguageManager.getWord('ssztl.common.checkInfo');
					break;
				case _flowerBtn:
					str = "";
					break;
			}
			if(str != "")
				TipsUtil.getInstance().show(str,null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		private function btnOutHander(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function checkInfoBtnClickHander(event:MouseEvent):void
		{
			SetModuleUtils.addRole(_player.info.userId);
		}
		
		private function inviteToTeamBtnClickHander(event:MouseEvent):void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TEAM_ACTION,{
				type:0,
				id:_player.info.userId,
				nick:_player.info.nick,
				serverId:_player.info.serverId
			}));
		}
		
		private function changeHandler(evt:FriendEvent):void
		{
			var item:ImPlayerInfo = evt.data as ImPlayerInfo;
			if(_player)
			{
				_player.removeEventListener(FriendEvent.CHATINFO_UPDATE,infoUpdateHandler);
			}	
			_player = item;
			_player.addEventListener(FriendEvent.CHATINFO_UPDATE,infoUpdateHandler);
		}
		
		private function disposeHandler(evt:FriendEvent):void
		{
			dispose();
		}
		
		private function initData():void
		{
//			var list:Vector.<ImMessage> = _player.records;
			addPromt();
			var list:Array = _player.records;
			for(var i:int = 0;i < list.length;i++)
			{
				addItem(list[i]);
				_lastItem = list[i];
			}
		}
		
		private function addPromt():void
		{
			var formatList:Array = [];
			var deployList:Array = [];
			var message:String = LanguageManager.getWord("ssztl.friends.chatRemind");
			var formatInfo:RichTextFormatInfo = new RichTextFormatInfo();
			formatInfo.index = 0;
			formatInfo.length = message.length;
			formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
			formatList.push(formatInfo);
			var textResult:RichTextField = new RichTextField(325,true);
			textResult.appendMessage(message,deployList,formatList);
			_itemList.push(textResult);
			textResult.y = _scrollPanel.getContainer().height+10;
			_scrollPanel.getContainer().addChild(textResult);
			_currentHeight += textResult.height + GAP;
			_scrollPanel.getContainer().height = _currentHeight;
			_scrollPanel.update();
			_scrollPanel.verticalScrollPosition = _scrollPanel.maxVerticalScrollPosition;
		}
		
		private function nameClickHandler(evt:MouseEvent):void
		{
			PlayerTip.getInstance().show(_player.info.serverId,_player.info.userId,_player.info.nick,_player.group,new Point(evt.stageX,evt.stageY));
		}
		
		private function faceBtnClickHandler(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_faceView == null)
			{
				_faceView = new FaceView();
				_faceView.addEventListener(CommonModuleEvent.ADD_FACE,addFaceHandler);
			}
			_faceView.move(evt.stageX, (evt.stageY - 100));
			if(_faceView && _faceView.parent) _faceView.hide();
			else _faceView.show();
		}
		
		private function addFaceHandler(evt:CommonModuleEvent):void
		{
			var index:int = evt.data as int;
			var mes:String = index < 10 ? "0" + index : String(index);
			_inputText.appendText("#" + mes);
			if(_timeoutIndex != -1)
			{
				clearTimeout(_timeoutIndex);
			}
			_timeoutIndex = setTimeout(backHandler,50);
			function backHandler():void
			{
				stage.focus = _inputText.textField;
				if(_timeoutIndex != -1)
				{
					clearTimeout(_timeoutIndex);
				}
			}
		}
		
		private function minBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var icon:FlashIcon = new FlashIcon(_player.info.serverId,_player.info.userId,_player.info.nick);
			icon.isRead = true;
			GlobalData.friendIconList.addItem(icon);
//			if(parent) parent.removeChild(this);
			TweenLite.to(this,0.5,{x:GlobalData.friendIconList.x + icon.x,y:GlobalData.friendIconList.y + icon.y,scaleX:0.1,scaleY:0.1,alpha:0,ease:Cubic.easeOut,onComplete:onAddMoveComplete});
		}
		private function onAddMoveComplete():void
		{
			if(parent) parent.removeChild(this);
			this.scaleX = this.scaleY = 1;
			this.alpha = 1;
			setPanelPosition(null);
		}
		
		private function setChangeHandler(evt:FriendEvent):void
		{
			var data:Object = evt.data;
			_autoReply = data.auto;
			_replyContext = data.replyContext;
			
		}
			
		private function keyIsDownHandler(evt:KeyboardEvent):void
		{
			if(_inputText && evt.target == _inputText.textField)
			{
				if((evt.keyCode == KeyType.ENTER && GlobalAPI.keyboardApi.keyIsDown(KeyType.CTRL)) ||
					(evt.keyCode == KeyType.CTRL && GlobalAPI.keyboardApi.keyIsDown(KeyType.ENTER)))
				{
					sendMessage(_inputText.text);
					_inputText.text = "";
					stage.focus = _inputText.textField;
				}
			}
		}
				
		private function addClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(GlobalData.imPlayList.getFriend(_player.info.userId) == null)
			{
				FriendUpdateSocketHandler.sendAddFriend(_player.info.serverId,_player.info.nick,true);
			}else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.friends.friendExisted"));
			}
		}
		
		private function deliverClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			QuickTips.show(LanguageManager.getWord("ssztl.friends.transferNotOpen"));
		}
		
		private function processMessageFormat(item:ImMessage):RichTextField
		{
//			var formatList:Vector.<RichTextFormatInfo> = new Vector.<RichTextFormatInfo>();
//			var deployList:Vector.<DeployItemInfo> = new Vector.<DeployItemInfo>();
			var formatList:Array = [];
			var deployList:Array = [];
			if(item.isSelf)
			{
//				var message:String = GlobalData.selfPlayer.nick + " " + GlobalData.systemDate.getSystemDate().toLocaleTimeString() + "\n";
				var message:String =  GlobalData.selfPlayer.nick + " " + item.time + "\n";
			}else
			{
//				message = _player.info.nick + " " + GlobalData.systemDate.getSystemDate().toLocaleTimeString() + "\n";
				message = _player.info.nick + " " + item.time + "\n";
			}
			
			
			var formatInfo:RichTextFormatInfo = new RichTextFormatInfo();
			formatInfo.index = 0;
			formatInfo.length = message.length;
			if(item.isSelf)
			{
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff9900);
			}else
			{
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x33ff00);
			}
			formatList.push(formatInfo);
			
			var message1:String = item.message;
			var list:Array = message1.match(_facePattern);
			var index:int = 0;
			for(var i:int = 0 ;i<list.length;i++)
			{
				index = message1.indexOf(list[i], index);
				var deployInfo:DeployItemInfo = new DeployItemInfo();
				deployInfo.type = DeployEventType.FACE;
				deployInfo.param4 = index + message.length;
				deployInfo.param1 = int(String(list[i]).slice(1,3));
				deployList.push(deployInfo);
				message1 = message1.replace(list[i],"　 ");
			}
						
			if(message1.length > 0)
			{
				formatInfo = new RichTextFormatInfo();
				formatInfo.index = message.length;
				formatInfo.length = message1.length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xfffccc,null,null,null,null,null,null,null,null,5);
				formatList.push(formatInfo);
			}
			
			message = message + message1;
				
			var textResult:RichTextField = new RichTextField(325,true);
			textResult.appendMessage(message,deployList,formatList);
			return textResult;
		}
		
		private function addItem(item:ImMessage):void
		{
			var richItem:RichTextField = processMessageFormat(item);
			_itemList.push(richItem);
			richItem.y = _scrollPanel.getContainer().height;
			_scrollPanel.getContainer().addChild(richItem);
			_currentHeight += richItem.height + GAP;
			_scrollPanel.getContainer().height = _currentHeight;
			_scrollPanel.update();
			_scrollPanel.verticalScrollPosition = _scrollPanel.maxVerticalScrollPosition;
		}
		
		private function infoUpdateHandler(evt:FriendEvent):void
		{
			var item:ImMessage = evt.data as ImMessage;
			if(item == _lastItem) return;
			addItem(item);
			_lastItem = item;
//			if(_autoReply && !_lastItem.isSelf)
//			{
//				sendMessage(_replyContext);
//			}
		}
			
		private function clearBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			for(var i:int = 0;i<_itemList.length;i++)
			{
				if(_itemList[i].parent)
				{
					_scrollPanel.getContainer().removeChild(_itemList[i]);
				}	
			}
			for(i = 0;i<_itemList.length;i++)
			{
				_itemList[i].dispose();
			}
//			_itemList = new Vector.<RichTextField>();
			_itemList = [];
			_scrollPanel.getContainer().height = _currentHeight = 0;
			_scrollPanel.update();
//			_player.records = new Vector.<ImMessage>();
			_player.records = [];
		}
		
		private function sendBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			sendMessage(_inputText.text);
			_inputText.text = "";
			if(_timeoutIndex != -1)
			{
				clearTimeout(_timeoutIndex);
			}
			_timeoutIndex = setTimeout(backHandler,50);
			function backHandler():void
			{
				stage.focus = _inputText.textField;
				if(_timeoutIndex != -1)
				{
					clearTimeout(_timeoutIndex);
				}
			}
		}
		
		private function sendMessage(message:String):void
		{
			if(message == "")
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.unableSendNullMsg"));
				return;
			}
			if(_player.online == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.friends.playerNotOnline"));
				return;
			}
			message = WordFilterUtils.filterChatWords(message);
			ChatSockethandler.sendMessage(ChannelType.IM,message,_player.info.nick,_player.info.userId);
		}
		
		private function setPanelPosition(e:Event):void
		{
			move( (CommonConfig.GAME_WIDTH - WIDTH)/2, (CommonConfig.GAME_HEIGHT - HEIGHT)/2);
		}
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - width,parent.stage.stageHeight - height));
		}
		
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		
		override public function dispose():void
		{
			dispatchEvent(new FriendEvent(FriendEvent.REMOVE_CHHATPANEL,_player.info.userId));
			dispatchEvent(new Event(Event.CLOSE));
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_clearBtn)
			{
				_clearBtn.dispose();
				_clearBtn = null;
			}
			if(_sendBtn)
			{
				_sendBtn.dispose();
				_sendBtn = null;
			}
			if(_scrollPanel)
			{
				_scrollPanel.dispose();
				_scrollPanel = null;
			}
			if(_itemList)
			{
				for(var i:int = 0;i<_itemList.length;i++)
				{
					_itemList[i].dispose();
				}
				_itemList = null;
			}
			if(_faceView)
			{
				_faceView.removeEventListener(CommonModuleEvent.ADD_FACE,addFaceHandler);
				_faceView.dispose();
				_faceView = null;
			}
			if(_inputText)
			{
				_inputText.dispose();
				_inputText = null;
			}
			_player = null;
			_playerName = null;
//			if(_deliverBtn)
//			{
//				_deliverBtn.dispose();
//				_deliverBtn = null;
//			}
			if(_minBtn)
			{
				_minBtn.dispose();
				_minBtn = null;
			}
			if(_addBtn)
			{
				_addBtn.dispose();
				_addBtn = null;
			}
			if(_faceBtn)
			{
				_faceBtn.dispose();
				_faceBtn = null;
			}
			if(_myselfName)
			{
				_myselfName=null;
			}
			if(_myselfInfo)
			{
				_myselfInfo=null;
			}
			if(_inviteToTeamBtn)
			{
				_inviteToTeamBtn.dispose();
				_inviteToTeamBtn = null;
			}
			if(_checkInfoBtn)
			{
				_checkInfoBtn.dispose();
				_checkInfoBtn = null;
			}
			_lastItem = null;
			super.dispose();
		}
	}
}