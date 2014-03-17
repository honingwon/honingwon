package sszt.furnace.components.qualityTabPanel
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.GuideTip;
	import sszt.events.CellEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.furnace.components.cell.FurnaceQualityCell;
	import sszt.furnace.components.item.FurnaceCellItemView;
	import sszt.furnace.components.item.FurnaceItemView;
	import sszt.furnace.components.item.FurnaceQucikBuyItemView;
	import sszt.furnace.data.FurnaceInfo;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.events.FuranceEvent;
	import sszt.furnace.mediators.FurnaceMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	public class QualityPanel extends Sprite
	{
		private var _furnaceMediator:FurnaceMediator;
		private var _bg:IMovieWrapper;
		private var _qualityItemViewVector:Array = [];
		private var _mTile:MTile;
		private var _currentIndex:int = -1;
		private var _currentType:int = -1;
		private var _btns:Array;
		private var _types:Array;
		private var _tipsLabel:MAssetLabel;
		private var _pageView:PageView;
		private var _currentSelected:FurnaceCellItemView;
		
		public function QualityPanel(argFurnaceMediator:FurnaceMediator)
		{
			_furnaceMediator = argFurnaceMediator;
			super();
			initialView();
			initialEvents();
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,23,247,212)),
				new BackgroundInfo(BackgroundType.BAR_4,new Rectangle(10,12,230,10)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,34,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,73,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,112,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,151,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
			]);
			addChild(_bg as DisplayObject);
			
//			var tabNameLabels:Vector.<String> = Vector.<String>(["全部","白色","绿色","蓝色","紫色"]);
//			_types = Vector.<int>([-1,0,1,2,3]);
//			var tabPoints:Vector.<Point> = Vector.<Point>([new Point(7,0),new Point(54,1),new Point(101,1),new Point(148,1),new Point(195,1)]);
//			_btns = new Vector.<MCacheTab1Btn>(tabPoints.length);
			
			var tabNameLabels:Array = [
				LanguageManager.getWord("ssztl.common.hasPutOnWord"),
				LanguageManager.getWord("ssztl.common.bagModule"),
				'宠物'
				/*
				LanguageManager.getWord("ssztl.common.greenQulity2"),
				LanguageManager.getWord("ssztl.common.blueQulity2"),
				LanguageManager.getWord("ssztl.common.purpleQulity2"),
				LanguageManager.getWord("ssztl.common.orangeQulity2")
				*/
			];
			_types = [-1,0,1,2,3,4];
			_btns =new Array(tabNameLabels.length);
			for(var i:int = 0;i < tabNameLabels.length;i++)
			{
				_btns[i] = new MCacheTabBtn1(0,1,tabNameLabels[i]);
				_btns[i].move(i * 57+5,-3);
				addChild(_btns[i]);
				_btns[i].addEventListener(MouseEvent.CLICK,btnHandler);
			}
			
			_tipsLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2);
			_tipsLabel.move(120,100);
			addChild(_tipsLabel);
//			_tipsLabel.setHtmlValue(LanguageManager.getWord("ssztl.furnace.noEqualEquip"));
			
			_mTile = new MTile(38,38,6);
			_mTile.itemGapW = 0;
			_mTile.itemGapH = 1;
			_mTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mTile.verticalLineScrollSize = 42;
			_mTile.setSize(228,175);
			_mTile.move(10,34);
			addChild(_mTile);
			
			_pageView = new PageView(24,false,90);
			_pageView.move(80,194);
			addChild(_pageView);
			
			setIndex(0);
			
		}
		
		private function btnHandler(e:MouseEvent):void
		{
			var index:int = _btns.indexOf(e.currentTarget as MCacheTabBtn1);
			setIndex(index);
		}
		public function setComposeIndex():void
		{
			if(_currentIndex == 0)
				setIndex(1);
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
			changeTabQualityFurnaceCells();
			
		}

		/**切卡时重新取数据更新格子**/
		private function changeTabQualityFurnaceCells():void
		{
			clearCell();
			var count:int;
			var tmpItemView:FurnaceCellItemView;
			
			var list:Array = getListByType(_currentType,_pageView.currentPage - 1);
			for each(var i:FurnaceItemInfo in list)
			{
				tmpItemView = new FurnaceCellItemView(i);
				tmpItemView.getFurnaceCell.addEventListener(FurnaceQualityCell.CELL_CLICK,itemViewClickHandler);
				_qualityItemViewVector.push(tmpItemView);
				_mTile.appendItem(tmpItemView);
				count++;
			}
			if(count == 0)
			{
				_tipsLabel.visible = true;
			}
			else
			{
				_tipsLabel.visible = false;
			}
			
//			if(GlobalData.guideTipInfo==null)
//			{
//				return;
//			}
//			var info:DeployItemInfo = GlobalData.guideTipInfo;
//			if(_furnaceMediator.furnaceModule.furnacePanel && info.param3 == _furnaceMediator.furnaceModule.furnacePanel.getIndex())
//			{
//				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.QUALITY));
//			}
			
		}
		
		private function getListByType(type:int,pageIndex:int = 0,pageSize:int = 24):Array
		{
			var result:Array;
			result = [];
			for each(var i:FurnaceItemInfo in furnaceInfo.qualityVector)
			{
				if(i.bagItemInfo.template.quality == type ||(_currentType == -1 && i.bagItemInfo.place < 30 && !CategoryType.isPetEquip(i.bagItemInfo.template.categoryId))
					||(_currentType == 0 && i.bagItemInfo.place >= 30) 
					|| (_currentType == 1 && CategoryType.isPetEquip(i.bagItemInfo.template.categoryId) &&  i.bagItemInfo.place < 30))
				{
					result.push(i);
				}
			}
				
//			var totalPage:int = Math.ceil(result.length / pageSize);			
//			if(totalPage <= pageIndex)
//			{
//				_pageView.currentPage = totalPage;				
//				pageIndex = totalPage - 1;
//			}
			_pageView.totalRecord = result.length;
			return result.slice(pageIndex * pageSize,(pageIndex + 1) * pageSize);			
		}
		
		/**清空视图格子类**/
		private function clearCell():void
		{
			for each(var i:FurnaceCellItemView in _qualityItemViewVector)
			{
				if(i)
				{
					i.getFurnaceCell.removeEventListener(FurnaceQualityCell.CELL_CLICK,itemViewClickHandler);
				}
			}
			_qualityItemViewVector.length = 0;
			_mTile.disposeItems();
			_tipsLabel.visible = true;
		}
		
		/**点击格子，改变数据**/
		private function itemViewClickHandler(e:MouseEvent):void
		{
			var tmpItemView:FurnaceCellItemView = (e.currentTarget as Sprite).parent as FurnaceCellItemView;
			if(_currentSelected) _currentSelected.selected = false;
			_currentSelected = tmpItemView;
			_currentSelected.selected = true;	
			if(tmpItemView && tmpItemView.furnaceItemInfo)
			{
				furnaceInfo.clickHandler(tmpItemView.furnaceItemInfo);
				
				if(GlobalData.guideTipInfo == null)return;
				var info:DeployItemInfo = GlobalData.guideTipInfo;
				if(info.param1 == GuideTipDeployType.QUALITY)
				{
					var temp:Boolean =false;
					switch(info.param3)
					{
						case 0:
							temp = true;
							break;
						case 1:
							temp = CategoryType.isWeapon(tmpItemView.furnaceItemInfo.bagItemInfo.template.categoryId);
							break;
						case 2:
							temp = CategoryType.isCloth(tmpItemView.furnaceItemInfo.bagItemInfo.template.categoryId);
							break;
					}
					if(temp)
					{
						if(info.param4 ==1)
						{
							ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.MATERIAL));
						}
						else
						{
							ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.FTAB));
						}
					}
				}
			}
			
		}
		
		private function initialEvents():void
		{
			furnaceInfo.addEventListener(FuranceEvent.CELL_QUALITY_UPDATE,updateCellhandler);
			furnaceInfo.addEventListener(FuranceEvent.CELL_QUALITY_ADD,addCellHandler);
			furnaceInfo.addEventListener(FuranceEvent.CELL_QUALITY_DELETE,deleteCellhandler);
			furnaceInfo.addEventListener(FuranceEvent.CELL_ALL_CLEAR,clearCellhandler);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		private function removeEvents():void
		{
			furnaceInfo.removeEventListener(FuranceEvent.CELL_QUALITY_UPDATE,updateCellhandler);
			furnaceInfo.removeEventListener(FuranceEvent.CELL_QUALITY_ADD,addCellHandler);
			furnaceInfo.removeEventListener(FuranceEvent.CELL_QUALITY_DELETE,deleteCellhandler);
			furnaceInfo.removeEventListener(FuranceEvent.CELL_ALL_CLEAR,clearCellhandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		public function dispatchGuideTip():void
		{
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.QUALITY));
		}
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.QUALITY)
			{
				if(info.param2 == 9)
				{
					var index:int;
					switch(info.param3)
					{
						case 1:
							index = getFirstWeaponCellItem();
							break;
						case 2:
							index = getFirstClothCellItem();
							break;
					}
					if(index != -1)
					{
						if(_mTile)
						{
							GuideTip.getInstance().show(info.descript,5,new Point(index * 38+55,72),addChild);
						}
					}
					else
					{
						GuideTip.getInstance().show(info.descript,5,new Point(55,72),addChild);
					}
				}
				else
				{
//					ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.QUALITY));
					GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addChild);
				}
			}
		}
		
		
		/**监听格子数据层更新**/
		private function updateCellhandler(e:FuranceEvent):void
		{
			var tmpItemId:Number = e.data as Number;
			var tmpFurnaceItemInfo:FurnaceItemInfo = furnaceInfo.getFurnaceItemInfoFromQualityVector(tmpItemId);
			if(tmpFurnaceItemInfo)
			{
				for each(var i:FurnaceCellItemView in _qualityItemViewVector)
				{
					if(i.furnaceItemInfo.bagItemInfo.itemId  == tmpItemId)
					{
						i.furnaceItemInfo = tmpFurnaceItemInfo;
						break;
					}
				}
			}
		}
		
		private function addCellHandler(e:FuranceEvent):void
		{
//			var tmpFurnaceItemInfo:FurnaceItemInfo = furnaceInfo.getFurnaceItemInfoFromQualityVector(e.data as Number);
//			if(tmpFurnaceItemInfo)
//			{
//				if(tmpFurnaceItemInfo.bagItemInfo.template.quality == _currentType || (_currentType == -1 && tmpFurnaceItemInfo.bagItemInfo.place < 30)
//					||(_currentType == 0 && tmpFurnaceItemInfo.bagItemInfo.place > 30))
//				{
//					var tmpFurnaceItemView:FurnaceCellItemView = new FurnaceCellItemView(tmpFurnaceItemInfo);
//					tmpFurnaceItemView.addEventListener(MouseEvent.CLICK,itemViewClickHandler);
//					_qualityItemViewVector.push(tmpFurnaceItemView);
//					_mTile.appendItem(tmpFurnaceItemView);
//					if(_tipsLabel.visible)
//					{
//						_tipsLabel.visible = false;
//					}
//				}
				
//			}
			changeTabQualityFurnaceCells();
			dispatchGuideTip();
//			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.QUALITY));
		}
		
		private function deleteCellhandler(e:FuranceEvent):void
		{
			var tmpItemId:Number = e.data as Number;
			for(var i:int = _qualityItemViewVector.length - 1;i >= 0;i--)
			{
				if(_qualityItemViewVector[i].furnaceItemInfo.bagItemInfo.itemId == tmpItemId)
				{
					_mTile.removeItem(_qualityItemViewVector[i]);
					_qualityItemViewVector.splice(i,1);
				}
			}
			changeTabQualityFurnaceCells();
			if(_qualityItemViewVector.length == 0)
			{
				_tipsLabel.visible = true;
			}
		}
		
		private function clearCellhandler(e:FuranceEvent):void
		{
			clearCell();
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		private function get furnaceInfo():FurnaceInfo
		{
			return _furnaceMediator.furnaceModule.furnaceInfo;
		}
		private function pageChangeHandler(e:PageEvent):void
		{
			changeTabQualityFurnaceCells();
		}
		
		
		private function getFirstWeaponCellItem():int		
		{
			var i:int = 0;
			for each(var view:FurnaceCellItemView in _qualityItemViewVector)
			{
				if(CategoryType.isWeapon(view.furnaceItemInfo.bagItemInfo.template.categoryId))
				{
					return i;
				}
				i++;
			}
			return -1;
		}
		
		private function getFirstClothCellItem():int		
		{
			var i:int = 0;
			for each(var view:FurnaceCellItemView in _qualityItemViewVector)
			{
				if(CategoryType.isCloth(view.furnaceItemInfo.bagItemInfo.template.categoryId))
				{
					return i;
				}
				i++;
			}
			return i;
		}
		
		public function setCurrentPage():void
		{
//			this._pageView.setPageFieldValue();
		}
		
		public function dispose():void
		{
			removeEvents();
			_furnaceMediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			for each(var i:FurnaceCellItemView in _qualityItemViewVector)
			{
				if(i)
				{
					i.getFurnaceCell.removeEventListener(FurnaceQualityCell.CELL_CLICK,itemViewClickHandler);
					i.dispose();
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
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			for each(var j:MCacheTabBtn1 in _btns)
			{
				j.dispose();
				j.removeEventListener(MouseEvent.CLICK,btnHandler);
				j = null;
			}
			_btns = null;
			_types = null;
			_tipsLabel = null;
		}
	}
}