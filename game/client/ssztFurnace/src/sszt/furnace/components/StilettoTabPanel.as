package sszt.furnace.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
	import sszt.core.data.furnace.parametersList.HoleTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.titles.TitleTemplateInfo;
	import sszt.core.data.titles.TitleTemplateList;
	import sszt.core.data.vip.VipTemplateInfo;
	import sszt.core.data.vip.VipTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.quickTips.QuickTips;
//	import mhsm.furnace.ForbbidenAsset;
	import sszt.furnace.components.cell.FurnaceBaseCell;
	import sszt.furnace.components.cell.FurnaceCell;
	import sszt.furnace.data.FurnaceBuyType;
	import sszt.furnace.data.FurnaceTipsType;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.events.FuranceEvent;
	import sszt.furnace.mediators.FurnaceMediator;
	import sszt.furnace.socketHandlers.FurnaceOpenHoleSocketHandler;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class StilettoTabPanel extends BaseFurnaceTabPanel
	{
		private var _bg:IMovieWrapper;
		private var _getBackBtn:MCacheAsset1Btn;
		private var _openHoleBtn:MCacheAsset1Btn;
		
		private var _currentSuccessRate:int;
		private var _currentMoney:int;
		private var _successRateTextFiled:TextField;
		private var _useMoneyTextField:TextField;
		private var _vipSuccessRateTextField:TextField;
		
//		private var _percentList:Array;
//		private var _useMoneyList:Array;
		
//		private var _holeCellsPoses:Vector.<Point> = Vector.<Point>([new Point(0,0),new Point(47,0),new Point(94,0)]);
		private var _holeCellsPoses:Array = [new Point(0,0),new Point(47,0),new Point(94,0),new Point(141,0),new Point(188,0)];
		private var _holeCellLayer:Sprite;
//		new Point(65,154),new Point(112,154),new Point(159,154)
		
		/**装备打孔材料**/
//		public static const STILETTO_MATERIAL_CATEGORYID_LIST:Vector.<int> = Vector.<int>([CategoryType.STILETTO]);
		public static const STILETTO_MATERIAL_CATEGORYID_LIST:Array = [CategoryType.STILETTO];
		
		public function StilettoTabPanel(mediator:FurnaceMediator)
		{
			super(mediator);
		}
		
		override protected function init():void
		{
			super.init();
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(1,223,125,19)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(140,223,125,19)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(16,152,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(63,152,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(110,152,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(157,152,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(204,152,40,40),new Bitmap(CellCaches.getCellBg()))
			]);
			addChild(_bg as DisplayObject);
			
			var _bg1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.furnace.normalHole"),MAssetLabel.LABELTYPE15);
			_bg1.move(18,165);
			addChild(_bg1);
			var _bg2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.furnace.normalHole"),MAssetLabel.LABELTYPE15);
			_bg2.move(65,165);
			addChild(_bg2);
			var _bg3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.furnace.normalHole"),MAssetLabel.LABELTYPE15);
			_bg3.move(112,165);
			addChild(_bg3);
			var _bg4:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.furnace.specialHole"),MAssetLabel.LABELTYPE15);
			_bg4.move(159,165);
			addChild(_bg4);
			var _bg5:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.furnace.specialHole"),MAssetLabel.LABELTYPE15);
			_bg5.move(206,165);
			addChild(_bg5);
			
			_holeCellLayer = new Sprite();
			_holeCellLayer.x = 18;
			_holeCellLayer.y = 154;
			addChild(_holeCellLayer);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(77,5,112,17),new MAssetLabel(LanguageManager.getWord("ssztl.furnace.inputStilettoEquip"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(30,206,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.furnace.needFare"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(181,206,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.furnace.successRate"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(106,251,52,17),new MAssetLabel(LanguageManager.getWord("ssztl.furnace.stilettoExplain"),MAssetLabel.LABELTYPE14)));
			
			/**---------------处理显示的textField---------------**/
//			var rectVector:Vector.<Rectangle> = Vector.<Rectangle>([new Rectangle(30,224,58,17),new Rectangle(187,224,58,17)]);
//			var textFieldVector:Vector.<TextField> = new Vector.<TextField>(rectVector.length);
			var rectVector:Array = [new Rectangle(30,224,58,17),new Rectangle(160,224,58,17),new Rectangle(190,224,58,17)];
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
			_useMoneyTextField = textFieldVector[textFieldVector.length - 3];
			_successRateTextFiled = textFieldVector[textFieldVector.length - 2];
			_vipSuccessRateTextField = textFieldVector[textFieldVector.length - 1];
			/**--------------------------------------------**/
			
			_getBackBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.furnace.getBackEquip"));
			_getBackBtn.move(95,75);
			addChild(_getBackBtn);
			
			_openHoleBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.furnace.beginStiletto"));
			_openHoleBtn.enabled = false;
			_openHoleBtn.move(95,382);
			addChild(_openHoleBtn);
			
//			_percentList = [[100,90,80,70,60],[100,80,70,60,50],[100,70,60,50,40],[100,60,50,40,30]];
//			_useMoneyList = [[10,20,30,40,50],[20,30,40,50,70],[30,40,50,70,100],[40,50,70,100,150]];
		}
		
		override public function show():void
		{
			super.show();
			/**加载数据到快速购买**/
//			furnaceInfo.currentBuyType = FurnaceBuyType.OPENHOLE;
			/**加载数据到另外两个面板**/
			furnaceInfo.initialFurnaceVector(qualityItemListChecker,STILETTO_MATERIAL_CATEGORYID_LIST);
			/**监听背包变化**/
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_getBackBtn.addEventListener(MouseEvent.CLICK,getBackBtnHandler);
			_openHoleBtn.addEventListener(MouseEvent.CLICK,openHoleBtnHandler);
		}
		
		override public function hide():void
		{
			super.hide();
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_getBackBtn.removeEventListener(MouseEvent.CLICK,getBackBtnHandler);
			_openHoleBtn.removeEventListener(MouseEvent.CLICK,openHoleBtnHandler);
//			getBackBtnHandler(null);
		}
		
		private function getBackBtnHandler(e:MouseEvent):void
		{
			clearCells();
		}
		override protected function middleCellClearHandler(e:FuranceEvent):void
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
			_openHoleBtn.enabled = false;
			_currentSuccessRate = 0;
			_currentMoney = 0;
			_successRateTextFiled.text = "";
			_useMoneyTextField.text = "";
			_vipSuccessRateTextField.text = "";
		}
		
		private function clearHoles():void
		{
			for(var i:int = _holeCellLayer.numChildren - 1;i>= 0;i--)
			{
				_holeCellLayer.removeChildAt(i);
			}
		}
		
		private function openHoleBtnHandler(e:MouseEvent):void
		{
			if(_currentMoney > GlobalData.selfPlayer.userMoney.allCopper)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
				return;
			}
			
			for each(var j:FurnaceCell in _cells)
			{
				if(!_cells[0].furnaceItemInfo.bagItemInfo.isBind && j.furnaceItemInfo && j.furnaceItemInfo.bagItemInfo.isBind)
				{
					MAlert.show(LanguageManager.getWord("ssztl.furnace.stilettoExistBind"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
					return;
				}
			}
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					_mediator.sendOpenHole(_cells[0].itemInfo.place,_cells[1].itemInfo.place);
				}
			}

			_mediator.sendOpenHole(_cells[0].itemInfo.place,_cells[1].itemInfo.place);
			_openHoleBtn.enabled = false;
		}
		
		/**监听背包信息更新**/
		private function bagItemUpdateHandler(e:BagInfoUpdateEvent):void
		{
//			var tmpItemIdList:Vector.<Number> = e.data as Vector.<Number>;
			var tmpItemIdList:Array = e.data as Array;
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				furnaceInfo.updateBagToFurnace(tmpItemIdList[i],qualityItemListChecker,STILETTO_MATERIAL_CATEGORYID_LIST);
			}
		}
		
		/**检测列表过滤条件**/
		private function qualityItemListChecker(argItemInfo:ItemInfo):Boolean
		{
			if(argItemInfo && CategoryType.isEquip(argItemInfo.template.categoryId) && 
				argItemInfo.template.canEnchase && argItemInfo.template.quality != 0 && argItemInfo.getUsedHoleCount(false) != 3)
			{
				return true;
			}
			return false;
		}
		
//		override protected function getCellPos():Vector.<Point>
//		{
//			return Vector.<Point>([new Point(112,30),new Point(112,107)]);
//		}
		override protected function getCellPos():Array
		{
			return [new Point(112,30),new Point(112,107)];
		}

		
//		override protected function getBackgroundName():Vector.<String>
//		{
//			return Vector.<String>(["装 备","开孔石"]);
//		}
		override protected function getBackgroundName():Array
		{
			return [LanguageManager.getWord("ssztl.furnace.equip"),LanguageManager.getWord("ssztl.common.stileto")];
		}
		
//		override protected function getAcceptCheckers():Vector.<Function>
//		{
//			return Vector.<Function>([equipChecker,openHoleChecker]);
//		}
		override protected function getAcceptCheckers():Array
		{
			return [equipChecker,openHoleChecker];
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
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.onlyInputStilettoEquip"));
					break;
				case FurnaceTipsType.NOEQUIP:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputStilettoEquipFirst"));
					break;
				case FurnaceTipsType.STONE:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.stilettoNotMatch"));
					break;
				case FurnaceTipsType.NOSTONE:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputStilettoStoneFirst"));
					break;
				case FurnaceTipsType.PROTECTBAG:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.onlyStilettoProtectSynbol"));
					break;
				case FurnaceTipsType.LUCKYBAG:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.onlyStilettoLuckySynbol"));
					break;
				case FurnaceTipsType.HOLEFULL:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.fullStilettoNum"));
					break;
			}
		}
		
		private function equipChecker(info:ItemInfo):int
		{
			if(!CategoryType.isEquip(info.template.categoryId))
			{
				return FurnaceTipsType.EQUIP;
			}
			return FurnaceTipsType.SUCCESS;
		}
		
		private function openHoleChecker(info:ItemInfo):int
		{
			var tmpEquip:ItemInfo = _cells[0].itemInfo;
			if(!tmpEquip){return FurnaceTipsType.NOEQUIP}
			else
			{
				if(tmpEquip.getUsedHoleCount(false) == 3)
				{
					return FurnaceTipsType.HOLEFULL;
				}
				if(info.template.categoryId != CategoryType.STILETTO)
				{
					return FurnaceTipsType.STONE;
				}
			}
			return FurnaceTipsType.SUCCESS;
		}
		
		override protected function updateFurnaceHandler(evt:FuranceEvent):void
		{
			var _place:int =evt.data["place"] as int;
			var _furnaceItemInfo:FurnaceItemInfo = evt.data["info"] as FurnaceItemInfo;
			_cells[_place].furnaceItemInfo = _furnaceItemInfo;
			
			var isAutoFill:Boolean = false;
			//更新格子视图后续处理
			switch(_place)
			{
				case 0:
					if(!_furnaceItemInfo)
					{
						getBackBtnHandler(null);
					}
					else
					{
						updateHoleCells(_furnaceItemInfo.bagItemInfo);
						isAutoFill = true;
					}
					break
				case 1:
					if(_furnaceItemInfo)
					{
						updateData(_cells[0].furnaceItemInfo.bagItemInfo,_furnaceItemInfo.bagItemInfo);
					}
					else
					{
						clearCells(false);
						updateHoleCells(_cells[0].furnaceItemInfo.bagItemInfo);
					}
					break;
			}
			if(isAutoFill)
			{
				autoFillCells(CategoryType.STILETTO,_cells[0].furnaceItemInfo.bagItemInfo.isBind);
			}
		}
		
		private function updateData(argEquipItemInfo:ItemInfo,argItemInfo:ItemInfo):void
		{
			/**成功率计算公式**/
			updateSuccessRate(argEquipItemInfo);
			_openHoleBtn.enabled = true;
			/**装备开孔收费**/
			_currentMoney =  HoleTemplateList.getHoleInfoNum(1,argEquipItemInfo.getUsedHoleCount(false) +1);
			_useMoneyTextField.text =_currentMoney.toString();
		}
		
		/**更新成功率**/
		private function updateSuccessRate(argEquipItemInfo:ItemInfo):void
		{
			/**成功率消耗系数**/
			_currentSuccessRate = HoleTemplateList.getHoleInfoNum(0,argEquipItemInfo.getUsedHoleCount(false) +1);
			if(_currentSuccessRate > 100)_currentSuccessRate = 100;
			_successRateTextFiled.text = _currentSuccessRate.toString() + "%";
			
			//vip附加成功率
			if(GlobalData.selfPlayer.getVipType() > 2)
			{
				var tmpVipTemplateInfo:VipTemplateInfo = VipTemplateList.getVipTemplateInfo(GlobalData.selfPlayer.getVipType());
				var tmpTitleTemplateInfo:TitleTemplateInfo = TitleTemplateList.getTitle(tmpVipTemplateInfo.titleId);
				_vipSuccessRateTextField.textColor = CategoryType.getQualityColor(tmpTitleTemplateInfo.quality);
				_vipSuccessRateTextField.text = " + " +tmpVipTemplateInfo.holeRate.toString() + "%";
			}
		}
		
		private function updateHoleCells(argEquipItemInfo:ItemInfo):void
		{
			var tmpBitmap:Bitmap;
//			var tmpBitmapData:BitmapData = new ForbbidenAsset();
			var tmpCell:FurnaceBaseCell;
			if(argEquipItemInfo.enchase1 < 0)
			{
//				tmpBitmap = new Bitmap(tmpBitmapData);
//				tmpBitmap.x = _holeCellsPoses[0].x + 5;
//				tmpBitmap.y = _holeCellsPoses[0].y + 5;
//				_holeCellLayer.addChild(tmpBitmap);
			}
			else if(argEquipItemInfo.enchase1 > 0)
			{
				tmpCell = new FurnaceBaseCell();
				tmpCell.info = ItemTemplateList.getTemplate(argEquipItemInfo.enchase1);
				tmpCell.x = _holeCellsPoses[0].x;
				tmpCell.y = _holeCellsPoses[0].y;
				_holeCellLayer.addChild(tmpCell);
			}
			if(argEquipItemInfo.enchase2 < 0)
			{
//				tmpBitmap = new Bitmap(tmpBitmapData);
//				tmpBitmap.x = _holeCellsPoses[1].x + 5;
//				tmpBitmap.y = _holeCellsPoses[1].y + 5;
//				_holeCellLayer.addChild(tmpBitmap);
			}
			else if(argEquipItemInfo.enchase2 > 0)
			{
				tmpCell = new FurnaceBaseCell();
				tmpCell.info = ItemTemplateList.getTemplate(argEquipItemInfo.enchase2);
				tmpCell.x = _holeCellsPoses[1].x;
				tmpCell.y = _holeCellsPoses[1].y;
				_holeCellLayer.addChild(tmpCell);
			}
			if(argEquipItemInfo.enchase3 < 0)
			{
//				tmpBitmap = new Bitmap(tmpBitmapData);
//				tmpBitmap.x = _holeCellsPoses[2].x + 5;
//				tmpBitmap.y = _holeCellsPoses[2].y + 5;
//				_holeCellLayer.addChild(tmpBitmap);
			}
			else if(argEquipItemInfo.enchase3 > 0)
			{
				tmpCell = new FurnaceBaseCell();
				tmpCell.info = ItemTemplateList.getTemplate(argEquipItemInfo.enchase3);
				tmpCell.x = _holeCellsPoses[2].x;
				tmpCell.y = _holeCellsPoses[2].y;
				_holeCellLayer.addChild(tmpCell);
			}
			if(argEquipItemInfo.enchase4 <= 0)
			{
				if(argEquipItemInfo.strengthenLevel < 7)
				{
//					tmpBitmap = new Bitmap(tmpBitmapData);
//					tmpBitmap.x = _holeCellsPoses[3].x + 5;
//					tmpBitmap.y = _holeCellsPoses[3].y + 5;
//					_holeCellLayer.addChild(tmpBitmap);
				}
			}
			else if(argEquipItemInfo.enchase4 > 0)
			{
				tmpCell = new FurnaceBaseCell();
				tmpCell.info = ItemTemplateList.getTemplate(argEquipItemInfo.enchase4);
				tmpCell.x = _holeCellsPoses[3].x;
				tmpCell.y = _holeCellsPoses[3].y;
				_holeCellLayer.addChild(tmpCell);
				if(argEquipItemInfo.strengthenLevel < 7)
				{
					tmpCell.locked = true;
				}
			}
			if(argEquipItemInfo.enchase5 <= 0)
			{
				if(argEquipItemInfo.strengthenLevel < 10)
				{
//					tmpBitmap = new Bitmap(tmpBitmapData);
//					tmpBitmap.x = _holeCellsPoses[4].x + 5;
//					tmpBitmap.y = _holeCellsPoses[4].y + 5;
//					_holeCellLayer.addChild(tmpBitmap);
				}
			}
			else if(argEquipItemInfo.enchase5 > 0)
			{
				tmpCell = new FurnaceBaseCell();
				tmpCell.info = ItemTemplateList.getTemplate(argEquipItemInfo.enchase5);
				tmpCell.x = _holeCellsPoses[4].x;
				tmpCell.y = _holeCellsPoses[4].y;
				_holeCellLayer.addChild(tmpCell);
				if(argEquipItemInfo.strengthenLevel < 10)
				{
					tmpCell.locked = true;
				}
			}
		}
		
		override protected function materialAddHandler(e:FuranceEvent):void
		{
			if(_cells[0].furnaceItemInfo)autoFillCells(CategoryType.STILETTO,_cells[0].furnaceItemInfo.bagItemInfo.isBind);
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
			if(_openHoleBtn)
			{
				_openHoleBtn.dispose();
				_openHoleBtn = null;
			}
			_successRateTextFiled = null;
			_useMoneyTextField = null;
			_vipSuccessRateTextField = null;
//			_percentList = null;
//			_useMoneyList = null;
			
			_holeCellsPoses = null;
			_holeCellLayer = null;
		}
	}
}