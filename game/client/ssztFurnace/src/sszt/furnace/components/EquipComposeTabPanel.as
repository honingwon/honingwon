package sszt.furnace.components
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
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
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.quickTips.QuickTips;
//	import mhsm.furnace.TipsAsset;
	import sszt.furnace.components.cell.FurnaceBaseCell;
	import sszt.furnace.components.cell.FurnaceCell;
	import sszt.furnace.data.FurnaceBuyType;
	import sszt.furnace.data.FurnaceTipsType;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.events.FuranceEvent;
	import sszt.furnace.mediators.FurnaceMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;

	public class EquipComposeTabPanel extends BaseFurnaceTabPanel
	{
		private var _bg:IMovieWrapper;
		private var _getBackBtn:MCacheAsset1Btn;
		private var _composeBtn:MCacheAsset1Btn;
		private var _successRateTextField:TextField;
		private var _useMoneyTextField:TextField;
		
		private var _currentSuccessRate:int;
		private var _currentMoney:int;
		
		private var _currentQuality:int;
		private var _resultCell:FurnaceBaseCell;
		
		/**装备融合材料**/
//		public static const EQUIPCOMPOSE_MATERIAL_CATEGORYID_LIST:Vector.<int> = Vector.<int>([]);
		public static const EQUIPCOMPOSE_MATERIAL_CATEGORYID_LIST:Array = [];
		
		public function EquipComposeTabPanel(mediator:FurnaceMediator)
		{
			super(mediator);
		}
		
		override protected function init():void
		{
			super.init();
			_bg = BackgroundUtils.setBackground([
									new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(1,223,125,19)),
									new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(140,223,125,19)),
									new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(112,154,40,40),new Bitmap(CellCaches.getCellBg())),
//									new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(103,127,51,23),new Bitmap(new TipsAsset()))
									new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(103,127,51,23))
			]);
			addChild(_bg as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(77,5,112,17),new MAssetLabel(LanguageManager.getWord("ssztl.furnace.inputNeedComposeEquip"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(30,206,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.furnace.needFare"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(181,206,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.furnace.successRate"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(106,251,52,17),new MAssetLabel(LanguageManager.getWord("ssztl.furnace.equipComposeExplain"),MAssetLabel.LABELTYPE14)));
			
			_resultCell = new FurnaceBaseCell();
			_resultCell.move(114,156);
			addChild(_resultCell);
			
			/**---------------处理显示的textField---------------**/
//			var rectVector:Vector.<Rectangle> = Vector.<Rectangle>([new Rectangle(30,224,58,17),new Rectangle(187,224,58,17)]);
//			var textFieldVector:Vector.<TextField> = new Vector.<TextField>(rectVector.length);
			var rectVector:Array = [new Rectangle(30,224,58,17),new Rectangle(187,224,58,17)];
			var textFieldVector:Array = new Array(rectVector.length);
			
			
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
			_getBackBtn.move(95,75);
			addChild(_getBackBtn);
			
			_composeBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.furnace.beginCompose"));
			_composeBtn.enabled = false;
			_composeBtn.move(95,382);
			addChild(_composeBtn);
			
		}
		
		override public function show():void
		{
			super.show();
			/**加载数据到另外两个面板**/
			furnaceInfo.initialFurnaceVector(qualityItemListChecker,EQUIPCOMPOSE_MATERIAL_CATEGORYID_LIST);
			/**监听背包变化**/
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_getBackBtn.addEventListener(MouseEvent.CLICK,getBackClickHandler);
			_composeBtn.addEventListener(MouseEvent.CLICK,composeBtnHandler);
		}
		
		override public function hide():void
		{
			super.hide();
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_getBackBtn.removeEventListener(MouseEvent.CLICK,getBackClickHandler);
			_composeBtn.removeEventListener(MouseEvent.CLICK,composeBtnHandler);
//			getBackClickHandler(null);
		}
		
		private function getBackClickHandler(evt:MouseEvent):void
		{
			clearCells();
		}
		
		private function clearCells(isIncludeEquip:Boolean = true):void
		{
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
			_resultCell.info = null;
			_composeBtn.enabled = false;
			_currentSuccessRate = 0;
			_currentMoney = 0;
			_successRateTextField.text = "";
			_useMoneyTextField.text = "";
		}
		
		private function composeBtnHandler(e:MouseEvent):void
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
			for each(var j:FurnaceCell in _cells)
			{
				if(!_cells[0].furnaceItemInfo.bagItemInfo.isBind && j.furnaceItemInfo && j.furnaceItemInfo.bagItemInfo.isBind)
				{
					MAlert.show(LanguageManager.getWord("ssztl.furnace.composeHasBind"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
					return;
				}
			}
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					_mediator.sendEquipCompose(_cells[0].furnaceItemInfo.bagItemInfo.place,_cells[1].furnaceItemInfo.bagItemInfo.place,_cells[2].furnaceItemInfo.bagItemInfo.place);
				}
			}
			_mediator.sendEquipCompose(_cells[0].furnaceItemInfo.bagItemInfo.place,_cells[1].furnaceItemInfo.bagItemInfo.place,_cells[2].furnaceItemInfo.bagItemInfo.place);
			_composeBtn.enabled = false;
		}
		
		/**监听背包信息更新**/
		private function bagItemUpdateHandler(e:BagInfoUpdateEvent):void
		{
//			var tmpItemIdList:Vector.<Number> = e.data as Vector.<Number>;
			var tmpItemIdList:Array = e.data as Array;
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				furnaceInfo.updateBagToFurnace(tmpItemIdList[i],qualityItemListChecker,EQUIPCOMPOSE_MATERIAL_CATEGORYID_LIST);
			}
		}
		
		/**检测列表过滤条件**/
		private function qualityItemListChecker(argItemInfo:ItemInfo):Boolean
		{
			if(argItemInfo && argItemInfo.template.canUpgrade)
			{
				if(argItemInfo.template.quality== 2)
				{
					if((argItemInfo.template.needLevel>=40 && argItemInfo.template.needLevel<=50) || (argItemInfo.template.needLevel>=60&&argItemInfo.template.needLevel<=70))
					{
						if(CategoryType.isSuitPlace(argItemInfo.template.categoryId))
						{
							 return true;
						}
					}
				}
				else if(argItemInfo.template.quality== 3 || argItemInfo.template.quality== 4)
				{
					if(argItemInfo.template.suitId > 0 && argItemInfo.template.needLevel != 39 && argItemInfo.template.needLevel != 59)
					{
						return true;
					}
				}
			}
//			if(argItemInfo && argItemInfo.template.canUpgrade && argItemInfo.template.quality != 0 && argItemInfo.template.quality != 1 &&
//				argItemInfo.template.needLevel >= 40 && CategoryType.isSuitPlace(argItemInfo.template.categoryId))
//			{
//				return true;
//			}
			return false;
		}
		
		
//		override protected function getCellPos():Vector.<Point>
		override protected function getCellPos():Array
		{
//			return Vector.<Point>([new Point(112,30),new Point(62,107),new Point(159,107),
//												  ]);
			return [new Point(112,30),new Point(62,107),new Point(159,107),
			];
//			new Point(112,154)
		}
		
//		override protected function getBackgroundName():Vector.<String>
//		{
//			return Vector.<String>(["蓝装","紫装","紫装"]);
//		}
		override protected function getBackgroundName():Array
		{
			return [LanguageManager.getWord("ssztl.common.blueEquip"),
				LanguageManager.getWord("ssztl.common.purpleEquipShot"),
				LanguageManager.getWord("ssztl.common.purpleEquipShot")];
		}
		
//		override protected function getAcceptCheckers():Vector.<Function>
//		{
//			return Vector.<Function>([blueEquipChecker,purpleEquipChecker1,purpleEquipChecker2]);
//		}
		override protected function getAcceptCheckers():Array
		{
			return [blueEquipChecker,purpleEquipChecker1,purpleEquipChecker2];
		}
		
//		override protected function doAlert(argNullTipsVector:Vector.<int>,argUnNullTipsVector:Vector.<int>):void
		override protected function doAlert(argNullTipsVector:Array,argUnNullTipsVector:Array):void
		{
			var argTipsType:int;
			if(argUnNullTipsVector.length > 0)
			{
				argTipsType = argUnNullTipsVector[0];
			}
			if(argNullTipsVector.length > 0)
			{
				argTipsType = argNullTipsVector[0];
			}
			switch(argTipsType)
			{
				case FurnaceTipsType.EQUIP:
//					QuickTips.show("只能放入可融合装备！");
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.putComposeOnly"));
					break;
				case FurnaceTipsType.NOEQUIP:
//					QuickTips.show("请先放入融合炼装备！");
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.putComposeFirst"));
					break;
				case FurnaceTipsType.STONE:
//					QuickTips.show("只能放入蓝色装备！");
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.putBlueEquipOnly"));
					break;
				case FurnaceTipsType.NOSTONE:
//					QuickTips.show("操作不符，请仔细查看说明！");
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.errorAction"));
					break;
				case FurnaceTipsType.PROTECTBAG:
//					QuickTips.show("只能放入融合保护符！");
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.putComposeProtectOnly"));
					break;
				case FurnaceTipsType.LUCKYBAG:
//					QuickTips.show("只能放入融合幸运符！");
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.putComposeLuckyOnly"));
					break;
			}
		}
		
		private function blueEquipChecker(info:ItemInfo):int
		{
			if(!CategoryType.isEquip(info.template.categoryId))
			{
				return FurnaceTipsType.EQUIP;
			}
			else 
			{
				if(info.template.quality !=  2)
				{
					return FurnaceTipsType.STONE;
				}
			}
			return FurnaceTipsType.SUCCESS;
		}
		
		private function  purpleEquipChecker1(info:ItemInfo):int
		{
			var tmpEquip:ItemInfo = _cells[0].itemInfo;
			if(!tmpEquip)
			{
				return FurnaceTipsType.NOEQUIP
			}
			else
			{
				//是否装备、是否紫装、是否和蓝装同一职业、
				if(CategoryType.isEquip(info.template.categoryId) && (info.template.quality == 3 || info.template.quality == 4)  && info.template.needCareer == tmpEquip.template.needCareer)
				{
					if((_cells[0].furnaceItemInfo.bagItemInfo.template.needLevel >= 40 && _cells[0].furnaceItemInfo.bagItemInfo.template.needLevel <= 50 &&  info.template.needLevel == 40) ||
							(_cells[0].furnaceItemInfo.bagItemInfo.template.needLevel >=60 &&_cells[0].furnaceItemInfo.bagItemInfo.template.needLevel <= 70 &&  info.template.needLevel == 60))
					{
						if(_cells[2].furnaceItemInfo)
						{
							if(info.template.suitId == _cells[2].itemInfo.template.suitId)
							{
								return FurnaceTipsType.SUCCESS;
							}
							else
							{
								return FurnaceTipsType.NOSTONE;
							}
						}
						else
						{
							return FurnaceTipsType.SUCCESS;
						}
					}
					else
					{
						return FurnaceTipsType.NOSTONE;
					}
				}
				else
				{
					return FurnaceTipsType.NOSTONE;
				}
			}
			return FurnaceTipsType.SUCCESS;
		}
		
		private function  purpleEquipChecker2(info:ItemInfo):int
		{
			var tmpEquip:ItemInfo = _cells[0].itemInfo;
			if(!tmpEquip)
			{
				return FurnaceTipsType.NOEQUIP
			}
			else
			{
				//是否装备、是否紫装、是否和蓝装同一职业、
				if(CategoryType.isEquip(info.template.categoryId) && (info.template.quality == 3 || info.template.quality == 4) && info.template.needCareer == tmpEquip.template.needCareer &&
					info.template.needLevel <=_cells[0].furnaceItemInfo.bagItemInfo.template.needLevel)
				{
					if((_cells[0].furnaceItemInfo.bagItemInfo.template.needLevel >= 40 && _cells[0].furnaceItemInfo.bagItemInfo.template.needLevel <= 50 &&  info.template.needLevel == 40) ||
						(_cells[0].furnaceItemInfo.bagItemInfo.template.needLevel >=60 &&_cells[0].furnaceItemInfo.bagItemInfo.template.needLevel <= 70 &&  info.template.needLevel == 60))
					{
						if(_cells[1].furnaceItemInfo)
						{
							if(info.template.suitId == _cells[1].itemInfo.template.suitId)
							{
								return FurnaceTipsType.SUCCESS;
							}
							else
							{
								return FurnaceTipsType.NOSTONE;
							}
						}
						else
						{
							return FurnaceTipsType.SUCCESS;
						}
					}
					else
					{
						return FurnaceTipsType.NOSTONE;
					}
				}
				else
				{
					return FurnaceTipsType.NOSTONE;
				}
			}
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
						getBackClickHandler(null);
					break
				case 1:
						updateData();
					break;
				case 2:
						updateData();
					break;
			}
		}
		
		private function updateData():void
		{
			if(_cells[1].furnaceItemInfo && _cells[2].furnaceItemInfo)
			{
				_composeBtn.enabled = true;
				_currentMoney = 0;
				_useMoneyTextField.text =_currentMoney.toString();
				_currentSuccessRate = 100;
				_successRateTextField.text = _currentSuccessRate.toString() + "%";
				_resultCell.info = ItemTemplateList.getTemplateSuitId(_cells[1].furnaceItemInfo.bagItemInfo.template.suitId,_cells[0].furnaceItemInfo.bagItemInfo.template.categoryId);
			}
			else
			{
				_composeBtn.enabled = false;
				_currentSuccessRate = 0;
				_currentMoney = 0;
				_successRateTextField.text = "";
				_useMoneyTextField.text = "";
				_resultCell.info = null;
			}
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
			if(_composeBtn)
			{
				_composeBtn.dispose();
				_composeBtn= null;
			}
			if(_resultCell)
			{
				_resultCell.dispose();
				_resultCell = null;
			}
			_successRateTextField = null;
			_useMoneyTextField = null;
		}
	}
}