package sszt.club.components.clubMain.pop.mail
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	
	import sszt.club.events.ClubMailUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubMailSendSocketHandler;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTextArea;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class TeamMailPanel extends MPanel
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _bg2:Bitmap;
		private var _sendBtn:MCacheAssetBtn1;
		private var _closeBtn:MCacheAssetBtn1;
		private var _textArea:MTextArea;
		private var _titleField:TextField;
		private var _isFirst:Boolean = true;
		private var _copperAsset:Bitmap;
		private var _cost:TextField;
		
		public function TeamMailPanel(mediator:ClubMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1("",new Bitmap()),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(299, 385);
			//背景图片
			_bg2 = new Bitmap();
			_bg2.x = 8;
			_bg2.y = 7;
			addContent(_bg2);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(69, 15, 207, 22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(69, 43, 207, 22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(23, 72, 253, 263))
				]);
			addContent(_bg as DisplayObject);
			
			_copperAsset = new Bitmap(MoneyIconCaches.copperAsset);
			_copperAsset.x = 72;
			_copperAsset.y = 348;
			addContent(_copperAsset);
			
			//背景文字
			var receiver:TextField = new TextField();
			receiver.textColor = 0xffffff;
			receiver.mouseEnabled = receiver.mouseWheelEnabled = false;
			receiver.x = 75;
			receiver.y = 16;
			receiver.height = 20;
			receiver.width = 76;
			receiver.text = LanguageManager.getWord("ssztl.club.allClubMember");
			addContent(receiver);
				
			addContent(MBackgroundLabel.getDisplayObject(
				new Rectangle(21, 18, 52, 16),
				new MAssetLabel(LanguageManager.getWord("ssztl.mail.accepter"),
					MAssetLabel.LABEL_TYPE2,
					TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(
				new Rectangle(21, 46, 52, 16),
				new MAssetLabel(LanguageManager.getWord("ssztl.mail.mainTitle"),
					MAssetLabel.LABEL_TYPE2,
					TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(
				new Rectangle(21, 348, 52, 16),
				new MAssetLabel(LanguageManager.getWord("ssztl.mail.mailCost"),
					MAssetLabel.LABEL_TYPE2,
					TextFormatAlign.LEFT)));
			
			_cost = new TextField();
			_cost.text = '500';
			_cost.textColor = 0xffffff;
			_cost.mouseWheelEnabled = false;
			_cost.x = 90;
			_cost.y = 348;
			addContent(_cost);
			
			//主题输入框
			_titleField = new TextField();
			_titleField.textColor = 0xffffff;
			_titleField.x = 75;
			_titleField.y = 44;
			_titleField.height = 19;
			_titleField.width = 280;
			_titleField.type = TextFieldType.INPUT;
			_titleField.maxChars = 20;
			addContent(_titleField);
			
			_textArea = new MTextArea();
			_textArea.textField.textColor = 0xffffff;
			_textArea.setSize(254, 259);
			_textArea.move(25, 74);
			_textArea.editable = true;
			_textArea.enabled = true;
			_textArea.appendText(LanguageManager.getWord("ssztl.club.mainText"));
			_textArea.horizontalScrollPolicy = ScrollPolicy.OFF;
			_textArea.verticalScrollPolicy = ScrollPolicy.ON;
			addContent(_textArea);
			
			_sendBtn = new MCacheAssetBtn1(0, 2, LanguageManager.getWord("ssztl.common.send"));
			_sendBtn.move(205, 341);
			addContent(_sendBtn);
			
			_closeBtn = new MCacheAssetBtn1(0, 2, LanguageManager.getWord("ssztl.common.close"));
			_closeBtn.move(0, 0);
			addContent(_closeBtn);
			_closeBtn.visible =false;
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_sendBtn.addEventListener(MouseEvent.CLICK,sendClickHandler);
			_closeBtn.addEventListener(MouseEvent.CLICK,closeBtnClickHandler);
			_textArea.addEventListener(FocusEvent.FOCUS_IN,focusHandler);
			_mediator.clubInfo.addEventListener(ClubMailUpdateEvent.MAIL_SEND_SUCCESS,clearHandler);
		}
		
		private function removeEvent():void
		{
			_sendBtn.removeEventListener(MouseEvent.CLICK,sendClickHandler);
			_closeBtn.removeEventListener(MouseEvent.CLICK,closeBtnClickHandler);
			_textArea.removeEventListener(FocusEvent.FOCUS_IN,focusHandler);
			_mediator.clubInfo.removeEventListener(ClubMailUpdateEvent.MAIL_SEND_SUCCESS,clearHandler);
		}
		
		public function assetsCompleteHandler():void
		{
			_bg2.bitmapData = AssetUtil.getAsset("ssztui.club.ClubMailBgAsset",BitmapData) as BitmapData;
		}
		
		private function clearHandler(evt:ClubMailUpdateEvent):void
		{
			QuickTips.show(LanguageManager.getWord("ssztl.mail.sendSuccess"));
			_titleField.text = "";
			_textArea.text = "";
		}
		
		private function focusHandler(evt:FocusEvent):void
		{
			if(_isFirst)
			{
				_textArea.text = "";
				_isFirst = false;
			}
		}
		
		private function sendClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_titleField.text == "")
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.writeInMailTitle"));
				return;
			}
			ClubMailSendSocketHandler.sendMail(_titleField.text,_textArea.text);
		}
		
		private function closeBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			dispose();
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_sendBtn)
			{
				_sendBtn.dispose();
				_sendBtn = null;
			}
			if(_closeBtn)
			{
				_closeBtn.dispose();
				_closeBtn = null;
			}
			if(_textArea)
			{
				_textArea.dispose();
				_textArea = null;
			}
			_mediator = null;
			
			if(_copperAsset)
			{
				_copperAsset = null;
			}
			if(_cost)
			{
				_cost = null;
			}
			if(_bg2 && _bg2.bitmapData)
			{
				_bg2.bitmapData.dispose();
				_bg2 = null;
			}
		}
	}
}