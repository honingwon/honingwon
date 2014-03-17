package sszt.mail.component
{
	import fl.controls.CheckBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.mail.MailEvent;
	import sszt.core.data.mail.MailItemInfo;
	import sszt.core.data.mail.MailType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.mail.mediator.MailMediator;
	import sszt.mail.utils.AttachUtils;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.mail.MailAttachIconAsset;
	import ssztui.ui.BorderAsset15;
	
	/**
	 * 修改：王鸿源  honingwon@gmail.com
	 * 日期：2012-10-23
	 * */
	public class MailItemView extends Sprite
	{
		public var mailItem:MailItemInfo;
		public var descript:TextField;
		public var hasRead:TextField;
		public var sender:MAssetLabel;
		public var leftDays:MAssetLabel;
		public var checkBox:CheckBox;
		private var _selectedBg:MovieClip;
		public var attachBg:Bitmap;
		public var typeBp:Bitmap;
		private var _selected:Boolean;
		private var _mediator:MailMediator;
		
		public function MailItemView(mediator:MailMediator)
		{
			_mediator = mediator;
			super();
			initView();
		}
		
		private function initView():void
		{	
			buttonMode = true;
			
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, 261, 46);
			graphics.endFill();
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(0,0,259,50),new BackgroundType.BORDER_14));
			
			_selectedBg = new BorderAsset15();
			_selectedBg.width = 259;
			_selectedBg.height = 50;
			_selectedBg.x = _selectedBg.y = 0;
			addChild(_selectedBg);
			_selectedBg.visible = false;
					
			checkBox = new CheckBox();
			checkBox.setSize(22, 22);
			checkBox.move(7, 14);
			checkBox.label="";
			addChild(checkBox);
			
			descript = new TextField();
			descript.mouseEnabled = descript.mouseWheelEnabled = false;
			descript.x = 68;
			descript.y = 8;
			descript.width = 52;
			descript.height =20;
			addChild(descript);
			
			hasRead = new TextField();
			hasRead.mouseEnabled = hasRead.mouseWheelEnabled = false;
			hasRead.x = 32;
			hasRead.y = 8;
			hasRead.width = 50;
			hasRead.height =20;
			addChild(hasRead);
			
			typeBp = new Bitmap();
			typeBp.x = 131;
			typeBp.y = 8;
			addChild(typeBp);

			sender = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			sender.move(32, 26);
			addChild(sender);
			
			leftDays = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.RIGHT);
			leftDays.move(249,17);
			addChild(leftDays);

			this.visible = false;
		}
		
		public function get hasAttachment():Boolean
		{
			return AttachUtils.hasAttachment(mailItem.attachFetch,mailItem) ||
				AttachUtils.hasMoney(mailItem);
		}
		
		public function get hasMoney():Boolean
		{
			return AttachUtils.hasMoney(mailItem);
		}
		
		public function set mailItemInfo(item:MailItemInfo):void
		{
			if(mailItem == item) 
				return;
			if(mailItem) 
				mailItem.removeEventListener(MailEvent.MAIL_ATTACH_RECEIVE,attachHandler);
			mailItem = item;
			if(mailItem)
			{
				mailItem.addEventListener(MailEvent.MAIL_ATTACH_RECEIVE,attachHandler);
				this.visible = true;
				if(hasAttachment)
				{
					attachBg = new Bitmap(new MailAttachIconAsset());
					addChild(attachBg);
					attachBg.x = 130;
					attachBg.y = 11;
				}
				if(mailItem.type != MailType.PRIVATE)
				{
					descript.textColor = 0xf39700;
					descript.text = MailType.getNameByType(mailItem.type);
				}else
				{
					descript.textColor = 0x13ec35;
					descript.text = LanguageManager.getWord("ssztl.common.privateMail");
				}
				if(mailItem.isRead)
				{
					hasRead.textColor = 0x988667;
					hasRead.text =  LanguageManager.getWord("ssztl.mail.read2");
				}
				else
				{
					hasRead.textColor = 0xff9900;
					hasRead.text = LanguageManager.getWord("ssztl.mail.unread2");
				}
				if(mailItem.type == MailType.PRIVATE || 
					mailItem.type == MailType.Mail_Type_Guild_Broad)
				{
				}
				else 
					typeBp.bitmapData = ListPanel.typeGmAsset;
				sender.setValue(LanguageManager.getWord("ssztl.mail.mainSender",mailItem.senderName));
				leftDays.setValue(LanguageManager.getWord("ssztl.mail.leftDay",mailItem.leftDay));
			}
			else
			{
				if(attachBg && attachBg.parent)
				{
					removeChild(attachBg);
					attachBg = null;
				}
				checkBox.selected = false;
				this.visible = false;
			}
		}
		
		public function attachHandler(evt:MailEvent):void
		{
			if(!hasAttachment && !hasMoney)
			{
				if(attachBg && attachBg.parent)
				{
					removeChild(attachBg);
					attachBg = null;
				}
			}
		}
		
		public function get mailItemInfo():MailItemInfo
		{
			return mailItem;
		}
				
		public function setRead():void
		{
			hasRead.textColor = 0x988667;
			hasRead.text = LanguageManager.getWord("ssztl.mail.read2");
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(_selected)
			{
				_selectedBg.visible = true;
			}else
			{
				_selectedBg.visible = false;
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function dispose():void
		{
			if(mailItem) mailItem.removeEventListener(MailEvent.MAIL_ATTACH_RECEIVE,attachHandler);
			mailItem = null;
			descript = null;
			hasRead = null;
			sender = null;
			leftDays = null;
			checkBox = null;
			if(_selectedBg)
			{
				//_selectedBg.dispose();
				_selectedBg = null;
			}
			if(typeBp && typeBp.parent.contains(typeBp))
			{
				typeBp.parent.removeChild(typeBp);
				typeBp = null;
			}
			attachBg = null;
			_mediator = null;
			typeBp = null;
			if(parent) parent.removeChild(this);
		}	
	}
}