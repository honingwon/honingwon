package sszt.furnace.components.materialTabPanel
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.furnace.parametersList.StoneMatchTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.GuideTip;
	import sszt.events.CommonModuleEvent;
	import sszt.furnace.components.item.FurnaceItemView;
	import sszt.furnace.data.FurnaceInfo;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.events.FuranceEvent;
	import sszt.furnace.mediators.FurnaceMediator;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;

	public class MaterialTabPanel extends Sprite implements IMaterialTabPanel
	{
		private var _furnaceMediator:FurnaceMediator;
//		private var _materialItemViewVector:Vector.<FurnaceItemView> = new Vector.<FurnaceItemView>();
		private var _materialItemViewVector:Array = [];
		private var _mTile:MTile;
		private var _tipsLabel:MAssetLabel;
		private var _pageView:PageView;
		
		public function MaterialTabPanel(argMediator:FurnaceMediator)
		{
			_furnaceMediator = argMediator;
			initialView();
			initialEvents();
			
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.MATERIAL));
		}
		
		private function initialView():void
		{
			_mTile = new MTile(120,48,2);
			_mTile.itemGapW = 1;
			_mTile.itemGapH = 2;
			_mTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mTile.verticalLineScrollSize = 42;
			_mTile.setSize(242,100);
			_mTile.move(3,28);
			addChild(_mTile);
			
			_tipsLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2);
			_tipsLabel.move(120,50);
			addChild(_tipsLabel);
			_tipsLabel.setHtmlValue(LanguageManager.getWord("ssztl.furnace.bagAbsentMaterial"));
			
			_pageView = new PageView(4,false,90);
			_pageView.move(80,130);
			addChild(_pageView);
		}
		
		private function initialEvents():void
		{
			furnaceInfo.addEventListener(FuranceEvent.CELL_MATERIAL_ADD,addCellHandler,false,2);
//			furnaceInfo.addEventListener(FuranceEvent.CELL_QUALITY_UPDATE,updateCellhandler);
//			furnaceInfo.addEventListener(FuranceEvent.CELL_MATERIAL_UPDATE,updateCellhandler);
			furnaceInfo.addEventListener(FuranceEvent.CELL_MATERIAL_DELETE,deleteCellhandler);
			furnaceInfo.addEventListener(FuranceEvent.CELL_MATERIAL_CLEAR,deleteAllCellhandler);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			furnaceInfo.addEventListener(FuranceEvent.CELL_ALL_CLEAR,clearCellHandler);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		private function removeEvents():void
		{
			furnaceInfo.removeEventListener(FuranceEvent.CELL_MATERIAL_ADD,addCellHandler);
//			furnaceInfo.removeEventListener(FuranceEvent.CELL_QUALITY_UPDATE,updateCellhandler);
//			furnaceInfo.removeEventListener(FuranceEvent.CELL_MATERIAL_UPDATE,updateCellhandler);
			furnaceInfo.removeEventListener(FuranceEvent.CELL_MATERIAL_DELETE,deleteCellhandler);
			furnaceInfo.removeEventListener(FuranceEvent.CELL_MATERIAL_CLEAR,deleteAllCellhandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			furnaceInfo.removeEventListener(FuranceEvent.CELL_ALL_CLEAR,clearCellHandler);
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.MATERIAL)
			{
				
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addChild);
			}
		}
		
		
		/**切卡时重新取数据更新格子**/
		private function changeMaterialFurnaceCells():void
		{
			clearCellHandler(new FuranceEvent(FuranceEvent.CELL_ALL_CLEAR));
			var count:int;
			var tmpItemView:FurnaceItemView;
			var list:Array = getListByType(_pageView.currentPage - 1);
			for each(var i:FurnaceItemInfo in list)
			{
				tmpItemView = new FurnaceItemView(i);
				tmpItemView.addEventListener(MouseEvent.CLICK,itemViewClickHandler);
				_materialItemViewVector.push(tmpItemView);
				_mTile.appendItem(tmpItemView);
			}
			if(_tipsLabel.visible)
			{
				_tipsLabel.visible = false;
				_pageView.visible = true;
			}
		}
		private function getListByType(pageIndex:int = 0,pageSize:int = 4):Array
		{
			var result:Array;
			result = [];
			for each(var i:FurnaceItemInfo in furnaceInfo.materialVector)
			{
				if(furnaceInfo.currentEquipCategoryId ==  -1)
				{
					result.push(i);
				}
				else
				{
					var isSuitable:Boolean = StoneMatchTemplateList.getStoneMatchInfo(furnaceInfo.currentEquipCategoryId).stoneList.indexOf(i.bagItemInfo.template.categoryId) + 1;
					if(isSuitable)
					{
						result.push(i);
					}
				}
			}
			_pageView.totalRecord = result.length;
			return result.slice(pageIndex * pageSize,(pageIndex + 1) * pageSize);			
		}
		
		
		private function addCellHandler(e:FuranceEvent):void
		{
			changeMaterialFurnaceCells();
//			var tmpFurnaceItemInfo:FurnaceItemInfo = furnaceInfo.getFurnaceItemInfoFromMaterialVector(e.data as Number);
//			if(tmpFurnaceItemInfo)
//			{
//				if(furnaceInfo.currentEquipCategoryId ==  -1)
//				{
//					var tmpFurnaceItemView:FurnaceItemView = new FurnaceItemView(tmpFurnaceItemInfo);
//					tmpFurnaceItemView.addEventListener(MouseEvent.CLICK,itemViewClickHandler);
//					_materialItemViewVector.push(tmpFurnaceItemView);
//					_mTile.appendItem(tmpFurnaceItemView);
//					if(_tipsLabel.visible)
//					{
//						_tipsLabel.visible = false;
//						_pageView.visible = true;
//					}
//				}
//				else
//				{
//					var isSuitable:Boolean = StoneMatchTemplateList.getStoneMatchInfo(furnaceInfo.currentEquipCategoryId).stoneList.indexOf(tmpFurnaceItemInfo.bagItemInfo.template.categoryId) + 1;
//					if(isSuitable)
//					{
//						var tmpFurnaceItemView1:FurnaceItemView = new FurnaceItemView(tmpFurnaceItemInfo);
//						tmpFurnaceItemView1.addEventListener(MouseEvent.CLICK,itemViewClickHandler);
//						_materialItemViewVector.push(tmpFurnaceItemView1);
//						_mTile.appendItem(tmpFurnaceItemView1);
//						if(_tipsLabel.visible)
//						{
//							_tipsLabel.visible = false;
//							_pageView.visible = true;
//						}
//					}
//				}
//			}
		}
		
		
		
		/**监听格子数据层更新**/
//		private function updateCellhandler(e:FuranceEvent):void
//		{
//			var tmpItemId:Number = e.data as Number;
//			var tmpFurnaceItemInfo:FurnaceItemInfo = furnaceInfo.getFurnaceItemInfoFromMaterialVector(tmpItemId);
//			for each(var i:FurnaceItemView in _materialItemViewVector)
//			{
//				if(i.furnaceItemInfo && i.furnaceItemInfo.bagItemInfo.itemId  == tmpItemId)
//				{
//					i.furnaceItemInfo = tmpFurnaceItemInfo;
//					break;
//				}
//			}
//		}
		
		private function deleteCellhandler(e:FuranceEvent):void
		{
			var tmpItemId:Number = e.data as Number;
			for(var i:int = _materialItemViewVector.length - 1;i >= 0;i--)
			{
				if(_materialItemViewVector[i].furnaceItemInfo.bagItemInfo.itemId == tmpItemId)
				{
					_mTile.removeItem(_materialItemViewVector[i]);
					_materialItemViewVector.splice(i,1);
					break;
				}
			}
			changeMaterialFurnaceCells();
			if(_materialItemViewVector.length == 0)
			{
				_tipsLabel.visible = true;
				_pageView.visible = false;
			}
		}
		
		private function deleteAllCellhandler(e:FuranceEvent):void
		{
			_materialItemViewVector.length = 0;
			_mTile.disposeItems();
			_tipsLabel.visible = true;
			_pageView.visible = false;
		}
		
		
		private function clearCellHandler(e:FuranceEvent):void
		{
			_materialItemViewVector.length = 0;
			_mTile.disposeItems();
			_tipsLabel.visible = true;
			_pageView.visible = false;
		}
		
		/**点击格子，改变数据**/
		private function itemViewClickHandler(e:MouseEvent):void
		{
			var tmpItemView:FurnaceItemView = e.currentTarget as FurnaceItemView;
			if(tmpItemView && tmpItemView.furnaceItemInfo)
			{
				furnaceInfo.clickHandler(tmpItemView.furnaceItemInfo);
				
				if(GlobalData.guideTipInfo == null)return;
				var info:DeployItemInfo = GlobalData.guideTipInfo;
				if(info.param1 == GuideTipDeployType.MATERIAL)
				{
					ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.FTAB));
				}
				
			}
		}

		
		private function get furnaceInfo():FurnaceInfo
		{
			return _furnaceMediator.furnaceModule.furnaceInfo;
		}
		
		public function show():void
		{
//			this._pageView.setPageFieldValue();
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		private function pageChangeHandler(e:PageEvent):void
		{
			changeMaterialFurnaceCells();
		}
		
		public function dispose():void
		{
			removeEvents();
			_furnaceMediator = null;
			for each(var i:FurnaceItemView in _materialItemViewVector)
			{
				if(i)
				{
					i.addEventListener(MouseEvent.CLICK,itemViewClickHandler);
					i.dispose();
					i = null;
				}
			}
			_materialItemViewVector = null;
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			if(_mTile)
			{
				_mTile.disposeItems();
				_mTile.dispose();
				_mTile = null;
			}
			_tipsLabel = null;
		}
	}
}