package sszt.furnace.components
{
	import fl.controls.CheckBox;
	
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
	import sszt.constData.PropertyType;
	import sszt.core.caches.NumberCache;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.bag.PetBagInfoUpdateEvent;
	import sszt.core.data.furnace.StrengthenTemplateList;
	import sszt.core.data.furnace.parametersList.DecomposeTemplateList;
	import sszt.core.data.item.ItemFreeProperty;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
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
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.furnace.BorderCellBgAsset;
	import ssztui.furnace.DownArrowBgAsset;
	import ssztui.furnace.LabelStrongAsset3;
	
	public class StrengthTransformTabPanel extends BaseFurnaceTabPanel
	{
		private var _bg:IMovieWrapper;
		private var _transformBtn:MCacheAssetBtn1;
		private var _useMoneyTextField:MAssetLabel;
		
		private var _strengProptery:MAssetLabel;
		private var _rebuildProptery:MAssetLabel;		
		private var _strengProptery1:MAssetLabel;
		private var _rebuildProptery1:MAssetLabel;
		
		private var _currentMoney:int;
//		private var _currentSuccessRate:int;
		public static const LABEL_FORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,4);

		
		private var _strengthenBg:Bitmap;
		
		private var _strengCheckBox:CheckBox;
		private var _rebiuldCheckBox:CheckBox;
		
		private var _successEffect:MovieClip;
		/**装备转移材料**/
		public static const EQUIPTRANSFORM_MATERIAL_CATEGORYID_LIST:Array = [];
		
		public function StrengthTransformTabPanel(mediator:FurnaceMediator)
		{
			super(mediator);
		}
		
		override protected function init():void
		{	
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(152,117,28,39),new Bitmap(new DownArrowBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(142,57,50,50),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(142,157,50,50),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				
			]);
			addChild(_bg as DisplayObject);
			_strengthenBg = new Bitmap();
			_strengthenBg.x = 84;
			_strengthenBg.y = 105;
			addChild(_strengthenBg as DisplayObject);
			
			var tabLabel:Bitmap = new Bitmap(new LabelStrongAsset3());
			tabLabel.x = 135;
			tabLabel.y = 118;
			addChild(tabLabel);
			
			super.init();			
			
			/**---------------处理显示的textField---------------**/
			_useMoneyTextField = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_useMoneyTextField.move(65,320);
			addChild(_useMoneyTextField);
			
			_strengProptery = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_strengProptery.move(160,210);
			addChild(_strengProptery);
			
			_rebuildProptery = new MAssetLabel("",MAssetLabel.LABELTYPE12,TextFormatAlign.LEFT);
			_rebuildProptery.move(111,118);
//			addChild(_rebuildProptery);
			
			_strengProptery1 = new MAssetLabel("",MAssetLabel.LABELTYPE12,TextFormatAlign.LEFT);
			_strengProptery1.move(206,118);
//			addChild(_strengProptery1);
			
			_rebuildProptery1 = new MAssetLabel("",MAssetLabel.LABELTYPE12,TextFormatAlign.LEFT);
			_rebuildProptery1.move(295,118);
//			addChild(_rebuildProptery1);
			
			/**--------------------------------------------**/
			
			_strengCheckBox = new CheckBox();
			_strengCheckBox.label = LanguageManager.getWord("ssztl.furnace.strengthEquip");
			_strengCheckBox.setSize(55,20);
			_strengCheckBox.move(178,38);
//			addChild(_strengCheckBox);	
			_strengCheckBox.selected = true;
			
			_rebiuldCheckBox = new CheckBox();
			_rebiuldCheckBox.label = LanguageManager.getWord("ssztl.furnace.beginRebuild");
			_rebiuldCheckBox.setSize(55,20);
			_rebiuldCheckBox.move(178,74);
//			addChild(_rebiuldCheckBox);
			
			_transformBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.furnace.beginTransfer"));
			_transformBtn.enabled = false;
			_transformBtn.move(115,269);
			addChild(_transformBtn);
		}
		
		override public function show():void
		{
			super.show();
			furnaceInfo.currentBuyType = FurnaceBuyType.EQUIPTRANSFORM;
			/**加载数据到另外两个面板**/
			furnaceInfo.initialFurnaceVector(qualityItemListChecker,EQUIPTRANSFORM_MATERIAL_CATEGORYID_LIST);
			/**监听背包变化**/
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_transformBtn.addEventListener(MouseEvent.CLICK,transformBtnHandler);
			
			furnaceModule.furnaceInfo.addEventListener(FuranceEvent.TRANSFORM_SUCCESS,composeHandler);
			GlobalData.petBagInfo.addEventListener(PetBagInfoUpdateEvent.ITEM_ID_UPDATE,petBagItemUpdateHandler);
		}
		
		private function petBagItemUpdateHandler(e:PetBagInfoUpdateEvent):void
		{
			var tmpItemIdList:Array = e.data as Array;
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				furnaceInfo.updatePetBagToFurnace(tmpItemIdList[i]);
			}
		}
		
		override public function hide():void
		{
			super.hide();
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_transformBtn.removeEventListener(MouseEvent.CLICK,transformBtnHandler);
			
			furnaceModule.furnaceInfo.removeEventListener(FuranceEvent.TRANSFORM_SUCCESS,composeHandler);
			GlobalData.petBagInfo.removeEventListener(PetBagInfoUpdateEvent.ITEM_ID_UPDATE,petBagItemUpdateHandler);
		}
		
		override public function addAssets():void
		{
			_strengthenBg.bitmapData = AssetUtil.getAsset("ssztui.furnace.BarBgAsset1", BitmapData) as BitmapData;
		}
		
		private function composeHandler(evt:FuranceEvent):void
		{
			if(!_successEffect)
			{
				_successEffect =  AssetUtil.getAsset("ssztui.furnace.EffectFurnaceInheritedAsset",MovieClip) as MovieClip;
				_successEffect.x = 166;
				_successEffect.y = 135;
				addChild(_successEffect);
				_successEffect.addEventListener(Event.ENTER_FRAME,efFrameHandler);
			}else{
				_successEffect.gotoAndPlay(1);
			}
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
		private function showItemStrengProperty(item:ItemInfo):void
		{
			if(item)
			{
				var string1:String = ""; 
				var string2:String = "";
				var level:int = item.strengthenLevel;
				var perfect:int = item.strengthenPerfect;
				
				var add:int = StrengthenTemplateList.getStrengthenAddition(level,perfect);
				
				string1 = LanguageManager.getWord("ssztl.furnace.strengthLevel") + " " + level.toString() + "\n";
				string1 = string1 + LanguageManager.getWord("ssztl.furnace.perfectDegree") + " " + perfect.toString() + "%\n";
				string1 = string1 + LanguageManager.getWord("ssztl.furnace.strengthAddition") + " " + add.toString() + "%\n";
				_strengProptery.setValue(string1);
				
				for each(var m:ItemFreeProperty in item.freePropertyVector)
				{					
					string2 = string2 + PropertyType.getName(m.propertyId) + " +" + m.propertyValue.toString() + "\n";									
				}
				_rebuildProptery.setValue(string2);
			}
		}
		
		/**监听背包信息更新**/
		private function bagItemUpdateHandler(e:BagInfoUpdateEvent):void
		{
			//			var tmpItemIdList:Vector.<Number> = e.data as Vector.<Number>;
			var tmpItemIdList:Array = e.data as Array;
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				furnaceInfo.updateBagToFurnace(tmpItemIdList[i],qualityItemListChecker,EQUIPTRANSFORM_MATERIAL_CATEGORYID_LIST);
			}
		}
		
		/**检测列表过滤条件**/
		private function qualityItemListChecker(argItemInfo:ItemInfo):Boolean
		{
			if(argItemInfo &&CategoryType.isEquip(argItemInfo.template.categoryId) &&
				argItemInfo.template.quality != 0 && argItemInfo.template.canStrengthen)
			{
				return true;
			}
			return false;
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
			clearTipsLayer();
			_transformBtn.enabled = false;
//			_currentSuccessRate = 0;
			_currentMoney = 10000;
			
			_useMoneyTextField.text = "0";
			_strengProptery.setValue("");
			_strengProptery1.setValue("");
			_rebuildProptery.setValue("");
			_rebuildProptery1.setValue("");
			
		}
		
		private function transformBtnHandler(e:MouseEvent):void
		{
//			if(!_strengCheckBox.selected && !_rebiuldCheckBox.selected)
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.furnace.strengthTransformError"));
//				return;
//			}
			var isPetEquip:Boolean;
			
			if(CategoryType.isPetEquip(FurnaceCell(_cells[0]).furnaceItemInfo.bagItemInfo.template.categoryId) && FurnaceCell(_cells[0]).furnaceItemInfo.bagItemInfo.place < 30 )
			{
				isPetEquip = true;
			}
			
			if(_currentMoney > GlobalData.selfPlayer.userMoney.allCopper)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
				return;
			}
			
			if(!_cells[0].furnaceItemInfo.bagItemInfo.isBind)
			{
				send();
			}
			else
			{
				if(_cells[1].furnaceItemInfo.bagItemInfo.isBind)
				{
					send();
				}
				else
				{
					MAlert.show(LanguageManager.getWord("ssztl.furnace.transferExistBind"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
				}
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
				var opType:int = 0;
				if(_strengCheckBox.selected)
					opType = opType + 1;
				if(_rebiuldCheckBox.selected)
					opType = opType + 2;
				_mediator.sendStrengthTransform(_cells[0].furnaceItemInfo.bagItemInfo.place,_cells[1].furnaceItemInfo.bagItemInfo.place,opType,isPetEquip);
				clearCells();
				_transformBtn.enabled = false;
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
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.unableTransfer"));
					break;
				case FurnaceTipsType.ENCHASEFULL:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.unableTransferHigher"));
					break;
				case FurnaceTipsType.STONE1:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.transferToHigher"));
					break;
			}
		}
		
		override protected function getCellPos():Array
		{
			return [new Point(148,62),new Point(148,163)];
		}
		override protected function getBackgroundName():Array
		{
			return [LanguageManager.getWord("ssztl.furnace.equip"),LanguageManager.getWord("ssztl.common.equip2")];
		}
		override protected function getAcceptCheckers():Array
		{
			return [equipChecker1,equipChecker2];
		}
		private function equipChecker1(info:ItemInfo):int
		{
			if(!CategoryType.isEquip(info.template.categoryId))return FurnaceTipsType.EQUIP;
			if(_cells[0].furnaceItemInfo)return FurnaceTipsType.NOSTONE;
			return FurnaceTipsType.SUCCESS;
		}
		
		private function equipChecker2(info:ItemInfo):int
		{
			//必须是装备类型
			if(!CategoryType.isEquip(info.template.categoryId))return FurnaceTipsType.EQUIP;
			//必须是同职业
			if(info.template.needCareer != _cells[0].furnaceItemInfo.bagItemInfo.template.needCareer)
			{
				return FurnaceTipsType.NOEQUIP;
			}
			//必须是同部位
			if(info.template.categoryId != _cells[0].furnaceItemInfo.bagItemInfo.template.categoryId)
			{
				return FurnaceTipsType.NOEQUIP;
			}
			
//			if(info.template.quality < _cells[0].furnaceItemInfo.bagItemInfo.template.quality)return FurnaceTipsType.ENCHASEFULL;
			if(_cells[0].furnaceItemInfo.bagItemInfo.strengthenLevel - info.strengthenLevel  <= 2)return FurnaceTipsType.STONE1;
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
						updateTips();
					}
				break;
				case 1:
					if(!_furnaceItemInfo)
					{
						clearCells(false);
						updateTips();
					}
					else
					{
						updateData(_cells[0].furnaceItemInfo.bagItemInfo);
						updateTips(true);
					}
				break;
			}
		}
		
		private function updateData(argEquipItemInfo:ItemInfo):void
		{
			/**成功率计算公式**/
			updateSuccessRate(argEquipItemInfo);
			_transformBtn.enabled = true;
			/**费用：系数**/
//			_currentMoney =  argEquipItemInfo.strengthenLevel * 30000;
			_useMoneyTextField.text =_currentMoney.toString();
			showItemStrengProperty(argEquipItemInfo);
		}
		
		private function updateTips(isIncludeOther:Boolean = false):void
		{
			clearTipsLayer();
			if(!_cells[0].furnaceItemInfo)return;
//			var sp:Sprite = NumberCache.getNumber(_cells[0].furnaceItemInfo.bagItemInfo.strengthenLevel,1);
//			if(sp)_tipsLayer.addChild(sp);
			if(isIncludeOther)
			{
				if(_cells[1].furnaceItemInfo.bagItemInfo.strengthenLevel == 0)return;
//				var sp1:Sprite = NumberCache.getNumber(_cells[1].furnaceItemInfo.bagItemInfo.strengthenLevel,1);
//				sp1.x = 141;
//				if(sp1)_tipsLayer.addChild(sp1);
			}
		}
		
		private function clearTipsLayer():void
		{
//			for(var i:int = _tipsLayer.numChildren - 1;i >=0;i--)
//			{
//				_tipsLayer.removeChildAt(i);
//			}
		}
		
		/**更新成功率**/
		private function updateSuccessRate(argEquipItemInfo:ItemInfo):void
		{
			/**成功率**/
//			_currentSuccessRate = 100;
//			_successRateTextField.text = _currentSuccessRate.toString() + "%";
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
			if(_transformBtn)
			{
				_transformBtn.dispose();
				_transformBtn = null;
			}
			if(_strengthenBg)
			{
				_strengthenBg.bitmapData.dispose();
				_strengthenBg = null;
			}
			_useMoneyTextField = null;
		}
	}
}