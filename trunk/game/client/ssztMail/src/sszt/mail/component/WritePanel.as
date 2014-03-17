package sszt.mail.component
{
	import fl.controls.ComboBox;
	import fl.controls.ScrollPolicy;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mhsm.ui.BarAsset6;
	
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.data.mail.MailEvent;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.WordFilterUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.mail.mediator.MailMediator;
	import sszt.mail.socket.MailSendSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTextArea;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class WritePanel extends Sprite
	{		
		private var _mediator:MailMediator;
		private var _bg:IMovieWrapper;
		private var _combox:ComboBox;
		private var _textAccept:TextField;
		private var _title:TextField;
		private var _textArea:MTextArea;
		private var _copper:TextField;
		private var _sendBtn:MCacheAssetBtn1;
		private var _cell:MailCell;
		private var _str:String = "";
		private static const COST:int = 10;
		private var tempData:Array;
		private var isFirst:Boolean = true;
		private var _serverIdBox:ComboBox;
		
		public function WritePanel(mediator:MailMediator)
		{
			_mediator = mediator;
			super();
			init();
		}
		
		private function init():void
		{
			//主题、 发送的铜币文字 背景
			_bg = BackgroundUtils.setBackground([
				/* textInput bg */
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(61,37,190,24)),				
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(11,69,254,173)),
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(96,259,91,24)),
//				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(2,2,250,26)),
				
				/* 发送邮件、收件人、标题、手续费、邮费10　*/
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(102,6,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.mail.sendMail"),MAssetLabel.LABEL_TYPE_TITLE,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,14,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.mail.accepter"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,42,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.mail.mainTitle"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,308,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.mail.mailCost"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(78,308,52,16),new MAssetLabel(COST.toString(),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(100,261,18,18),new Bitmap(MoneyIconCaches.copperAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(61,306,18,18),new Bitmap(MoneyIconCaches.copperAsset))
			]);
			addChild(_bg as DisplayObject);
			
			_combox = new ComboBox();
			_combox.setSize(88,24);
			_combox.editable = true;
			_combox.move(61,10);
			addChild(_combox);
			
			//好友列表
			tempData = new Array();
//			tempData.push({label:LanguageManager.getWord("ssztl.mail.selectFriend"),serverId:0});
			for each(var i:ImPlayerInfo in GlobalData.imPlayList.friends)
			{
				tempData.push({
					label : i.info.nick,
					serverId : i.info.serverId
				});
			}
			_combox.dataProvider = new DataProvider(tempData);
			
			//服务器列表
			_serverIdBox = new ComboBox();
			_serverIdBox.setSize(50,19);
			_serverIdBox.move(52,0);
			_serverIdBox.editable = false;
			addChild(_serverIdBox);
			var dp:DataProvider = new DataProvider();
			var index:int = 0;
			for each(var id:int in GlobalData.serverList)
			{
				if(id == GlobalData.selfPlayer.serverId)index = GlobalData.serverList.indexOf(String(id));
//				dp.addItem({label:id+"服",value:id});
				dp.addItem({label:LanguageManager.getWord("ssztl.common.serverValue",id),value:id});
			}
			_serverIdBox.dataProvider = dp;
			_serverIdBox.selectedIndex = index;
			_serverIdBox.visible = false;
			
			_textAccept = new TextField();
			_textAccept.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc);
			_textAccept.mouseWheelEnabled = false;
			_textAccept.type = TextFieldType.INPUT;
			_textAccept.x = 62;
			_textAccept.y = 35;
			_textAccept.width = 89;
			_textAccept.height = 18;
//			addChild(_textAccept);
			
			_title = new TextField();
			_title.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc);
			//_title.textColor = 0xffffff;
			_title.maxChars = 18;
			_title.mouseWheelEnabled = false;
			_title.type = TextFieldType.INPUT;
			_title.x = 66;
			_title.y = 42;
			_title.width = 178;
			_title.height = 18;
			addChild(_title);
			
			_textArea = new MTextArea();
			_textArea.setSize(248,165);
			_textArea.setTextFormat(new TextFormat("SimSun",12,0xffffff,null,null,null,null,null,null,null,null,null,3));
			_textArea.textField.textColor = 0xfffccc;
			_textArea.move(18,75);
			_textArea.textField.maxChars = 150;
			_textArea.editable = true;
			_textArea.enabled = true;
			_textArea.verticalScrollPolicy = ScrollPolicy.OFF;
			_textArea.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_textArea);
			
			_copper = new TextField();
			_copper.defaultTextFormat = new TextFormat("SimSun",12,0xffffff);
			_copper.type = TextFieldType.INPUT;
			_copper.maxChars = 10;
			_copper.restrict = "0123456789";
			_copper.height =20;
			_copper.width = 173;
			_copper.x = 119;
			_copper.y = 263;
			_copper.text = "0";
			addChild(_copper);
		
			_sendBtn = new MCacheAssetBtn1(0, 3, LanguageManager.getWord("ssztl.mail.sendMail"));
			_sendBtn.move(195,303);
			addChild(_sendBtn);
			
			_cell = new MailCell(1,0);
			_cell.move(52,252);
			addChild(_cell);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_combox.addEventListener(Event.CHANGE,comboxChangeHandler);
			_sendBtn.addEventListener(MouseEvent.CLICK,sendClickHandler);
			_cell.addEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
			_textArea.addEventListener(FocusEvent.FOCUS_IN,focusInHandler);
			GlobalData.mailInfo.addEventListener(MailEvent.MAIL_SEND_RESULT,sendResultHandler);
		}
		
		private function removeEvent():void
		{
			_combox.removeEventListener(Event.CHANGE,comboxChangeHandler);
			_sendBtn.removeEventListener(MouseEvent.CLICK,sendClickHandler);
			_cell.removeEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
			_textArea.removeEventListener(FocusEvent.FOCUS_IN,focusInHandler);
			GlobalData.mailInfo.removeEventListener(MailEvent.MAIL_SEND_RESULT,sendResultHandler);
		}
		
		private function comboxChangeHandler(e:Event):void
		{
			var serverId:int;
			if(_combox.selectedItem == null)
			{
				for each(var obj:Object in _combox.dataProvider.toArray())
				{
					if(_combox.text == obj.label)
					{
						serverId = obj.serverId;
						_serverIdBox.selectedIndex = GlobalData.serverList.indexOf(String(serverId));
					}
				}
			}
			else
			{
				serverId = _combox.selectedItem.serverId;
				_serverIdBox.selectedIndex = GlobalData.serverList.indexOf(String(serverId));
			}
		}
		
		private function sendResultHandler(evt:MailEvent):void
		{
			var result:Boolean = evt.data as Boolean;
			if(result)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mail.sendSuccess"));
				GlobalData.clientBagInfo.clearMailList();
				clear();
			}else
			{
				_serverIdBox.selectedIndex = GlobalData.serverList.indexOf(String(GlobalData.selfPlayer.serverId));
				_combox.text = "";
				QuickTips.show(LanguageManager.getWord("ssztl.mail.sendFail"));
			}
		}
		
		private function focusInHandler(evt:FocusEvent):void
		{
			if(isFirst)
			{
				_textArea.text = "";
				isFirst = false;
			}
		}
		
		private function cellDownHandler(evt:MouseEvent):void
		{
			if(_cell.itemInfo)
			{
				GlobalAPI.dragManager.startDrag(_cell as IDragable);
			}
		}
		
		private function sendClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var len:int = 0;
			var array:Array = new Array();
			if(_cell.itemInfo){
				if(_cell.itemInfo.isBind)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.itemIsBind"));
					return;
				}
				len = 1;
				array.push(_cell.itemInfo.place);
			}
			if(_combox.text == "")
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mail.receiverNull"));
				return ;
			}
			if(_title.text == "")
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mail.mainTitleNull"));
				return ;
			}
			if(!WordFilterUtils.checkNameAllow(_title.text))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mail.hasIllegalcharacters"));
				return;
			}
			if(MapTemplateList.isAcrossBossMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.crossServerBoss"));
				return;
			}
			_textArea.text = WordFilterUtils.filterChatWords(_textArea.text);
			if(_copper.text != "")
			{
				var num:int = int(_copper.text);
				if(num > GlobalData.selfPlayer.userMoney.copper)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.mail.copperNoEnough"));
					return ;
				}
			}
			if((GlobalData.selfPlayer.userMoney.copper+GlobalData.selfPlayer.userMoney.bindCopper)<COST)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
				return ;
			}
			MailSendSocketHandler.sendMail(
				_serverIdBox.selectedItem.value,
				_combox.text,
				WordFilterUtils.filterChatWords(_title.text),
				WordFilterUtils.filterChatWords(_textArea.text),
				int(_copper.text),
				len,
				array
			);
		}
		
		private function clear():void
		{
//			_receiver.text = "";
			_serverIdBox.selectedIndex = GlobalData.serverList.indexOf(String(GlobalData.selfPlayer.serverId));
			_combox.text = "";
			_title.text = "";
			_textArea.text = "";
			_copper.text = "";
			_cell.itemInfo = null;
			isFirst = true;
			_textArea.appendText("");
		}
		
		public function write(serverId:int,nick:String):void
		{
			_cell.itemInfo = null;
			_textArea.text = "";
			_serverIdBox.selectedIndex = GlobalData.serverList.indexOf(String(serverId));
			_combox.setEditableValue(nick);
			_combox.text = nick;
			_textArea.appendText(LanguageManager.getWord("ssztl.mail.mainContent"));
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		};
		
		public function dispose():void
		{
			GlobalData.clientBagInfo.clearMailList();
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_combox = null;
			_serverIdBox = null;
			_title = null;
			_textAccept = null;
			_textArea.dispose();
			_textArea = null;
			_copper = null;
			if(_sendBtn)
			{
				_sendBtn.dispose();
				_sendBtn = null;
			}
			_cell.dispose();
			_cell = null;
			tempData = null;
			if(parent) parent.removeChild(this);
		}
	}
}