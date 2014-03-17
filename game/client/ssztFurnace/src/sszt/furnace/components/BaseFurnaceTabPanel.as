package sszt.furnace.components
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.ClientBagInfoUpdateEvent;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.view.tips.GuideTip;
	import sszt.events.CellEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.furnace.FurnaceModule;
	import sszt.furnace.components.cell.FurnaceCell;
	import sszt.furnace.components.cell.FurnaceQualityCell;
	import sszt.furnace.data.FurnaceBuyType;
	import sszt.furnace.data.FurnaceInfo;
	import sszt.furnace.data.FurnaceTipsType;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.events.FuranceEvent;
	import sszt.furnace.mediators.FurnaceMediator;
	import sszt.interfaces.drag.IDragable;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.cells.CellCaches;
	
	public class BaseFurnaceTabPanel extends Sprite implements IFurnaceTabPanel
	{
		public static const STRENGTHEN:int = 1;
		public static const REBUILD:int = 2;
		public static const TRANSFORM:int = 3;
		public static const UPLEVEL:int = 4;
		public static const UPGRADE:int = 5;
		public static const ENCHASE:int = 6;
		public static const REMOVE:int = 7;
		public static const COMPOSE:int = 8;
		public static const QUENCHING:int = 9;
		public static const FUSE:int = 10;
		
		protected var _mediator:FurnaceMediator;
		protected var _cells:Array;
		
		public function BaseFurnaceTabPanel(mediator:FurnaceMediator)
		{
			_mediator = mediator;
			super();
			init();
		}
		
		protected function init():void
		{
			var poses:Array = getCellPos();
			var nameVector:Array = getBackgroundName();
			for(var i:int = 0; i < poses.length; i++)
			{
				var bg:Bitmap = new Bitmap(CellCaches.getCellBg());
				bg.x = poses[i].x;
				bg.y = poses[i].y;
				addChild(bg);
				if(nameVector[i])
				{
					var nameLabel:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_CELL);
					nameLabel.htmlText = nameVector[i];
					nameLabel.x =bg.x + (bg.width - nameLabel.width)/2;
					nameLabel.y = bg.y + (bg.height - nameLabel.height)/2;
					addChild(nameLabel);
				}
			}
			initCells(poses);
		}
		
		protected function getCellPos():Array
		{
			return null;
		}
		
		protected function getBackgroundName():Array
		{
			return null;
		}
		
		protected function initCells(poses:Array):void
		{
			_cells = [];
			
			for(var i:int = 0; i < poses.length; i++)
			{
				var cell:FurnaceCell = new FurnaceCell();
				cell.move(poses[i].x,poses[i].y);
				_cells.push(cell);
				addChild(cell);
				cell.addEventListener(MouseEvent.CLICK,cellClickHandler);
			}
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function addAssets():void
		{
			
		}
		
		public function show():void
		{
			furnaceModule.furnaceInfo.addEventListener(FuranceEvent.CELL_CLICK,otherCellClickHandler);
			furnaceModule.furnaceInfo.addEventListener(FuranceEvent.FURANCE_CELL_UPDATE,updateFurnaceHandler);
			furnaceModule.furnaceInfo.addEventListener(FuranceEvent.CELL_PUTAGAIN,putAgainHandler);
			
			furnaceModule.furnaceInfo.addEventListener(FuranceEvent.CELL_ALL_CLEAR,middleCellClearHandler);
			furnaceModule.furnaceInfo.addEventListener(FuranceEvent.CELL_MIDDLE_CLEAR,middleCellClearHandler);
			//监听材料框的增加，方便快速购买时自动填充
			furnaceModule.furnaceInfo.addEventListener(FuranceEvent.CELL_MATERIAL_ADD,materialAddHandler,false,1);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		public function hide():void
		{
			/**清除所有格子界面**/
			furnaceInfo.clearAllVector();
			if(parent)parent.removeChild(this);
			furnaceModule.furnaceInfo.removeEventListener(FuranceEvent.CELL_CLICK,otherCellClickHandler);
			furnaceModule.furnaceInfo.removeEventListener(FuranceEvent.FURANCE_CELL_UPDATE,updateFurnaceHandler);
			furnaceModule.furnaceInfo.removeEventListener(FuranceEvent.CELL_PUTAGAIN,putAgainHandler);
			
			furnaceModule.furnaceInfo.removeEventListener(FuranceEvent.CELL_ALL_CLEAR,middleCellClearHandler);
			furnaceModule.furnaceInfo.removeEventListener(FuranceEvent.CELL_MIDDLE_CLEAR,middleCellClearHandler);
			
			furnaceModule.furnaceInfo.removeEventListener(FuranceEvent.CELL_MATERIAL_ADD,materialAddHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		protected function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.FTAB)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addChild);
			}
		}
		
		protected function updateFurnaceHandler(evt:FuranceEvent):void
		{
			var _place:int =evt.data["place"] as int;
			var _furnaceItemInfo:FurnaceItemInfo = evt.data["info"] as FurnaceItemInfo;
			_cells[_place].furnaceItemInfo = _furnaceItemInfo;
		}
		
		protected function putAgainHandler(e:FuranceEvent):void
		{
			var tmpItemId:Number = e.data as Number;
			equipFillAgain(tmpItemId);	
		}
		
		protected function middleCellClearHandler(e:FuranceEvent):void
		{
//			for each(var i:FurnaceCell in _cells)
//			{
//				i.furnaceItemInfo = null;
//			}
		}
		
		protected function materialAddHandler(e:FuranceEvent):void
		{
		}
		
//		protected function getAcceptCheckers():Vector.<Function>
		protected function getAcceptCheckers():Array
		{
			return null;
		}
		
		protected function cellClickHandler(e:MouseEvent):void
		{
			var tmpCell:FurnaceCell = e.currentTarget as FurnaceCell;
			if(tmpCell.furnaceItemInfo)
			{
//				if(furnaceInfo.currentBuyType != FurnaceBuyType.UPLEVEL && furnaceInfo.currentBuyType != FurnaceBuyType.UPGRADE && furnaceInfo.currentBuyType != FurnaceBuyType.STRENGTH)
//				{
//					furnaceInfo.deleteToPlace(tmpCell.furnaceItemInfo,_cells.indexOf(tmpCell));
//				}
				if(furnaceInfo.currentBuyType == FurnaceBuyType.ENCHASE || furnaceInfo.currentBuyType == FurnaceBuyType.FUSE)
				{
					furnaceInfo.deleteToPlace(tmpCell.furnaceItemInfo,_cells.indexOf(tmpCell));
				}
				else if(_cells.indexOf(tmpCell) == 0)
				{
					furnaceInfo.deleteToPlace(tmpCell.furnaceItemInfo, 0);
				}
			}
		}
		
		protected function otherCellClickHandler(e:FuranceEvent):void
		{
			var tmpFurnaceItemInfo:FurnaceItemInfo = e.data as FurnaceItemInfo;
			otherClickUpdate(tmpFurnaceItemInfo);
		}
		
		protected function otherClickUpdate(argFurnaceItemInfo:FurnaceItemInfo,isShowTips:Boolean = true):Boolean
		{
			var checkers:Array = getAcceptCheckers();
			var isSuccess:Boolean = false;
			var tipsType:int;
			var tipsNullVector:Array = [];
			var tipsUnNullVector:Array = [];
			
			//格子满是不给点击
			var isFull:Boolean = true;
			for(var m:int = 0;m <_cells.length;m++)
			{
				if(_cells[m].furnaceItemInfo == null)
				{
					isFull = false;
					break;
				}
			}
			if(isFull && !CategoryType.isEquip(argFurnaceItemInfo.bagItemInfo.template.categoryId))
			{
				return false;
			}
			
			//先填充空格子
			for(var i:int = 0;i <_cells.length;i++)
			{
				if(_cells[i].furnaceItemInfo == null)
				{
					if( i > 0 && (furnaceInfo.currentBuyType == FurnaceBuyType.UPLEVEL || furnaceInfo.currentBuyType == FurnaceBuyType.UPGRADE))
					{
						break;
					}
					else
					{
						tipsType = checkers[i](argFurnaceItemInfo.bagItemInfo);
					}				
					
					tipsNullVector.push(tipsType);
					if(tipsType == FurnaceTipsType.SUCCESS)
					{
						isSuccess = true;
						furnaceInfo.setToPlace(argFurnaceItemInfo,i);												
						break; 	
					}
				}
			}
			//替换已有格子(格子不为空)
			if(!isSuccess)
			{
				for(var j:int = 0;j <_cells.length;j++)
				{
//					if(_cells[j].furnaceItemInfo && argFurnaceItemInfo != _cells[j].furnaceItemInfo)
					if(_cells[j].furnaceItemInfo)
					{
						if( j > 0 && (furnaceInfo.currentBuyType == FurnaceBuyType.UPLEVEL || furnaceInfo.currentBuyType == FurnaceBuyType.UPGRADE))
						{
							break;
						}
						else
						{
							tipsType = checkers[j](argFurnaceItemInfo.bagItemInfo);
						}
						tipsUnNullVector.push(tipsType);
						if(tipsType == FurnaceTipsType.SUCCESS)
						{
							isSuccess = true;
							//先删除原来的
							if(_cells[j].furnaceItemInfo)furnaceInfo.deleteToPlace(_cells[j].furnaceItemInfo,j);
							//增加
							furnaceInfo.setToPlace(argFurnaceItemInfo,j);						
							break;
						}
					}
				}
			}

			if(!isSuccess && isShowTips)
			{
				tipsNullVector.sort(sortOn);
				tipsUnNullVector.sort(sortOn);
				doAlert(tipsNullVector,tipsUnNullVector);
			}
			return isSuccess;
		}
		
		private function sortOn(x:int,y:int):int
		{
			if(x > y)
			{
				return -1;
			}
			if(x < y)
			{
				return 1;
			}
			return 0;
		}
		
//		protected function doAlert(argNullTipsVector:Vector.<int>,argUnNullTipsVector:Vector.<int>):void{}
		protected function doAlert(argNullTipsVector:Array,argUnNullTipsVector:Array):void{}
		/**自动填充材料**/
		
		
		protected function autoFillCells(argCategoryId:int,argBind:Boolean,argQuality:int = -1):void
		{
			//！= -1为与装备品质一致， = -1为与品质无关
			if(argQuality != -1)
			{
				//与装备品质一致，绑定的随机放，非绑定的放非绑定的
				if(argBind)
				{
					for(var j:int = 0;j < furnaceInfo.materialVector.length;j++)
					{
						if(furnaceInfo.materialVector[j].bagItemInfo.template.categoryId == argCategoryId 
							&& furnaceInfo.materialVector[j].bagItemInfo.template.quality == argQuality)
						{
							if(otherClickUpdate(furnaceInfo.materialVector[j],false))break;
						}
					}
				}
				else
				{
					for(var m:int = 0;m < furnaceInfo.materialVector.length;m++)
					{
						if(furnaceInfo.materialVector[m].bagItemInfo.template.categoryId == argCategoryId && furnaceInfo.materialVector[m].bagItemInfo.template.quality == argQuality && 
						    furnaceInfo.materialVector[m].bagItemInfo.isBind == false)
						{
							if(otherClickUpdate(furnaceInfo.materialVector[m],false))break;
						}
					}
				}

			}
			else
			{
				//绑定的随机放，非绑定的放非绑定的
				if(argBind)
				{
					for(var i:int = 0;i < furnaceInfo.materialVector.length;i++)
					{
						if(furnaceInfo.materialVector[i].bagItemInfo.template.categoryId == argCategoryId)
						{
							if(otherClickUpdate(furnaceInfo.materialVector[i],false))break;
						}
					}
				}
				else
				{
					for(var n:int = 0;n < furnaceInfo.materialVector.length;n++)
					{
						if(furnaceInfo.materialVector[n].bagItemInfo.template.categoryId == argCategoryId &&
							furnaceInfo.materialVector[n].bagItemInfo.isBind == false)
						{
							if(otherClickUpdate(furnaceInfo.materialVector[n],false))break;
						}
					}
				}
			}
		}
		/**重新放入装备**/
		protected function equipFillAgain(argItemId:Number):void
		{
			for(var i:int = 0;i < furnaceInfo.qualityVector.length;i++)
			{
				if(furnaceInfo.qualityVector[i].bagItemInfo.itemId == argItemId)
				{
					if(otherClickUpdate(furnaceInfo.qualityVector[i]))break;
				}
			}
		}
		
		public function get furnaceModule():FurnaceModule
		{
			return _mediator.furnaceModule;
		}
		
		public function get furnaceInfo():FurnaceInfo
		{
			return furnaceModule.furnaceInfo;
		}
		
		public function dispose():void
		{
			hide();
			_mediator = null;
			for each(var i:FurnaceCell in _cells)
			{
				i.dispose();
				i = null;
			}
			_cells = null;
		}
	}
}