package sszt.box.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.box.data.BoxStoreInfo;
	import sszt.box.data.ToBagType;
	import sszt.box.events.ShenMoStoreEvent;
	import sszt.box.mediators.BoxMediator;
	import sszt.box.socketHandlers.MoveToBagSocketHandler;
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.selectBtns.MCacheSelectBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.box.StoreTitleAsset;
	import ssztui.ui.SplitCompartLine2;
	
	public class BoxStorePanel extends MPanel
	{
		private static const PAGE_SIZE:int = 60;
		
		private var _boxMediator:BoxMediator;
		private var _bg:IMovieWrapper;
		private var _allOutBtn:MCacheAssetBtn1;  //全部取出按钮
		private var _pageView:PageView;
		
		private var _tile:MTile;
		private var _cellList:Array;
		
		private var _totalField:MAssetLabel;
		
		private var _pages:Array;
		private var _pagesBtns:Array;
		private var _currentPage:int = 0;
		
		public function BoxStorePanel(mediator:BoxMediator,title:DisplayObject=null, dragable:Boolean=true, mode:Number=0.5, closeable:Boolean=true, toCenter:Boolean=true)
		{
			_boxMediator = mediator;
			super(new MCacheTitle1("",new Bitmap(new StoreTitleAsset())), true, -1, true, true);
			initEvents();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(420,326);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,4,404,314)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(13,9,394,269)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(13,277,394,25),new Bitmap(new SplitCompartLine2())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(20,16,380,38),new Bitmap(CellCaches.getCellBgPanel10())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(20,54,380,38),new Bitmap(CellCaches.getCellBgPanel10())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(20,92,380,38),new Bitmap(CellCaches.getCellBgPanel10())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(20,130,380,38),new Bitmap(CellCaches.getCellBgPanel10())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(20,168,380,38),new Bitmap(CellCaches.getCellBgPanel10())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(20,206,380,38),new Bitmap(CellCaches.getCellBgPanel10())),
			]);
			addContent(_bg as DisplayObject);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(22,252,40,16),new MAssetLabel(LanguageManager.getWord("ssztl.box.storeSize"),MAssetLabel.LABEL_TYPE20,"left")));
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(17,289,184,16),new MAssetLabel(LanguageManager.getWord("ssztl.box.toBag"),MAssetLabel.LABEL_TYPE_TAG,"left")));
			
			
			_allOutBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.box.allOut"));
			_allOutBtn.move(335,284);
			addContent(_allOutBtn);
			
			
			_pages = ["1","2","3","4","5"]; 
			_pagesBtns = new Array();
			for(var i:int = 0;i < _pages.length;i++)
			{
				var page:MCacheSelectBtn1 = new MCacheSelectBtn1(0,0,_pages[i]);
				_pagesBtns.push(page);
				_pagesBtns[i].move(269+i*26,249);
				addContent(page);	
			}
			_pagesBtns[_currentPage].selected = true;
			
			
//			_pageView = new PageView(PAGE_SIZE);
//			_pageView.move(173,286);
//			_pageView.totalRecord = ShenMoStoreInfo.MAX_SIZE;
//			addContent(_pageView);
			
			_tile = new MTile(38,38,10);
			_tile.itemGapH = 0;
			_tile.itemGapW = 0;
			_tile.setSize(380,228);
			_tile.move(20,16);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
		
			_cellList = new Array();
			addContent(_tile);
			
			_totalField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,"left");
			_totalField.move(58,252);
			_totalField.setSize(60,16);
			addContent(_totalField);
			
			initItems();
		}
		

		
		private function initEvents():void
		{
			
			_boxMediator.boxModule.shenmoStoreInfo.addEventListener(ShenMoStoreEvent.ADD_ITEM,addItemHandler);
			_boxMediator.boxModule.shenmoStoreInfo.addEventListener(ShenMoStoreEvent.REMOVE_ITEM,removeItemHandler);
			_boxMediator.boxModule.shenmoStoreInfo.addEventListener(ShenMoStoreEvent.ITEM_UPDATE,itemUpdateHandler);
			_boxMediator.boxModule.shenmoStoreInfo.addEventListener(ShenMoStoreEvent.CLEAR,clearHandler);
			
			_allOutBtn.addEventListener(MouseEvent.CLICK,allToBagHandler);
			
			for(var i:int=0;i<_pagesBtns.length;i++)
			{
				_pagesBtns[i].addEventListener(MouseEvent.CLICK,changePage);
				_pagesBtns[i].addEventListener(MouseEvent.MOUSE_OVER,pageBtnOverHandler);
			}
			
		}
		
		private function removeEvents():void
		{
			
			_boxMediator.boxModule.shenmoStoreInfo.removeEventListener(ShenMoStoreEvent.ADD_ITEM,addItemHandler);
			_boxMediator.boxModule.shenmoStoreInfo.removeEventListener(ShenMoStoreEvent.REMOVE_ITEM,removeItemHandler);
			_boxMediator.boxModule.shenmoStoreInfo.removeEventListener(ShenMoStoreEvent.ITEM_UPDATE,itemUpdateHandler);
			_boxMediator.boxModule.shenmoStoreInfo.removeEventListener(ShenMoStoreEvent.CLEAR,clearHandler);
			
			_allOutBtn.removeEventListener(MouseEvent.CLICK,allToBagHandler);
			
			for(var i:int=0;i<_pagesBtns.length;i++)
			{
				_pagesBtns[i].removeEventListener(MouseEvent.CLICK,changePage);
				_pagesBtns[i].removeEventListener(MouseEvent.MOUSE_OVER,pageBtnOverHandler);
			}
			
		}
		
		private function changePage(evt:Event):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			setCurrentPageSelect(_pagesBtns.indexOf(evt.currentTarget));	
		}
		
		private function pageBtnOverHandler(evt:MouseEvent):void
		{
			if(GlobalData.bagInfo.currentDrag != null)
			{
				setCurrentPageSelect(_pagesBtns.indexOf(evt.currentTarget));
			}
		}
		
		private function setCurrentPageSelect(pageIndex:int):void
		{
			if(_currentPage == pageIndex) return;
			_pagesBtns[0].selected = _pagesBtns[1].selected = _pagesBtns[2].selected = _pagesBtns[3].selected = _pagesBtns[4].selected = false;
			_pagesBtns[pageIndex].selected = true;
			_currentPage = pageIndex;
			initItems();
		}
		
		
		
		private function initItems():void
		{
			clearHandler(null);
			var list:Array = _boxMediator.boxModule.shenmoStoreInfo.getItemsByPage(_currentPage + 1,60);
			for each(var i:ItemInfo in list)
			{
				addItem(i);
			}
			_totalField.text = _boxMediator.boxModule.shenmoStoreInfo.getItemsCount().toString() + "/" + BoxStoreInfo.MAX_SIZE.toString();
		}
		private function addItemHandler(evt:ShenMoStoreEvent):void
		{
			addItem(evt.data as ItemInfo);
		}
		private function addItem(info:ItemInfo):void
		{
			var cell:StoreItemCell = new StoreItemCell();
			cell.itemInfo = info;
			cell.addEventListener(MouseEvent.CLICK,cellClickHandler);
			_cellList.push(cell);
			_tile.sortOn(["templateId"],[Array.NUMERIC|Array.DESCENDING]);
			_tile.appendItem(cell);
			_totalField.text = _boxMediator.boxModule.shenmoStoreInfo.getItemsCount().toString() + "/" + BoxStoreInfo.MAX_SIZE.toString();
		}
		private function removeItemHandler(evt:ShenMoStoreEvent):void
		{
			removeItem(Number(evt.data));
		}
		private function removeItem(id:Number):void
		{
			var item:StoreItemCell;
			for(var i:int = _cellList.length - 1; i >= 0; i--)
			{
				if(_cellList[i] && _cellList[i].itemInfo && _cellList[i].itemInfo.itemId == id)
				{
					item = _cellList.splice(i,1)[0];
					break;
				}
			}
			if(item)
			{
				_tile.removeItem(item);
				item.removeEventListener(MouseEvent.CLICK,cellClickHandler);
				item.dispose();
				_totalField.text = _boxMediator.boxModule.shenmoStoreInfo.getItemsCount().toString() + "/" + BoxStoreInfo.MAX_SIZE.toString();
			}
		}
		private function itemUpdateHandler(evt:ShenMoStoreEvent):void
		{
			var id:Number = Number(evt.data);
			for each(var i:StoreItemCell in _cellList)
			{
				if(i && i.itemInfo && i.itemInfo.itemId == id)
				{
					i.updateCount();
					break;
				}
			}
		}
		private function clearHandler(evt:ShenMoStoreEvent):void
		{
			_tile.disposeItems();
			_cellList.length = 0;
			_totalField.text = _boxMediator.boxModule.shenmoStoreInfo.getItemsCount().toString() + "/" + BoxStoreInfo.MAX_SIZE.toString();
		}
		
//		private function itemUpdateHandler(evt:ShenMoStoreEvent):void
//		{
//			_totalField.text = _boxMediator.boxModule.shenmoStoreInfo.getItemsCount().toString() + "/" + ShenMoStoreInfo.MAX_SIZE.toString();
//			var place:int = evt.data as int;
//			if(place>=(_pageView.currentPage-1)* PAGE_SIZE && place<_pageView.currentPage * PAGE_SIZE)
//			{
//				_cellList[place%PAGE_SIZE].itemInfo = _boxMediator.boxModule.shenmoStoreInfo.getItem(place);
//			}
//		}
		
		private function allToBagHandler(evt:MouseEvent):void
		{
			if(_boxMediator.boxModule.shenmoStoreInfo.getItemsCount() == 0)
			{
				return;
			}
			else if(GlobalData.bagInfo.currentSize >= GlobalData.selfPlayer.bagMaxCount)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagFull"));
			}
			else
			{
				MoveToBagSocketHandler.sendMoveToBag(ToBagType.ALL,0);
			}
		}
		
//		private function pageChangeHandler(evt:PageEvent):void
//		{
//			initItems();
//		}
		
		private function cellClickHandler(evt:MouseEvent):void
		{
//			_boxMediator.boxModule.shenmoStoreInfo.addItem(GlobalData.bagInfo._itemList[50]);
			var cell:StoreItemCell = evt.currentTarget as StoreItemCell;
			if(GlobalData.bagInfo.currentSize >= GlobalData.selfPlayer.bagMaxCount)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagFull"));
			}
			else if(cell.itemInfo)
			{
//				var place:int = _cellList.indexOf(cell);
//				var index:int = (_pageView.currentPage-1)*PAGE_SIZE + place;
//				var item:ItemInfo = _boxMediator.boxModule.shenmoStoreInfo.itemList[index];
				
				MoveToBagSocketHandler.sendMoveToBag(ToBagType.SINGLE,cell.itemInfo.itemId);
			}
		}
		
		override public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_allOutBtn)
			{
				_allOutBtn.dispose();
				_allOutBtn = null;
			}
			
			if(_pagesBtns)
			{
				for( var j:int=0;j<_pagesBtns.length;j++)
				{
					_pagesBtns[j].dispose();
				}
				_pagesBtns = null;
			}
//			if(_pageView)
//			{
//				_pageView.dispose();
//				_pageView = null;
//			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_cellList)
			{
				for each(var cell:StoreItemCell in _cellList)
				{
					cell.dispose();
				}
				cell = null;
				_cellList = null;
			}
			super.dispose();
			_boxMediator = null;
		}
	}
}
