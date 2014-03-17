package sszt.furnace.components
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.PropertyType;
	import sszt.constData.SourceClearType;
	import sszt.core.caches.NumberCache;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.bag.ClientBagInfoUpdateEvent;
	import sszt.core.data.bag.PetBagInfoUpdateEvent;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.furnace.StrengTemplateList;
	import sszt.core.data.furnace.StrengthenInfo;
	import sszt.core.data.furnace.StrengthenTemplateList;
	import sszt.core.data.furnace.parametersList.StrengAddsuccrateTemplateList;
	import sszt.core.data.furnace.parametersList.StrengCopperTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.item.PropertyInfo;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.titles.TitleTemplateInfo;
	import sszt.core.data.titles.TitleTemplateList;
	import sszt.core.data.vip.VipTemplateInfo;
	import sszt.core.data.vip.VipTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.GuideTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.furnace.components.cell.FurnaceCell;
	import sszt.furnace.data.FurnaceBuyType;
	import sszt.furnace.data.FurnaceTipsType;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.events.FuranceEvent;
	import sszt.furnace.mediators.FurnaceMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.furnace.BorderCellBgAsset;
	import ssztui.furnace.LabelStrongAsset;
	import ssztui.furnace.PerfectBarAsset;
	import ssztui.furnace.TrackBgAsset;
	import ssztui.furnace.UpArrowBgAsset;
	import ssztui.ui.CellBgAsset;
	
	public class StrengthTabPanel extends BaseFurnaceTabPanel
	{
		private var _bg:IMovieWrapper;
		private var _strengthenBtn:MCacheAssetBtn1;
		private var _strengthenBtn2:MCacheAssetBtn1;
		private var _useMoneyTextField:MAssetLabel;
		private var _currentPropertyText:MAssetLabel;
		
		private var _perfectDegreeProgressBar:ProgressBar;
		
		private var _strengLevelView:MAssetLabel;
		private var _strengAdditionView:MAssetLabel;
		private var _perfectDegreeView:MAssetLabel;
		private var _stuffAmount:MAssetLabel;
		
		private var _strengProptery1:MAssetLabel;
		private var _strengProptery2:MAssetLabel;
		
		private var _strengthEffect:BaseLoadEffect;
		private var _strengthUpEffect:MovieClip;
		
//		private var _currentSuccessRate:int;
		private var _currentMoney:int;
		public static const MAX_PERFECT_DEGREE:uint = 100;
		public static const LABEL_FORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),14,0xFF6600,4,null,null,null,null,TextFormatAlign.LEFT,null,null,null,4);
		/**装备强化材料**/
//		public static const STRENGTH_MATERIAL_CATEGORYID_LIST:Vector.<int> = Vector.<int>([CategoryType.STRENGTHPROTECTSYMBOL,
//			CategoryType.STRENGTHLUCKYSYMBOL,CategoryType.STRENGTH]);
		public static const STRENGTH_MATERIAL_CATEGORYID_LIST:Array = [CategoryType.STRENGTH];
		
		public var _tipsLayer:Sprite;
		private var _showCell:BaseItemInfoCell;
		private var _clubSuccessRateLabel:MAssetLabel;
		
		private var _previewText:Bitmap;
		
		private var _strengInfo:MSprite;
		private var _strengLabel:Bitmap;
		private var _strengNumber:MSprite;
		private var _barBg:Bitmap;
		
		private var _assetsComplete:Boolean;
		
		public function StrengthTabPanel(mediator:FurnaceMediator)
		{
			super(mediator);
			
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.FTAB));
		}
		
		override protected function init():void
		{
			
			_previewText = new Bitmap();
			_previewText.x = 11;
			_previewText.y = 60;
			addChild(_previewText);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(11,12,50,50),new Bitmap(new BorderCellBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(91,104,50,50),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(188,104,50,50),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(40,212,252,22),new Bitmap(new TrackBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(17,18,38,38),new Bitmap(CellCaches.getCellBg())),
				]);
			addChild(_bg as DisplayObject);
			
			super.init();
			// topBar
			_strengInfo = new MSprite();
			_strengInfo.move(84,52);
			addChild(_strengInfo);
			_barBg = new Bitmap();	//164
			_strengInfo.addChild(_barBg);
			_strengLabel = new Bitmap(new LabelStrongAsset());
			_strengLabel.x = 23;
			_strengLabel.y = 9;
			_strengInfo.addChild(_strengLabel);
			_strengNumber = new MSprite();
			_strengNumber.move(90,4);
			_strengInfo.addChild(_strengNumber);
			_strengInfo.visible = false;
			
			/**---------------处理显示的textField---------------**/
			
			_perfectDegreeProgressBar = new ProgressBar(new Bitmap(new PerfectBarAsset()),0,100,202,13,false,false);
			_perfectDegreeProgressBar.move(66,217);
			addChild(_perfectDegreeProgressBar);
			_perfectDegreeProgressBar.setValue(MAX_PERFECT_DEGREE,MAX_PERFECT_DEGREE);
			
			_useMoneyTextField = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_useMoneyTextField.move(65,320);
			addChild(_useMoneyTextField);
			
			_strengLevelView = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_strengLevelView.setLabelType([new TextFormat("Microsoft YaHei",22,0xffcc00,null,null)]);
			_strengLevelView.move(125,-2);
//			_strengInfo.addChild(_strengLevelView);	
			
			_strengAdditionView = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			_strengAdditionView.textColor = 0x66ff00;
			_strengAdditionView.move(113,158);
			addChild(_strengAdditionView);	
			
//			_currentPropertyText = new MAssetLabel(LanguageManager.getWord("ssztl.furnace.currentProperty"),MAssetLabel.LABELTYPE12);
//			_currentPropertyText.move(93,146);
//			addChild(_currentPropertyText);
			
			_perfectDegreeView = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			_perfectDegreeView.move(166,215);
			addChild(_perfectDegreeView);
			_perfectDegreeView.setHtmlValue(LanguageManager.getWord("ssztl.furnace.perfectDegree") + "0%");
			
			_strengProptery1 = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_strengProptery1.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,5)]);
			_strengProptery1.move(182,63);
//			addChild(_strengProptery1);
			_strengProptery2 = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_strengProptery2.setLabelType([new TextFormat("SimSun",12,0x33cc00,null,null,null,null,null,null,null,null,null,5)]);
			_strengProptery2.move(240,63);
//			addChild(_strengProptery2);
			
			_stuffAmount = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_stuffAmount.move(212,158);
//			_stuffAmount.setHtmlValue("<font color='#00ff00'>强化石名字品质</font><font color='#ffcc00'>(1/5)</font>");
			addChild(_stuffAmount);
			/**--------------------------------------------**/
						
			_strengthenBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.furnace.strengthEquip"));
			_strengthenBtn.move(64,269);
			addChild(_strengthenBtn);
			
			_strengthenBtn2 = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.furnace.strengthEquip1"));
			_strengthenBtn2.move(166,269);
			addChild(_strengthenBtn2);
			
			_showCell = new FurnaceCell();
			_showCell.move(17,18);
			addChild(_showCell);
		}
		
				
		override public function show():void
		{
			super.show();
			/**加载数据到快速购买**/
			furnaceInfo.currentBuyType = FurnaceBuyType.STRENGTH;
			/**加载数据到另外两个面板**/
			furnaceInfo.initialFurnaceVector(qualityItemListChecker,STRENGTH_MATERIAL_CATEGORYID_LIST);
			/**监听背包变化**/
			furnaceInfo.addEventListener(FuranceEvent.STRENGTH_SUCCESS, strengthHandler);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			GlobalData.petBagInfo.addEventListener(PetBagInfoUpdateEvent.ITEM_ID_UPDATE,petBagItemUpdateHandler);
			
			_strengthenBtn.addEventListener(MouseEvent.CLICK,strengthClickHandler);
			_strengthenBtn2.addEventListener(MouseEvent.CLICK,strength2ClickHandler);
//			_lastConfigBtn.addEventListener(MouseEvent.CLICK,lastConfigClickHandler);
		}
		
		override public function hide():void
		{
			super.hide();
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_strengthenBtn.removeEventListener(MouseEvent.CLICK,strengthClickHandler);
			_strengthenBtn2.removeEventListener(MouseEvent.CLICK,strength2ClickHandler);
			furnaceInfo.removeEventListener(FuranceEvent.STRENGTH_SUCCESS, strengthHandler);
			GlobalData.petBagInfo.removeEventListener(PetBagInfoUpdateEvent.ITEM_ID_UPDATE,petBagItemUpdateHandler);
//			_lastConfigBtn.removeEventListener(MouseEvent.CLICK,lastConfigClickHandler);
//			getBackClickHandler(null);
		}
		
		override public function addAssets():void
		{
			_assetsComplete = true;
			_previewText.bitmapData = AssetUtil.getAsset("ssztui.furnace.TextPreviewAsset",BitmapData) as BitmapData;
			_barBg.bitmapData = AssetUtil.getAsset("ssztui.furnace.BarBgAsset1" ,BitmapData) as BitmapData;
		}
		
		private function showItemStrengProperty(item:ItemInfo, add:int):void
		{
			if(item)
			{
				var string1:String = ""; 
				var string2:String = ""; 
				var attack:int = item.template.attack;
				var defence:int = item.template.defense;
				if(attack > 0)
				{
					string1 = string1 + PropertyType.getName(PropertyType.ATTR_ATTACK) + "+" + attack + "\n";
					string2 = string2 + LanguageManager.getWord("ssztl.furnace.strengthEquip") +"+" + int(attack * add / 100) + "\n";
				}
				if(defence > 0)
				{
					string1 = string1 + PropertyType.getName(PropertyType.ATTR_DEFENSE) + "+" + defence + "\n";
					string2 = string2 + LanguageManager.getWord("ssztl.furnace.strengthEquip") +"+" + int(defence * add / 100) + "\n";
				}
				for each(var m:PropertyInfo in item.template.regularPropertyList)
				{
					var name:String = PropertyType.getName(m.propertyId);
					
					string1 = string1 + name + "+" + m.propertyValue + "\n";
					
					string2 = string2 + LanguageManager.getWord("ssztl.furnace.strengthEquip") +"+" + int(m.propertyValue * add / 100) + "\n";
				}
				_strengProptery1.setValue(string1);
				if(add > 0)
					_strengProptery2.setValue(string2);
			}
		}
		
		private function overHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.furnace.successRateDetail"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function outHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function strengthHandler(evt:FuranceEvent):void
		{
			if(!_strengthEffect)
			{
				_strengthEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.STRENGTHEN_EFFECT));
				_strengthEffect.move(116,130);
				_strengthEffect.addEventListener(Event.COMPLETE,strengthCompleteHandler);
				_strengthEffect.play(SourceClearType.TIME,300000);
				addChild(_strengthEffect);
			}
			if(_cells[0] && _cells[0].furnaceItemInfo.bagItemInfo.strengthenPerfect	== 100 && _assetsComplete)
			{
				if(!_strengthUpEffect)
				{
					_strengthUpEffect =  AssetUtil.getAsset("ssztui.furnace.EffectFurnaceStrongAsset",MovieClip) as MovieClip;
					_strengthUpEffect.x = 166;
					_strengthUpEffect.y = 130;
					addChild(_strengthUpEffect);
					_strengthUpEffect.addEventListener(Event.ENTER_FRAME,strengthFrameHandler);
				}else{
					_strengthUpEffect.gotoAndPlay(1);
				}
			}
		}
		private function strengthFrameHandler(e:Event):void
		{
			if(_strengthUpEffect.currentFrame >= _strengthUpEffect.totalFrames)
			{
				_strengthUpEffect.removeEventListener(Event.ENTER_FRAME,strengthFrameHandler);
				_strengthUpEffect.parent.removeChild(_strengthUpEffect);
				_strengthUpEffect = null;
			}
		}
		private function strengthCompleteHandler(evt:Event):void
		{
			_strengthEffect.removeEventListener(Event.COMPLETE,strengthCompleteHandler);
			_strengthEffect.dispose();
			_strengthEffect = null;
		}
		
		/**监听背包信息更新**/
		private function bagItemUpdateHandler(e:BagInfoUpdateEvent):void
		{
//			var tmpItemIdList:Vector.<Number> = e.data as Vector.<Number>;
			var tmpItemIdList:Array = e.data as Array;
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				furnaceInfo.updateBagToFurnace(tmpItemIdList[i],qualityItemListChecker,STRENGTH_MATERIAL_CATEGORYID_LIST);
			}
		}
		
		private function petBagItemUpdateHandler(e:PetBagInfoUpdateEvent):void
		{
			var tmpItemIdList:Array = e.data as Array;
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				furnaceInfo.updatePetBagToFurnace(tmpItemIdList[i]);
			}
		}
		
		/**检测列表过滤条件**/
		private function qualityItemListChecker(argItemInfo:ItemInfo):Boolean
		{
			if(argItemInfo && argItemInfo.template.canStrengthen && argItemInfo.template.quality != 0)
			{
				return true;
			}
			return false;
		}
		
		private function getBackClickHandler(evt:MouseEvent):void
		{
			clearCells();
		}
		
		override protected function middleCellClearHandler(e:FuranceEvent):void
		{
			clearCells();
		}
		
		private function clearCells(isIncludeEquip:Boolean = true):void
		{
			var _beginIndex:int = 0;
			if(!isIncludeEquip){_beginIndex = 1;}
			//清空中间面板Cell，并回复到另外两个面板
			for(var i:int = _cells.length - 1;i >= _beginIndex;i--)
			{
				if(_cells[i].furnaceItemInfo)
				{
					_cells[i].furnaceItemInfo.removePlace(i);
					_cells[i].furnaceItemInfo.setBack();
					_cells[i].furnaceItemInfo = null;
				}
			}
			//清空txt、等资源
			clearTipsLayer();
			if(isIncludeEquip)
			{
				_showCell.itemInfo = null;
			}
//			_strengthenBtn.enabled = false;
//			_strengthenBtn2.enabled = false;
//			_currentSuccessRate = 0;
			_currentMoney = 0;
//			_successRateTextField.text = "";
			_useMoneyTextField.setValue("0");
			_stuffAmount.setHtmlValue("");
//			_failRateTextField.text = "";
//			_vipRateTextField.text = "";
		}
		
		private function clearTipsLayer():void
		{
			_strengLevelView.setValue("");
			setNumbers(-1);
			 _strengAdditionView.setValue("");
			 _perfectDegreeView.setValue(LanguageManager.getWord("ssztl.furnace.perfectDegree") + "0%");
			 _perfectDegreeProgressBar.setValue(MAX_PERFECT_DEGREE,0);
			 _strengProptery1.setValue("");
			 _strengProptery2.setValue("");
			 
			 _strengInfo.visible = false;
		}
		
		private function strength2ClickHandler(evt:MouseEvent):void
		{
			var tmpProtectBagPlace:int = 999;
			//			var tmpLuckyBagPlaceVector:Vector.<int> = new Vector.<int>();
			var tmpLuckyBagPlaceVector:Array = [];
			
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
			if(_stuffAmount.textColor == 0xff0000)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.stoneNotEnough"));
				return;
			}
			if(_cells[0].itemInfo.strengthenLevel + _cells[0].itemInfo.strengthenPerfect /100 >= 13)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.maxStrengthLevel"));
				return;
			}
			for each(var j:FurnaceCell in _cells)
			{
				if(!_cells[0].furnaceItemInfo.bagItemInfo.isBind && j.furnaceItemInfo && j.furnaceItemInfo.bagItemInfo.isBind)
				{
					//					MAlert.show("您的材料中有已绑定物品，你将要强化的装备会变成绑定状态，确定进行此操作？",LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
					MAlert.show(LanguageManager.getWord("ssztl.furnace.strengthExistBind"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
					return;
				}
			}
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					_mediator.sendStrength(_cells[0].furnaceItemInfo.bagItemInfo.place,_cells[1].furnaceItemInfo.bagItemInfo.place,tmpProtectBagPlace,1,isPetEquip);
				}
			}
			
			_mediator.sendStrength(_cells[0].furnaceItemInfo.bagItemInfo.place,_cells[1].furnaceItemInfo.bagItemInfo.place,tmpProtectBagPlace,1,isPetEquip);
//			_strengthenBtn.enabled = false;
//			_strengthenBtn2.enabled = false;
			
		}
		private function strengthClickHandler(evt:MouseEvent):void
		{
			var tmpProtectBagPlace:int = 999;
			var tmpLuckyBagPlaceVector:Array = [];
			var isPetEquip:Boolean;
			
			if(CategoryType.isPetEquip(FurnaceCell(_cells[0]).furnaceItemInfo.bagItemInfo.template.categoryId) && FurnaceCell(_cells[0]).furnaceItemInfo.bagItemInfo.place < 30 )
			{
				isPetEquip = true;
			}

			for(var i:int = 3;i < _cells.length;i++)
			{
				if(_cells[i].furnaceItemInfo)
				{
					tmpLuckyBagPlaceVector.push(_cells[i].furnaceItemInfo.bagItemInfo.place);
				}
			}
			if(_currentMoney > GlobalData.selfPlayer.userMoney.allCopper)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
				return;
			}
			if(_stuffAmount.textColor == 0xff0000)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.stoneNotEnough"));
				return;
			}			
			if(_cells[0].itemInfo.strengthenLevel + _cells[0].itemInfo.strengthenPerfect /100 >= 13)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.maxStrengthLevel"));
				return;
			}
			for each(var j:FurnaceCell in _cells)
			{
				if(!_cells[0].furnaceItemInfo.bagItemInfo.isBind && j.furnaceItemInfo && j.furnaceItemInfo.bagItemInfo.isBind)
				{
//					MAlert.show("您的材料中有已绑定物品，你将要强化的装备会变成绑定状态，确定进行此操作？",LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
					MAlert.show(LanguageManager.getWord("ssztl.furnace.strengthExistBind"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
					return;
				}
			}
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					_mediator.sendStrength(_cells[0].furnaceItemInfo.bagItemInfo.place,_cells[1].furnaceItemInfo.bagItemInfo.place,tmpProtectBagPlace,0,isPetEquip);
				}
			}
			
			_mediator.sendStrength(_cells[0].furnaceItemInfo.bagItemInfo.place,_cells[1].furnaceItemInfo.bagItemInfo.place,tmpProtectBagPlace,0,isPetEquip);
//			_strengthenBtn.enabled = false;
//			_strengthenBtn2.enabled = false;

		}
		
		
		private function setClubSuccess(argScore:int):void
		{
//			_clubSuccessRateLabel.text = "帮会加成：" + argScore.toString() + "%";
			_clubSuccessRateLabel.text = LanguageManager.getWord("ssztl.furnace.clubAddValue",argScore);
		}
		
		private function lastConfigClickHandler(e:MouseEvent):void
		{
			
		}
		
		override protected function getCellPos():Array
		{
			return [new Point(97,110),new Point(194,110)];
		}
		
		override protected function getBackgroundName():Array
		{
//			return ["装 备","强化石","保护符","幸运符","幸运符","幸运符","幸运符","幸运符"];
			return [LanguageManager.getWord("ssztl.furnace.equip"),
				LanguageManager.getWord("ssztl.common.material")];		//强化石材料
		}
		
		override protected function getAcceptCheckers():Array
		{
			return [equipChecker,strengthenStoneChecker,protectBagChecker];
		}
		
		private function equipChecker(info:ItemInfo):int
		{
			if(!CategoryType.isEquip(info.template.categoryId))return FurnaceTipsType.EQUIP;
			return FurnaceTipsType.SUCCESS;
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
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.onlyInputStrengthEquip"));
					break;
				case FurnaceTipsType.NOEQUIP:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputStrengthEquipFirst"));
					break;
				case FurnaceTipsType.STONE:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.strengthNotMatch"));
					break;
				case FurnaceTipsType.NOSTONE:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputMatchStrengthStone"));
					break;
				case FurnaceTipsType.PROTECTBAG:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputMatchProtectSymbol"));
					break;
				case FurnaceTipsType.LUCKYBAG:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputMatchLuckySymbol"));
					break;
			}
		}
		
		private function strengthenStoneChecker(info:ItemInfo):int
		{
			var tmpEquip:ItemInfo = _cells[0].itemInfo;
			if(!tmpEquip){return FurnaceTipsType.NOEQUIP}
			else
			{
				if(info.template.categoryId == CategoryType.STRENGTH)
				{
					var level:int = tmpEquip.strengthenLevel + tmpEquip.strengthenPerfect /100;
					if((info.template.property3 == 3 && level <= 3) ||
						(info.template.property3 == 6 && level > 3 && level <= 6) ||
						(info.template.property3 == 9 && level > 6 && level <= 9) ||
						(info.template.property3 == 12 && level > 9))
						return FurnaceTipsType.SUCCESS;
					return FurnaceTipsType.STONE;
				}
				else
				{
					return FurnaceTipsType.STONE;
				}
			}
			return FurnaceTipsType.SUCCESS;
		}
		
		private function protectBagChecker(info:ItemInfo):int
		{
			if(!_cells[1].itemInfo)
			{
				return FurnaceTipsType.NOSTONE;
			}
			else
			{
				if(info.template.categoryId == CategoryType.STRENGTHNEWPROTECTSYMBOL)
				{
					if((info.template.property3 == 3 && _cells[0].itemInfo.strengthenLevel <= 3) ||
						(info.template.property3 == 6 && _cells[0].itemInfo.strengthenLevel > 3 && _cells[0].itemInfo.strengthenLevel <= 6) ||
						(info.template.property3 == 9 && _cells[0].itemInfo.strengthenLevel > 6 && _cells[0].itemInfo.strengthenLevel <= 9) ||
						(info.template.property3 == 12 && _cells[0].itemInfo.strengthenLevel > 9) 
					)
						return FurnaceTipsType.SUCCESS;
					return FurnaceTipsType.PROTECTBAG;
				}
				else
				{
					return FurnaceTipsType.PROTECTBAG;
				}
				
			}
			return FurnaceTipsType.SUCCESS;
		}
		
//		private function luckyBagChecker(info:ItemInfo):int
//		{
//			if(!_cells[1].itemInfo)
//			{
//				return FurnaceTipsType.NOSTONE;
//			}
//			else
//			{
//				if(info.template.categoryId == CategoryType.STRENGTHLUCKYSYMBOL)
//				{
//					if((info.template.property3 == 1 && _cells[0].itemInfo.strengthenLevel < 4) ||
//						(info.template.property3 == 2 && _cells[0].itemInfo.strengthenLevel > 3 && _cells[0].itemInfo.strengthenLevel < 8) ||
//						(info.template.property3 == 3 && _cells[0].itemInfo.strengthenLevel > 7 && _cells[0].itemInfo.strengthenLevel < 12) || 
//						(info.template.property3 == 7 && _cells[0].itemInfo.strengthenLevel == 6) || 
//						(info.template.property3 == 8 && _cells[0].itemInfo.strengthenLevel == 7) || 
//						(info.template.property3 == 9 && _cells[0].itemInfo.strengthenLevel == 8) || 
//						(info.template.property3 == 10 && _cells[0].itemInfo.strengthenLevel == 9) || 
//						(info.template.property3 == 11 && _cells[0].itemInfo.strengthenLevel == 10) ||
//						(info.template.property3 == 12 && _cells[0].itemInfo.strengthenLevel == 11) 
//					)
//						return FurnaceTipsType.SUCCESS;
//					return FurnaceTipsType.LUCKYBAG;
//				}
//				else
//				{
//					return FurnaceTipsType.LUCKYBAG;
//				}
//			}
//			return FurnaceTipsType.SUCCESS;
//		}
		
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
						getBackClickHandler(null);
					}
					else
					{
						isAutoFill = true;
						updateTips();
						updateShowCell(_furnaceItemInfo);
					}
					break
				case 1:
					if(_furnaceItemInfo)
					{
						updateData(_cells[0].furnaceItemInfo.bagItemInfo,_furnaceItemInfo.bagItemInfo);
						updateTips();
					}
					else
					{
						clearCells(false);
						updateTips();
					}
					break;
				case 2:break;
				case 3:
				case 4:
				case 5:
				case 6:
				case 7:
				//剩下的幸运符更新成功率公式
					if(_cells[0].furnaceItemInfo)
							updateSuccessRate(_cells[0].furnaceItemInfo.bagItemInfo);
			}
			if(isAutoFill)
			{
				autoFillCells1()//autoFillCells(CategoryType.STRENGTH,_cells[0].furnaceItemInfo.bagItemInfo.isBind);
			}
		}
		private function autoFillCells1():void
		{
			var tmpEquip:ItemInfo = _cells[0].itemInfo;
			if(!tmpEquip){return;}
			else
			{
				var level:int = tmpEquip.strengthenLevel + tmpEquip.strengthenPerfect /100;
				var info:StrengthenInfo = StrengthenTemplateList.getStrengthenInfo(level);
				
				if(info)
				{					
					var itemNum:int = furnaceInfo.getFurnaceItemNumByTemplateId(info.needStone);
					if(itemNum > 0)
					{
						var material:FurnaceItemInfo = furnaceInfo.getFurnaceMaterialByTemplateId(info.needStone);
						if(material)
						{
							_cells[1].furnaceItemInfo = material;
							_stuffAmount.textColor = 0xffcc00;
							_stuffAmount.setHtmlValue("<font color='#ffcc00'>"+ itemNum +"/1</font>");
						}						
					}
					else
					{
						var tmpInfo:ItemInfo = new ItemInfo();
						tmpInfo.itemId = 0;
						tmpInfo.templateId = info.needStone;
						_cells[1].furnaceItemInfo = new FurnaceItemInfo(tmpInfo);
						_stuffAmount.setHtmlValue("0/1");
						_stuffAmount.textColor = 0xff0000;
					}
					_useMoneyTextField.setValue(info.needCopper.toString());
					_currentMoney = info.needCopper;
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
			tmpInfo.strengthenLevel = 12;
			tmpInfo.strengthenPerfect = 100;
			tmpInfo.count = argInfo.bagItemInfo.count;
			tmpInfo.place = argInfo.bagItemInfo.place;
			tmpInfo.stallSellPrice = argInfo.bagItemInfo.stallSellPrice;
			tmpInfo.date = argInfo.bagItemInfo.date;
			tmpInfo.state = argInfo.bagItemInfo.state;
			tmpInfo.enchase1 = argInfo.bagItemInfo.enchase1;
			tmpInfo.enchase2 = argInfo.bagItemInfo.enchase2;
			tmpInfo.enchase3 = argInfo.bagItemInfo.enchase3;
	    	tmpInfo.enchase4 = argInfo.bagItemInfo.enchase4;
			tmpInfo.enchase5 = argInfo.bagItemInfo.enchase5;
			tmpInfo.isExist = argInfo.bagItemInfo.isExist;
			tmpInfo.attack = argInfo.bagItemInfo.attack;
			tmpInfo.defence = argInfo.bagItemInfo.defence;
			tmpInfo.durable = argInfo.bagItemInfo.durable;
			tmpInfo.freePropertyVector = argInfo.bagItemInfo.freePropertyVector;
			tmpInfo.lastUseTime = argInfo.bagItemInfo.lastUseTime;
			tmpInfo.isInCooldown = argInfo.bagItemInfo.isInCooldown;
			_showCell.itemInfo = tmpInfo;
		}
		
		private function updateTips():void
		{
			clearTipsLayer();
			var level:int = _cells[0].furnaceItemInfo.bagItemInfo.strengthenLevel;
			var perfect:int = _cells[0].furnaceItemInfo.bagItemInfo.strengthenPerfect;
//			var sp:Sprite = NumberCache.getNumber(level,1);
//			if(sp)_tipsLayer.addChild(sp);
			_strengLevelView.setValue(level.toString());
			setNumbers(level);
			var add:int = StrengthenTemplateList.getStrengthenAddition(level,perfect);
			 _strengAdditionView.setValue(LanguageManager.getWord("ssztl.furnace.strengthAddition") + add.toString() + "%");
			 _perfectDegreeView.setValue(LanguageManager.getWord("ssztl.furnace.perfectDegree") + perfect.toString() + "%");
			 _perfectDegreeProgressBar.setValue(MAX_PERFECT_DEGREE,perfect);
			 showItemStrengProperty(_cells[0].furnaceItemInfo.bagItemInfo, add);
			 
			 _strengInfo.visible = true;
		}
		//等级数字图片
		private function setNumbers(n:int):void
		{
			var _numAssets:Array = new Array(
				AssetUtil.getAsset("ssztui.scene.NumberAsset0") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset1") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset2") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset3") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset4") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset5") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset6") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset7") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset8") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset9") as BitmapData
			);
			while(_strengNumber && _strengNumber.numChildren>0){
				_strengNumber.removeChildAt(0);
			}
			if(n>-1)
			{
				var f:String = n.toString();
				for(var i:int=0; i<f.length; i++)
				{
					var mc:Bitmap = new Bitmap(_numAssets[int(f.charAt(i))]);
					mc.x = i*15; 
					_strengNumber.addChild(mc);
				}
			}
		}
		
		private function updateData(argEquipItemInfo:ItemInfo,argItemInfo:ItemInfo):void
		{
			/**成功率计算公式**/
			//updateSuccessRate(argEquipItemInfo);
			_strengthenBtn.enabled = true;
			_strengthenBtn2.enabled =true;
			/**所消耗金钱值为**/
//			_currentMoney = StrengthenTemplateList.getStrengthenInfo(argEquipItemInfo.strengthenLevel).needCopper;
//			_useMoneyTextField.setValue(_currentMoney.toString());
		}
		
		/**更新成功率**/
		private function updateSuccessRate(argEquipItemInfo:ItemInfo):void
		{			
			var luckyRate:int = 0;
			if(_cells[3].furnaceItemInfo)luckyRate+= ItemTemplateList.getTemplate(_cells[3].furnaceItemInfo.bagItemInfo.templateId).property1;
			if(_cells[4].furnaceItemInfo)luckyRate+= ItemTemplateList.getTemplate(_cells[4].furnaceItemInfo.bagItemInfo.templateId).property1;
			if(_cells[5].furnaceItemInfo)luckyRate+= ItemTemplateList.getTemplate(_cells[5].furnaceItemInfo.bagItemInfo.templateId).property1;
			if(_cells[6].furnaceItemInfo)luckyRate+= ItemTemplateList.getTemplate(_cells[6].furnaceItemInfo.bagItemInfo.templateId).property1;
			if(_cells[7].furnaceItemInfo)luckyRate+= ItemTemplateList.getTemplate(_cells[7].furnaceItemInfo.bagItemInfo.templateId).property1;
			
			//失败附加成功率
			if(furnaceInfo.strengthFailCount > 10)furnaceInfo.strengthFailCount = 10;
			
			var _clubSuccessRate:int = updateClubSuccessRate();
			//_currentSuccessRate = ((StrengTemplateList.getStrengInfoByTypeLevel(argEquipItemInfo.template.categoryId,argEquipItemInfo.strengthenLevel).strengSuccessRate + luckyRate) * (1 + _clubSuccessRate/100));
//			if(_currentSuccessRate > 100)_currentSuccessRate = 100;
//			_successRateTextField.text = _currentSuccessRate.toString() + "%";
			//vip附加成功率
			if(GlobalData.selfPlayer.getVipType() > 1)
			{
				var tmpVipTemplateInfo:VipTemplateInfo = VipTemplateList.getVipTemplateInfo(GlobalData.selfPlayer.getVipType());
				var tmpTitleTemplateInfo:TitleTemplateInfo = TitleTemplateList.getTitle(tmpVipTemplateInfo.titleId);
//				_vipRateTextField.textColor = CategoryType.getQualityColor(tmpTitleTemplateInfo.quality);
//				_vipRateTextField.text = " + " + tmpVipTemplateInfo.strengthRate.toString() + "%";
			}
			
			if(furnaceInfo.strengthFailCount != 0)
			{
//				_failRateTextField.text = StrengAddsuccrateTemplateList.getStrengAddsuccrateInfo(furnaceInfo.strengthFailCount).addSuccrate + "%";
			}
		}
		
		private function updateClubSuccessRate():int
		{
			var tmp:int = 0;
			if((GlobalData.selfPlayer.clubRich > 0 && (GlobalData.selfPlayer.totalExploit >= GlobalData.selfPlayer.furnaceNeedExploit)) || 
				ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty))
			{
				tmp =GlobalData.selfPlayer.clubFurnaceLevel * 5;
			}
			return tmp;
		}
		
		//购买时自动填充
		override protected function materialAddHandler(e:FuranceEvent):void
		{
			if(_cells[0].furnaceItemInfo)autoFillCells1();//autoFillCells(CategoryType.STRENGTH,_cells[0].furnaceItemInfo.bagItemInfo.isBind);
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_strengthenBtn)
			{
				_strengthenBtn.dispose();
				_strengthenBtn = null;
			}
			if(_strengthenBtn2)
			{
				_strengthenBtn2.dispose();
				_strengthenBtn2 = null;
			}
			if(_perfectDegreeProgressBar)
			{
				_perfectDegreeProgressBar.dispose();
				_perfectDegreeProgressBar = null;
			}
			if(_previewText && _previewText.bitmapData)
			{
				_previewText.bitmapData.dispose();
				_previewText = null;
			}
			if(_barBg && _barBg.bitmapData)
			{
				_barBg.bitmapData.dispose();
				_barBg = null;
			}
			if(_strengLabel && _strengLabel.bitmapData)
			{
				_strengLabel.bitmapData.dispose();
				_strengLabel = null;
			}
			_stuffAmount = null;
			_strengInfo = null;
			_useMoneyTextField = null;
			_currentPropertyText = null;
			_strengLevelView = null;
			setNumbers(-1);
			_strengNumber = null;
			_strengAdditionView = null;
			_perfectDegreeView = null;
			_strengProptery1 = null;
			_strengProptery2 = null;
			_tipsLayer = null;
		}
	}
}