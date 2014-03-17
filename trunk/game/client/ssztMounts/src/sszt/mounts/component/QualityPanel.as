package sszt.mounts.component
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.quickBuy.BuyItemView;
	import sszt.events.CellEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.mounts.component.cells.MountsQualityCell;
	import sszt.mounts.component.cells.MountsSkillCell;
	import sszt.mounts.component.items.MountsFeedQuickStoreItem;
	import sszt.mounts.data.MountsInfo;
	import sszt.mounts.data.itemInfo.MountsFeedItemInfo;
	import sszt.mounts.event.MountsEvent;
	import sszt.mounts.mediator.MountsMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	public class QualityPanel extends Sprite
	{
		private var _mediator:MountsMediator;
		private var _bg:IMovieWrapper;
		private var _qualityItemViewVector:Array = [];
		private var _mTile:MTile;
		private var _quickStoreTile:MTile;
		private var _currentIndex:int = -1;
		private var _currentType:int = -1;
		private var _btns:Array;
		private var _types:Array;
		private var _pageView:PageView;
		
		public function QualityPanel(mediator:MountsMediator)
		{
			_mediator = mediator;
			super();
			initialView();
			initialEvents();
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,29,246,195)),
				new BackgroundInfo(BackgroundType.BORDER_13,new Rectangle(3,32,240,189)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,226,246,145)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(2,228,242,26)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(9,38,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(9,76,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(9,114,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(9,152,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(99,233,64,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.quickBuy"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT))
				
			]);
			addChild(_bg as DisplayObject);
			
			var tabNameLabels:Array = [LanguageManager.getWord("ssztl.common.all"),
				LanguageManager.getWord("ssztl.common.greenQulity2"),
				LanguageManager.getWord("ssztl.common.blueQulity2"),
				LanguageManager.getWord("ssztl.common.purpleQulity2"),
				LanguageManager.getWord("ssztl.common.orangeQulity2")];
			_types = [-1,1,2,3,4];
			var tabPoints:Array = [new Point(5,6),new Point(52,6),new Point(99,6),new Point(146,6),new Point(193,6)];
			_btns =new Array(tabNameLabels.length);
			for(var i:int = 0;i < tabNameLabels.length;i++)
			{
				_btns[i] =  new MCacheTabBtn1(0,0,tabNameLabels[i]);
				_btns[i].move(tabPoints[i].x,tabPoints[i].y);
				addChild(_btns[i]);
				_btns[i].addEventListener(MouseEvent.CLICK,btnHandler);
			}
			
			_mTile = new MTile(38,38,6);
			_mTile.itemGapW = 0;
			_mTile.itemGapH = 0;
			_mTile.horizontalScrollPolicy =_mTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_mTile.setSize(228,152);
			_mTile.move(9,38);
			addChild(_mTile);
			
			_quickStoreTile = new MTile(230,87);
			_quickStoreTile.itemGapW = 0;
			_quickStoreTile.itemGapH = 0;
			_quickStoreTile.horizontalScrollPolicy =_mTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_quickStoreTile.setSize(230,87);
			_quickStoreTile.move(8,258);
			addChild(_quickStoreTile);
			_quickStoreTile.appendItem(new MountsFeedQuickStoreItem(CategoryType.MOUNST_EXP_ITEM,ShopID.STORE));
			
			_pageView = new PageView(24);
			_pageView.move(63,195);
			addChild(_pageView);
			
			mountsInfo.initialMountsVector(qualityItemListChecker);
			setIndex(0);
		}
		
		private function initialEvents():void
		{
			mountsInfo.addEventListener(MountsEvent.CELL_QUALITY_UPDATE,updateCellhandler);
			mountsInfo.addEventListener(MountsEvent.CELL_QUALITY_ADD,addCellHandler);
			mountsInfo.addEventListener(MountsEvent.CELL_QUALITY_DELETE,deleteCellhandler);
			mountsInfo.addEventListener(MountsEvent.CELL_ALL_CLEAR,clearCellhandler);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		
		private function removeEvents():void
		{
			mountsInfo.removeEventListener(MountsEvent.CELL_QUALITY_UPDATE,updateCellhandler);
			mountsInfo.removeEventListener(MountsEvent.CELL_QUALITY_ADD,addCellHandler);
			mountsInfo.removeEventListener(MountsEvent.CELL_QUALITY_DELETE,deleteCellhandler);
			mountsInfo.removeEventListener(MountsEvent.CELL_ALL_CLEAR,clearCellhandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		
		
		private function qualityItemListChecker(argItemInfo:ItemInfo):Boolean
		{
			if(argItemInfo && argItemInfo.template.canFeed && argItemInfo.template.feedCount >0)
			{
				return true;
			}
			return false;
		}
		
		private function btnHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			var index:int = _btns.indexOf(e.currentTarget as MCacheTabBtn1);
			setIndex(index);
		}
		
		private function setIndex(argIndex:int):void
		{
			if(argIndex == _currentIndex)return;
			if(_currentIndex != -1)
			{
				_btns[_currentIndex].selected = false;
			}
			_currentIndex = argIndex;
			_currentType = _types[_currentIndex];
			_btns[_currentIndex].selected = true;
			changeTabQualityCells();
		}

		private function changeTabQualityCells():void
		{
			clearCell();
			var tmpItemView:MountsQualityCell;
			var list:Array = getListByType(_currentType,_pageView.currentPage - 1);
			for each(var i:MountsFeedItemInfo in list)
			{
				tmpItemView = new MountsQualityCell(i);
				tmpItemView.addEventListener(MouseEvent.CLICK,itemViewClickHandler);
				_qualityItemViewVector.push(tmpItemView);
				_mTile.appendItem(tmpItemView);
			}	
		}
		
		private function getListByType(type:int,pageIndex:int = 0,pageSize:int = 24):Array
		{
			var result:Array;
			if(type == -1)
				result = mountsInfo.qualityVector;
			else
			{
				result = [];
				for each(var i:MountsFeedItemInfo in mountsInfo.qualityVector)
				{
					if(i.bagItemInfo.template.quality == type)
					{
						result.push(i);
					}
				}	
			}
			_pageView.totalRecord = result.length;
			return result.slice(pageIndex * pageSize,(pageIndex + 1) * pageSize);
			
		}
		
		/**清空视图格子类**/
		private function clearCell():void
		{
			_qualityItemViewVector.length = 0;
			_mTile.disposeItems();
		}
		
		/**点击格子，改变数据**/
		private function itemViewClickHandler(e:MouseEvent):void
		{
			var tmpItemView:MountsQualityCell = e.currentTarget as MountsQualityCell;
			if(tmpItemView && tmpItemView.itemInfo)
			{
				if(MountsInfo.PAGESIZE > mountsInfo.feedItemList.length)
				{
					mountsInfo.clickHandler(tmpItemView.mountsItemInfo);
				}
			}
		}
		
		
		private function updateCellhandler(e:MountsEvent):void
		{
			var tmpItemId:Number = e.data as Number;
			var tmpMountsItemInfo:MountsFeedItemInfo = mountsInfo.getMountsItemInfoFromQualityVector(tmpItemId);
			if(tmpMountsItemInfo)
			{
				for each(var i:MountsQualityCell in _qualityItemViewVector)
				{
					if(i.mountsItemInfo.bagItemInfo.itemId  == tmpItemId)
					{
						i.mountsItemInfo = tmpMountsItemInfo;
						break;
					}
				}
			}
		}
		
		private function addCellHandler(e:MountsEvent):void
		{
			var tmpMountsItemInfo:MountsFeedItemInfo = mountsInfo.getMountsItemInfoFromQualityVector(e.data as Number);
			if(tmpMountsItemInfo)
			{
				if(tmpMountsItemInfo.bagItemInfo.template.quality == _currentType || _currentType == -1)
				{
					var tmpFurnaceItemView:MountsQualityCell = new MountsQualityCell(tmpMountsItemInfo);
					tmpFurnaceItemView.addEventListener(MouseEvent.CLICK,itemViewClickHandler);
					_qualityItemViewVector.push(tmpFurnaceItemView);
					_mTile.appendItem(tmpFurnaceItemView);
				}
			}
		}
		
		private function deleteCellhandler(e:MountsEvent):void
		{
			var tmpItemId:Number = e.data as Number;
			for(var i:int = _qualityItemViewVector.length - 1;i >= 0;i--)
			{
				if(_qualityItemViewVector[i].mountsItemInfo.bagItemInfo.itemId == tmpItemId)
				{
					_mTile.removeItem(_qualityItemViewVector[i]);
					
					_qualityItemViewVector.splice(i,1);
				}
			}
		}
		
		private function clearCellhandler(e:MountsEvent):void
		{
			clearCell();
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		private function get mountsInfo():MountsInfo
		{
			return _mediator.module.mountsInfo;
		}
		
		private function pageChangeHandler(e:PageEvent):void
		{
			changeTabQualityCells();
		}
		
		
		public function dispose():void
		{
			removeEvents();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			for each(var i:MountsQualityCell in _qualityItemViewVector)
			{
				if(i)
				{
					i.dispose();
					i.removeEventListener(MouseEvent.CLICK,itemViewClickHandler);
					i = null;
				}
			}
			_qualityItemViewVector = null;
			if(_mTile)
			{
				_mTile.disposeItems();
				_mTile.dispose();
				_mTile = null;
			}
			if(_quickStoreTile)
			{
				_quickStoreTile.disposeItems();
				_quickStoreTile.dispose();
				_quickStoreTile = null;
			}
			for each(var j:MCacheTabBtn1 in _btns)
			{
				j.dispose();
				j.removeEventListener(MouseEvent.CLICK,btnHandler);
				j = null;
			}
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			_btns = null;
			_types = null;
		}
	}
}