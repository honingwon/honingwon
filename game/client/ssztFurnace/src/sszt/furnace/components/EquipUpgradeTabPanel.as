package sszt.furnace.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.SourceClearType;
	import sszt.core.caches.NumberCache;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.bag.PetBagInfoUpdateEvent;
	import sszt.core.data.furnace.parametersList.DecomposeTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.item.OrangeItemTemplateInfo;
	import sszt.core.data.item.OrangeItemTemplateList;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.effects.BaseLoadEffect;
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
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.furnace.BorderCellBgAsset;
	import ssztui.furnace.BorderCellBgAsset2;
	import ssztui.furnace.LevelupArrowBgAsset;
	
	public class EquipUpgradeTabPanel extends BaseFurnaceTabPanel
	{
		private var _upgradeBtn:MCacheAssetBtn1;
		private var _useMoneyTextField:MAssetLabel;
		private var _currentMoney:int;
		/**装备转移材料**/
		public static const EQUIPTRANSFORM_MATERIAL_CATEGORYID_LIST:Array = [CategoryType.PURPLE_CRYSTAL, CategoryType.UPGRADE_UPLEVEL];
		
		private var _bg:IMovieWrapper;
		private var _resultCell:BaseItemInfoCell;
		private var _resultCellBg:Bitmap;
//		private var _stoneCell:FurnaceBaseCell;  
		
		private var _upgradeEffect:BaseLoadEffect;
		private var _successEffect:MovieClip;
		
		private var _lableArray:Array;
		
		public function EquipUpgradeTabPanel(mediator:FurnaceMediator)
		{
			super(mediator);
		}
		
		override protected function init():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(98,145,140,46),new Bitmap(new LevelupArrowBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(81,107,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(144,107,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(207,107,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(142,32,50,50),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(142,188,50,50),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(148,194,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addChild(_bg as DisplayObject);
			super.init();
			
			/**---------------处理显示的textField---------------**/
			_useMoneyTextField = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_useMoneyTextField.move(65,320);
			addChild(_useMoneyTextField);
			_lableArray = [];
			for(var i:int = 0; i < 3; i++)
			{
				var temp1:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
				//temp1.width = 30;
				addChild(temp1);
				_lableArray.push(temp1);
			}
			_lableArray[0].move(104,150);
			_lableArray[1].move(167,150);
			_lableArray[2].move(230,150);
			/**--------------------------------------------**/
			
			_resultCell = new BaseItemInfoCell();
			_resultCell.move(148,194);
			addChild(_resultCell);
			
//			_stoneCell = new FurnaceBaseCell();
//			_stoneCell.move(186,62);
//			addChild(_stoneCell);
			
			
//			_countLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
//			_countLabel.move(205,110);
//			addChild(_countLabel);

			
			_upgradeBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.furnace.beginUpgrade"));
			_upgradeBtn.enabled = false;
			_upgradeBtn.move(115,269);
			addChild(_upgradeBtn);
		}
		
		override public function show():void
		{
			super.show();
			/**加载数据到快速购买**/
			furnaceInfo.currentBuyType = FurnaceBuyType.UPGRADE;
			/**加载数据到另外两个面板**/
			furnaceInfo.initialFurnaceVector(qualityItemListChecker,EQUIPTRANSFORM_MATERIAL_CATEGORYID_LIST);
			/**监听背包变化**/
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_upgradeBtn.addEventListener(MouseEvent.CLICK,transformBtnHandler);
			furnaceModule.furnaceInfo.addEventListener(FuranceEvent.UPGRADE_SUCCESS,upgradeHandler);
			GlobalData.petBagInfo.addEventListener(PetBagInfoUpdateEvent.ITEM_ID_UPDATE,petBagItemUpdateHandler);
		}
		
		override public function hide():void
		{
			super.hide();
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_upgradeBtn.removeEventListener(MouseEvent.CLICK,transformBtnHandler);
			furnaceModule.furnaceInfo.removeEventListener(FuranceEvent.UPGRADE_SUCCESS,upgradeHandler);
			GlobalData.petBagInfo.removeEventListener(PetBagInfoUpdateEvent.ITEM_ID_UPDATE,petBagItemUpdateHandler);
		}
		
		private function petBagItemUpdateHandler(e:PetBagInfoUpdateEvent):void
		{
			var tmpItemIdList:Array = e.data as Array;
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				furnaceInfo.updatePetBagToFurnace(tmpItemIdList[i]);
			}
		}
		
		override public function addAssets():void
		{
//			_equipBg.bitmapData = AssetUtil.getAsset("ssztui.furnace.LightCellBgAsset" ,BitmapData) as BitmapData;
		}
		private function autoFillCells1(info:ItemInfo):void
		{
			//是否优先使用绑定材料
			var tmp:OrangeItemTemplateInfo = OrangeItemTemplateList.getOrangeItemTemplateInfo(info.templateId);
			if (tmp == null)
				return;
			var materialList:Array = tmp.materialList;
			for(var i:int = 0; i < materialList.length; i++)
			{
//				for(var j:int = 0;j < furnaceInfo.materialVector.length;j++)
//				{
//					if(furnaceInfo.materialVector[j].bagItemInfo.templateId == materialList[i].id)
//					{
//						if(otherClickUpdate(furnaceInfo.materialVector[j],false))break;
//					}
//				}
				//使用另一个种方式显示
				autoFillMaterial(materialList[i].id, materialList[i].value);
			}
		}
		private function autoFillMaterial(id:Number, num:Number):void
		{
//			var itemNum:int = furnaceInfo.getFurnaceItemNumByTemplateId(id);
			var tmpInfo:ItemInfo = new ItemInfo();
			tmpInfo.itemId = 0;
			tmpInfo.templateId = id;

			var checkers:Array = getAcceptCheckers();
			var isSuccess:Boolean = false;
			var tipsType:int;
			for(var i:int = 1;i <_cells.length;i++)
			{
				if(_cells[i].furnaceItemInfo == null)
				{
					tipsType = checkers[i](tmpInfo);
					if(tipsType == FurnaceTipsType.SUCCESS)
					{
						isSuccess = true;
						_cells[i].furnaceItemInfo = new FurnaceItemInfo(tmpInfo);						
						break;
					}
				}
			}
		}
		
		private function upgradeHandler(evt:FuranceEvent):void
		{
			if(!_successEffect)
			{
				_successEffect =  AssetUtil.getAsset("ssztui.furnace.EffectFurnaceUpgradeAsset",MovieClip) as MovieClip;
				_successEffect.x = 166;
				_successEffect.y = 170;
				addChild(_successEffect);
				_successEffect.addEventListener(Event.ENTER_FRAME,efFrameHandler);
			}else{
				_successEffect.gotoAndPlay(1);
			}
			/* 2013.5.15 old Effect
			if(!_upgradeEffect)
			{
				_upgradeEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.STRENGTHEN_EFFECT)); //UPQUALITY_EFFECT
				_upgradeEffect.move(155,211);
				_upgradeEffect.addEventListener(Event.COMPLETE,upgradeCompleteHandler);
				_upgradeEffect.play(SourceClearType.TIME,300000);
				addChild(_upgradeEffect);
			}
			*/
		}
		private function efFrameHandler(e:Event):void
		{
			if(_successEffect.currentFrame >= _successEffect.totalFrames)
			{
				_successEffect.removeEventListener(Event.ENTER_FRAME,efFrameHandler);
				_successEffect.parent.removeChild(_successEffect);
				_successEffect = null;
				clearCells();
			}
		}
		private function upgradeCompleteHandler(evt:Event):void
		{
			_upgradeEffect.removeEventListener(Event.COMPLETE,upgradeCompleteHandler);
			_upgradeEffect.dispose();
			_upgradeEffect = null;
		}
		
		/**监听背包信息更新**/
		private function bagItemUpdateHandler(e:BagInfoUpdateEvent):void
		{
			var tmpItemIdList:Array = e.data as Array;
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				furnaceInfo.updateBagToFurnace(tmpItemIdList[i],qualityItemListChecker,EQUIPTRANSFORM_MATERIAL_CATEGORYID_LIST);
			}
		}
		
		/**检测列表过滤条件**/
		private function qualityItemListChecker(argItemInfo:ItemInfo):Boolean
		{
			if(argItemInfo && OrangeItemTemplateList.getOrangeItemTemplateInfo(argItemInfo.templateId))
			{
				return true;
			}
			return false;
		}
		
		
		private function clearCells(isIncludeEquip:Boolean = true):void
		{
			var _beginIndex:int = 0;
			if(!isIncludeEquip){_beginIndex = 1;}
			if(_cells)
			{
				for(var i:int = _cells.length - 1;i >= _beginIndex;i--)
				{
					if(_cells[i] && _cells[i].furnaceItemInfo)
					{
						_cells[i].furnaceItemInfo.removePlace(i);
						_cells[i].furnaceItemInfo.setBack();
						_cells[i].furnaceItemInfo = null;
					}
				}
			}
			
			for(var j:int = 0; j < 3; j++)
			{
				if(_lableArray[j])_lableArray[j].text = "";
			}
			if(_resultCell)_resultCell.itemInfo = null;
//			_stoneCell.info = null;
//			_countLabel.text = "";
			if(_upgradeBtn)_upgradeBtn.enabled = false;
			_currentMoney = 0;
			if(_useMoneyTextField)_useMoneyTextField.text = "0";
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagUpdateHandler);
		}
		
		private function transformBtnHandler(e:MouseEvent):void
		{
			var isPetEquip:Boolean;
			
			if(CategoryType.isPetEquip(FurnaceCell(_cells[0]).furnaceItemInfo.bagItemInfo.template.categoryId) && FurnaceCell(_cells[0]).furnaceItemInfo.bagItemInfo.place < 30 )
			{
				isPetEquip = true;
			}
			
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
			var tmp:OrangeItemTemplateInfo = OrangeItemTemplateList.getOrangeItemTemplateInfo(_cells[0].furnaceItemInfo.bagItemInfo.templateId);
			if(!_cells[0].furnaceItemInfo.bagItemInfo.isBind && checkMaterialBind(tmp.materialList))
			{
				MAlert.show(LanguageManager.getWord("ssztl.furnace.hasBindPurple"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
			}
			else
			{
				send();
			}
			function checkMaterialBind(list:Array):Boolean
			{
				for ( var i:int = 0; i < list.length; i++)
				{
					if(GlobalData.bagInfo.hasBindItem(list[i].id))
						return true;
				}
				return false;
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
				_mediator.sendUpgrade(_cells[0].furnaceItemInfo.bagItemInfo.place,isPetEquip);
//				clearCells();
				_upgradeBtn.enabled = false;
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
			}
		}
		
		override protected function getCellPos():Array
		{
			return [new Point(148,38), new Point(85,111),new Point(148,111),new Point(211,111)];
		}
		override protected function getBackgroundName():Array
		{
//			return ["紫装"];
			return [LanguageManager.getWord("ssztl.furnace.equip"),
				LanguageManager.getWord("ssztl.common.material"),
				LanguageManager.getWord("ssztl.common.material"),
				LanguageManager.getWord("ssztl.common.purpleCrystal"),""];
		}		
		override protected function getAcceptCheckers():Array
		{
			return [equipChecker1,lronChecker1,copperChecker1,upLevelSymbolChecker1];
		}
		private function equipChecker1(info:ItemInfo):int
		{
			if(!CategoryType.isEquip(info.template.categoryId))return FurnaceTipsType.EQUIP;
//			if(info.template.quality != 3)return FurnaceTipsType.STONE1;
//			if(_cells[0].furnaceItemInfo)return FurnaceTipsType.NOSTONE;
			return FurnaceTipsType.SUCCESS;
		}
		private function lronChecker1(info:ItemInfo):int
		{
			if(!_cells[0].furnaceItemInfo) return FurnaceTipsType.NOEQUIP;
			if(CategoryType.isEquip(info.template.categoryId))return FurnaceTipsType.EQUIP;
			if(info.template.categoryId == CategoryType.PURPLE_CRYSTAL || info.template.categoryId == CategoryType.UPGRADE_UPLEVEL)return FurnaceTipsType.SUCCESS;
			return FurnaceTipsType.EQUIP;
		}
		private function copperChecker1(info:ItemInfo):int
		{
			if(!_cells[0].furnaceItemInfo) return FurnaceTipsType.NOEQUIP;
			if(CategoryType.isEquip(info.template.categoryId))return FurnaceTipsType.EQUIP;
			if(info.template.categoryId == CategoryType.PURPLE_CRYSTAL || info.template.categoryId == CategoryType.UPGRADE_UPLEVEL)return FurnaceTipsType.SUCCESS;			
			return FurnaceTipsType.EQUIP;
		}
		private function upLevelSymbolChecker1(info:ItemInfo):int
		{
			if(!_cells[0].furnaceItemInfo) return FurnaceTipsType.NOEQUIP;
			if(CategoryType.isEquip(info.template.categoryId))return FurnaceTipsType.EQUIP;
			if(info.template.categoryId == CategoryType.PURPLE_CRYSTAL)return FurnaceTipsType.SUCCESS;
			return FurnaceTipsType.EQUIP;
		}
		
		override protected function updateFurnaceHandler(evt:FuranceEvent):void
		{
			var _place:int =evt.data["place"] as int;
			var _furnaceItemInfo:FurnaceItemInfo = evt.data["info"] as FurnaceItemInfo;
			_cells[_place].furnaceItemInfo = _furnaceItemInfo;
			//更新格子视图后续处理
			var isAutoFill:Boolean = false;
			switch(_place)
			{
				case 0:
					if(!_furnaceItemInfo)
					{
						clearCells();
					}
					else
					{
						isAutoFill = true;
						updateData(_cells[0].furnaceItemInfo.bagItemInfo);
						GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagUpdateHandler);
					}
					break;
			}
			if(isAutoFill)
			{
				autoFillCells1(_cells[0].furnaceItemInfo.bagItemInfo);
			}
		}
		
		private function updateData(argEquipItemInfo:ItemInfo):void
		{
			/**成功率计算公式**/
//			updateSuccessRate(argEquipItemInfo);
			var tmp:OrangeItemTemplateInfo = OrangeItemTemplateList.getOrangeItemTemplateInfo(argEquipItemInfo.templateId);
			if(tmp)
			{
				/**费用：系数**/
				_currentMoney =  tmp.copper;
				_useMoneyTextField.text =_currentMoney.toString();
				//			_stoneCell.info = ItemTemplateList.getTemplate(tmp.amethystTempId);
				updateShowCell(ItemTemplateList.getTemplate(tmp.orangeTempId));
				updateCount();				
			}
			
		}
				
		private function updateShowCell(argTargetTemplateInfo:ItemTemplateInfo):void
		{
			var tmpEquipInfo:ItemInfo = _cells[0].furnaceItemInfo.bagItemInfo;
			var tmpInfo:ItemInfo = new ItemInfo();
			tmpInfo.templateId = argTargetTemplateInfo.templateId;
			tmpInfo.strengthenLevel = tmpEquipInfo.strengthenLevel;
			tmpInfo.strengthenPerfect = tmpEquipInfo.strengthenPerfect;
			tmpInfo.wuHunId = tmpEquipInfo.wuHunId;
			tmpInfo.freePropertyVector = tmpEquipInfo.freePropertyVector;
			tmpInfo.enchase1 = tmpEquipInfo.enchase1
			tmpInfo.enchase2 = tmpEquipInfo.enchase2;
			tmpInfo.enchase3 = tmpEquipInfo.enchase3;
			tmpInfo.enchase4 = tmpEquipInfo.enchase4;
			tmpInfo.enchase5 = tmpEquipInfo.enchase5;
			tmpInfo.enchase6 = tmpEquipInfo.enchase6;
			tmpInfo.isBind = tmpEquipInfo.isBind;
			tmpInfo.durable = tmpEquipInfo.durable;
			_resultCell.itemInfo = tmpInfo;
		}
		
		private function bagUpdateHandler(e:BagInfoUpdateEvent):void
		{
			updateCount();
		}
		
		private function updateCount():void
		{
			var tmp:OrangeItemTemplateInfo = OrangeItemTemplateList.getOrangeItemTemplateInfo(_cells[0].furnaceItemInfo.bagItemInfo.templateId);
			if(!tmp)return;
			
			var materialList:Array = tmp.materialList;
			var canUP:Boolean = true;
			for(var i:int = 0; i < materialList.length; i++)
			{
				var itemNum:int = furnaceInfo.getFurnaceItemNumByTemplateId(materialList[i].id);
				var num:int = materialList[i].value
				if (itemNum < num)
				{
					_lableArray[i].htmlText =  "<font color = '#ff0000'>" + itemNum.toString() + "/" + num +"</font>";
					canUP = false;
				}
				else
				{
					_lableArray[i].text = itemNum + "/" + num;
				}
			}
			
			if(canUP)
				_upgradeBtn.enabled = true;	
		}
		
		/**更新成功率**/
//		private function updateSuccessRate(argEquipItemInfo:ItemInfo):void
//		{
//			/**成功率**/
//		}
		
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
			if(_upgradeBtn)
			{
				_upgradeBtn.dispose();
				_upgradeBtn = null;
			}
			if(_resultCellBg && _resultCellBg.bitmapData)
			{
//				_resultCellBg.bitmapData.dispose();
				_resultCellBg = null;
			}
			if(_resultCell)
			{
				_resultCell.dispose();
				_resultCell = null;
			}
//			if(_stoneCell)
//			{
//				_stoneCell.dispose();
//				_stoneCell = null;
//			}
			for(var i:int = 0; i < 3; i++)
			{
				_lableArray[i] = null;
			}
			_useMoneyTextField = null;
//			_countLabel = null;
		}
	}
}