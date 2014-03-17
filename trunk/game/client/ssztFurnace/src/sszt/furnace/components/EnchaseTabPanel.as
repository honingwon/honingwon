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
	
	import sszt.constData.CareerType;
	import sszt.constData.CategoryType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.bag.ClientBagInfoUpdateEvent;
	import sszt.core.data.furnace.parametersList.StoneEnchaseTemplateList;
	import sszt.core.data.furnace.parametersList.StoneMatchTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.furnace.components.cell.FurnaceBaseCell;
	import sszt.furnace.components.cell.FurnaceCell;
	import sszt.furnace.data.FurnaceBuyType;
	import sszt.furnace.data.FurnaceTipsType;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.events.FuranceEvent;
	import sszt.furnace.mediators.FurnaceMediator;
	import sszt.furnace.socketHandlers.FurnaceEnchaseSocketHandler;
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

	public class EnchaseTabPanel extends BaseFurnaceTabPanel
	{
		private var _bg:IMovieWrapper;
//		private var _getBackBtn:MCacheAsset1Btn;
		private var _enchaseBtn:MCacheAssetBtn1;
		private var _useMoneyTextField:MAssetLabel;
//		private var _successRateTextFiled:TextField;
//		private var _currentSuccessRate:int;
		private var _currentMoney:int;
		private var _currentEnchaseItemCell:FurnaceCell;
		/**镶嵌宝石材料**/
//		public static const ENCHASE_MATERIAL_CATEGORYID_LIST:Vector.<int> = CategoryType.ENCHASESTONE_TYPE;
//		private var _holeCellsPoses:Vector.<Point> = Vector.<Point>([new Point(0,0),new Point(47,0),new Point(94,0)]);
		public static const ENCHASE_MATERIAL_CATEGORYID_LIST:Array = CategoryType.ENCHASESTONE_TYPE.slice(0,CategoryType.ENCHASESTONE_TYPE.length-1);
//		private var _holeCellsPoses:Array = [new Point(53,0),new Point(95,0),new Point(140,0),new Point(181,0),new Point(224,0)];
		private var pos_x:int = 18;
		private var pos_y:int = 139;
		private var _holeCellsPoses:Array = [new Point(108,48),new Point(74,111),new Point(108,174),new Point(186,174),new Point(220,111),new Point(186,48)];
//		private var _holeCellsPoses:Array = [new Point(97 - pos_x,51 - pos_y),new Point(63 - pos_x,114 - pos_y),new Point(97 - pos_x,177 - pos_y),new Point(175 - pos_x,177 - pos_y),
//			new Point(209 - pos_x,114 - pos_y),new Point(175 - pos_x,51 - pos_y)]; //(175,51)
		private var _holeCellLayer:Sprite;
		private var _lockCellVector:Array = new Array(6);
		private var _tipVector:Array = [0,0,0,6,8,10];
		/**判断是否放入宝石，每次只能放一个**/
		private var _isChange:Boolean;
		
//		new Point(65,132),new Point(112,132),new Point(159,132)
		
		private var _previewText:Bitmap;
		
		private var _showCell:BaseItemInfoCell;
		
		private var _enchaseEffect1:BaseLoadEffect;
//		private var _enchaseEffect2:BaseLoadEffect;
		
		
		public function EnchaseTabPanel(mediator:FurnaceMediator)
		{
			super(mediator);
		}
		
		override protected function init():void
		{
			_previewText = new Bitmap();
			_previewText.x = 11;
			_previewText.y = 60;
			addChild(_previewText);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(11,12,50,50),new Bitmap(new BorderCellBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(141,105,50,50),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(104,44,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(182,44,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(70,107,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(216,107,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(104,170,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(182,170,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(17,18,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addChild(_bg as DisplayObject);
			super.init();
						
			_holeCellLayer = new Sprite();
//			_holeCellLayer.x = 18;
//			_holeCellLayer.y = 139;
			addChild(_holeCellLayer);
			
			/**---------------处理显示的textField---------------**/

			_useMoneyTextField = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_useMoneyTextField.move(65,320);
			addChild(_useMoneyTextField);
			/**--------------------------------------------**/

			
			_enchaseBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.furnace.beginEnchase"));
			_enchaseBtn.enabled = false;
			_enchaseBtn.move(115,269);
			addChild(_enchaseBtn);

			_showCell = new FurnaceCell();
			_showCell.move(17,18);
			addChild(_showCell);
			
			/** 应用给程序员看 **/
//			var lock:Bitmap = new Bitmap(new EnchaseLockAsset() as BitmapData);
//			lock.x = _holeCellsPoses[0].x - 1;
//			lock.y = _holeCellsPoses[0].y - 1;
//			addChild(lock);
//			var lock2:Bitmap = new Bitmap(new EnchaseOffAsset() as BitmapData);
//			lock2.x = _holeCellsPoses[3].x - 1;
//			lock2.y = _holeCellsPoses[3].y - 1;
//			addChild(lock2);
		}
		
		override public function show():void
		{
			super.show();
			/**加载数据到快速购买**/
			furnaceInfo.currentBuyType = FurnaceBuyType.ENCHASE;
			/**加载数据到另外两个面板**/
			furnaceInfo.initialFurnaceVector(qualityItemListChecker,ENCHASE_MATERIAL_CATEGORYID_LIST);
			/**监听背包变化**/
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);

			_enchaseBtn.addEventListener(MouseEvent.CLICK,enchaseBtnHandler);
			furnaceModule.furnaceInfo.addEventListener(FuranceEvent.ENCHASE_SUCCESS,enchaseHandler);
		}
		
		override public function hide():void
		{
			super.hide();
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);

			_enchaseBtn.removeEventListener(MouseEvent.CLICK,enchaseBtnHandler);
			furnaceModule.furnaceInfo.removeEventListener(FuranceEvent.ENCHASE_SUCCESS,enchaseHandler);
		}
		
		override public function addAssets():void
		{
			_previewText.bitmapData = AssetUtil.getAsset("ssztui.furnace.TextPreviewAsset" ,BitmapData) as BitmapData;
		}
		
		private function getBackBtnHandler(e:MouseEvent):void
		{
			clearCells();
//			furnaceInfo.chooseEnchaseMaterial(ENCHASE_MATERIAL_CATEGORYID_LIST);
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
			_showCell.itemInfo = null;
			_enchaseBtn.enabled = false;
			_isChange = false;
//			_currentSuccessRate = 0;
			_currentMoney = 0;
//			_successRateTextFiled.text = "";
			_useMoneyTextField.text = "0";
			
			furnaceInfo.currentEquipCategoryId =  -1;
		}
		
		private function clearHoles():void
		{
			for(var i:int = _holeCellLayer.numChildren - 1;i>= 0;i--)
			{
				_holeCellLayer.removeChildAt(i);
			}
		}
		
		private function enchaseBtnHandler(e:MouseEvent):void
		{
			var tmpEquipPlace:int = _cells[0].furnaceItemInfo.bagItemInfo.place;
			var tmpStonePlace:int = _currentEnchaseItemCell.itemInfo.place;
			var tmpEnchasePlace:int = _cells.indexOf(_currentEnchaseItemCell);
//			FurnaceEnchaseSocketHandler.sendEnchase(tmpEquipPlace,tmpStonePlace,tmpEnchasePlace);
			if(_currentMoney > GlobalData.selfPlayer.userMoney.allCopper)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
				return;
			}
			for each(var j:FurnaceCell in _cells)
			{
				if(!_cells[0].furnaceItemInfo.bagItemInfo.isBind && j.furnaceItemInfo && j.furnaceItemInfo.bagItemInfo.isBind)
				{
					MAlert.show(LanguageManager.getWord("ssztl.furnace.exsitBindEquip"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
					return;
				}
			}
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					_mediator.sendEnchase(tmpEquipPlace,tmpStonePlace,tmpEnchasePlace);
				}
			}
			_mediator.sendEnchase(tmpEquipPlace,tmpStonePlace,tmpEnchasePlace);
			_enchaseBtn.enabled = false;
		}
		private function enchaseHandler(evt:FuranceEvent):void
		{
			if(!_enchaseEffect1)
			{
				_enchaseEffect1 = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.XIANGQIAN_EFFECT_2)); //XIANGQIAN_EFFECT_1
				if(_currentEnchaseItemCell) _enchaseEffect1.move(_currentEnchaseItemCell.x+19,_currentEnchaseItemCell.y+19);
				_enchaseEffect1.addEventListener(Event.COMPLETE,enchase1CompleteHandler);
				_enchaseEffect1.play(SourceClearType.TIME,300000);
				addChild(_enchaseEffect1);
			}
//			if(!_enchaseEffect2)
//			{
//				_enchaseEffect2 = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.XIANGQIAN_EFFECT_2));
//				_enchaseEffect2.move(200,120);
//				_enchaseEffect2.addEventListener(Event.COMPLETE,enchase2CompleteHandler);
//				_enchaseEffect2.play(SourceClearType.TIME,300000);
//				addChild(_enchaseEffect2);
//			}
		}
		private function enchase1CompleteHandler(evt:Event):void
		{
			_enchaseEffect1.removeEventListener(Event.COMPLETE,enchase1CompleteHandler);
			_enchaseEffect1.dispose();
			_enchaseEffect1 = null;
		}
//		private function enchase2CompleteHandler(evt:Event):void
//		{
//			_enchaseEffect2.removeEventListener(Event.COMPLETE,enchase2CompleteHandler);
//			_enchaseEffect2.dispose();
//			_enchaseEffect2 = null;
//		}
		/**监听背包信息更新**/
		private function bagItemUpdateHandler(e:BagInfoUpdateEvent):void
		{
//			var tmpItemIdList:Vector.<Number> = e.data as Vector.<Number>;
			var tmpItemIdList:Array = e.data as Array
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				furnaceInfo.updateBagToFurnace(tmpItemIdList[i],qualityItemListChecker,ENCHASE_MATERIAL_CATEGORYID_LIST);
			}
		}
		
		/**检测列表过滤条件**/
		private function qualityItemListChecker(argItemInfo:ItemInfo):Boolean
		{
			if(argItemInfo && argItemInfo.template.canEnchase && CategoryType.isCanEnchaseEquip(argItemInfo.template.categoryId) &&
				argItemInfo.template.quality != 0 && (argItemInfo.getOpenHoleCount(true) != 0))
			{
				return true;
			}
			return false;
		}
		
//		override protected function getCellPos():Vector.<Point>
		override protected function getCellPos():Array
		{
//			return Vector.<Point>([new Point(112,43),new Point(65,132),new Point(112,132),new Point(159,132)]);
			return [new Point(147,111),	new Point(108,48),new Point(74,111),new Point(108,174),new Point(186,174),new Point(220,111),new Point(186,48)]; //(175,51)
		}
		
//		override protected function getBackgroundName():Vector.<String>
		override protected function getBackgroundName():Array
		{
			return [LanguageManager.getWord("ssztl.furnace.equip"),
				LanguageManager.getWord("ssztl.common.stone"),
				LanguageManager.getWord("ssztl.common.stone"),
				LanguageManager.getWord("ssztl.common.stone"),
				LanguageManager.getWord("ssztl.common.stone"),
				LanguageManager.getWord("ssztl.common.stone"),
				LanguageManager.getWord("ssztl.common.stone")];
		}
		
//		override protected function getAcceptCheckers():Vector.<Function>
		override protected function getAcceptCheckers():Array
		{
			return [equipChecker,enchaseStoneChecker1,enchaseStoneChecker2,enchaseStoneChecker3,enchaseStoneChecker4,enchaseStoneChecker5,enchaseStoneChecker6];
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
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputEncharsableEquip"));
					break;
				case FurnaceTipsType.NOEQUIP:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputEncharsableEquipFirst"));
					break;
				case FurnaceTipsType.STONE:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.stoneEquipNotSuit"));
					break;
				case FurnaceTipsType.NOSTONE:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputStoneFirst"));
					break;
				case FurnaceTipsType.PROTECTBAG:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputProtectSymbol"));
					break;
				case FurnaceTipsType.LUCKYBAG:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputLuckySymbol"));
					break;
				case FurnaceTipsType.STONE1:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputOnlyOneStone"));
					break;
				case FurnaceTipsType.ENCHASEFULL:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.encharseFull"));
					break;
				case FurnaceTipsType.STONE2:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.cannotEncharseSame"));
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
		
		private function enchaseStoneChecker1(info:ItemInfo):int
		{
			return enchaseStoneChecker(1,info);
		}
		private function enchaseStoneChecker2(info:ItemInfo):int
		{
			return enchaseStoneChecker(2,info);
		}
		
		private function enchaseStoneChecker3(info:ItemInfo):int
		{
			return enchaseStoneChecker(3,info);
//			//判断是否孔已满
		}
		
		private function enchaseStoneChecker4(info:ItemInfo):int
		{
			return enchaseStoneChecker(4,info);
		}
		private function enchaseStoneChecker5(info:ItemInfo):int
		{
			return enchaseStoneChecker(5,info);
		}
		private function enchaseStoneChecker6(info:ItemInfo):int
		{
			return enchaseStoneChecker(6,info);
		}
		
		
		private function enchaseStoneChecker(argHolePlace:int,info:ItemInfo):int
		{
			//判断是否孔已满
			if(_cells[0].itemInfo && _cells[0].itemInfo.enchase1 != 0 && _cells[0].itemInfo.enchase2 != 0 && _cells[0].itemInfo.enchase3 != 0
				&& _cells[0].itemInfo.enchase4 != 0 && _cells[0].itemInfo.enchase5 != 0 && _cells[0].itemInfo.enchase6 != 0)
			{
				return FurnaceTipsType.ENCHASEFULL;
			}
			var tmpEquip:ItemInfo = _cells[0].itemInfo;
			if(!tmpEquip){return FurnaceTipsType.NOEQUIP}
			else
			{
				/**没开孔、其他孔已经放入镶嵌宝石**/
				if(CategoryType.isEnchaseStone(info.template.categoryId) &&
					StoneMatchTemplateList.getStoneMatchInfo(tmpEquip.template.categoryId).isSuitableStone(info.template.categoryId))
				{
					if(_isChange)
					{
						return FurnaceTipsType.STONE1;
						
					}
//					//------------------/
					if(tmpEquip["enchase" + argHolePlace] != 0)
					{
						return FurnaceTipsType.STONE;
					}//第六个孔能镶嵌同一类型宝石
					if(argHolePlace == 6)
					{
						//
					}
					else if((tmpEquip.enchase1 > 0 && info.template.categoryId == ItemTemplateList.getTemplate(tmpEquip.enchase1).categoryId) || 
						(tmpEquip.enchase2 > 0 && info.template.categoryId == ItemTemplateList.getTemplate(tmpEquip.enchase2).categoryId) ||
						(tmpEquip.enchase3 > 0 && info.template.categoryId == ItemTemplateList.getTemplate(tmpEquip.enchase3).categoryId) ||
							(tmpEquip.enchase4 > 0 && info.template.categoryId == ItemTemplateList.getTemplate(tmpEquip.enchase4).categoryId) ||
							(tmpEquip.enchase5 > 0 && info.template.categoryId == ItemTemplateList.getTemplate(tmpEquip.enchase5).categoryId))
					{
						return FurnaceTipsType.STONE2;
					}
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
			
			if(_place == 0)
			{
				if(!_furnaceItemInfo)
				{
					getBackBtnHandler(null);
//					furnaceInfo.chooseEnchaseMaterial(ENCHASE_MATERIAL_CATEGORYID_LIST);
				}
				else
				{
					/**画上已镶嵌宝石到格子**/
					updateHoleCells(_furnaceItemInfo.bagItemInfo);
					furnaceInfo.chooseEnchaseMaterial(null,_cells[0].furnaceItemInfo.bagItemInfo.template.categoryId);
					furnaceInfo.currentEquipCategoryId = _cells[0].furnaceItemInfo.bagItemInfo.template.categoryId;
//					equipFillAgain(_furnaceItemInfo.bagItemInfo.itemId);
					updateShowCell(_furnaceItemInfo);
				}
			}
			else{
				if(_cells[_place].itemInfo) 
				{
					_isChange = true;
					_currentEnchaseItemCell = _cells[_place];
					updateData(_cells[0].furnaceItemInfo.bagItemInfo,_furnaceItemInfo.bagItemInfo);
				}
				else{
						_isChange = false;
						_enchaseBtn.enabled = false;
				}
			}
		}
		
		private function updateShowCell(argInfo:FurnaceItemInfo):void
		{
			var tmpInfo:ItemInfo = new ItemInfo();
			tmpInfo.itemId = argInfo.bagItemInfo.itemId;
			tmpInfo.templateId = argInfo.bagItemInfo.templateId;
			tmpInfo.isBind = argInfo.bagItemInfo.isBind;
			tmpInfo.wuHunId = argInfo.bagItemInfo.wuHunId;
			tmpInfo.strengthenLevel = argInfo.bagItemInfo.strengthenLevel;
			tmpInfo.strengthenPerfect = argInfo.bagItemInfo.strengthenPerfect;
			tmpInfo.count = argInfo.bagItemInfo.count;
			tmpInfo.place = argInfo.bagItemInfo.place;
			tmpInfo.stallSellPrice = argInfo.bagItemInfo.stallSellPrice;
			tmpInfo.date = argInfo.bagItemInfo.date;
			tmpInfo.state = argInfo.bagItemInfo.state;
			
				tmpInfo.enchase1 = 202020;
				tmpInfo.enchase2 = 202040;
				tmpInfo.enchase3 = 202100;
				tmpInfo.enchase4 = 202060;
				tmpInfo.enchase5 = 202080;
				tmpInfo.enchase6 = 202020;

			tmpInfo.isExist = argInfo.bagItemInfo.isExist;
			tmpInfo.attack = argInfo.bagItemInfo.attack;
			tmpInfo.defence = argInfo.bagItemInfo.defence;
			tmpInfo.durable = argInfo.bagItemInfo.durable;
			tmpInfo.freePropertyVector = argInfo.bagItemInfo.freePropertyVector;
			tmpInfo.lastUseTime = argInfo.bagItemInfo.lastUseTime;
			tmpInfo.isInCooldown = argInfo.bagItemInfo.isInCooldown;
			_showCell.itemInfo = tmpInfo;
		}
		
		private function updateData(argEquipItemInfo:ItemInfo,argItemInfo:ItemInfo):void
		{
			/**成功率计算公式**/
//			updateSuccessRate(argEquipItemInfo);
			_enchaseBtn.enabled = true;
			/**装备镶嵌收费**/
			_currentMoney =  StoneEnchaseTemplateList.getStoneEnchaseInfo(argItemInfo.template.property3).copper;
//			var level:int = argItemInfo.template.property3;
//			_currentMoney = level * 1000 + level ^ 2 * 100;
			_useMoneyTextField.text =_currentMoney.toString();
		}
		
		/**更新成功率**/
//		private function updateSuccessRate(argEquipItemInfo:ItemInfo):void
//		{
//			/**成功率100%**/
//			_currentSuccessRate = 100;
//			_successRateTextFiled.text = _currentSuccessRate.toString() + "%";
//		}
		
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
		
		override protected function otherClickUpdate(argFurnaceItemInfo:FurnaceItemInfo, isShowTips:Boolean=true):Boolean
		{
			//格子孔是否满时
			if(_cells[0].furnaceItemInfo && 
				_cells[0].furnaceItemInfo.bagItemInfo.enchase1 > 0 &&
				_cells[0].furnaceItemInfo.bagItemInfo.enchase2 > 0 &&
				_cells[0].furnaceItemInfo.bagItemInfo.enchase3 > 0 &&
				_cells[0].furnaceItemInfo.bagItemInfo.enchase4 > 0 &&
				_cells[0].furnaceItemInfo.bagItemInfo.enchase5 > 0 &&
				_cells[0].furnaceItemInfo.bagItemInfo.enchase6 > 0 &&
				 !CategoryType.isEquip(argFurnaceItemInfo.bagItemInfo.template.categoryId))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.enchaseFull"));
				return false;
			}
			
			return super.otherClickUpdate(argFurnaceItemInfo,isShowTips);
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
//			if(_getBackBtn)
//			{
//				_getBackBtn.dispose();
//				_getBackBtn = null;
//			}
			if(_enchaseBtn)
			{
				_enchaseBtn.dispose();
				_enchaseBtn = null;
			}
			if(_showCell)
			{
				_showCell.dispose();
				_showCell = null;
			}
			_useMoneyTextField = null;
//			_successRateTextFiled = null;
			if(_currentEnchaseItemCell)
			{
				_currentEnchaseItemCell.dispose();
				_currentEnchaseItemCell = null;
			}
			if(_previewText && _previewText.bitmapData)
			{
				_previewText.bitmapData.dispose();
				_previewText = null;
			}
			_holeCellsPoses = null;
			_holeCellLayer = null;
		}
	}
}