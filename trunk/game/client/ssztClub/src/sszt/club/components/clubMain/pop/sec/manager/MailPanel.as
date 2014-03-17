/** 
 * @author Aron 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-12-24 上午9:18:34 
 * 
 */ 
package sszt.club.components.clubMain.pop.sec.manager
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.club.components.clubMain.pop.sec.IClubMainPanel;
	import sszt.club.events.ClubDetailInfoUpdateEvent;
	import sszt.club.events.ClubMailUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubMailSendSocketHandler;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTextArea;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class MailPanel extends MSprite implements IClubMainPanel
	{
		
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _rowBg:Shape;
		
		private var _bg2:Bitmap;
		private var _sendBtn:MCacheAssetBtn1;
		private var _closeBtn:MCacheAssetBtn1;
		private var _textArea:MTextArea;
		private var _titleField:TextField;
		private var _isFirst:Boolean = true;
		private var _copperAsset:Bitmap;
		private var _cost:TextField;
		private var _mailCount:MAssetLabel;
		
		private const PAGESIZE:int = 11;
		
		public function MailPanel(mediator:ClubMediator)
		{
			_mediator = mediator;
			_mediator.clubInfo.initTryinInfo();
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,0,455,353)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(8,40,438,2)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(88,81,331,24)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(41,114,378,184)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(41,58,50,18),new MAssetLabel(LanguageManager.getWord("ssztl.mail.accepter"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(93,58,150,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.allClubMember"),MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(41,86,50,18),new MAssetLabel(LanguageManager.getWord("ssztl.mail.mainTitle"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(41,310,50,18),new MAssetLabel(LanguageManager.getWord("ssztl.mail.mailCost"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(141,310,100,18),new MAssetLabel(LanguageManager.getWord("ssztl.mail.mailSendCount",(GlobalData.selfPlayer.clubLevel*10)),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				
				
			]);
			addChild(_bg as DisplayObject);	
			_bg2 = new Bitmap();
			_bg2.x = 14;
			_bg2.y = 4;
			addChild(_bg2);
			
			_mailCount = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_mailCount.move(141,310);
			addChild(_mailCount);
			
			_copperAsset = new Bitmap(MoneyIconCaches.copperAsset);
			_copperAsset.x = 85;
			_copperAsset.y = 308;
			addChild(_copperAsset);
			
			_cost = new TextField();			
			_cost.defaultTextFormat = new TextFormat("SimSun",12,0xffffff);
			_cost.text = '500';
			_cost.mouseWheelEnabled = false;
			_cost.mouseEnabled = false;
			_cost.x = 104;
			_cost.y = 310;
			addChild(_cost);
			
			//主题输入框
			_titleField = new TextField();
			_titleField.defaultTextFormat = new TextFormat("SimSun",12,0xffffff);
			_titleField.x = 93;
			_titleField.y = 86;
			_titleField.height = 19;
			_titleField.width = 280;
			_titleField.type = TextFieldType.INPUT;
			_titleField.maxChars = 20;
			addChild(_titleField);
			
			_textArea = new MTextArea();
			_textArea.textField.defaultTextFormat = new TextFormat("SimSun",12,0xffffff);
			_textArea.setSize(378,175);
			_textArea.move(45,118);
			_textArea.editable = true;
			_textArea.enabled = true;
			_textArea.appendText(LanguageManager.getWord("ssztl.club.mainText"));
			_textArea.horizontalScrollPolicy = ScrollPolicy.OFF;
			_textArea.verticalScrollPolicy = ScrollPolicy.AUTO;
			addChild(_textArea);
			
			_sendBtn = new MCacheAssetBtn1(0, 3, LanguageManager.getWord("ssztl.common.send"));
			_sendBtn.move(349,307);
			addChild(_sendBtn);
			_sendBtn.enabled = false;
			if(ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty))
			{
				_sendBtn.enabled = true;
			}
			
			_closeBtn = new MCacheAssetBtn1(0, 3, LanguageManager.getWord("ssztl.common.close"));
			_closeBtn.move(0, 0);
			addChild(_closeBtn);
			_closeBtn.visible =false;
			
			initEvent();
		}
		
		
		public function assetsCompleteHandler():void
		{
			_bg2.bitmapData = AssetUtil.getAsset("ssztui.club.ClubMailTagBgAsset",BitmapData) as BitmapData;
		}
		
		public function show():void
		{
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		private function initEvent():void
		{
			_sendBtn.addEventListener(MouseEvent.CLICK,sendClickHandler);
			_closeBtn.addEventListener(MouseEvent.CLICK,closeBtnClickHandler);
			_textArea.addEventListener(FocusEvent.FOCUS_IN,focusHandler);
			_mediator.clubInfo.addEventListener(ClubMailUpdateEvent.MAIL_SEND_SUCCESS,clearHandler);
			_mediator.clubInfo.clubDetailInfo.addEventListener(ClubDetailInfoUpdateEvent.DETAILINFO_UPDATE,detailInfoUpdateHandler);
		}
		
		private function removeEvent():void
		{
			_sendBtn.removeEventListener(MouseEvent.CLICK,sendClickHandler);
			_closeBtn.removeEventListener(MouseEvent.CLICK,closeBtnClickHandler);
			_textArea.removeEventListener(FocusEvent.FOCUS_IN,focusHandler);
			_mediator.clubInfo.removeEventListener(ClubMailUpdateEvent.MAIL_SEND_SUCCESS,clearHandler);
			_mediator.clubInfo.clubDetailInfo.removeEventListener(ClubDetailInfoUpdateEvent.DETAILINFO_UPDATE,detailInfoUpdateHandler);
		}
		
		private function detailInfoUpdateHandler(evt:ClubDetailInfoUpdateEvent):void
		{
			_mailCount.setValue(LanguageManager.getWord("ssztl.mail.mailSendCount",_mediator.clubInfo.clubDetailInfo.mailTadayNum,_mediator.clubInfo.clubDetailInfo.mailTotalNum))
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