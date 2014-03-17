package sszt.furnace.components.materialTabPanel
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.furnace.parametersList.StoneMatchTemplateList;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.furnace.components.item.FurnaceQucikBuyItemView;
	import sszt.furnace.data.FurnaceInfo;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.events.FuranceEvent;
	import sszt.furnace.mediators.FurnaceMediator;
	import sszt.ui.container.MTile;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;

	public class MaterialQuickBuyTabPanel extends Sprite  implements IMaterialTabPanel
	{
		private var _furnaceMediator:FurnaceMediator;
//		private var _quickBuyItemViewVector:Vector.<FurnaceQucikBuyItemView> = new Vector.<FurnaceQucikBuyItemView>();
		private var _quickBuyItemViewVector:Array = [];
		private var _quickMTile:MTile;
		private var _pageView:PageView;
		
		public function MaterialQuickBuyTabPanel(argMediator:FurnaceMediator)
		{
			_furnaceMediator = argMediator;
			initialView();
			initialEvents();
		}
		
		private function initialView():void
		{
			_quickMTile = new MTile(120,48,2);
			_quickMTile.itemGapW = 1;
			_quickMTile.itemGapH = 2;
			_quickMTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_quickMTile.verticalLineScrollSize = 42;
			_quickMTile.setSize(242,100);
			_quickMTile.move(3,28);
			addChild(_quickMTile);
			
			_pageView = new PageView(4,false,90);
			_pageView.move(80,130);
			addChild(_pageView);
		}
		
		private function initialEvents():void
		{
			furnaceInfo.addEventListener(FuranceEvent.CELL_QUICKBUY_INITIAL,initialData);
			furnaceInfo.addEventListener(FuranceEvent.CELL_EQUIP_UPDATE,cellClickHandler);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		
		private function removeEvents():void
		{
			furnaceInfo.removeEventListener(FuranceEvent.CELL_QUICKBUY_INITIAL,initialData);
			furnaceInfo.removeEventListener(FuranceEvent.CELL_EQUIP_UPDATE,cellClickHandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		
		/**大切卡时加载数据**/
		private function initialData(e:FuranceEvent):void
		{
			setData();
		}
		
		
		private function setData():void
		{
			clearCells();
			var argBuyType:int = furnaceInfo.currentBuyType;
			var tmpQuickItemView:FurnaceQucikBuyItemView;
			if(argBuyType >= 0)
			{
				
				var list:Array = getListByType(argBuyType, _pageView.currentPage - 1);				
				for each(var j:ShopItemInfo in list)
				{
					if(furnaceInfo.currentEquipCategoryId == -1)
					{
						tmpQuickItemView = new FurnaceQucikBuyItemView(j);
						_quickBuyItemViewVector.push(tmpQuickItemView);
						_quickMTile.appendItem(tmpQuickItemView);
					}
					else if(StoneMatchTemplateList.getStoneMatchInfo(furnaceInfo.currentEquipCategoryId).stoneList.indexOf(j.template.categoryId) >= 0)
					{
						tmpQuickItemView = new FurnaceQucikBuyItemView(j);
						_quickBuyItemViewVector.push(tmpQuickItemView);
						_quickMTile.appendItem(tmpQuickItemView);
					}
				}	
			}
		}
		
		private function getListByType(type:int,pageIndex:int = 0,pageSize:int = 4):Array
		{
			var result:Array;
			result = [];
			for each(var j:ShopItemInfo in ShopTemplateList.shopList[ShopID.FURNACE_QUICK_BUY].shopItemInfos[type])
			{
				if(furnaceInfo.currentEquipCategoryId == -1)
				{
					result.push(j);
				}
				else if(StoneMatchTemplateList.getStoneMatchInfo(furnaceInfo.currentEquipCategoryId).stoneList.indexOf(j.template.categoryId) >= 0)
				{
					result.push(j);
				}
			}
			_pageView.totalRecord = result.length;
			return result.slice(pageIndex * pageSize,(pageIndex + 1) * pageSize);			
		}
		
		
		private function cellClickHandler(e:FuranceEvent):void
		{
			if(furnaceInfo.currentEquipCategoryId != -1)
			{
				if(!CategoryType.isEquip(furnaceInfo.currentEquipCategoryId))
				{
					return;
				}
			}
			setData();
		}
		
		/**排序函数**/
		private function sortOnVector(x:ShopItemInfo,y:ShopItemInfo):Number
		{
			if(x.templateId < y.templateId)
			{
				return -1;
			}
			if(x.templateId > y.templateId)
			{
				return 1;
			}
			return 0;
		}
		
		
		
		/**切卡时清空视图格子**/
		private function clearCells():void
		{
//			for(var i:int = _quickBuyItemViewVector.length - 1;i >= 0;i--)
//			{
//				_quickMTile.removeItemAt(i);
//				 _quickBuyItemViewVector.splice(i,1);
//				
//			}
			
			_quickBuyItemViewVector.length = 0;
			_quickMTile.disposeItems();
		}
		

			
		private function get furnaceInfo():FurnaceInfo
		{
			return _furnaceMediator.furnaceModule.furnaceInfo;
		}
		
		private function pageChangeHandler(e:PageEvent):void
		{
			setData();
		}
		
		public function show():void
		{
			initialData(null);
//			this._pageView.setPageFieldValue();
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function dispose():void
		{
			removeEvents();
			_furnaceMediator = null;
			for each(var i:FurnaceQucikBuyItemView in _quickBuyItemViewVector)
			{
				if(i)
				{
					i.dispose();
					i = null;
				}
			}
			_quickBuyItemViewVector = null;
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			if(_quickMTile)
			{
				_quickMTile.disposeItems();
				_quickMTile.dispose();
				_quickMTile = null;
			}
		}
	}
}