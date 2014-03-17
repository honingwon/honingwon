package sszt.club.components.clubMain.pop
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubContributionSocketHandler;
	import sszt.constData.CategoryType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.MCacheAssetBtn2;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.club.ClubTitleJXAsset;
	
	public class ClubContributePanel extends MPanel
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _countField1:TextField;
		private var _countField2:TextField;
		private var _descriptField:TextField;
		private var _copperView:MAssetLabel;
		private var _yuanBaoView:MAssetLabel;
		private var _count1:int;
		private var _count2:int;
		private var _addBtn1:MCacheAssetBtn2;
		private var _subBtn1:MCacheAssetBtn2;
		private var _addBtn2:MCacheAssetBtn2;
		private var _subBtn2:MCacheAssetBtn2;
		private var _okBtn1:MCacheAssetBtn1;
		private var _okBtn2:MCacheAssetBtn1;
		
		public function ClubContributePanel(mediator:ClubMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1("",new Bitmap(new ClubTitleJXAsset())),true,-1);
//			super(new MCacheTitle1(LanguageManager.getWord("ssztl.club.clubContribute")),true,-1);
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			setContentSize(281,232);
			
			_bg = BackgroundUtils.setBackground([
//				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,3,265,219)),
//				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(15,10,252,62)),
//				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(15,75,252,62)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,2,281,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,72,281,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.BORDER_7,new Rectangle(83,40,110,24)),
				new BackgroundInfo(BackgroundType.BORDER_7,new Rectangle(83,105,110,24))
			]);
			addContent(_bg as DisplayObject);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(16,20,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.currentCopper"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(16,85,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.currentYuanBao"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(16,45,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.contributeCopper")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(16,110,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.contributeYuanBao")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(16,147,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.contributeExplain"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(82,19,18,18),new Bitmap(MoneyIconCaches.copperAsset)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(82,83,18,18),new Bitmap(MoneyIconCaches.yuanBaoAsset)));
			
			_copperView = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_copperView.move(101,20);
			_copperView.setValue(GlobalData.selfPlayer.userMoney.copper.toString());
			addContent(_copperView);
			_yuanBaoView= new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_yuanBaoView.move(101,85);
			_yuanBaoView.setValue(GlobalData.selfPlayer.userMoney.yuanBao.toString());
			addContent(_yuanBaoView);			
			
			_descriptField = new TextField();
			_descriptField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x6fb54c,null,null,null,null,null,null,null,null,null,4);
			//_descriptField.filters = [new GlowFilter(0x1D250E,1,4,4,4.5)];
			_descriptField.width = 260;
			_descriptField.height = 110;
			_descriptField.x = 16;
			_descriptField.y = 165;
			_descriptField.mouseEnabled = _descriptField.mouseWheelEnabled = false;
			_descriptField.wordWrap = _descriptField.multiline = true;
			addContent(_descriptField);
			_descriptField.text = LanguageManager.getWord("ssztl.club.contributeDescript");
			
			_countField1 = new TextField();
			_countField1.defaultTextFormat = new TextFormat("Tahoma",12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_countField1.type = TextFieldType.INPUT;
			_countField1.restrict = "0123456789";
			_countField1.maxChars = 7;
			_countField1.width = 70;
			_countField1.height = 18;
			_countField1.x = 104;
			_countField1.y = 43;
			addContent(_countField1);
			
			_countField2 = new TextField();
			_countField2.defaultTextFormat = new TextFormat("Tahoma",12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_countField2.type = TextFieldType.INPUT;
			_countField2.restrict = "0123456789";
			_countField2.maxChars = 5;
			_countField2.width = 70;
			_countField2.height = 18;
			_countField2.x = 104;
			_countField2.y = 108;
			addContent(_countField2);
			
			_addBtn1 = new MCacheAssetBtn2(0);
			_addBtn1.move(174,43);
			addContent(_addBtn1);
			_subBtn1 = new MCacheAssetBtn2(1);
			_subBtn1.move(86,43);
			addContent(_subBtn1);
			
			_addBtn2 = new MCacheAssetBtn2(0);
			_addBtn2.move(174,108);
			addContent(_addBtn2);
			_subBtn2 = new MCacheAssetBtn2(1);
			_subBtn2.move(86,108);
			addContent(_subBtn2);
			
			_okBtn1 = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.club.contribute"));
			_okBtn1.move(195,40);
			addContent(_okBtn1);
			_okBtn2 = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.club.contribute"));
			_okBtn2.move(195,105);
			addContent(_okBtn2);
			
			_count1 = 2000;
			_countField1.text = String(_count1);
			_countField1.setSelection(_countField1.length,_countField1.length);
			
			_count2 = 1;
			_countField2.text = String(_count2);
			_countField2.setSelection(_countField2.length,_countField2.length);
		}
		
		private function initEvent():void
		{
			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdataHandler);
			_addBtn1.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_subBtn1.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_addBtn2.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_subBtn2.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_okBtn1.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_okBtn2.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function removeEvent():void
		{
			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdataHandler);
			_addBtn1.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_subBtn1.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_addBtn2.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_subBtn2.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_okBtn1.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_okBtn2.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		private function moneyUpdataHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			_yuanBaoView.setValue(GlobalData.selfPlayer.userMoney.yuanBao.toString());
			_copperView.setValue(GlobalData.selfPlayer.userMoney.copper.toString());
		}
		
//		private function countFieldChangeHandler(e:Event):void
//		{
//			_count2 = int(_countField2.text);
//			if(_count2 > 50)_count2 = 50;
//			if(_count2 < 1)_count2 = 1;
//			_countField2.text = String(_count2);
//			_countField2.setSelection(_countField2.length,_countField2.length);
//		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			switch(e.currentTarget)
			{
				case _addBtn1:
					_count1 += 2000;
					if(_count1 > 1000000)_count1 = 1000000;
					if(_count1 < 2000)_count1 = 2000;
					_countField1.text = String(_count1);
					_countField1.setSelection(_countField1.length,_countField1.length);
					break;
				case _subBtn1:
					_count1 -= 2000;
					if(_count1 > 1000000)_count1 = 1000000;
					if(_count1 < 2000)_count1 = 2000;
					_countField1.text = String(_count1);
					_countField1.setSelection(_countField1.length,_countField1.length);
					break;
				case _addBtn2:
					_count2++;
					if(_count2 > 10000)_count2 = 10000;
					if(_count2 < 1)_count2 = 1;
					_countField2.text = String(_count2);
					_countField2.setSelection(_countField2.length,_countField2.length);
					break;
				case _subBtn2:
					_count2--;
					if(_count2 > 10000)_count2 = 10000;
					if(_count2 < 1)_count2 = 1;
					_countField2.text = String(_count2);
					_countField2.setSelection(_countField2.length,_countField2.length);
					break;
				case _okBtn1:
					_count1 = int(_countField1.text);
					if(_count1%2000 != 0)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.club.contributeCopperExplain"));
						_countField1.text = "2000";
						_count1 = int(_countField1.text);
						return;
					}
					if(_count1 > GlobalData.selfPlayer.userMoney.copper)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough2"));
					}
					else
					{
						if(_count1 > 1000000)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.club.copperMaxContribute"));
							return;
						}
						ClubContributionSocketHandler.send(1,_count1);
					}
					break;
				case _okBtn2:
					_count2 = int(_countField2.text);
					if(_count2 > GlobalData.selfPlayer.userMoney.yuanBao)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.yuanBaoNotEnough"));
					}
					else
					{
						if(_count2 > 10000)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.club.yuanBaoMaxContribute"));
							return;
						}
						ClubContributionSocketHandler.send(2,_count2);
					}
					break;
			}
		}
		
		
		override public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_countField1 = null;
			_countField2 = null;
			_descriptField = null;
			if(_addBtn1)
			{
				_addBtn1.dispose();
				_addBtn1 = null;
			}
			if(_subBtn1)
			{
				_subBtn1.dispose();
				_subBtn1 = null;
			}
			if(_addBtn2)
			{
				_addBtn2.dispose();
				_addBtn2 = null;
			}
			if(_subBtn2)
			{
				_subBtn2.dispose();
				_subBtn2 = null;
			}
			if(_okBtn1)
			{
				_okBtn1.dispose();
				_okBtn1 = null;
			}
			if(_okBtn2)
			{
				_okBtn2.dispose();
				_okBtn2 = null;
			}
			super.dispose();
		}
	}
}