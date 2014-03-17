package sszt.consign.components.quickConsign
{
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.RadioButton;
	import fl.controls.ScrollPolicy;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mhsm.ui.UpBtnAsset;
	
	import sszt.consign.components.ConsignCellEmpty;
	import sszt.consign.components.ConsignItemCell;
	import sszt.consign.components.itemView.MyItemView;
	import sszt.consign.data.ConsignInfo;
	import sszt.consign.data.Item.MyItemInfo;
	import sszt.consign.data.PriceType;
	import sszt.consign.events.ConsignEvent;
	import sszt.consign.mediator.ConsignMediator;
	import sszt.consign.socketHandlers.ConsignAddConsignHandler;
	import sszt.constData.DragActionType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.doubleClicks.DoubleClickManager;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CellEvent;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.ui.SplitCompartLine2;
	
	public class ItemConsignPanel extends Sprite implements IConsignPanelView,IAcceptDrag
	{
		private var _consignMediator:ConsignMediator;
		private var _bg:IMovieWrapper;
		private var _resetBtn:MCacheAssetBtn1;
		private var _consignBtn:MCacheAssetBtn1;
		private var _consignPriceTextField:TextField;
		private var _fareTextField:TextField;
		private var _tongBiRadioBtn:RadioButton;
		private var _yuanBaoRadioBtn:RadioButton;
		private var _combox:ComboBox; //寄售时间
		private var _myCell:ConsignItemCell;
		private var _priceType:Bitmap;
		
		private var _checkbox:CheckBox;
		
		public function setPriceType(value:int):void
		{
			switch(value)
			{
				case 1 : _tongBiRadioBtn.selected = true; break;
				case 2 : _yuanBaoRadioBtn.selected = true; break;
			}
		}
		
		public function ItemConsignPanel(consignMediator:ConsignMediator)
		{
			_consignMediator = consignMediator;
			super();
			initialView();
		}
		
		public function initialView():void
		{
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0,0,247,261);
			this.graphics.endFill();
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,0,231,238)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,86,237,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,237,237,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(86,126,110,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(95,38,38,38),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(56,343,16,14),new Bitmap(MoneyIconCaches.yuanBaoAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(89,183,18,18),new Bitmap(MoneyIconCaches.copperAsset)),
			]);
			addChild(_bg as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(52,13,124,17),new MAssetLabel(LanguageManager.getWord("ssztl.consign.inputConsignItem"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(25,101,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.consign.chooseMoney")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(25,129,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.consign.consignPrice"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(25,159,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.consign.copperTime"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(25,185,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.consign.copperCost"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			
			_myCell = new ConsignItemCell(null,null);
			_myCell.move(95,38);
			addChild(_myCell);
			
			_consignPriceTextField = new TextField();
			_consignPriceTextField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC);
			_consignPriceTextField.selectable = true;
			_consignPriceTextField.type = "input";
			_consignPriceTextField.restrict = "0123456789";
			_consignPriceTextField.text = "";
			_consignPriceTextField.maxChars = 7;
			_consignPriceTextField.x = 107;
			_consignPriceTextField.y = 129;
			_consignPriceTextField.width = 110;
			_consignPriceTextField.height = 18;
			addChild(_consignPriceTextField);
			
			_fareTextField = new TextField();
			_fareTextField.selectable = false;
			_fareTextField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC);
			_fareTextField.restrict = "0123456789";
			_fareTextField.text = "0";
			_fareTextField.maxChars = 9;
			_fareTextField.x = 107;
			_fareTextField.y = 185;
			_fareTextField.width =124;
			_fareTextField.height = 18;
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
			
			_yuanBaoRadioBtn = new RadioButton();
			_yuanBaoRadioBtn.width = 60;
			_yuanBaoRadioBtn.label = LanguageManager.getWord("ssztl.common.yuanBao2");
//			_yuanBaoRadioBtn.selected = true;
			_yuanBaoRadioBtn.move(143,109);
			addChild(_yuanBaoRadioBtn);
			
			_tongBiRadioBtn = new RadioButton();
			_tongBiRadioBtn.width = 60;
			_tongBiRadioBtn.label = LanguageManager.getWord("ssztl.common.copper2");
			_tongBiRadioBtn.move(88,109);
			addChild(_tongBiRadioBtn);
			_tongBiRadioBtn.selected = true;
			
			_priceType = new Bitmap();
			_priceType.x = 89;
			_priceType.y = 128;
			addChild(_priceType);
			_priceType.bitmapData = MoneyIconCaches.copperAsset;
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
			
			infoPlaceUpdateHandler(null);
		}
		
		private function addEvents():void
		{
			_consignPriceTextField.addEventListener(Event.CHANGE, onPriceChange);//监听寄售价格的改变
			_tongBiRadioBtn.group.addEventListener(Event.CHANGE, onPriceChange);//监听价格单位改变
			_combox.addEventListener(Event.CHANGE, onPriceChange);//监听寄售时间的改变
//			_myCell.addEventListener(CellEvent.CELL_MOVE,cellMoveHandler);
//			_myCell.addEventListener(MouseEvent.MOUSE_DOWN,myCellDownHandler);
//			_myCell.addEventListener(MouseEvent.CLICK,myCellClickHandler);
			
			_consignBtn.addEventListener(MouseEvent.CLICK,consignBtnHandler);
			_resetBtn.addEventListener(MouseEvent.CLICK,resetBtnHandler);
			_consignMediator.consignInfo.addEventListener(ConsignEvent.INFO_PLACE_UPDATE,infoPlaceUpdateHandler);
		}
		
		private function removeEvents():void
		{
			_consignPriceTextField.removeEventListener(Event.CHANGE, onPriceChange);
			_tongBiRadioBtn.group.removeEventListener(Event.CHANGE, onPriceChange);
			_combox.removeEventListener(Event.CHANGE, onPriceChange);
//			_myCell.removeEventListener(CellEvent.CELL_MOVE,cellMoveHandler);
//			_myCell.removeEventListener(MouseEvent.MOUSE_DOWN,myCellDownHandler);
//			_myCell.removeEventListener(MouseEvent.CLICK,myCellClickHandler);
			
			_consignBtn.removeEventListener(MouseEvent.CLICK,consignBtnHandler);
			_resetBtn.removeEventListener(MouseEvent.CLICK,resetBtnHandler);
			_consignMediator.consignInfo.removeEventListener(ConsignEvent.INFO_PLACE_UPDATE,infoPlaceUpdateHandler);
		}
		
		public function show():void
		{
			addEvents();
		}
		
		public function hide():void
		{
			resetData();
			removeEvents();
			if(parent)parent.removeChild(this);
		}
		
		private function onPriceChange(e:Event):void
		{
			var price:int = parseInt(_consignPriceTextField.text);
//			var priceType:int = _tongBiRadioBtn.selected?PriceType.COPPER : PriceType.YUANBAO;
			var priceType:int;
			if(_tongBiRadioBtn.selected)
			{
				priceType = PriceType.COPPER;
				_priceType.bitmapData = MoneyIconCaches.copperAsset;
			}
			else if(_yuanBaoRadioBtn.selected)
			{
				priceType = PriceType.YUANBAO;
				_priceType.bitmapData = MoneyIconCaches.yuanBaoAsset;
			}
//			else
//				return;
			var consignTime:Number = Number(_combox.selectedItem.value);
			var base:int;
			switch(priceType)
			{
				case PriceType.COPPER : base = Math.ceil(price/20); break;
				case PriceType.YUANBAO : base = (price * 15);break;
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
			
			if(_consignPriceTextField.text != "" && _consignPriceTextField.text != "0" && _myCell.info)
			{
				_consignBtn.enabled = true;
			}
			else
			{
				_consignBtn.enabled = false;
			}
			
		}
		
//		public function cellMoveHandler(e:CellEvent):void
//		{
//			var tmpItemInfo:ItemInfo = e.data as ItemInfo;
//			setCellInfo(tmpItemInfo);
//		}
		
		private function setCellInfo(info:ItemInfo):void
		{
			if(info && !info.isBind)
			{
				if(_myCell.itemInfo)_myCell.itemInfo.lock = false;
				_myCell.itemInfo = info;
				if(_consignPriceTextField.text != "" && _consignPriceTextField.text != "0")
				{
					_consignBtn.enabled = true;
				}
				
			}
			else
			{
				if(_myCell.itemInfo)
				{
					_myCell.itemInfo.lock = false;
				}
				resetData();
			}
		}
		
		public function dragDrop(data:IDragData):int
		{
			var action:int = DragActionType.UNDRAG;
			var source:IDragable = data.dragSource;
			var sourceInfo:ItemInfo = source.getSourceData() as ItemInfo;
			if(source == this)return action;
			if(!sourceInfo) return action;
			if(source.getSourceType() == CellType.BAGCELL)
			{
				if(sourceInfo.isBind)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.consign.consignBindItem"));
				}
				else
				{
					sourceInfo.lock = true;
					action = DragActionType.DRAGIN;
					setCellInfo(sourceInfo);
				}
			}
			return action;
		}
		
		private function resetBtnHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			resetData();
		}
		
		private function resetData():void
		{
			if(_myCell.itemInfo)
				_myCell.itemInfo.lock = false;
			_myCell.itemInfo = null;
			_combox.selectedIndex = 0;
			_consignBtn.enabled = false;
			_consignPriceTextField.text = "";
			_fareTextField.text = "0";
			_yuanBaoRadioBtn.selected = false;
			_tongBiRadioBtn.selected = false;
			_tongBiRadioBtn.group.selection = null;
			_tongBiRadioBtn.group.selectedData = null;
			_consignMediator.consignInfo.place = -1;
		}
		
		private function infoPlaceUpdateHandler(e:ConsignEvent):void
		{
			if(_consignMediator.consignInfo.place != -1)
			{
				var itemInfo:ItemInfo = GlobalData.bagInfo.getItem(_consignMediator.consignInfo.place);
				if(itemInfo.isBind)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.consign.consignBindItem"));
				}
				else
				{
					itemInfo.lock = true;
					setCellInfo(itemInfo);
				}
			}
		}
		
		private function myCellDownHandler(e:MouseEvent):void
		{
			var _tmpMyCell:ConsignItemCell = e.currentTarget as ConsignItemCell;
			if(_tmpMyCell.itemInfo)
			{
				_tmpMyCell.dragStart();
			}
		}
		
//		private function myCellClickHandler(e:MouseEvent):void{DoubleClickManager.addClick(e.currentTarget as ConsignItemCell);}
//		private function clickHandler(e:Object):void{}
		private function doubleClickHandler(cell:ConsignItemCell):void
		{
			ModuleEventDispatcher.dispatchCellEvent(new CellEvent(CellEvent.CELL_DOUBLECLICK,cell));
		}

		//点击寄售按钮
		private function consignBtnHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(!(_yuanBaoRadioBtn.selected || _tongBiRadioBtn.selected))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.consign.selectMoneyType"));
				return;
			}
			if(parseInt(_fareTextField.text) > GlobalData.selfPlayer.userMoney.copper)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotConsign"));
			}
			else
			{
				var priceType:String = _yuanBaoRadioBtn.selected?LanguageManager.getWord("ssztl.common.yuanBao2"):LanguageManager.getWord("ssztl.common.copper2");
				if(_myCell.itemInfo)
					MAlert.show(LanguageManager.getWord("ssztl.consign.isSureConsign",_consignPriceTextField.text,priceType),LanguageManager.getAlertTitle(),MAlert.OK | MAlert.CANCEL,null,closeHandler);
			}
		}
		private function closeHandler(e:CloseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
				if(e.detail == MAlert.OK)
				{
					_consignMediator.sendAddConsign(_myCell.itemInfo.place,(_tongBiRadioBtn.selected?PriceType.COPPER : PriceType.YUANBAO),Number(_consignPriceTextField.text),Number(_combox.selectedItem.value));
					resetData();
				}
		}

		private function get consignInfo():ConsignInfo
		{
			return _consignMediator.module.consignInfo;
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		public function dispose():void
		{
			removeEvents();
			if(parent)parent.removeChild(this);
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_resetBtn)
			{
				_resetBtn.dispose();
				_resetBtn = null;
			}
			if(_consignBtn)
			{
				_consignBtn.dispose();
				_consignBtn = null;
			}
			if(_myCell)
			{
				if(_myCell.itemInfo)_myCell.itemInfo.lock = false;
				_myCell.dispose();
				_myCell = null;
			}
			
			_combox = null;
//			_checkbox = null;
			_consignPriceTextField = null;
			_fareTextField = null;
			_tongBiRadioBtn = null;
			_yuanBaoRadioBtn = null;
			_consignMediator.consignInfo.place = -1;
			_consignMediator= null;
		}
	}
}