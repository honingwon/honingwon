package sszt.furnace.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import mx.messaging.AbstractConsumer;
	
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.bag.ClientBagInfoUpdateEvent;
	import sszt.core.data.furnace.parametersList.PickStoneTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.furnace.components.cell.FurnaceBaseCell;
	import sszt.furnace.components.cell.FurnaceCell;
	import sszt.furnace.data.FurnaceBuyType;
	import sszt.furnace.data.FurnaceTipsType;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.events.FuranceEvent;
	import sszt.furnace.mediators.FurnaceMediator;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.furnace.BorderCellBgAsset;
	import ssztui.furnace.BorderCellBgAsset2;
	import ssztui.furnace.EnchaseLockAsset;
	import ssztui.furnace.EnchaseOffAsset;
	import ssztui.ui.CellBgAsset;
	
	public class RemoveTabPanel extends BaseFurnaceTabPanel
	{
		private var _bg:IMovieWrapper;
//		private var _getBackBtn:MCacheAsset1Btn;
		private var _removeBtn:MCacheAssetBtn1;
		private var _useMoneyTextField:MAssetLabel;
		private var _successRateTextFiled:MAssetLabel;
		private var _currentSuccessRate:int;
		private var _currentMoney:int;
		private var _currentCell:FurnaceBaseCell;
		
		private var _rateBar:Bitmap;
		
//		private var _holeCellVector:Vector.<FurnaceBaseCell> = new Vector.<FurnaceBaseCell>(3);
//		
//		private var _holeCellsPoses:Vector.<Point> = Vector.<Point>([new Point(0,0),new Point(47,0),new Point(94,0)]);
		private var _holeCellVector:Array = new Array(6);
		private var _lockCellVector:Array = new Array(6);
		private var _holeCellsPoses:Array = [new Point(108,48),new Point(74,111),new Point(108,174),new Point(186,174),new Point(220,111),new Point(186,48)];
		private var _holeCellLayer:Sprite;
		private var _tipVector:Array = [0,0,0,6,8,10];
//		new Point(65,154),new Point(112,154),new Point(159,154)
		
		private var _removeEffect1:BaseLoadEffect;
//		private var _removeEffect2:BaseLoadEffect;
		
		/**摘取宝石材料**/
//		public static const REMOVE_MATERIAL_CATEGORYID_LIST:Vector.<int> = Vector.<int>([CategoryType.STONEPICKSYMBOL]);
		public static const REMOVE_MATERIAL_CATEGORYID_LIST:Array = [CategoryType.STONEPICKSYMBOL];
		public static const REMOVE_SPELL_LIST:Array = [202141,202142,202143];
		
		public function RemoveTabPanel(mediator:FurnaceMediator)
		{
			super(mediator);
		}
		
		override protected function init():void
		{
			_rateBar = new Bitmap();
			_rateBar.x = 84;
			_rateBar.y = 224;
			addChild(_rateBar);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(141,105,50,50),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(104,44,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(182,44,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(70,107,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(216,107,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(104,170,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(182,170,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(271,10,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(108,48,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(74,111,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(108,174,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(186,174,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(220,111,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(186,48,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addChild(_bg as DisplayObject);
			super.init();
			
			/**---------------处理显示的textField---------------**/

			_holeCellLayer = new Sprite();
			addChild(_holeCellLayer);
		
			_useMoneyTextField = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_useMoneyTextField.move(65,320);
			addChild(_useMoneyTextField);
			_successRateTextFiled = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2);
			_successRateTextFiled.move(166,234);
			addChild(_successRateTextFiled);
			_successRateTextFiled.setValue(LanguageManager.getWord("ssztl.furnace.successRate") + "：");
			/**--------------------------------------------**/
			
			_removeBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.furnace.beginRemove"));
			_removeBtn.enabled = false;
			_removeBtn.move(115,269);
			addChild(_removeBtn);
		}
		
		override public function show():void
		{
			super.show();
			/**加载数据到快速购买**/
			furnaceInfo.currentBuyType = FurnaceBuyType.REMOVE;
			/**加载数据到另外两个面板**/
			furnaceInfo.initialFurnaceVector(qualityItemListChecker,REMOVE_MATERIAL_CATEGORYID_LIST);
			/**监听背包变化**/
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
//			_getBackBtn.addEventListener(MouseEvent.CLICK,getBackBtnHandler);
			_removeBtn.addEventListener(MouseEvent.CLICK,removeBtnHandler);
			furnaceModule.furnaceInfo.addEventListener(FuranceEvent.REMOVE_SUCCESS,removeHandler);
		}
		
		override public function hide():void
		{
			super.hide();
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
//			_getBackBtn.removeEventListener(MouseEvent.CLICK,getBackBtnHandler);
			_removeBtn.removeEventListener(MouseEvent.CLICK,removeBtnHandler);
			furnaceModule.furnaceInfo.removeEventListener(FuranceEvent.REMOVE_SUCCESS,removeHandler);
//			getBackBtnHandler(null);
		}
		
		override public function addAssets():void
		{
			_rateBar.bitmapData = AssetUtil.getAsset("ssztui.furnace.BarBgAsset1" ,BitmapData) as BitmapData;
		}
		
		private function getBackBtnHandler(e:MouseEvent):void
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
			_removeBtn.enabled = false;
			_currentSuccessRate = 0;
			_currentMoney = 0;
			_successRateTextFiled.text = LanguageManager.getWord("ssztl.furnace.successRate") + "：0%";
			_useMoneyTextField.text = "0";
			_currentCell = null;
			for each(var c:FurnaceBaseCell in _holeCellVector)
			{
				if(c)
				{
					c.dispose();
					c = null;
				}
			}
			for each(var m:Sprite in _lockCellVector)
			{
				if(m)
				{
					m.removeEventListener(MouseEvent.MOUSE_OVER, tipShowHandler);
					m.removeEventListener(MouseEvent.MOUSE_OUT, tipHideHandler);
					m = null;
				}
			}
		}
		
		private function clearHoles():void
		{
			for(var i:int = _holeCellLayer.numChildren - 1;i>= 0;i--)
			{
				_holeCellLayer.removeChildAt(i);
			}
		}
		
		
		private function removeBtnHandler(e:MouseEvent):void
		{
//			_mediator.sendRebuild();
			if(GlobalData.bagInfo.currentSize >= GlobalData.selfPlayer.bagMaxCount)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagFull"));
				return;
			}
			var removeBagPlace:int = 999;
			if(_cells[1].furnaceItemInfo)
			{
				removeBagPlace = _cells[1].furnaceItemInfo.bagItemInfo.place;
			}
			else if(_currentCell)
			{
				var tmpTemplateInfo:ItemTemplateInfo = ItemTemplateList.getTemplate(_currentCell.info.templateId);
				var Index:int = getRemoveSpellByLevel(tmpTemplateInfo.property3);
				MAlert.show(LanguageManager.getWord("ssztl.furnace.notEnoughSpell"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,alertCloseHandler);
				function alertCloseHandler(evt:CloseEvent):void
				{
					if(evt.detail == MAlert.OK)
					{
						BuyPanel.getInstance().show([REMOVE_SPELL_LIST[Index]],new ToStoreData(ShopID.QUICK_BUY));
					}
				}
				return;
			}
			if(_currentMoney > GlobalData.selfPlayer.userMoney.allCopper)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
				return;
			}
			
			var _currentPoint:int = _holeCellVector.indexOf(_currentCell)+1;
			
			for each(var j:FurnaceCell in _cells)
			{
				if(!_cells[0].furnaceItemInfo.bagItemInfo.isBind && j.furnaceItemInfo && j.furnaceItemInfo.bagItemInfo.isBind)
				{
					MAlert.show(LanguageManager.getWord("ssztl.furnace.removeExistBind"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
					return;
				}
			}
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					_mediator.sendRemove(_cells[0].furnaceItemInfo.bagItemInfo.place,removeBagPlace,_currentPoint);
				}
			}
			_mediator.sendRemove(_cells[0].furnaceItemInfo.bagItemInfo.place,removeBagPlace,_currentPoint);
			_removeBtn.enabled = false;
//			_currentCell = null;
		}
		
		private function getHolePlace(argEquip:ItemInfo,argItemTemplateId:int):int
		{
			var place:int = 999;
			if(argEquip.enchase1 == argItemTemplateId)place = 1;
			if(argEquip.enchase2 == argItemTemplateId)place = 2;
			if(argEquip.enchase3 == argItemTemplateId)place = 3;
			if(argEquip.enchase4 == argItemTemplateId)place = 4;
			if(argEquip.enchase5 == argItemTemplateId)place = 5;
			if(argEquip.enchase6 == argItemTemplateId)place = 6;
			return place;
		}
		private function removeHandler(evt:FuranceEvent):void
		{
			if(!_removeEffect1)
			{
				_removeEffect1 = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.XIANGQIAN_EFFECT_1));; //ZHAIQU_EFFECT_1
				if(_currentCell) _removeEffect1.move(_currentCell.x+19,_currentCell.y+19);
				_removeEffect1.addEventListener(Event.COMPLETE,remove1CompleteHandler);
				_removeEffect1.play(SourceClearType.TIME,300000);
				addChild(_removeEffect1);
			}
//			if(!_removeEffect2)
//			{
//				_removeEffect2 = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.ZHAIQU_EFFECT_2));
//				_removeEffect2.move(196,192);
//				_removeEffect2.addEventListener(Event.COMPLETE,remove2CompleteHandler);
//				_removeEffect2.play(SourceClearType.TIME,300000);
//				addChild(_removeEffect2);
//			}
		}
		private function remove1CompleteHandler(evt:Event):void
		{
			_removeEffect1.removeEventListener(Event.COMPLETE,remove1CompleteHandler);
			_removeEffect1.dispose();
			_removeEffect1 = null;
		}
//		private function remove2CompleteHandler(evt:Event):void
//		{
//			_removeEffect2.removeEventListener(Event.COMPLETE,remove2CompleteHandler);
//			_removeEffect2.dispose();
//			_removeEffect2 = null;
//		}
		/**监听背包信息更新**/
		private function bagItemUpdateHandler(e:BagInfoUpdateEvent):void
		{
//			var tmpItemIdList:Vector.<Number> = e.data as Vector.<Number>;
			var tmpItemIdList:Array = e.data as Array;
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				furnaceInfo.updateBagToFurnace(tmpItemIdList[i],qualityItemListChecker,REMOVE_MATERIAL_CATEGORYID_LIST);
			}
		}
		
		/**检测列表过滤条件**/
		private function qualityItemListChecker(argItemInfo:ItemInfo):Boolean
		{
			if(argItemInfo && argItemInfo.template.canEnchase && argItemInfo.template.quality != 0 &&
				(argItemInfo.getEnchaseCount(true) != 0 || argItemInfo.getSpecialEnchaseHoleCount()))
			{
				return true;
			}
			return false;
		}
		override protected function getCellPos():Array
		{
			return [new Point(147,111),new Point(275,14),
			];
		}
		
//		override protected function getBackgroundName():Vector.<String>
//		{
//			return Vector.<String>(["装 备","摘取符"]);
//		}
		override protected function getBackgroundName():Array
		{
			return [LanguageManager.getWord("ssztl.furnace.equip"),LanguageManager.getWord("ssztl.furnace.pickSymbol")];
		}
		
//		override protected function getAcceptCheckers():Vector.<Function>
//		{
//			return Vector.<Function>([equipChecker,removeBagChecker,null,null,null,null,null]);
//		}
		override protected function getAcceptCheckers():Array
		{
			return [equipChecker,removeBagChecker,null,null,null,null,null];
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
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.onlyInputenchasedEquip"));
					break;
				case FurnaceTipsType.NOEQUIP:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputenchasedEquipFirst"));
					break;
				case FurnaceTipsType.STONE:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.pickSymbolNotMatch"));
					break;
				case FurnaceTipsType.NOSTONE:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputPickSymbolFirst"));
					break;
				case FurnaceTipsType.PROTECTBAG:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputProtectSymbol"));
					break;
				case FurnaceTipsType.LUCKYBAG:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputLuckySymbol"));
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
		
		private function getRemoveSpellByLevel(itemLevel:int):int
		{
			if (itemLevel < 4)
				return 0;
			else if (itemLevel > 3 && itemLevel < 7)
				return 1;
			else 
				return 2;
		}
		
		private function removeBagChecker(info:ItemInfo):int
		{
			//要选中宝石后才能放入摘取符
			if(!_cells[0].itemInfo || _currentCell == null)
			{
				return FurnaceTipsType.STONE;
			}
			else
			{
				if(info.template.categoryId != CategoryType.STONEPICKSYMBOL)
				{
					return FurnaceTipsType.STONE;
				}
				//根据宝石等级判断
				var tmpTemplateInfo:ItemTemplateInfo = ItemTemplateList.getTemplate(_currentCell.info.templateId);
				if(info.template.property3 == 1 && tmpTemplateInfo.property3 < 4 || 
					info.template.property3 == 2 && tmpTemplateInfo.property3 > 3 && tmpTemplateInfo.property3 < 7 ||
					info.template.property3 == 3 && tmpTemplateInfo.property3 > 6 && tmpTemplateInfo.property3 <= 10)
				{
					return FurnaceTipsType.SUCCESS;
				}
				else
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
						_removeBtn.enabled = true;
					}
					break
				case 1:
					if(_cells[1].furnaceItemInfo)
					{
						updateData(_cells[0].furnaceItemInfo.bagItemInfo,ItemTemplateList.getTemplate(_currentCell.info.templateId));
						_removeBtn.enabled = true;
					}
					else
					{
//						_removeBtn.enabled = false;
					}
					break;
			}
			
			if(isAutoFill)
			{
				autoFillCells(CategoryType.STONEPICKSYMBOL,_cells[0].furnaceItemInfo.bagItemInfo.isBind);
			}
		}
		
		private function updateData(argEquipItemInfo:ItemInfo,argItemTemplateInfo:ItemTemplateInfo):void
		{
			/**成功率计算公式**/
			updateSuccessRate(argItemTemplateInfo);
			/**宝石摘取收取金钱**/
			_currentMoney =  PickStoneTemplateList.getPickStoneInfo(argItemTemplateInfo.property3).copperModulus;
			_useMoneyTextField.text =_currentMoney.toString();
		}
		
		/**更新成功率**/
		private function updateSuccessRate(argItemTemplateInfo:ItemTemplateInfo):void
		{
			/**成功率:(宝石等级系数) **/
			_currentSuccessRate = PickStoneTemplateList.getPickStoneInfo(argItemTemplateInfo.property3).successRates;
			if(_currentSuccessRate > 100)_currentSuccessRate = 100;
			_successRateTextFiled.text = LanguageManager.getWord("ssztl.furnace.successRate") + "：" + _currentSuccessRate.toString() + "%";
		}
		
		private function updateHoleCells1(enchase:int,index:int):void
		{
			
			if(enchase < 0)
			{
				var tmpBitmap:Sprite = new Sprite();
				tmpBitmap.addChild(new Bitmap(new EnchaseOffAsset()));
				tmpBitmap.x = _holeCellsPoses[index].x;
				tmpBitmap.y = _holeCellsPoses[index].y;			
				tmpBitmap.addEventListener(MouseEvent.MOUSE_OVER, tipShowHandler);
				tmpBitmap.addEventListener(MouseEvent.MOUSE_OUT, tipHideHandler);
				_holeCellLayer.addChild(tmpBitmap);
				_lockCellVector[index] = tmpBitmap;
			}			
			if(enchase > 0)
			{
				var tmpCell:FurnaceBaseCell;
				tmpCell = new FurnaceBaseCell();
				tmpCell.info = ItemTemplateList.getTemplate(enchase);
				tmpCell.x = _holeCellsPoses[index].x;
				tmpCell.y = _holeCellsPoses[index].y;
				_holeCellLayer.addChild(tmpCell);
				_holeCellVector[index] = tmpCell;
				tmpCell.addEventListener(MouseEvent.CLICK,holeClickHandler);
				if(!_currentCell)
				{
					_currentCell = tmpCell;
				}
				var tmpBitmap1:Bitmap = new Bitmap(new EnchaseLockAsset());
				tmpBitmap1.x = _holeCellsPoses[index].x - 3;
				tmpBitmap1.y = _holeCellsPoses[index].y - 3;				
				_holeCellLayer.addChild(tmpBitmap1);
			}
			
		}
		
		private function updateHoleCells(argEquipItemInfo:ItemInfo):void
		{
			updateHoleCells1(argEquipItemInfo.enchase1,0);
			updateHoleCells1(argEquipItemInfo.enchase2,1);
			updateHoleCells1(argEquipItemInfo.enchase3,2);
			updateHoleCells1(argEquipItemInfo.enchase4,3);
			updateHoleCells1(argEquipItemInfo.enchase5,4);
			updateHoleCells1(argEquipItemInfo.enchase6,5);
			if(_currentCell)
			{
				_currentCell.select = true;
//				_removeBtn.enabled = true;
//				updateData(_cells[0].furnaceItemInfo.bagItemInfo,ItemTemplateList.getTemplate(tmpCell.info.templateId));
			}
		}
		
		
		private function holeClickHandler(e:MouseEvent):void
		{
			var tmpCell:FurnaceBaseCell = e.currentTarget as FurnaceBaseCell;
			//点击同一个格子时
			if(_currentCell == tmpCell)return;
			//格子不为空时，先把上次一次的不选
			if(_currentCell)
			{
				_currentCell.select = false;
			}
			_currentCell = tmpCell;
			_currentCell.select = true;
//			_removeBtn.enabled = true;
			
			//清空摘取石
			if(_cells[1].furnaceItemInfo)
			{
				furnaceInfo.deleteToPlace(_cells[1].furnaceItemInfo,1);
			}
			updateData(_cells[0].furnaceItemInfo.bagItemInfo,ItemTemplateList.getTemplate(tmpCell.info.templateId));
			
			//自动填充
			autoFillCells(CategoryType.STONEPICKSYMBOL,_cells[0].furnaceItemInfo.bagItemInfo.isBind);
		}
		private function tipShowHandler(e:MouseEvent):void
		{
			var level:int = _tipVector[_lockCellVector.indexOf(e.target)];
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.furnace.stilettoOpenNeedLevel",level),null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		private function tipHideHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		override protected function middleCellClearHandler(e:FuranceEvent):void
		{
			clearCells();
		}
		
		//购买时自动填充
		override protected function materialAddHandler(e:FuranceEvent):void
		{
			if(_cells[0].furnaceItemInfo)autoFillCells(CategoryType.STONEPICKSYMBOL,_cells[0].furnaceItemInfo.bagItemInfo.isBind);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
//			if(_getBackBtn)
//			{
//				_getBackBtn.dispose();
//				_getBackBtn = null;
//			}
			if(_removeBtn)
			{
				_removeBtn.dispose();
				_removeBtn = null;
			}
			_useMoneyTextField = null;
			_successRateTextFiled = null;
			if(_currentCell)
			{
				_currentCell.dispose();
				_currentCell = null;
			}
			for each(var i:FurnaceBaseCell in _holeCellVector)
			{
				if(i)
				{
					i.dispose();
					i = null;
				}
			}
			for each(var m:Sprite in _lockCellVector)
			{
				if(m)
				{
					m.removeEventListener(MouseEvent.MOUSE_OVER, tipShowHandler);
					m.removeEventListener(MouseEvent.MOUSE_OUT, tipHideHandler);
					m = null;
				}
			}
			if(_rateBar && _rateBar.bitmapData)
			{
				_rateBar.bitmapData.dispose();
				_rateBar = null;
			}
			_holeCellVector = null;
			
			_holeCellsPoses = null;
			_holeCellLayer = null;
		}
	}
}