package sszt.furnace.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.caches.NumberCache;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.expList.ExpList;
	import sszt.core.data.furnace.CuiLianTemplateInfo;
	import sszt.core.data.furnace.CuiLianTemplateList;
	import sszt.core.data.furnace.parametersList.DecomposeTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.item.OrangeItemTemplateInfo;
	import sszt.core.data.item.OrangeItemTemplateList;
	import sszt.core.data.item.PlaceCategoryTemaplteList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.furnace.components.cell.FurnaceBaseCell;
	import sszt.furnace.components.cell.FurnaceCell;
	import sszt.furnace.data.FurnaceBuyType;
	import sszt.furnace.data.FurnaceTipsType;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.events.FuranceEvent;
	import sszt.furnace.mediators.FurnaceMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.cells.CellCaches;
	
	public class EquipWuHunPanel extends BaseFurnaceTabPanel
	{
		private var _bg:IMovieWrapper;
		private var _getBackBtn1:MCacheAsset1Btn;
		//		private var _getBackBtn2:MCacheAsset1Btn;
		private var _cuiBtn:MCacheAsset1Btn;
		private var _useExpTextField:TextField;
		private var _successRateTextField:TextField;
		private var _currentExp:int;
		private var _currentSuccessRate:int;
		public static const LABEL_FORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,2);
		
		/**装备淬炼材料**/
		public static const EQUIPCUI_MATERIAL_CATEGORYID_LIST:Array = [CategoryType.WUHUN];
		
		private var _resultLabel:MAssetLabel;
		private var _resultCell:BaseItemInfoCell;
		private var _stoneCell:FurnaceBaseCell;
		private var _countLabel:MAssetLabel;
		
		public function EquipWuHunPanel(mediator:FurnaceMediator)
		{
			super(mediator);
		}
		
		override protected function init():void
		{
			super.init();
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(1,223,125,19)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(140,223,125,19)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(113,33,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(189,79,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(85,98,93,7),new Bitmap(new DoubleArrowAsset()))
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(96,80,74,29),new Bitmap(new TipsAsset()))
			]);
			addChild(_bg as DisplayObject);
			
			var _showBg:Bitmap = new Bitmap(CellCaches.getCellBg());
			_showBg.x = 104;
			_showBg.y = 77;
			addChild(_showBg);
			
			var label1:MAssetLabel = new MAssetLabel("请放入要淬炼的装备",MAssetLabel.LABELTYPE14);
			label1.move(77,5);
			addChild(label1);
			var label2:MAssetLabel = new MAssetLabel("消耗现有经验值",MAssetLabel.LABELTYPE14);
			label2.move(30,206);
			addChild(label2);
			var label3:MAssetLabel = new MAssetLabel("成功率",MAssetLabel.LABELTYPE14);
			label3.move(181,206);
			addChild(label3);
			var label4:MAssetLabel = new MAssetLabel("淬炼说明",MAssetLabel.LABELTYPE14);
			label4.move(106,251);
			addChild(label4);
			
			var label5:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.orangeEquip"),MAssetLabel.LABELTYPE15);
			label5.move(120,45);
			addChild(label5);
			
			var label6:MAssetLabel = new MAssetLabel("魂石",MAssetLabel.LABELTYPE15);
			label6.move(195,91);
			addChild(label6);
			
			/**---------------处理显示的textField---------------**/
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
			_useExpTextField = textFieldVector[textFieldVector.length - 2];
			_successRateTextField = textFieldVector[textFieldVector.length - 1];
			/**--------------------------------------------**/
			
//			_resultCell = new BaseItemInfoCell();
//			_resultCell.move(114,132);
//			addChild(_resultCell);
			
			_resultLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.CENTER);
			_resultLabel.defaultTextFormat = LABEL_FORMAT;
			_resultLabel.setTextFormat(LABEL_FORMAT);
			_resultLabel.wordWrap = true;
			_resultLabel.multiline = true;
			_resultLabel.width = 240;
			_resultLabel.move(16,155);
			addChild(_resultLabel);
			
			_resultCell = new BaseItemInfoCell();
			_resultCell.move(115,35);
			addChild(_resultCell);
			
			_stoneCell = new FurnaceBaseCell();
			_stoneCell.move(191,81);
			addChild(_stoneCell);
			
			_getBackBtn1 = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.furnace.getBackEquip"));
			_getBackBtn1.move(18,125);
			addChild(_getBackBtn1);
			
			_countLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_countLabel.move(205,130);
			addChild(_countLabel);
			//			_getBackBtn2 = new MCacheAsset1Btn(2,"取回装备");
			//			_getBackBtn2.move(169,107);
			//			addChild(_getBackBtn2);
			
			_cuiBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.furnace.beginCuiLian"));
			_cuiBtn.enabled = false;
			_cuiBtn.move(95,382);
			addChild(_cuiBtn);
		}
		
		override public function show():void
		{
			super.show();
			/**加载数据到快速购买**/
			furnaceInfo.currentBuyType = FurnaceBuyType.WUHUN;
			/**加载数据到另外两个面板**/
			furnaceInfo.initialFurnaceVector(qualityItemListChecker,EQUIPCUI_MATERIAL_CATEGORYID_LIST);
			/**监听背包变化**/
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_getBackBtn1.addEventListener(MouseEvent.CLICK,getBackClickHandler);
			//			_getBackBtn2.addEventListener(MouseEvent.CLICK,getBackClickHandler);
			_cuiBtn.addEventListener(MouseEvent.CLICK,cuiLianBtnHandler);
		}
		
		override public function hide():void
		{
			super.hide();
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_getBackBtn1.removeEventListener(MouseEvent.CLICK,getBackClickHandler);
			//			_getBackBtn2.removeEventListener(MouseEvent.CLICK,getBackClickHandler);
			_cuiBtn.removeEventListener(MouseEvent.CLICK,cuiLianBtnHandler);
		}
		
		/**监听背包信息更新**/
		private function bagItemUpdateHandler(e:BagInfoUpdateEvent):void
		{
			//			var tmpItemIdList:Vector.<Number> = e.data as Vector.<Number>;
			var tmpItemIdList:Array = e.data as Array;
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				furnaceInfo.updateBagToFurnace(tmpItemIdList[i],qualityItemListChecker,EQUIPCUI_MATERIAL_CATEGORYID_LIST);
			}
		}
		
		/**检测列表过滤条件**/
		private function qualityItemListChecker(argItemInfo:ItemInfo):Boolean
		{
			if(argItemInfo && argItemInfo.strengthenLevel >= 10 && argItemInfo.template.quality == 4 && CategoryType.isWuHun(argItemInfo.template.categoryId))
			{
				return true;
			}
			return false;
		}
		
		private function getBackClickHandler(evt:MouseEvent):void
		{
			switch(evt.currentTarget)
			{
				case _getBackBtn1:
					clearCells();
					break;
				//				case _getBackBtn2:
				//					clearCells(false);
				//					break;
			}
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
			_resultLabel.text = "";
			_resultCell.info = null;
			_stoneCell.info = null;
			_countLabel.text = "";
			_cuiBtn.enabled = false;
			_currentSuccessRate = 0;
			_currentExp = 0;
			_successRateTextField.text = "";
			_useExpTextField.text = "";
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagUpdateHandler);
		}
		
		private function cuiLianBtnHandler(e:MouseEvent):void
		{
			if(GlobalData.bagInfo.currentSize >= GlobalData.selfPlayer.bagMaxCount)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagFull"));
				return;
			}
			//---------经验计算------------//
			var exp:Number = 0;
			if(ExpList.list[GlobalData.selfPlayer.level+1])
			{
				exp = GlobalData.selfPlayer.currentExp - ExpList.list[GlobalData.selfPlayer.level].totalExp;
			}else
			{
				exp = GlobalData.selfPlayer.currentExp - ExpList.list[GlobalData.selfPlayer.level - 1].totalExp;
			}
			if(_currentExp > exp)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.expNotEnough"));
//				QuickTips.show(LanguageManager.getWord("当前经验不足，不能提升武魂。"));
				return;
			}
			var tmp:CuiLianTemplateInfo;
			if(_cells[0].furnaceItemInfo.bagItemInfo.wuHunId == 0)
			{
				tmp = CuiLianTemplateList.getCuiLianByCategoryId(PlaceCategoryTemaplteList.categoryToPlace(_cells[0].furnaceItemInfo.bagItemInfo.template.categoryId),1);
			}
			else
			{
				tmp = CuiLianTemplateList.getCuiLianTemplateInfo(_cells[0].furnaceItemInfo.bagItemInfo.wuHunId);
			}
			if(tmp.level >= 10)
			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.wuHunMaxEnough"));
				QuickTips.show("武魂已达最高级，无需淬炼。");
				return;
			}
			if(!_cells[0].furnaceItemInfo.bagItemInfo.isBind && GlobalData.bagInfo.hasBindItem(tmp.needId))
			{
				MAlert.show(LanguageManager.getWord("ssztl.furnace.hasBindPurple"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
			}
			else
			{
				send();
			}
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					send();
				}
			}
			function send():void
			{
				_mediator.sendCuiLian(_cells[0].furnaceItemInfo.bagItemInfo.place);
				clearCells();
				_cuiBtn.enabled = false;
			}
		}
		
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
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.onlyEquip"));
					break;
				case FurnaceTipsType.NOEQUIP:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.equipFirst"));
					break;
				case FurnaceTipsType.ENCHASEFULL:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputJingShi"));
					break;
				case FurnaceTipsType.STONE1:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.onlyPurpleEquip"));
					break;
				case FurnaceTipsType.STONE2:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.strengthLevel10"));
					break;
			}
		}
		
		override protected function getCellPos():Array
		{
			return [new Point(35,79)];
		}
		override protected function getBackgroundName():Array
		{
			//			return ["紫装"];
			return [LanguageManager.getWord("ssztl.common.orangeEquip")];
		}		
		override protected function getAcceptCheckers():Array
		{
			return [equipChecker1];
		}
		private function equipChecker1(info:ItemInfo):int
		{
			if(!CategoryType.isEquip(info.template.categoryId))return FurnaceTipsType.EQUIP;
			if(info.template.quality != 4)return FurnaceTipsType.STONE1;
			if(info.strengthenLevel < 10)return FurnaceTipsType.STONE2;
			if(_cells[0].furnaceItemInfo)return FurnaceTipsType.NOSTONE;
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
						clearCells();
					}
					else
					{
						updateData(_cells[0].furnaceItemInfo.bagItemInfo);
						GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagUpdateHandler);
					}
					break;
			}
		}
		
		private function updateData(argEquipItemInfo:ItemInfo):void
		{
			/**成功率计算公式**/
			updateSuccessRate(argEquipItemInfo);
			var tmp:CuiLianTemplateInfo;
			if(argEquipItemInfo.wuHunId == 0)
			{
				tmp = CuiLianTemplateList.getCuiLianByCategoryId(PlaceCategoryTemaplteList.categoryToPlace(argEquipItemInfo.template.categoryId),1);
			}
			else
			{
				tmp = CuiLianTemplateList.getCuiLianTemplateInfo(argEquipItemInfo.wuHunId);
			}
//			 = OrangeItemTemplateList.getOrangeItemTemplateInfo(argEquipItemInfo.templateId);
			if(!tmp)return;
			/**费用：系数**/
			_currentExp =  tmp.needExp;
			_useExpTextField.text =_currentExp.toString();
			_stoneCell.info = ItemTemplateList.getTemplate(tmp.needId);
			updateShowResultLabel(tmp);
			updateCount();
		}
		
		
		private function updateShowResultLabel(argTargetTemplateInfo:CuiLianTemplateInfo):void
		{
			var content:String = "";
			content = "<font color = '#FFFDA5'>武魂效果：</font>\n" +argTargetTemplateInfo.description + "\n";
			_resultLabel.htmlText = content;
			
			var tmpEquipInfo:ItemInfo = _cells[0].furnaceItemInfo.bagItemInfo;
			var tmpInfo:ItemInfo = new ItemInfo();
			tmpInfo.templateId = tmpEquipInfo.templateId;
			tmpInfo.strengthenLevel = tmpEquipInfo.strengthenLevel;
			tmpInfo.freePropertyVector = tmpEquipInfo.freePropertyVector;
			tmpInfo.enchase1 = tmpEquipInfo.enchase1
			tmpInfo.enchase2 = tmpEquipInfo.enchase2;
			tmpInfo.enchase3 = tmpEquipInfo.enchase3;
			tmpInfo.enchase4 = tmpEquipInfo.enchase4;
			tmpInfo.enchase5 = tmpEquipInfo.enchase5;
			tmpInfo.isBind = tmpEquipInfo.isBind;
			tmpInfo.durable = tmpEquipInfo.durable;
			var tmpWuHunId:int = CuiLianTemplateList.getCuiLianByCategoryId(argTargetTemplateInfo.place,10).id;
			tmpInfo.wuHunId = tmpWuHunId;
			_resultCell.itemInfo = tmpInfo;
		}
		
		private function bagUpdateHandler(e:BagInfoUpdateEvent):void
		{
			updateCount();
		}
		
		private function updateCount():void
		{
			var tmp:CuiLianTemplateInfo;
			if(!_cells[0].furnaceItemInfo)return;
			var argEquipItemInfo:ItemInfo = _cells[0].furnaceItemInfo.bagItemInfo;
			if(!argEquipItemInfo)return;
			if(argEquipItemInfo.wuHunId == 0)
			{
				tmp = CuiLianTemplateList.getCuiLianByCategoryId(PlaceCategoryTemaplteList.categoryToPlace(argEquipItemInfo.template.categoryId),1);
			}
			else
			{
				tmp = CuiLianTemplateList.getCuiLianTemplateInfo(argEquipItemInfo.wuHunId);
			}
			var bagCount:int = GlobalData.bagInfo.getItemCountById(tmp.needId);
			if(bagCount < tmp.needCount)
			{
				_countLabel.htmlText = "<font color = '#ff0000'>" + bagCount.toString() +"</font>" + " / " + tmp.needCount.toString();
				_cuiBtn.enabled = false;
			}
			else
			{
				_countLabel.htmlText = bagCount.toString() + " / " + tmp.needCount.toString();
				_cuiBtn.enabled = true;
			}
		}
		
		/**更新成功率**/
		private function updateSuccessRate(argEquipItemInfo:ItemInfo):void
		{
			/**成功率**/
			_currentSuccessRate = 100;
			_successRateTextField.text = _currentSuccessRate.toString() + "%";
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
			if(_getBackBtn1)
			{
				_getBackBtn1.dispose();
				_getBackBtn1 = null;
			}
			if(_cuiBtn)
			{
				_cuiBtn.dispose();
				_cuiBtn = null;
			}
			if(_resultCell)
			{
				_resultCell.dispose();
				_resultCell = null;
			}
			if(_stoneCell)
			{
				_stoneCell.dispose();
				_stoneCell = null;
			}
			_useExpTextField = null;
			_successRateTextField = null;
			_countLabel = null;
		}
	}
}