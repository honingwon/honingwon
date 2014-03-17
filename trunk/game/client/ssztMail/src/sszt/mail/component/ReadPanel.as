package sszt.mail.component
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mhsm.ui.BarAsset6;
	
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.mail.MailEvent;
	import sszt.core.data.mail.MailItemInfo;
	import sszt.core.data.mail.MailType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.mail.command.MailEndCommand;
	import sszt.mail.mediator.MailMediator;
	import sszt.mail.socket.MailDeleteSocketHandler;
	import sszt.mail.socket.MailReceiveSocketHandler;
	import sszt.mail.utils.AttachUtils;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTextArea;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.mail.MailHeadingGMAsset;
	
	
	public class ReadPanel extends Sprite
	{
		private var _mediator:MailMediator;
		private var _getBtn:MCacheAssetBtn1;
		private var _writeBtn:MCacheAssetBtn1;
		private var _replyBtn:MCacheAssetBtn1;
		private var _deleteBtn:MCacheAssetBtn1;
		private var _yuanBao:MAssetLabel;
		private var _bindYuanBao:MAssetLabel;
		private var _copper:MAssetLabel;
		private var _bindCopper:MAssetLabel;
		private var _sender:MAssetLabel;
		private var _title:MAssetLabel;
		private var _textArea:MTextArea;
		private var _mailItem:MailItemInfo;
		private var _mailCell:MailCell;
		private var _bg:IMovieWrapper;
		private var _currentPage:int = 0;
		private var _currentType:int = 0;
		private var _heading:MAssetLabel;
		private var _headingSys:Bitmap;
		
		public function ReadPanel(mediator:MailMediator)
		{
			_mediator = mediator;
			super();
			init();
		}
		
		private function init():void
		{
			//发件人、主题 背景
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(96,251,63,20)),				
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(96,271,63,20)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(159,251,91,20)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(159,271,91,20)),
//				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(2,2,248,26)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(100,252,18,18),new Bitmap(MoneyIconCaches.yuanBaoAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(100,272,18,18),new Bitmap(MoneyIconCaches.bingYuanBaoAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(163,252,18,18),new Bitmap(MoneyIconCaches.copperAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(163,272,18,18),new Bitmap(MoneyIconCaches.bingCopperAsset)),
				
				/* textInput Bg */
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(61,37,190,24)),				
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(11,69,254,173)),
				/* 发件人、主题 标签文字 */
				//new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(102,7,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.mail.heading"),MAssetLabel.LABEL_TYPE_TITLE,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,14,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.mail.sender"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,42,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.mail.mainTitle"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT))
				]);
			addChild(_bg as DisplayObject);
			
			_headingSys = new Bitmap(new MailHeadingGMAsset );
			_headingSys.x = 60;
			_headingSys.y = 12;
			addChild(_headingSys);
			_headingSys.visible = false;
			
			//发件人、主题 文字
			_sender = new MAssetLabel("",MAssetLabel.LABEL_TYPE20, TextFormatAlign.LEFT);
			_sender.move(66,14);
			addChild(_sender);			
			_title = new MAssetLabel("",MAssetLabel.LABEL_TYPE20, TextFormatAlign.LEFT);
			_title.move(66,42);
			addChild(_title);
			
			_textArea = new MTextArea();
			_textArea.setTextFormat(new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,3));
			_textArea.setSize(248,165);
			_textArea.move(18,75);
			_textArea.editable = false;
			_textArea.enabled = true;
			_textArea.verticalScrollPolicy = ScrollPolicy.AUTO;
			_textArea.horizontalScrollPolicy = ScrollPolicy.OFF;
			_textArea.appendText("");
			addChild(_textArea);
			
			_yuanBao = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			addChild(_yuanBao);
			_yuanBao.move(119,253);
			
			_bindYuanBao = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			addChild(_bindYuanBao);
			_bindYuanBao.move(119,273);
			
			_copper = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			addChild(_copper);
			_copper.move(182,253);
			
			_bindCopper = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			addChild(_bindCopper);
			_bindCopper.move(182,273);
			
			_deleteBtn = new MCacheAssetBtn1(0, 1, LanguageManager.getWord("ssztl.common.delete"));
			_deleteBtn.move(66,303);
			addChild(_deleteBtn);
			
			_getBtn = new MCacheAssetBtn1(0, 3, LanguageManager.getWord("ssztl.mail.acceptAttach"));
			_getBtn.move(123,303);
			addChild(_getBtn);
			
			_replyBtn = new MCacheAssetBtn1(0, 3, LanguageManager.getWord("ssztl.mail.reply"));
			_replyBtn.move(195,303);
			addChild(_replyBtn);
			
			_writeBtn = new MCacheAssetBtn1(0, 2, LanguageManager.getWord("ssztl.mail.writeMail"));
			_writeBtn.move(0, 332);
			addChild(_writeBtn);
			_writeBtn.visible = false;
			
			_mailCell = new MailCell(0,0);
			_mailCell.move(52,252);
			addChild(_mailCell);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_getBtn.addEventListener(MouseEvent.CLICK,getClickHandler);
			_writeBtn.addEventListener(MouseEvent.CLICK,writeClickHandler);
			_replyBtn.addEventListener(MouseEvent.CLICK,replyClickHandler);
			_deleteBtn.addEventListener(MouseEvent.CLICK,deleteClickHandler);
			_mailCell.addEventListener(MouseEvent.CLICK,cellClickHandler);
			GlobalData.mailInfo.addEventListener(MailEvent.MAIL_DELETE,deleteHandler);
		}
		
		private function removeEvent():void
		{
			_getBtn.removeEventListener(MouseEvent.CLICK,getClickHandler);
			_writeBtn.removeEventListener(MouseEvent.CLICK,writeClickHandler);
			_replyBtn.removeEventListener(MouseEvent.CLICK,replyClickHandler);
			_deleteBtn.removeEventListener(MouseEvent.CLICK,deleteClickHandler);
			_mailCell.removeEventListener(MouseEvent.CLICK,cellClickHandler);
			GlobalData.mailInfo.removeEventListener(MailEvent.MAIL_DELETE,deleteHandler);
		}
		
		private function deleteHandler(evt:MailEvent):void
		{
			var id:Number = evt.data as Number;
			clear();
			_mediator.mailModule.mailPanel.showFirst();
		}
		
		private function attachHandler(evt:MailEvent):void
		{
			if(!_mailItem) return;
			if(AttachUtils.CanFetch(_mailItem.attachFetch,AttachUtils.money))
//			if(AttachUtils.hasMoney(_mailItem))
			{
				_yuanBao.setValue(String(_mailItem.yuanBao));
				_bindYuanBao.setValue(String(_mailItem.bindYuanBao));
				_copper.setValue(String(_mailItem.copper));
				_bindCopper.setValue(String(_mailItem.bindCopper));
			}else
			{
				_yuanBao.setValue("0");
				_bindYuanBao.setValue("0");
				_copper.setValue("0");
				_bindCopper.setValue("0");
			}
			if(!AttachUtils.CanFetch(_mailItem.attachFetch,AttachUtils.attachs[0]))
			{
				_mailCell.itemInfo = null;
			}
		}
		
		private function cellClickHandler(evt:MouseEvent):void
		{
			if(_mailCell.itemInfo)
			{
				for(var i:int =0;i<5;i++)
				{
					if(_mailCell.itemInfo.itemId == _mailItem.attachs[i])
					{
						MailReceiveSocketHandler.sendReceive(_mailItem.mailId,int(AttachUtils.attachs[i]));
						break;
					}
				}
			}
		}
		
		private function getClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_mailItem)
			{
				if(AttachUtils.hasAttachment(_mailItem.attachFetch,_mailItem)||AttachUtils.hasMoney(_mailItem))
				{
					if(AttachUtils.hasAttachment(_mailItem.attachFetch,_mailItem)&&GlobalData.bagInfo.currentSize >= GlobalData.selfPlayer.bagMaxCount)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.mail.bagFull"));
						return;
					}
					MailReceiveSocketHandler.sendReceive(_mailItem.mailId,0);
				}else
				{
					QuickTips.show(LanguageManager.getWord("ssztl.mail.noAttach"));
				}	
			}
		}
		
		private function writeClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_mediator.showWritePanel(GlobalData.selfPlayer.serverId);
		}
		
		private function replyClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_mediator.showWritePanel(_mailItem.senderServerId,_sender.text);
		}
		
		private function deleteClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_mailItem)
			{
				if(AttachUtils.hasAttachment(_mailItem.attachFetch,_mailItem) || AttachUtils.hasMoney(_mailItem))
				{
					MAlert.show(LanguageManager.getWord("ssztl.mail.includeAttach"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,deleteAlertHandler);	
				}else
				{
					MAlert.show(LanguageManager.getWord("ssztl.mail.sureDelete"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,deleteAlertHandler);

				}
				function deleteAlertHandler(evt:CloseEvent):void
				{
					if(evt.detail == MAlert.OK)
					{
						MailDeleteSocketHandler.sendDelete(_mailItem.mailId);
					}	
				}
			}
		}
		
		public function clear():void
		{
			_textArea.text = "";
			_mailCell.itemInfo = null;
			if(_mailItem){
				_mailItem.removeEventListener(MailEvent.MAIL_ATTACH_RECEIVE,attachHandler);
				_mailItem = null;
			}
			_sender.text = "";
			_title.text = "";
			_yuanBao.text = "";
			_bindYuanBao.text = "";
			_copper.text = "";
			_bindCopper.text = "";
			_replyBtn.enabled = false;
		}
		
		public function showMail(item:MailItemInfo,page:int,type:int):void
		{
			_replyBtn.enabled =true;
			_currentPage = page;
			_currentType = type;
			if(_mailItem){
				_mailItem.removeEventListener(MailEvent.MAIL_ATTACH_RECEIVE,attachHandler);
				_mailItem = null;
			}
			_mailItem = item;
			_mailItem.addEventListener(MailEvent.MAIL_ATTACH_RECEIVE,attachHandler);
			
			_textArea.text = "";
			_mailCell.itemInfo = null;
			
			_sender.setValue(_mailItem.senderName);
			_title.setValue(_mailItem.title);
			
			_textArea.htmlText = _mailItem.context;
			_textArea.textField.textColor = 0xffffff;
			
			if(AttachUtils.hasMoney(_mailItem))
			{
				_yuanBao.setValue(String(_mailItem.yuanBao));
				_bindYuanBao.setValue(String(_mailItem.bindYuanBao));
				_copper.setValue(String(_mailItem.copper));
				_bindCopper.setValue(String(_mailItem.bindCopper));
			}
			else
			{
				_yuanBao.setValue("0");
				_bindYuanBao.setValue("0");
				_copper.setValue("0");
				_bindCopper.setValue("0");
			}
			if(AttachUtils.hasAttachment(_mailItem.attachFetch,_mailItem))
			{
				_mailCell.itemInfo = _mailItem.attachments[0];
			}
			if(item.type != MailType.PRIVATE )
			{
				_headingSys.visible = true;
				_sender.visible = false;
			}
			else
			{
				_headingSys.visible = false;
				_sender.visible = true;
			}
		}
				
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_getBtn)
			{
				_getBtn.dispose();
				_getBtn = null;
			}
			if(_writeBtn)
			{
				_writeBtn.dispose();
				_writeBtn = null;
			}
			if(_replyBtn)
			{
				_replyBtn.dispose();
				_replyBtn = null;
			}
			if(_deleteBtn)
			{
				_deleteBtn.dispose();
				_deleteBtn = null;
			}
			_yuanBao = null;
			_bindYuanBao = null;
			_copper = null;
			_bindCopper = null;
			_sender = null;
			_title = null;
			_heading = null;
			_headingSys.bitmapData.dispose();
			_headingSys = null;
			_textArea.dispose();
			_textArea = null;
			if(_mailItem) _mailItem.removeEventListener(MailEvent.MAIL_ATTACH_RECEIVE,attachHandler);
			_mailItem = null;
			_mailCell.dispose();
			_mailCell = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(parent) parent.removeChild(this);
		}
	}
}