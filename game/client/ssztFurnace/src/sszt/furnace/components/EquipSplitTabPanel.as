package sszt.furnace.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.cells.CellCaches;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.bag.ClientBagInfoUpdateEvent;
	import sszt.core.data.furnace.parametersList.DecomposeTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.furnace.components.cell.FurnaceBaseCell;
	import sszt.furnace.components.cell.FurnaceCell;
	import sszt.furnace.components.cell.FurnaceQualityCell;
	import sszt.furnace.data.FurnaceTipsType;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.events.FuranceEvent;
	import sszt.furnace.mediators.FurnaceMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class EquipSplitTabPanel extends BaseFurnaceTabPanel
	{
		private var _bg:IMovieWrapper;
		private var _getBackBtn:MCacheAsset1Btn;
		private var _splitBtn:MCacheAsset1Btn;
		private var _useMoneyTextField:TextField;
		private var _successRateTextField:TextField;
		private var _currentMoney:int;
		private var _currentSuccessRate:int;
		private var _currentEnchaseItemCell:FurnaceCell;
//		private var _holeCellsPoses:Vector.<Point> = Vector.<Point>([new Point(0,0)]);
		private var _holeCellsPoses:Array = [new Point(0,0)];
		
		private var _holeCellLayer:Sprite;
		
		/**装备分解材料**/
//		public static const EQUIPSPLIT_MATERIAL_CATEGORYID_LIST:Vector.<int> = Vector.<int>([]);
		public static const EQUIPSPLIT_MATERIAL_CATEGORYID_LIST:Array = [];
		
		public function EquipSplitTabPanel(mediator:FurnaceMediator)
		{
			super(mediator);
		}
		
		override protected function init():void
		{
			super.init();
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(1,223,125,19)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(140,223,125,19)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(112,132,40,40),new Bitmap(CellCaches.getCellBg())),
			]);
			addChild(_bg as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(77,5,112,17),new MAssetLabel(LanguageManager.getWord("ssztl.furnace.inpuSplitEquip"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(30,206,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.furnace.needFare"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(181,206,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.furnace.successRate"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(106,251,52,17),new MAssetLabel(LanguageManager.getWord("ssztl.furnace.splitExplain"),MAssetLabel.LABELTYPE14)));
			
			/**---------------处理显示的textField---------------**/
//			var rectVector:Vector.<Rectangle> = Vector.<Rectangle>([new Rectangle(30,224,58,17),new Rectangle(187,224,58,17)]);
//			var textFieldVector:Vector.<TextField> = new Vector.<TextField>(rectVector.length);
			var rectVector:Array = [new Rectangle(30,224,58,17),new Rectangle(187,224,58,17)];
			var textFieldVector:Array = new Array(rectVector.length);
			
			_holeCellLayer = new Sprite();
			_holeCellLayer.x = 114;
			_holeCellLayer.y = 134;
			addChild(_holeCellLayer);
			
			for(var j:int = 0;j < rectVector.length; j++)
			{
				var tmpTextField:TextField = new TextField();
				tmpTextField.x = rectVector[j].x;
				tmpTextField.y = rectVector[j].y;
				tmpTextField.width = rectVector[j].width;
				tmpTextField.height = rectVector[j].height;
				tmpTextField.text = "";
				tmpTextField.selectable = false;
				tmpTextField.textColor = 0xFFFFFF;
				addChild(tmpTextField);
				textFieldVector[j] = tmpTextField;
			}
			_useMoneyTextField = textFieldVector[textFieldVector.length - 2];
			_successRateTextField = textFieldVector[textFieldVector.length - 1];
			/**--------------------------------------------**/
			
			_getBackBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.furnace.getBackEquip"));
			_getBackBtn.move(95,88);
			addChild(_getBackBtn);
			
			_splitBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.furnace.beginSplit"));
			_splitBtn.enabled = false;
			_splitBtn.move(95,382);
			addChild(_splitBtn);
		}
		
		override public function show():void
		{
			super.show();
			/**加载数据到另外两个面板**/
			furnaceInfo.initialFurnaceVector(qualityItemListChecker,EQUIPSPLIT_MATERIAL_CATEGORYID_LIST);
			/**监听背包变化**/
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_getBackBtn.addEventListener(MouseEvent.CLICK,getBackClickHandler);
			_splitBtn.addEventListener(MouseEvent.CLICK,splitBtnHandler);
		}
		
		override public function hide():void
		{
			super.hide();
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_getBackBtn.removeEventListener(MouseEvent.CLICK,getBackClickHandler);
			_splitBtn.removeEventListener(MouseEvent.CLICK,splitBtnHandler);
//			getBackClickHandler(null);
		}
		
		/**监听背包信息更新**/
		private function bagItemUpdateHandler(e:BagInfoUpdateEvent):void
		{
//			var tmpItemIdList:Vector.<Number> = e.data as Vector.<Number>;
			var tmpItemIdList:Array = e.data as Array;
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				furnaceInfo.updateBagToFurnace(tmpItemIdList[i],qualityItemListChecker,EQUIPSPLIT_MATERIAL_CATEGORYID_LIST);
			}
		}
		
		/**检测列表过滤条件**/
		private function qualityItemListChecker(argItemInfo:ItemInfo):Boolean
		{
			if(argItemInfo &&CategoryType.isEquip(argItemInfo.template.categoryId) &&
				argItemInfo.template.quality != 0 && argItemInfo.template.canRecycle && argItemInfo.template.quality != 0)
			{
				return true;
			}
			return false;
		}
		
		private function getBackClickHandler(evt:MouseEvent):void
		{
			clearCells();
		}
		
		private function clearCells(isIncludeEquip:Boolean = true):void
		{
			clearHoles();
			var _beginIndex:int = 0;
			if(!isIncludeEquip){_beginIndex = 1;}
			for(var i:int = _cells.length - 1;i >= _beginIndex;i--)
			{
				if(_cells[i].furnaceItemInfo)
				{
					_cells[i].furnaceItemInfo.removePlace(i);
					_cells[i].furnaceItemInfo.setBack();
					_cells[i].furnaceItemInfo = null;
				}
			}
			_splitBtn.enabled = false;
			_currentSuccessRate = 0;
			_currentMoney = 0;
			_successRateTextField.text = "";
			_useMoneyTextField.text = "";
		}
		
		private function clearHoles():void
		{
			for(var i:int = _holeCellLayer.numChildren - 1;i>= 0;i--)
			{
				_holeCellLayer.removeChildAt(i);
			}
		}
		
		private function splitBtnHandler(e:MouseEvent):void
		{
			if(GlobalData.bagInfo.currentSize >= GlobalData.selfPlayer.bagMaxCount)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagFull"));
				return;
			}
			if(_currentMoney > GlobalData.selfPlayer.userMoney.allCopper)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
				return;
			}
			//强化二级提示
			if(_cells[0].furnaceItemInfo.bagItemInfo.strengthenLevel > 0)
			{
				MAlert.show(LanguageManager.getWord("ssztl.furnace.sureSplitStrength"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
				return;
			}
			//开孔二级提示
			if(_cells[0].furnaceItemInfo.bagItemInfo.getUsedHoleCount(true) > 0)
			{
				MAlert.show(LanguageManager.getWord("ssztl.furnace.sureSplitHoled"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
				return;
			}
			//橙色、紫色装备二级提示
			if(ItemTemplateList.getTemplate(_cells[0].furnaceItemInfo.bagItemInfo.templateId).quality == 3 ||
				ItemTemplateList.getTemplate(_cells[0].furnaceItemInfo.bagItemInfo.templateId).quality == 4)
			{
				MAlert.show(LanguageManager.getWord("ssztl.furnace.isSureSplitpoEquip"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
				return;
			}
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					_mediator.sendEquipSplit(_cells[0].furnaceItemInfo.bagItemInfo.place);
				}
			}
			_mediator.sendEquipSplit(_cells[0].furnaceItemInfo.bagItemInfo.place);
			_splitBtn.enabled = false;
		}
		
//		override protected function getCellPos():Vector.<Point>
//		{
//			return Vector.<Point>([new Point(112,43)]);
//		}
		override protected function getCellPos():Array
		{
			return [new Point(112,43)];
		}
//		,new Point(112,132)
//		,new Point(18,132),new Point(65,132),
//		,new Point(159,132),new Point(206,132)
		
//		override protected function getBackgroundName():Vector.<String>
//		{
//			return Vector.<String>(["装 备"]);
//		}
		override protected function getBackgroundName():Array
		{
			return [LanguageManager.getWord("ssztl.furnace.equip")];
		}		
//		override protected function getAcceptCheckers():Vector.<Function>
//		{
//			return Vector.<Function>([equipChecker]);
//		}
		override protected function getAcceptCheckers():Array
		{
			return [equipChecker];
		}
		
		private function equipChecker(info:ItemInfo):int
		{
			if(!CategoryType.isEquip(info.template.categoryId))return FurnaceTipsType.EQUIP;
			return FurnaceTipsType.SUCCESS;
		}
		
		
		override protected function updateFurnaceHandler(evt:FuranceEvent):void
		{
			var _place:int =evt.data["place"] as int;
			var _furnaceItemInfo:FurnaceItemInfo = evt.data["info"] as FurnaceItemInfo;
			_cells[_place].furnaceItemInfo = _furnaceItemInfo;
			
			//更新格子视图后续处理
			switch(_place)
			{
				case 0:
					if(!_furnaceItemInfo)
					{
						getBackClickHandler(null);
					}
					else
					{
						updateHoleCells(_furnaceItemInfo.bagItemInfo);
						updateData(_cells[0].furnaceItemInfo.bagItemInfo);
					}
			}
		}
		
		private function updateData(argEquipItemInfo:ItemInfo):void
		{
			/**成功率计算公式**/
			updateSuccessRate(argEquipItemInfo);
			_splitBtn.enabled = true;
			/**费用：系数**/
			_currentMoney =  DecomposeTemplateList.getDecomposeInfo(argEquipItemInfo.template.quality).needCopper;
			_useMoneyTextField.text =_currentMoney.toString();
		}
		
		/**更新成功率**/
		private function updateSuccessRate(argEquipItemInfo:ItemInfo):void
		{
			/**成功率**/
			_currentSuccessRate = DecomposeTemplateList.getDecomposeInfo(argEquipItemInfo.template.quality).succRate;
			_successRateTextField.text = _currentSuccessRate.toString() + "%";
		}
		
		private function updateHoleCells(argEquipItemInfo:ItemInfo):void
		{
			var tmpCell:FurnaceBaseCell;
			tmpCell = new FurnaceBaseCell();
			tmpCell.info = ItemTemplateList.getTemplate(argEquipItemInfo.template.property3);
			tmpCell.x = _holeCellsPoses[0].x;
			tmpCell.y = _holeCellsPoses[0].y;
			_holeCellLayer.addChild(tmpCell);
		}
		
		override protected function middleCellClearHandler(e:FuranceEvent):void
		{
			clearCells();
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_getBackBtn)
			{
				_getBackBtn.dispose();
				_getBackBtn = null;
			}
			if(_splitBtn)
			{
				_splitBtn.dispose();
				_splitBtn = null;
			}
			_useMoneyTextField = null;
			_successRateTextField = null;
			if(_currentEnchaseItemCell)
			{
				_currentEnchaseItemCell.dispose();
				_currentEnchaseItemCell = null;
			}
			_holeCellsPoses = null;
			_holeCellLayer = null;
		}
		
	}
}