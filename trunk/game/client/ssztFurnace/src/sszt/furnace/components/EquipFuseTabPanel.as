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
	
	public class EquipFuseTabPanel extends BaseFurnaceTabPanel
	{
		public static const _fuseSignID:int = 203026;
		public static const _currentMoney:int = 200000;
		private var _fuseBtn:MCacheAssetBtn1;
		private var _useMoneyTextField:MAssetLabel;
		private var _fuseTemplate:ItemTemplateInfo;
		private var _fuseSignCount:int;
		/**装备熔炼材料**/
		public static const EQUIPTRANSFORM_MATERIAL_CATEGORYID_LIST:Array = [CategoryType.UPGRADE_UPLEVEL];
		
		private var _bg:IMovieWrapper;
		private var _resultCell:BaseItemInfoCell;
		private var _resultCellBg:Bitmap;
		private var _fuseSignCell:BaseItemInfoCell;
//		private var _stoneCell:FurnaceBaseCell;  
		
		private var _upgradeEffect:BaseLoadEffect;
		private var _successEffect:MovieClip;
		
		private var _lableCount:MAssetLabel;
		
		public function EquipFuseTabPanel(mediator:FurnaceMediator)
		{
			super(mediator);
		}
		
		override protected function init():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(98,122,140,46),new Bitmap(new LevelupArrowBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(81,78,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(144,78,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(207,78,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				//new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(142,32,50,50),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(142,165,50,50),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(148,171,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addChild(_bg as DisplayObject);
			super.init();
			
			/**---------------处理显示的textField---------------**/
			_useMoneyTextField = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_useMoneyTextField.move(65,320);
			addChild(_useMoneyTextField);
			
			_fuseSignCell = new BaseItemInfoCell();
			_fuseSignCell.move(148,82);
			addChild(_fuseSignCell);
			var tmpInfo:ItemInfo = new ItemInfo();
			tmpInfo.itemId = 0;
			tmpInfo.templateId = _fuseSignID;
			_fuseSignCell.itemInfo = tmpInfo;
			_lableCount = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			addChild(_lableCount);
			_lableCount.move(167,120);
			
			/**--------------------------------------------**/
						
			_resultCell = new BaseItemInfoCell();
			_resultCell.move(148,171);
			addChild(_resultCell);
			
			_fuseBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.furnace.equipFuse"));
			_fuseBtn.enabled = false;
			_fuseBtn.move(115,269);
			addChild(_fuseBtn);
		}
		
		override public function show():void
		{
			super.show();
			/**加载数据到快速购买**/
			furnaceInfo.currentBuyType = FurnaceBuyType.FUSE;
			/**加载数据到另外两个面板**/
			furnaceInfo.initialFurnaceVector(qualityItemListChecker,EQUIPTRANSFORM_MATERIAL_CATEGORYID_LIST);
			/**监听背包变化**/
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_fuseBtn.addEventListener(MouseEvent.CLICK,fuseBtnHandler);
			furnaceModule.furnaceInfo.addEventListener(FuranceEvent.FUSE_SUCCESS,fuseHandler);
		}
		
		override public function hide():void
		{
			super.hide();
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_fuseBtn.removeEventListener(MouseEvent.CLICK,fuseBtnHandler);
			furnaceModule.furnaceInfo.removeEventListener(FuranceEvent.FUSE_SUCCESS,fuseHandler);
		}
		
		override public function addAssets():void
		{
//			_equipBg.bitmapData = AssetUtil.getAsset("ssztui.furnace.LightCellBgAsset" ,BitmapData) as BitmapData;
		}
//		private function autoFillCells1():void
//		{
//			//是否优先使用绑定材料
//			if (_fuseTemplate == null)
//				return;
//			autoFillMaterial(_fuseSignID, _fuseTemplate.fusion_num);
//		}
//		private function autoFillMaterial(id:Number, num:Number):void
//		{
////			var itemNum:int = furnaceInfo.getFurnaceItemNumByTemplateId(id);
//			var tmpInfo:ItemInfo = new ItemInfo();
//			tmpInfo.itemId = 0;
//			tmpInfo.templateId = id;
//
//			var checkers:Array = getAcceptCheckers();
//			var isSuccess:Boolean = false;
//			var tipsType:int;
//			if(_cells[2].furnaceItemInfo == null)
//			{
//				tipsType = checkers[2](tmpInfo);
//				if(tipsType == FurnaceTipsType.SUCCESS)
//				{
//					isSuccess = true;
//					_cells[2].furnaceItemInfo = new FurnaceItemInfo(tmpInfo);
//				}
//			}			
//		}
		
		private function fuseHandler(evt:FuranceEvent):void
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
			furnaceInfo.chooseFuseQuality(qualityItemListChecker);
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
			if(argItemInfo && CategoryType.isEquip(argItemInfo.template.categoryId) && !CategoryType.isPetEquip(argItemInfo.template.categoryId))
			{
				return true;
			}
			return false;
		}
		
		private function qualityItemListChecker1(argItemInfo:ItemInfo):Boolean
		{
			if(argItemInfo && CategoryType.isEquip(argItemInfo.template.categoryId))
			{
				//必须是同职业
				if(argItemInfo.template.needCareer != _cells[0].furnaceItemInfo.bagItemInfo.template.needCareer)
				{
					return false;
				}
				//40级以上装备
				if(argItemInfo.template.needLevel < 40)
				{
					return false;
				}
				//紫色以上装备
				if(argItemInfo.template.quality < 3)
				{
					return false;
				}			
				//必须是同部位
				if(argItemInfo.template.categoryId != _cells[0].furnaceItemInfo.bagItemInfo.template.categoryId)
				{
					return false;
				}
				//不能镶嵌宝石
				if(argItemInfo.getEnchaseCount(true) >0)
				{
					return false;
				}
				//一真一普通
				if((argItemInfo.template.name.indexOf("真·") == -1) == (_cells[0].furnaceItemInfo.bagItemInfo.template.name.indexOf("真·") == -1))
				{
					return false;
				}
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
			
			if(_lableCount)_lableCount.text = "";
			
			if(_resultCell)_resultCell.itemInfo = null;
//			_stoneCell.info = null;
//			_countLabel.text = "";
			if(_fuseBtn)_fuseBtn.enabled = false;
			if(_useMoneyTextField)_useMoneyTextField.text = "0";
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagUpdateHandler);
		}
		
		private function fuseBtnHandler(e:MouseEvent):void
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
			_mediator.sendFuse(_cells[0].furnaceItemInfo.bagItemInfo.place,_cells[1].furnaceItemInfo.bagItemInfo.place,_fuseSignID);
			_fuseBtn.enabled = false;		
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
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.unableFuse"));
					break;
				case FurnaceTipsType.ENCHASEFULL:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.unableFuse1"));
					break;
				case FurnaceTipsType.STONE1:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.unableFuse2"));
					break;				
				case FurnaceTipsType.HOLEFULL:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.unableFuse3"));
					break;
				case FurnaceTipsType.STONE:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.unableFuse4"));
			}
		}
		
		override protected function getCellPos():Array
		{
			return [new Point(85,82),new Point(211,82)];
		}
		override protected function getBackgroundName():Array
		{
//			return ["紫装"];
			return [LanguageManager.getWord("ssztl.furnace.equip1"),
				LanguageManager.getWord("ssztl.furnace.equip2"),
				LanguageManager.getWord("ssztl.common.material"),""];
		}		
		override protected function getAcceptCheckers():Array
		{
			return [equipChecker1,equipChecker2];
		}
		private function equipChecker1(info:ItemInfo):int
		{
			if(!CategoryType.isEquip(info.template.categoryId))return FurnaceTipsType.EQUIP;
			if(_cells[0].furnaceItemInfo)return FurnaceTipsType.NOSTONE;
			if(info.template.needLevel < 40)
			{
				return FurnaceTipsType.STONE;
			}
			if(info.template.quality < 3)
			{
				return FurnaceTipsType.STONE;
			}
			if(info.getEnchaseCount(true) >0)
			{
				return FurnaceTipsType.STONE1;
			}
			//if(_cells[0].furnaceItemInfo)return FurnaceTipsType.NOSTONE;
			return FurnaceTipsType.SUCCESS;
		}
		
		private function equipChecker2(info:ItemInfo):int
		{
			if(!_cells[0].furnaceItemInfo) return FurnaceTipsType.EQUIP;
			//必须是装备类型
			if(!CategoryType.isEquip(info.template.categoryId))return FurnaceTipsType.EQUIP;
			//必须是同职业
			if(info.template.needCareer != _cells[0].furnaceItemInfo.bagItemInfo.template.needCareer)
			{
				return FurnaceTipsType.NOEQUIP;
			}
			//40级以上装备
			if(info.template.needLevel < 40)
			{
				return FurnaceTipsType.STONE;
			}
			//紫色以上装备
			if(info.template.quality < 3)
			{
				return FurnaceTipsType.STONE;
			}			
			//必须是同部位
			if(info.template.categoryId != _cells[0].furnaceItemInfo.bagItemInfo.template.categoryId)
			{
				return FurnaceTipsType.NOEQUIP;
			}
			//不能镶嵌宝石
			if(info.getEnchaseCount(true) >0)
			{
				return FurnaceTipsType.STONE1;
			}
			//一真一普通
			if((info.template.name.indexOf("真·") == -1) == (_cells[0].furnaceItemInfo.bagItemInfo.template.name.indexOf("真·") == -1))
			{
				return FurnaceTipsType.ENCHASEFULL;
			}
			return FurnaceTipsType.SUCCESS;
		}
		private function lronChecker1(info:ItemInfo):int
		{
			if(!_cells[2].furnaceItemInfo) return FurnaceTipsType.HOLEFULL;
			//if(CategoryType.isEquip(info.template.categoryId))return FurnaceTipsType.EQUIP;
			if(info.template.categoryId == CategoryType.UPGRADE_UPLEVEL)return FurnaceTipsType.SUCCESS;
			return FurnaceTipsType.EQUIP;
		}
		
		override protected function updateFurnaceHandler(evt:FuranceEvent):void
		{
			var _place:int =evt.data["place"] as int;
			var _furnaceItemInfo:FurnaceItemInfo = evt.data["info"] as FurnaceItemInfo;
			_cells[_place].furnaceItemInfo = _furnaceItemInfo;
			//更新格子视图后续处理
		//	var isAutoFill:Boolean = false;
			switch(_place)
			{
				case 0:
					if(!_furnaceItemInfo)
					{
						clearCells();
						furnaceInfo.chooseFuseQuality(qualityItemListChecker);						
					}
					else
					{
						_fuseTemplate = null;
						furnaceInfo.chooseFuseQuality(qualityItemListChecker1);
						//updateData(_cells[0].furnaceItemInfo.bagItemInfo);
						//GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagUpdateHandler);
					}
					break;
				case 1:
					if(!_furnaceItemInfo)
					{
						clearCells(false);
					}
					else
					{						
						var tmp1:ItemTemplateInfo = _cells[0].furnaceItemInfo.bagItemInfo.template;
						var tmp2:ItemTemplateInfo = _cells[1].furnaceItemInfo.bagItemInfo.template;
						var level:int  = Math.max(tmp1.needLevel,tmp2.needLevel);
						var quality:int  = Math.max(tmp1.quality,tmp2.quality);
						_fuseTemplate = ItemTemplateList.getTemplateForFuse(level,quality,"真·",tmp1.needCareer,tmp1.categoryId);
						_fuseSignCount = getFuseSignCount(tmp1,tmp2);
						updateData();
						GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagUpdateHandler);
					}
					break;
			}
		}	
		
		private function updateData():void
		{
			/**成功率计算公式**/
			_useMoneyTextField.text = "0";
//			updateSuccessRate(argEquipItemInfo);
			if(_fuseTemplate)
			{
				/**费用：系数**/
				_useMoneyTextField.text =_currentMoney.toString();
				//			_stoneCell.info = ItemTemplateList.getTemplate(tmp.amethystTempId);
				updateShowCell();
				updateCount();				
			}
			
		}
				
		private function updateShowCell():void
		{
			var tmpEquipInfo1:ItemInfo = _cells[0].furnaceItemInfo.bagItemInfo;
			var tmpEquipInfo2:ItemInfo = _cells[1].furnaceItemInfo.bagItemInfo;
			var tmpInfo:ItemInfo = new ItemInfo();
			tmpInfo.templateId = _fuseTemplate.templateId;
			tmpInfo.strengthenLevel = Math.max(tmpEquipInfo1.strengthenLevel,tmpEquipInfo2.strengthenLevel);
			tmpInfo.strengthenPerfect = Math.max(tmpEquipInfo1.strengthenPerfect,tmpEquipInfo2.strengthenPerfect);
			//tmpInfo.wuHunId = tmpEquipInfo.wuHunId;
			tmpInfo.freePropertyVector = tmpEquipInfo1.freePropertyVector;
			tmpInfo.isBind = true;
			tmpInfo.durable = Math.max(tmpEquipInfo1.durable,tmpEquipInfo2.durable);
			
			_resultCell.itemInfo = tmpInfo;
		}
		
		private function bagUpdateHandler(e:BagInfoUpdateEvent):void
		{
			updateCount();
		}
		
		private function getFuseSignCount(tmp1:ItemTemplateInfo,tmp2:ItemTemplateInfo):int
		{
			var count:int = 0;
			var count1:int = 0;
			var lv1:int = Math.min(tmp1.needLevel,tmp2.needLevel);
			var lv2:int = Math.max(tmp1.needLevel,tmp2.needLevel);
			var qu1:int = Math.min(tmp1.quality,tmp2.quality);
			var qu2:int = Math.max(tmp1.quality,tmp2.quality);
			for(lv1; lv1 <= lv2; )
			{
				switch (lv1)
				{
					case 40:
						count += 2;
						break;
					case 50:
						count += 4;
						break;
					case 60:
						count += 6;
						break;				
					case 70:
						count += 8;
						break;
					case 80:
						count += 10;
						break;
				}
				lv1 += 10;
			}
			for(qu1; qu1 < qu2; qu1++)
			{
				switch (qu1)
				{
					case 3:
						count += 5;
						break;
					case 4:
						count += 15;
						break;
				}
			}
			return count;
		}
		
		private function updateCount():void
		{
			if(!_fuseTemplate)return;
			
			var canUP:Boolean = true;
			var itemNum:int = furnaceInfo.getFurnaceItemNumByTemplateId(_fuseSignID);
			var num:int = _fuseSignCount;
			if (itemNum < num)
			{
				_lableCount.htmlText =  "<font color = '#ff0000'>" + itemNum.toString() + "/" + num +"</font>";
				canUP = false;
			}
			else
			{
				_lableCount.text = itemNum + "/" + num;
			}
			if(canUP)
				_fuseBtn.enabled = true;	
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
			if(_fuseBtn)
			{
				_fuseBtn.dispose();
				_fuseBtn = null;
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
			_lableCount = null;
			
			_useMoneyTextField = null;
//			_countLabel = null;
		}
	}
}