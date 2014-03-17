package sszt.stall.compoments
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset4Btn;
	import sszt.ui.mcache.btns.MCacheAsset5Btn;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.labelField.MLabelField2Bg;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.ClientBagInfo;
	import sszt.core.data.bag.ClientBagInfoUpdateEvent;
	import sszt.core.data.bag.StallShopBuySaleInfo;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.stall.StallBuyCellInfo;
	import sszt.core.doubleClicks.DoubleClickManager;
	import sszt.core.doubleClicks.IDoubleClick;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.cell.CellType;
	import sszt.events.CellEvent;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.stall.StallModule;
	import sszt.stall.compoments.cell.StallShoppingBegBuyCell;
	import sszt.stall.compoments.cell.StallShoppingBegSaleCell;
	import sszt.stall.compoments.cell.StallShoppingBuyCell;
	import sszt.stall.compoments.cell.StallShoppingSaleCell;
	import sszt.stall.compoments.emptyCell.StallShopBegSaleCellEmpty;
	import sszt.stall.compoments.emptyCell.StallShopBuyCellEmpty;
	import sszt.stall.compoments.emptyCell.StallShopSaleCellEmpty;
	import sszt.stall.data.StallShopEvents;
	import sszt.stall.data.StallShopInfo;
	import sszt.stall.mediator.StallMediator;
	
	public class StallShopPanel extends MPanel
	{
		private var _stallMediator:StallMediator;
		private var _bg:IMovieWrapper;
		
		private var _messageBtn:MCacheAsset4Btn;
		private var _buyBtn:MCacheAsset4Btn;
		private var _saleBtn:MCacheAsset4Btn;
		private var _stallNameTextField:TextField;
		private var _buyPriceTextField:TextField;
		private var _salePriceTextField:TextField;
		private var _messageTextField:TextField;
		
		private var _stallBuyTile:MTile;
		private var _stallSaleTile:MTile;
		private var _stallShoppingBuyTile:MTile;
		private var _stallShoppingSaleTile:MTile;
		
//		public var _stallBuyCellVector:Vector.<StallShoppingBegBuyCell> = new Vector.<StallShoppingBegBuyCell>(StallShopInfo.PAGE_SIZE);
//		public var _stallSaleCellVector:Vector.<StallShoppingBegSaleCell> = new Vector.<StallShoppingBegSaleCell>(StallShopInfo.PAGE_SIZE);
//		public var _stallShoppingBuyVector:Vector.<StallShoppingBuyCell> = new Vector.<StallShoppingBuyCell>(StallShopInfo.PAGE_SIZE);
//		public var _stallShoppingSaleVector:Vector.<StallShoppingSaleCell> = new Vector.<StallShoppingSaleCell>(StallShopInfo.PAGE_SIZE);
		public var _stallBuyCellVector:Array = new Array(StallShopInfo.PAGE_SIZE);
		public var _stallSaleCellVector:Array = new Array(StallShopInfo.PAGE_SIZE);
		public var _stallShoppingBuyVector:Array = new Array(StallShopInfo.PAGE_SIZE);
		public var _stallShoppingSaleVector:Array = new Array(StallShopInfo.PAGE_SIZE);
		
		private var _stallShopBegSaleCellEmpty:StallShopBegSaleCellEmpty;
		private var _stallShopBuyCellEmpty:StallShopBuyCellEmpty;
		private var _stallShopSaleCellEmpty:StallShopSaleCellEmpty;
		
		public function StallShopPanel(stallMediator:StallMediator)
		{
			_stallMediator = stallMediator;
			super(new MCacheTitle1("摆摊店面"),true,-1,true,false);
			this.move(26,62);
			initialEvents();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(506,379);
			_bg = BackgroundUtils.setBackground([
						new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,252,379)),
						new BackgroundInfo(BackgroundType.BAR_4,new Rectangle(3,33,244,24)),
						
						new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,60,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
						new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,98,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
						new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,136,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
						new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,179,250,2),new MCacheSplit2Line()),
						new BackgroundInfo(BackgroundType.BAR_4,new Rectangle(3,182,244,24)),
					
						new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,223,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
						new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,261,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
						new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,299,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
						new BackgroundInfo(BackgroundType.BAR_5,new Rectangle(13,344,182,22)),
						
						new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(254,0,252,379)),
						new BackgroundInfo(BackgroundType.BAR_4,new Rectangle(258,33,244,24)),
						
						new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(265,60,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
						new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(265,98,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
						new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(265,136,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
						new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(267,181,169,22),new MLabelField2Bg(169,105)),
						
						new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(255,214,250,2),new MCacheSplit2Line()),
						new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(265,223,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
						new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(265,261,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
						new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(265,299,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
						new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(267,344,169,22),new MLabelField2Bg(169,105)),
				]);
			
			addContent(_bg as DisplayObject);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(53,6,144,25),new MCacheTitle1("")));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(137,10,46,21),new MAssetLabel("的摊位",MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(12,37,76,19),new MAssetLabel("出售物品列表",MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(10,184,76,19),new MAssetLabel("收购物品列表",MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(12,206,196,19),new MAssetLabel("出售物品从背包拖动到右边格子栏上",MAssetLabel.LABELTYPE8)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(307,6,144,25),new MCacheTitle1("购物篮")));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(263,37,124,19),new MAssetLabel("购买物品从左拖动至此",MAssetLabel.LABELTYPE8)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(280,183,36,19),new MAssetLabel("金币",MAssetLabel.LABELTYPE2)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(280,348,36,19),new MAssetLabel("金币",MAssetLabel.LABELTYPE2)));
										
			_messageBtn = new MCacheAsset4Btn(0,"留言");
			_messageBtn.labelField.setTextFormat(new TextFormat("宋体",12,0xFAC951));
			_messageBtn.move(200,346);
			addContent(_messageBtn);
			
			_buyBtn = new MCacheAsset4Btn(0,"购买");
			_buyBtn.labelField.setTextFormat(new TextFormat("宋体",12,0xFAC951));
			_buyBtn.move(441,183);
			addContent(_buyBtn);
			
			_saleBtn = new MCacheAsset4Btn(0,"出售");
			_saleBtn.labelField.setTextFormat(new TextFormat("宋体",12,0xFAC951));
			_saleBtn.move(441,345);
			addContent(_saleBtn);
			
			_stallNameTextField = new TextField();
			_stallNameTextField.textColor = 0xFDE268;
			_stallNameTextField.autoSize = TextFieldAutoSize.RIGHT;
			_stallNameTextField.text = _stallMediator.stallModule.userName;
			_stallNameTextField.x = 65;
			_stallNameTextField.y = 10;
			_stallNameTextField.width = 69;
			_stallNameTextField.height = 22;
			_stallNameTextField.filters = [new GlowFilter(0x2B3832,1,2,2,4.5)];
			addContent(_stallNameTextField);
			
			_buyPriceTextField = new TextField();
			_buyPriceTextField.textColor = 0xFFFFFF;
			_buyPriceTextField.autoSize = TextFieldAutoSize.LEFT;
			_buyPriceTextField.text = "0";
			_buyPriceTextField.x = 335;
			_buyPriceTextField.y = 180;
			_buyPriceTextField.width = 140;
			_buyPriceTextField.height = 20;
			_buyPriceTextField.filters = [new GlowFilter(0x000000,1,2,2,10)];
			addContent(_buyPriceTextField);
			
			
			_salePriceTextField = new TextField();
			_salePriceTextField.textColor = 0xFFFFFF;
			_salePriceTextField.autoSize = TextFieldAutoSize.LEFT;
			_salePriceTextField.text = "0";
			_salePriceTextField.x = 335;
			_salePriceTextField.y = 345;
			_salePriceTextField.width = 140;
			_salePriceTextField.height = 20;
			_salePriceTextField.filters = [new GlowFilter(0x000000,1,2,2,10)];
			addContent(_salePriceTextField);
			
			_messageTextField = new TextField();
			_messageTextField.textColor = 0xFFFFFF;
//			_messageTextField.autoSize = TextFieldAutoSize.LEFT;
			_messageTextField.type = "input";
			_messageTextField.text = "";
			_messageTextField.x = 16;
			_messageTextField.y = 345;
			_messageTextField.width = 180;
			_messageTextField.height = 20;
			_messageTextField.filters = [new GlowFilter(0x000000,1,2,2,10)];
			addContent(_messageTextField);
			
			 _stallSaleTile = new MTile(38,38,6);
			 _stallSaleTile.itemGapH = _stallSaleTile.itemGapW = 0;
			 _stallSaleTile.setSize(228,114);
			 _stallSaleTile.move(13,61);
			 addContent(_stallSaleTile);
			 
			 
			 _stallBuyTile = new MTile(38,38,6);
			 _stallBuyTile.itemGapH = _stallBuyTile.itemGapW = 0;
			 _stallBuyTile.setSize(228,114);
			 _stallBuyTile.move(13,224);
			 addContent(_stallBuyTile);
			 
			 _stallShoppingBuyTile = new MTile(38,38,6);
			 _stallShoppingBuyTile.itemGapH = _stallShoppingBuyTile.itemGapW = 0;
			 _stallShoppingBuyTile.setSize(228,114);
			 _stallShoppingBuyTile.move(266,61);
			 addContent(_stallShoppingBuyTile);
			 
			 _stallShoppingSaleTile = new MTile(38,38,6);
			 _stallShoppingSaleTile.itemGapH = _stallShoppingSaleTile.itemGapW = 0;
			 _stallShoppingSaleTile.setSize(228,114);
			 _stallShoppingSaleTile.move(266,224);
			 addContent(_stallShoppingSaleTile);
			 
			 var tmpStallBuyCell:StallShoppingBegBuyCell;
			 var tmpStallSaleCell:StallShoppingBegSaleCell;
			 var tmpStallShoppingBuyCell:StallShoppingBuyCell;
			 var tmpStallShoppingSaleCell:StallShoppingSaleCell;
			 
			for(var i:int = 0;i<StallShopInfo.PAGE_SIZE;i++)
			{
				tmpStallBuyCell = new StallShoppingBegBuyCell(click,doubleClick);
				_stallBuyCellVector[i] = tmpStallBuyCell;
				_stallBuyCellVector[i].stallBuyInfo = null;
				_stallBuyTile.appendItem(tmpStallBuyCell);
				
				tmpStallSaleCell = new StallShoppingBegSaleCell(click,doubleClick);
				tmpStallSaleCell.addEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
				tmpStallSaleCell.addEventListener(MouseEvent.CLICK,cellClickHandler);
				_stallSaleCellVector[i] = tmpStallSaleCell;
				_stallSaleCellVector[i].itemInfo = null;
				_stallSaleTile.appendItem(tmpStallSaleCell);
				
				tmpStallShoppingBuyCell = new StallShoppingBuyCell(click,doubleClick);
				tmpStallShoppingBuyCell.addEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
				tmpStallShoppingBuyCell.addEventListener(MouseEvent.CLICK,cellClickHandler);
				_stallShoppingBuyVector[i] = tmpStallShoppingBuyCell;
				_stallShoppingBuyVector[i].itemInfo = null;
				_stallShoppingBuyTile.appendItem(tmpStallShoppingBuyCell);
				
				tmpStallShoppingSaleCell = new StallShoppingSaleCell(click,doubleClick);
				tmpStallShoppingSaleCell.addEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
				tmpStallShoppingSaleCell.addEventListener(MouseEvent.CLICK,cellClickHandler);
				_stallShoppingSaleVector[i] = tmpStallShoppingSaleCell;
				_stallShoppingSaleVector[i].itemInfo = null;
				_stallShoppingSaleTile.appendItem(tmpStallShoppingSaleCell);
			}
			
			_stallShopBegSaleCellEmpty = new StallShopBegSaleCellEmpty();
			_stallShopBegSaleCellEmpty.move(12,60);
			addContent(_stallShopBegSaleCellEmpty);
			_stallShopBuyCellEmpty = new StallShopBuyCellEmpty();
			_stallShopBuyCellEmpty.move(265,60);
			addContent(_stallShopBuyCellEmpty);
			_stallShopSaleCellEmpty = new StallShopSaleCellEmpty();
			_stallShopSaleCellEmpty.move(265,223);
			addContent(_stallShopSaleCellEmpty);
			
		}
		
		private function click(cell:IDragable):void
		{
//			GlobalAPI.dragManager.startDrag(cell);
		}
		
		private function doubleClick(cell:IDragable):void
		{
			ModuleEventDispatcher.dispatchCellEvent(new CellEvent(CellEvent.CELL_DOUBLECLICK,cell));
		}
		
		private function cellDownHandler(e:MouseEvent):void
		{
			var cell:BaseItemInfoCell = e.currentTarget as BaseItemInfoCell;
			var tmpData:ItemInfo = cell.itemInfo;
			if(tmpData&&!cell.locked)
			{
				GlobalAPI.dragManager.startDrag(cell);
			}
		}
		
		private function cellClickHandler(e:MouseEvent):void
		{
			var cell:BaseItemInfoCell = e.currentTarget as BaseItemInfoCell;
			var tmpData:ItemInfo = cell.itemInfo;
			if(tmpData&&!cell.locked)
			{
				DoubleClickManager.addClick(e.currentTarget as IDoubleClick);
			}
		}
		
		private function cellMoveDataHandler(e:CellEvent):void
		{
			if(e.currentTarget is StallShopBegSaleCellEmpty)
			{
//				_stallMediator.showStallShopBegSalePopUpPanel(e.data as ItemInfo);
				var tmpShopBuyItmeInfo:ItemInfo = e.data as ItemInfo;
				var tmpBegSale:ItemInfo = stallShopInfo.getItemInfoFromStallBegSaleVector(tmpShopBuyItmeInfo.place);
				tmpBegSale.lock = false;
				stallShopInfo.removeFromShoppingBuyVector(tmpShopBuyItmeInfo.place);
			}
			else if(e.currentTarget is StallShopBuyCellEmpty)
			{
				_stallMediator.showStallShopBuyPopUpPanel(e.data as ItemInfo);
			}
			else if(e.currentTarget is StallShopSaleCellEmpty)
			{
				//判断是否是求购物品
				var tmpItemInfo:ItemInfo = e.data as ItemInfo;
				var tmp:StallBuyCellInfo = null;
				tmp = stallShopInfo.getStallBuyCellInfoFromStallBegBuyVector(tmpItemInfo.templateId);
				if(tmp)
				{
					if(tmp.num == GlobalData.clientBagInfo.getSameItemCountFromShoppingBuyVector(tmpItemInfo.templateId))
					{
						MAlert.show("求购数量已满！");
					}
					else
					{
						_stallMediator.showStallShopSalePopUpPanel(tmpItemInfo);
					}
				}
				else
				{
					MAlert.show("不是求购物品不能求购！","警告");
				}
			}
		}
		
		private function  initialEvents():void
		{
			_messageBtn.addEventListener(MouseEvent.CLICK,messageBtnClickHandler);
			_buyBtn.addEventListener(MouseEvent.CLICK,buyBtnClickHandler)
			_saleBtn.addEventListener(MouseEvent.CLICK,saleBtnClickHandler);
			
			_stallShopBegSaleCellEmpty.addEventListener(CellEvent.CELL_MOVE,cellMoveDataHandler);
			_stallShopBuyCellEmpty.addEventListener(CellEvent.CELL_MOVE,cellMoveDataHandler);
			_stallShopSaleCellEmpty.addEventListener(CellEvent.CELL_MOVE,cellMoveDataHandler);
			
			stallShopInfo.addEventListener(StallShopEvents.STALLSHOP_BEG_SALE_VECTOR_UPDATE,shopBegSaleUpdateHandler);
			stallShopInfo.addEventListener(StallShopEvents.STALLSHOP_BEG_BUY_VECTOR_UPDATE,shopBegBuyUpdateHandler);
			stallShopInfo.addEventListener(StallShopEvents.STALLSHOP_BUY_VECTOR_UPDATE,shopBuyUpdateHandler);
			GlobalData.clientBagInfo.addEventListener(ClientBagInfoUpdateEvent.STALL_SHOPPING_SALE_VECTOR_UPDATE,shopSaleUpdateHandler);
		}
		
		private function removeEvents():void
		{
			_messageBtn.removeEventListener(MouseEvent.CLICK,messageBtnClickHandler);
			_buyBtn.removeEventListener(MouseEvent.CLICK,buyBtnClickHandler)
			_saleBtn.removeEventListener(MouseEvent.CLICK,saleBtnClickHandler);
			
			_stallShopBegSaleCellEmpty.removeEventListener(CellEvent.CELL_MOVE,cellMoveDataHandler);
			_stallShopBuyCellEmpty.removeEventListener(CellEvent.CELL_MOVE,cellMoveDataHandler);
			_stallShopSaleCellEmpty.removeEventListener(CellEvent.CELL_MOVE,cellMoveDataHandler);
			
			stallShopInfo.removeEventListener(StallShopEvents.STALLSHOP_BEG_SALE_VECTOR_UPDATE,shopBegSaleUpdateHandler);
			stallShopInfo.removeEventListener(StallShopEvents.STALLSHOP_BEG_BUY_VECTOR_UPDATE,shopBegBuyUpdateHandler);
			stallShopInfo.removeEventListener(StallShopEvents.STALLSHOP_BUY_VECTOR_UPDATE,shopBuyUpdateHandler);
			GlobalData.clientBagInfo.removeEventListener(ClientBagInfoUpdateEvent.STALL_SHOPPING_SALE_VECTOR_UPDATE,shopSaleUpdateHandler);
		}
		
		private function shopBegSaleUpdateHandler(e:StallShopEvents):void
		{
			var tempPlace:int = e._data as int;
			var tempItemInfo:ItemInfo = stallShopInfo.getItemInfoFromStallBegSaleVector(tempPlace);
			var isExist:Boolean = false;
			
			for each(var i:StallShoppingBegSaleCell in _stallSaleCellVector)
			{
				if(i.itemInfo)
				{
					if(i.itemInfo.place == tempPlace)
					{
						i.itemInfo = tempItemInfo;
						isExist = true;
						break;
					}
				}
			}
			
			if(!isExist)
			{
				for each(var j:StallShoppingBegSaleCell in _stallSaleCellVector)
				{
					if(!j.itemInfo)
					{
						j.itemInfo = tempItemInfo;
						break;
					}
				}
			}
		}
		
		private function shopBegBuyUpdateHandler(e:StallShopEvents):void
		{
			var tempTemplateId:int = e._data as int;
			var tempStallBuyCellInfo:StallBuyCellInfo = stallShopInfo.getStallBuyCellInfoFromStallBegBuyVector(tempTemplateId);
			var isExist:Boolean = false;
			
			for each(var i:StallShoppingBegBuyCell in _stallBuyCellVector)
			{
				if(i.stallBuyInfo)
				{
					if(i.stallBuyInfo.templateId == tempTemplateId)
					{
						i.stallBuyInfo = tempStallBuyCellInfo;
						isExist = true;
						break;
					}
				}
			}
			
			if(!isExist)
			{
				for each(var j:StallShoppingBegBuyCell in _stallBuyCellVector)
				{
					if(!j.stallBuyInfo)
					{
						j.stallBuyInfo = tempStallBuyCellInfo;
						break;
					}
				}
			}
		}
		
		private function shopBuyUpdateHandler(e:StallShopEvents):void
		{
			var tempPlace:int = e._data as int;
			var tempStallShopBuyInfo:StallShopBuySaleInfo = stallShopInfo.getStallShopBuyInfoFromShoppingBuyVector(tempPlace);
			var isExist:Boolean = false;
			
			for each(var i:StallShoppingBuyCell in _stallShoppingBuyVector)
			{
				if(i.stallShopBuyInfo)
				{
					if(i.itemInfo.place == tempPlace)
					{
						i.stallShopBuyInfo = tempStallShopBuyInfo;
						isExist = true;
						break;
					}
				}
			}
			
			if(!isExist)
			{
				for each(var j:StallShoppingBuyCell in _stallShoppingBuyVector)
				{
					if(!j.stallShopBuyInfo)
					{
						j.stallShopBuyInfo = tempStallShopBuyInfo;
						break;
					}
				}
			}
			updateShopBuyPrice();
		}
		
		private function shopSaleUpdateHandler(e:ClientBagInfoUpdateEvent):void
		{
			var tempPlace:int = e.data as int;
			var tempStallShopBuySaleInfo:StallShopBuySaleInfo = GlobalData.clientBagInfo.getStallShopBuySaleInfoFromStallShoppingSaleVector(tempPlace);
			var isExist:Boolean = false;
			
			for each(var i:StallShoppingSaleCell in _stallShoppingSaleVector)
			{
				if(i.stallShopSaleInfo)
				{
					if(i.itemInfo.place == tempPlace)
					{
						i.stallShopSaleInfo = tempStallShopBuySaleInfo;
						isExist = true;
						break;
					}
				}
			}
			
			if(!isExist)
			{
				for each(var j:StallShoppingSaleCell in _stallShoppingSaleVector)
				{
					if(!j.stallShopSaleInfo)
					{
						j.stallShopSaleInfo = tempStallShopBuySaleInfo;
						break;
					}
				}
			}
			updateShopSalePrice();
		}
		
		private function updateShopSalePrice():void
		{
			_salePriceTextField.text = stallShopInfo.getAllPriceFromShoppingSaleVector().toString();
		}
		
		private function updateShopBuyPrice():void
		{
			_buyPriceTextField.text = stallShopInfo.getAllPriceFromShoppingBuyVector().toString();
		}
		
		private function messageBtnClickHandler(e:Event):void
		{
			if(_messageTextField.text == "")
			{
				MAlert.show("你还没有输入任何信息喔!");
			}
			else
			{
				_stallMediator.sendStallShopMessage(_messageTextField.text);
				_messageTextField.text = "";
			}
		}
		
		private function buyBtnClickHandler(e:Event):void
		{
			if(stallShopInfo.shoppingBuyVector.length <= 0)
			{
				MAlert.show("你还没购买物品喔!");
			}
			else
			{
				_stallMediator.sendStallShopBuy();
			}
		}
		
		private function saleBtnClickHandler(e:Event):void
		{
			if(GlobalData.clientBagInfo.stallShoppingSaleVector.length <= 0)
			{
				MAlert.show("你还没有出售物品喔!");
			}
			else
			{
				_stallMediator.sendStallShopSale();
			}
		}
		
		private function get stallShopInfo():StallShopInfo
		{
			return stallModule.stallShopInfo;
		}
		
		private function get stallModule():StallModule
		{
			return _stallMediator.stallModule;
		}

		override public function dispose():void
		{
			removeEvents();
			GlobalData.clientBagInfo.unLockItemInfoFromStallShoppingSaleVector();
			stallShopInfo.clearAllVector();
			_stallMediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_messageBtn)
			{
				_messageBtn.dispose()
				_messageBtn = null;
			}
			if(_buyBtn)
			{
				_buyBtn.dispose()
				_buyBtn = null;
			}
			if(_saleBtn)
			{
				_saleBtn.dispose();
				_saleBtn = null;
			}
			_buyPriceTextField = null;
			_salePriceTextField = null;
			_messageTextField = null;
			_stallNameTextField = null;
			if(_stallBuyTile)
			{
				_stallBuyTile.dispose();
				_stallBuyTile = null;
			}
			if(_stallSaleTile)
			{
				_stallSaleTile.dispose();
				_stallSaleTile = null;
			}
			if(_stallShoppingBuyTile)
			{
				_stallShoppingBuyTile.dispose();
				_stallShoppingBuyTile = null;
			}
			if(_stallShoppingSaleTile)
			{
				_stallShoppingSaleTile.dispose();
				_stallShoppingSaleTile = null;
			}
			
			for(var i:int = 0;i<StallShopInfo.PAGE_SIZE;i++)
			{
				if(_stallBuyCellVector[i])
				{
					_stallBuyCellVector[i].dispose();
					_stallBuyCellVector[i] = null;
				}
				
				if(_stallSaleCellVector[i])
				{
					_stallSaleCellVector[i].dispose();
					_stallSaleCellVector[i] = null;
				}
				
				if(_stallShoppingBuyVector[i])
				{
					_stallShoppingBuyVector[i].dispose();
					_stallShoppingBuyVector[i] = null;
				}
				
				if(_stallShoppingBuyVector[i])
				{
					_stallShoppingBuyVector[i].dispose();
					_stallShoppingBuyVector[i] = null;
				}
			}
			_stallBuyCellVector = null;
			_stallSaleCellVector = null;
			_stallShoppingBuyVector = null;
			_stallShoppingSaleVector = null;
			
			if(_stallShopBegSaleCellEmpty)
			{
				_stallShopBegSaleCellEmpty.dispose();
				_stallShopBegSaleCellEmpty = null;
			}
			if(_stallShopBuyCellEmpty)
			{
				_stallShopBuyCellEmpty.dispose();
				_stallShopBuyCellEmpty = null
			}
			if(_stallShopSaleCellEmpty)
			{
				_stallShopSaleCellEmpty.dispose();
				_stallShopSaleCellEmpty = null;
			}
			super.dispose();
		}

		
	}
}