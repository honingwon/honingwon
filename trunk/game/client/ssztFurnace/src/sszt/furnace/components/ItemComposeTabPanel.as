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
	
	import sszt.constData.CategoryType;
	import sszt.core.caches.NumberCache;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.furnace.LuckComposeTemplateInfo;
	import sszt.core.data.furnace.LuckComposeTemplateList;
	import sszt.core.data.furnace.parametersList.DecomposeTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.item.OrangeItemTemplateInfo;
	import sszt.core.data.item.OrangeItemTemplateList;
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
	
	public class ItemComposeTabPanel extends BaseFurnaceTabPanel
	{
		private var _bg:IMovieWrapper;
		private var _getBackBtn1:MCacheAsset1Btn;
		private var _composeBtn:MCacheAsset1Btn;
		private var _batchComposeBtn:MCacheAsset1Btn;
		private var _useMoneyTextField:TextField;
		private var _successRateTextField:TextField;
		private var _currentMoney:int;
		private var _currentSuccessRate:int;
		public static const LABEL_FORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,4);
		
		/**装备合成材料**/
		public static const STONECOMPOSE_MATERIAL_CATEGORYID_LIST:Array = [];
		
		private var _resultCell:FurnaceBaseCell;
		private var _countLabel:MAssetLabel;
		
		private static const ITEM_LIST:Array = [CategoryType.STRENGTHNEWPROTECTSYMBOL,CategoryType.REBUILD,CategoryType.PET_SKILL_BOOK,CategoryType.FIRE];
		
		public function ItemComposeTabPanel(mediator:FurnaceMediator)
		{
			super(mediator);
		}
		
		override protected function init():void
		{
			super.init();
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(1,223,125,19)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(140,223,125,19)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(112,130,40,40),new Bitmap(CellCaches.getCellBg())),
			]);
			addChild(_bg as DisplayObject);
			
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.furnace.inputNeedComposeMaterial"),MAssetLabel.LABELTYPE14);
			label1.move(77,5);
			addChild(label1);
			//			var label2:MAssetLabel = new MAssetLabel("费用(铜币)",MAssetLabel.LABELTYPE14);
			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.furnace.needFare"),MAssetLabel.LABELTYPE14);
			label2.move(30,206);
			addChild(label2);
			//			var label3:MAssetLabel = new MAssetLabel("成功率",MAssetLabel.LABELTYPE14);
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.furnace.successRate"),MAssetLabel.LABELTYPE14);
			label3.move(181,206);
			addChild(label3);
			//			var label4:MAssetLabel = new MAssetLabel("神佑说明",MAssetLabel.LABELTYPE14);
			var label4:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.furnace.composeExplain"),MAssetLabel.LABELTYPE14);
			label4.move(106,251);
			addChild(label4);
			
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
			_useMoneyTextField = textFieldVector[textFieldVector.length - 2];
			_successRateTextField = textFieldVector[textFieldVector.length - 1];
			/**--------------------------------------------**/
			
			_resultCell = new FurnaceBaseCell();
			_resultCell.move(114,132);
			addChild(_resultCell);
			
			_getBackBtn1 = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.furnace.getBackMatrial"));
			_getBackBtn1.move(95,95);
			addChild(_getBackBtn1);
			
			_countLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_countLabel.move(180,50);
			addChild(_countLabel);
			//			_getBackBtn2 = new MCacheAsset1Btn(2,"取回装备");
			//			_getBackBtn2.move(169,107);
			//			addChild(_getBackBtn2);
			
			_composeBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.furnace.compose"));
			_composeBtn.enabled = false;
			_composeBtn.move(30,382);
			addChild(_composeBtn);
			
			_batchComposeBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.furnace.multiCompose"));
			_batchComposeBtn.enabled = false;
			_batchComposeBtn.move(130,382);
			addChild(_batchComposeBtn);
		}
		
		override public function show():void
		{
			super.show();
			/**加载数据到快速购买**/
			furnaceInfo.currentBuyType = FurnaceBuyType.ITEMCOMPOSE;
			/**加载数据到另外两个面板**/
			furnaceInfo.initialFurnaceVector(qualityItemListChecker,STONECOMPOSE_MATERIAL_CATEGORYID_LIST);
			/**监听背包变化**/
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_getBackBtn1.addEventListener(MouseEvent.CLICK,getBackClickHandler);
			//			_getBackBtn2.addEventListener(MouseEvent.CLICK,getBackClickHandler);
			_composeBtn.addEventListener(MouseEvent.CLICK,composeBtnHandler);
			_batchComposeBtn.addEventListener(MouseEvent.CLICK,batchComposeBtnHandler);
		}
		
		override public function hide():void
		{
			super.hide();
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_getBackBtn1.removeEventListener(MouseEvent.CLICK,getBackClickHandler);
			//			_getBackBtn2.removeEventListener(MouseEvent.CLICK,getBackClickHandler);
			_composeBtn.removeEventListener(MouseEvent.CLICK,composeBtnHandler);
			_batchComposeBtn.addEventListener(MouseEvent.CLICK,batchComposeBtnHandler);
		}
		
		override public function addAssets():void
		{
		}
		
		/**监听背包信息更新**/
		private function bagItemUpdateHandler(e:BagInfoUpdateEvent):void
		{
			//			var tmpItemIdList:Vector.<Number> = e.data as Vector.<Number>;
			var tmpItemIdList:Array = e.data as Array;
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				furnaceInfo.updateBagToFurnace(tmpItemIdList[i],qualityItemListChecker,STONECOMPOSE_MATERIAL_CATEGORYID_LIST);
			}
			updateCount();
		}
		
		/**检测列表过滤条件**/
		private function qualityItemListChecker(argItemInfo:ItemInfo):Boolean
		{
			if(argItemInfo && LuckComposeTemplateList.getLuckComposeTemplateInfo(argItemInfo.templateId))
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
			_resultCell.info = null;
			_countLabel.text = "";
			_composeBtn.enabled = false;
			_batchComposeBtn.enabled = false;
			_currentSuccessRate = 0;
			_currentMoney = 0;
			_successRateTextField.text = "";
			_useMoneyTextField.text = "";
//			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagUpdateHandler);
		}
		
		private function batchComposeBtnHandler(e:MouseEvent):void
		{
			var tmp:LuckComposeTemplateInfo = LuckComposeTemplateList.getLuckComposeTemplateInfo(_cells[0].furnaceItemInfo.bagItemInfo.templateId);
			var bagCount:int = GlobalData.bagInfo.getItemCountById(tmp.formulaId);
			var materialInfo:ItemTemplateInfo = ItemTemplateList.getTemplate(tmp.formulaId);
			var targetInfo:ItemTemplateInfo = ItemTemplateList.getTemplate(tmp.createId);
			var canCount:int = bagCount/tmp.createAmount;
			var allCopper:int = canCount * tmp.copper;
			if(canCount < 1)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.mutrialNotEnough"));
				return;
			}
			if(GlobalData.bagInfo.currentSize >= GlobalData.selfPlayer.bagMaxCount)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagFull"));
				return;
			}
			if(allCopper > GlobalData.selfPlayer.userMoney.allCopper)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
				return;
			}
//			var content1:String = "            将" + canCount * tmp.needCount + "个<font color = '#FFCC00'>" +materialInfo.name+"</font>\n           合成" + canCount + "个<font color = '#FFCC00'>" + targetInfo.name+ "</font>";
			var content1:String = LanguageManager.getWord("ssztl.furnace.composeToNum",canCount * tmp.createAmount,materialInfo.name,canCount,targetInfo.name);
//			var content2:String = "            将" + canCount * tmp.needCount + "个<font color = '#FFCC00'>" +materialInfo.name+"</font>\n           合成" + canCount + "个<font color = '#FFCC00'>" + targetInfo.name+ "</font>\n                 (绑定)";
//			if(GlobalData.bagInfo.hasBindItem(tmp.materialTemplateId))
//			{
//				MAlert.show(content2,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler,TextFormatAlign.CENTER,-1,true,false);
//			}
//			else
//			{
			MAlert.show(content1,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler,TextFormatAlign.CENTER,-1,true,false);
//			}
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					send();
				}
			}
			function send():void
			{
//				_mediator.sendItemCompose(_cells[0].furnaceItemInfo.bagItemInfo.templateId,2);
				clearCells();
				_composeBtn.enabled = false;
				_batchComposeBtn.enabled = false;
			}
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
			var tmp:LuckComposeTemplateInfo = LuckComposeTemplateList.getLuckComposeTemplateInfo(_cells[0].furnaceItemInfo.bagItemInfo.templateId);
			if(!_cells[0].furnaceItemInfo.bagItemInfo.isBind && GlobalData.bagInfo.hasBindItem(tmp.formulaId))
			{
				MAlert.show(LanguageManager.getWord("ssztl.furnace.hasBindMatrial"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
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
//				_mediator.sendItemCompose(_cells[0].furnaceItemInfo.bagItemInfo.templateId,1);
				clearCells();
				_composeBtn.enabled = false;
				_batchComposeBtn.enabled = false;
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
					//					QuickTips.show("只能放入装备！");
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.onlyEquip"));
					break;
				case FurnaceTipsType.NOEQUIP:
					//					QuickTips.show("请先放入装备！");
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.equipFirst"));
					break;
				case FurnaceTipsType.ENCHASEFULL:
					//					QuickTips.show("请放入合适的晶石！");
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputJingShi"));
					break;
				case FurnaceTipsType.STONE1:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.putMatchMatrialOnly"));
					break;
			}
		}
		
		override protected function getCellPos():Array
		{
			return [new Point(114,40)];
		}
		override protected function getBackgroundName():Array
		{
			return [LanguageManager.getWord("ssztl.common.material")];
		}		
		override protected function getAcceptCheckers():Array
		{
			return [equipChecker1];
		}
		private function equipChecker1(info:ItemInfo):int
		{
			if(ITEM_LIST.indexOf(info.template.categoryId) == -1)return FurnaceTipsType.STONE1;
			if(_cells[0].furnaceItemInfo)return FurnaceTipsType.NOSTONE;
			return FurnaceTipsType.SUCCESS;
		}
		
		//		private function equipChecker2(info:ItemInfo):int
		//		{
		//			if(!_cells[0].furnaceItemInfo)return FurnaceTipsType.NOEQUIP;
		//			if(_cells[1].furnaceItemInfo)return FurnaceTipsType.NOSTONE;
		//			if(info.templateId != OrangeItemTemplateList.getOrangeItemTemplateInfo(_cells[0].furnaceItemInfo.bagItemInfo.templateId).amethystTempId)return FurnaceTipsType.ENCHASEFULL;
		//			return FurnaceTipsType.SUCCESS;
		//		}
		
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
//						GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagUpdateHandler);
					}
					break;
			}
		}
		
		private function updateData(argEquipItemInfo:ItemInfo):void
		{
			/**成功率计算公式**/
			updateSuccessRate(argEquipItemInfo);
			var tmp:LuckComposeTemplateInfo = LuckComposeTemplateList.getLuckComposeTemplateInfo(argEquipItemInfo.templateId);
			/**费用：系数**/
			_currentMoney =  tmp.copper;
			_useMoneyTextField.text =_currentMoney.toString();
			_resultCell.info = ItemTemplateList.getTemplate(tmp.createId);
			updateCount();
		}
		
//		private function bagUpdateHandler(e:BagInfoUpdateEvent):void
//		{
//			updateCount();
//		}
		
		private function updateCount():void
		{
			if(!_cells[0].furnaceItemInfo)return;
			var tmp:LuckComposeTemplateInfo = LuckComposeTemplateList.getLuckComposeTemplateInfo(_cells[0].furnaceItemInfo.bagItemInfo.templateId);
			var bagCount:int = GlobalData.bagInfo.getItemCountById(tmp.formulaId);
			if(bagCount < tmp.createAmount)
			{
				_countLabel.htmlText = "<font color = '#ff0000'>" + bagCount.toString() +"</font>" + " / " + tmp.createAmount.toString();
				_composeBtn.enabled = false;
				_batchComposeBtn.enabled = false;
			}
			else
			{
				_countLabel.htmlText = bagCount.toString() + " / " + tmp.createAmount.toString();
				_composeBtn.enabled = true;
				_batchComposeBtn.enabled = true;
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
			//			if(_getBackBtn2)
			//			{
			//				_getBackBtn2.dispose();
			//				_getBackBtn2 = null;
			//			}
			if(_composeBtn)
			{
				_composeBtn.dispose();
				_composeBtn = null;
			}
			if(_batchComposeBtn)
			{
				_batchComposeBtn.dispose();
				_batchComposeBtn = null;
			}
			if(_resultCell)
			{
				_resultCell.dispose();
				_resultCell = null;
			}
			_useMoneyTextField = null;
			_successRateTextField = null;
			_countLabel = null;
		}
	}
}