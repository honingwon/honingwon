package sszt.consign.components.quickConsign
{
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.RadioButton;
	import fl.controls.ScrollPolicy;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.consign.components.ConsignCellEmpty;
	import sszt.consign.components.ConsignItemCell;
	import sszt.consign.components.yuanBaoSecs.OtherItemView;
	import sszt.consign.components.yuanBaoSecs.SelfItemView;
	import sszt.consign.data.GoldConsignItem;
	import sszt.consign.data.PriceType;
	import sszt.consign.events.ConsignEvent;
	import sszt.consign.mediator.ConsignMediator;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.consign.IconMoneyAsset;
	import ssztui.consign.IconYuanbaoAsset;
	import ssztui.consign.SelectedBorderAsset;
	import ssztui.ui.CopperAsset;
	import ssztui.ui.SplitCompartLine2;
	import ssztui.ui.YuanBaoAsset;
	
	public class YuanBaoConsignPanel extends Sprite implements IConsignPanelView
	{
		private var _mediator:ConsignMediator;
		private var _bg:IMovieWrapper;
		
		private var _yuanBaoBitmap:Bitmap;
		private var _tongBiBitmap:Bitmap;
		private var _inputMoneyTextField:TextField;
		private var _tongBiRadioBtn:RadioButton;
		private var _yuanBaoRadioBtn:RadioButton;
		
		private var _inputType:Bitmap;
		private var _priceType:Bitmap;
		private var _typeList:Array;
		private var _selectedBorder:Bitmap;
		
		private var _consignPriceTextField:TextField;
		private var _consignTypeLabel:MAssetLabel;
		
		private var _fareTextField:TextField;
		private var _combox:ComboBox;
		
		private var _consignBtn:MCacheAssetBtn1;
		private var _resetBtn:MCacheAssetBtn1;
		
		private var _checkbox:CheckBox;
		
		
		public function setInputMoney(value:int):void
		{
			_inputMoneyTextField.text = value.toString();
		}
		
		public function setPriceType(value:int):void
		{
			switch(value)
			{
				case 2:_tongBiRadioBtn.selected = true; break;
				case 3:_yuanBaoRadioBtn.selected = true; break;
			}
		}
		
//		public 
		
		public function YuanBaoConsignPanel(mediator:ConsignMediator)
		{
			_mediator = mediator;
			super();
			initView();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,0,231,238)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,86,237,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,237,237,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(86,126,110,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(86,98,110,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(68,38,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(125,38,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(71,41,32,32),new Bitmap(new IconMoneyAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(128,41,32,32),new Bitmap(new IconYuanbaoAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(89,183,18,18),new Bitmap(MoneyIconCaches.copperAsset))
				
			]);
			addChild(_bg as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(52,13,148,17),new MAssetLabel(LanguageManager.getWord("ssztl.consign.inputPrice2"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(25,101,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.consign.sellAmount"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(25,129,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.consign.consignPrice"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(25,159,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.consign.copperTime"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(25,185,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.consign.copperCost"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			
			//默认出售铜币
			_inputType = new Bitmap();
			_inputType.x = 89;
			_inputType.y = 100;
			addChild(_inputType);
			_inputType.bitmapData = MoneyIconCaches.copperAsset;
			//默认价格为元宝
			_priceType = new Bitmap();
			_priceType.x = 89;
			_priceType.y = 128;
			addChild(_priceType);
			_priceType.bitmapData = MoneyIconCaches.yuanBaoAsset;
			
			//0：铜币	1：元宝
			_typeList = [];	
			for(var i:int=0; i<2; i++)
			{
				var btn:MSprite = new MSprite();
				btn.buttonMode = true;
				btn.graphics.beginFill(0,0);
				btn.graphics.drawRect(0,0,38,38);
				btn.graphics.endFill();
				btn.move(68+i*57,38);
				addChild(btn);
				_typeList.push(btn);
			}
			_selectedBorder = new Bitmap(new SelectedBorderAsset());
			_selectedBorder.x = _typeList[0].x-3;
			_selectedBorder.y = _typeList[0].y-3;
			addChild(_selectedBorder);
			
			/*
			_yuanBaoBitmap = new Bitmap();
			_yuanBaoBitmap.x = 35;
			_yuanBaoBitmap.y = 51;
			var yuanBaobmpd:BitmapData = new IconYuanbaoAsset();
			_yuanBaoBitmap.bitmapData = yuanBaobmpd;
			_yuanBaoBitmap.visible = false;
			addChild(_yuanBaoBitmap);
			
			_tongBiBitmap = new Bitmap();
			_tongBiBitmap.x = 35;
			_tongBiBitmap.y = 51;
			var tongBibmpd:BitmapData = new IconMoneyAsset();
			_tongBiBitmap.bitmapData = tongBibmpd;
			addChild(_tongBiBitmap);
			*/
			
			_inputMoneyTextField = new TextField();
			_inputMoneyTextField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC);
			_inputMoneyTextField.selectable = true;
			_inputMoneyTextField.type = TextFieldType.INPUT;
			_inputMoneyTextField.maxChars = 20;
			_inputMoneyTextField.restrict = "0123456789";
			_inputMoneyTextField.x = 107;
			_inputMoneyTextField.y = 101;
			_inputMoneyTextField.width = 110;
			_inputMoneyTextField.height = 17;
			addChild(_inputMoneyTextField);
			
			_yuanBaoRadioBtn = new RadioButton();
			_yuanBaoRadioBtn.groupName = "yuanBaoConsignGroup";
			_yuanBaoRadioBtn.width = 60;
			_yuanBaoRadioBtn.label = LanguageManager.getWord("ssztl.common.yuanBao2");
			_yuanBaoRadioBtn.x = 86;
			_yuanBaoRadioBtn.y = 50;
//			addChild(_yuanBaoRadioBtn);
			
			_tongBiRadioBtn = new RadioButton();
			_tongBiRadioBtn.groupName = "yuanBaoConsignGroup";
			_tongBiRadioBtn.width = 60;
			_tongBiRadioBtn.label = LanguageManager.getWord("ssztl.common.copper2");
			_tongBiRadioBtn.x = 141;
			_tongBiRadioBtn.y = 50;
			_tongBiRadioBtn.selected = true;
//			addChild(_tongBiRadioBtn);
			
			_consignPriceTextField = new TextField();
			_consignPriceTextField.selectable = false;
			_consignPriceTextField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC);
			_consignPriceTextField.selectable = true;
			_consignPriceTextField.type = TextFieldType.INPUT;
			_consignPriceTextField.restrict = "0123456789";
			_consignPriceTextField.text = "";
			_consignPriceTextField.maxChars = 7;
			_consignPriceTextField.x = 107;
			_consignPriceTextField.y = 129;
			_consignPriceTextField.width =110;
			_consignPriceTextField.height = 17;
			addChild(_consignPriceTextField);
			
			_consignTypeLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.yuanBao2"),MAssetLabel.LABEL_TYPE1);
			_consignTypeLabel.move(201,131);
//			addChild(_consignTypeLabel);
			
			_fareTextField = new TextField();
			_fareTextField.selectable = false;
			_fareTextField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC);
			_fareTextField.restrict = "0123456789";
			_fareTextField.text = "0";
			_fareTextField.maxChars = 9;
			_fareTextField.x = 107;
			_fareTextField.y = 185;
			_fareTextField.width = 110;
			_fareTextField.height = 17;
			addChild(_fareTextField);
			
			_combox = new ComboBox();
			_combox.setStyle("textFormat",new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF));
			_combox.x = 86;
			_combox.y = 154;
			_combox.width = 110;
			_combox.height = 23;
			addChild(_combox);
			_combox.dataProvider = new DataProvider([{label:LanguageManager.getWord("ssztl.consign.hour8"),value:8},
				{label:LanguageManager.getWord("ssztl.consign.hour24"),value:24},
				{label:LanguageManager.getWord("ssztl.consign.hour48"),value:48}]);
			
//			_checkbox = new CheckBox();
//			_checkbox.label = LanguageManager.getWord("ssztl.consign.shenChat");
//			_checkbox.setSize(220,20);
//			_checkbox.move(18,194);
//			addChild(_checkbox);
			
			
			_consignBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.consign"));
			_consignBtn.move(45,244);
			_consignBtn.enabled = false;
			addChild(_consignBtn);
			
			_resetBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.resetBtn"));
			_resetBtn.move(117,244);
			addChild(_resetBtn);
			
		}
		//添加事件
		private function addEvents():void
		{
			_inputMoneyTextField.addEventListener(Event.CHANGE , onMoneyChange);
			_tongBiRadioBtn.group.addEventListener(Event.CHANGE , onRadioBtnChange);
			
			_consignPriceTextField.addEventListener(Event.CHANGE , onConsignChange);
			_tongBiRadioBtn.group.addEventListener(Event.CHANGE , onConsignChange);
			_combox.addEventListener(Event.CHANGE, onConsignChange);
			
			_consignBtn.addEventListener(MouseEvent.CLICK, onConsign);
			_resetBtn.addEventListener(MouseEvent.CLICK, onResetBtnHandler);
			
			_typeList[0].addEventListener(MouseEvent.CLICK, onTypeSelectHandler);
			_typeList[1].addEventListener(MouseEvent.CLICK, onTypeSelectHandler);
		}
		
		private function removeEvents():void
		{
			_inputMoneyTextField.removeEventListener(Event.CHANGE , onMoneyChange);
			_tongBiRadioBtn.group.removeEventListener(Event.CHANGE , onRadioBtnChange);
			
			_consignPriceTextField.removeEventListener(Event.CHANGE , onConsignChange);
			_tongBiRadioBtn.group.removeEventListener(Event.CHANGE , onConsignChange);
			_combox.removeEventListener(Event.CHANGE, onConsignChange);
			
			_consignBtn.removeEventListener(MouseEvent.CLICK, onConsign);
			_resetBtn.removeEventListener(MouseEvent.CLICK, onResetBtnHandler);
			
			_typeList[0].removeEventListener(MouseEvent.CLICK, onTypeSelectHandler);
			_typeList[1].removeEventListener(MouseEvent.CLICK, onTypeSelectHandler);
		}
		private function onTypeSelectHandler(e:MouseEvent):void
		{
			var id:int = _typeList.indexOf(e.target);
			if(id == 0)
			{
				_tongBiRadioBtn.selected = true;
			}else
			{
				_yuanBaoRadioBtn.selected = true;
			}
			_selectedBorder.x = _typeList[id].x-3;
			_selectedBorder.y = _typeList[id].y-3;
		}
		
		private function onMoneyChange(e:Event):void
		{
			if(_inputMoneyTextField.text != "" && _inputMoneyTextField.text != "0" && _consignPriceTextField.text != ""  && _consignPriceTextField.text != "0")
			{
				_consignBtn.enabled = true;
			}else
			{
				_consignBtn.enabled = false;
			}
		}
		
		private function onRadioBtnChange(e:Event):void
		{
			_consignTypeLabel.setValue(_tongBiRadioBtn.selected?LanguageManager.getWord("ssztl.common.yuanBao2"):LanguageManager.getWord("ssztl.common.copper2"));
			if(_tongBiRadioBtn.selected)
			{
				_inputType.bitmapData = MoneyIconCaches.copperAsset;
				_priceType.bitmapData = MoneyIconCaches.yuanBaoAsset;
				_consignTypeLabel.setValue(LanguageManager.getWord("ssztl.common.yuanBao2"));
//				addChild(_tongBiBitmap);
//				_tongBiBitmap.visible = true;
//				_yuanBaoBitmap.visible = false;
			}
			else
			{
				_inputType.bitmapData = MoneyIconCaches.yuanBaoAsset;
				_priceType.bitmapData = MoneyIconCaches.copperAsset;
				_consignTypeLabel.setValue(LanguageManager.getWord("ssztl.common.copper2"));
//				addChild(_yuanBaoBitmap);
//				_tongBiBitmap.visible = false;
//				_yuanBaoBitmap.visible = true;
			}
		}
		
		private function onConsignChange(e:Event):void
		{
			var price:int = parseInt(_consignPriceTextField.text);
			var priceType:int = _tongBiRadioBtn.selected? PriceType.YUANBAO : PriceType.COPPER;
			var consignTime:Number = Number(_combox.selectedItem.value);
			var base:int;
			onMoneyChange(null);
			switch(priceType)
			{
				case PriceType.COPPER : base = Math.ceil(price/20); break;
				case PriceType.YUANBAO : base = (price * 15);
			}
			switch(consignTime)
			{
				case 8 : base *= 1; break;
				case 24 : base *= 2; break;
				case 48 : base *= 3; break;
			}
			if(base != 0)
			{
				_fareTextField.text = base.toString();// + LanguageManager.getWord("ssztl.common.copper2");
			}
			
		}
		
		//提交
		private function onConsign(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_tongBiRadioBtn.selected && parseInt(_inputMoneyTextField.text)>GlobalData.selfPlayer.userMoney.copper)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
				return;
			}
			else if(_yuanBaoRadioBtn.selected && parseInt(_inputMoneyTextField.text) > GlobalData.selfPlayer.userMoney.yuanBao)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.yuanBaoNotEnough"));
				return;
			}
			var inputMoney:int = parseInt(_inputMoneyTextField.text);
			var fareMoney:int =  parseInt(_fareTextField.text);
			
			var sendChat:int = 0;
			
//			if(_checkbox.selected)
//			{
//				sendChat = 5000;
//			}
			var deduct:int = 0;
			if(_tongBiRadioBtn.selected)
			{
				deduct = parseInt(_inputMoneyTextField.text);
			}
			
			if(fareMoney > (GlobalData.selfPlayer.userMoney.copper - deduct))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotConsign"));
			}
			else if(fareMoney > (GlobalData.selfPlayer.userMoney.copper - deduct - sendChat ))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotConsign1"));
			}
			else
			{
				_mediator.sendAddYuanBaoConsign(_tongBiRadioBtn.selected?PriceType.YUANBAO:PriceType.COPPER, inputMoney, parseInt(_consignPriceTextField.text), parseInt(_combox.selectedItem.value),0);
				onResetBtnHandler(null);
			}
		}
		
		//重置
		private function onResetBtnHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_inputMoneyTextField.text = "";
			_tongBiRadioBtn.selected = true;
			_consignPriceTextField.text = "";
			_fareTextField.text = "0";
			_combox.selectedIndex = 0;
			_consignBtn.enabled = false;
			
		}
		
		public function hide():void
		{
			removeEvents();
			if(parent) parent.removeChild(this);
		}
	
		public function show():void
		{
			addEvents();
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_yuanBaoBitmap = null;
			_tongBiBitmap = null;
			_inputMoneyTextField = null;
			_tongBiRadioBtn = null;
			_yuanBaoRadioBtn = null;
			_consignPriceTextField = null;
			_consignTypeLabel = null;
			_fareTextField = null;
			_combox = null;
//			_checkbox = null;
			if(_consignBtn)
			{
				_consignBtn.dispose(); 
				_consignBtn = null;
			}
			if(_resetBtn)
			{
				_resetBtn.dispose(); 
				_resetBtn = null;
			}
			if(parent)
			{
				parent.removeChild(this);
			}
			_mediator = null;
			
		}
		
	}
}