package sszt.firebox.components
{
	import fl.controls.CheckBox;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.furnace.ForgeCorrespondInfo;
	import sszt.core.data.furnace.ForgeTemplateList;
	import sszt.core.data.furnace.FormulaDataInfo;
	import sszt.core.data.furnace.FormulaDataTemplateList;
	import sszt.core.data.furnace.FormulaInfo;
	import sszt.core.data.furnace.FormulaTemplateList;
	import sszt.core.data.module.changeInfos.ToNpcStoreData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.ModuleEvent;
	import sszt.firebox.data.FireBoxMaterialInfo;
	import sszt.firebox.events.FireBoxEvent;
	import sszt.firebox.events.FireBoxModuleEvent;
	import sszt.firebox.mediators.FireBoxMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MSelectButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.labelField.MLabelField2Bg;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.furnace.BorderCellBgAsset;
	import ssztui.furnace.SearchBtnAsset;
	import ssztui.furnace.TabBtnAsset1;
	import ssztui.furnace.TabBtnAsset2;
	import ssztui.furnace.TitleTxtAsset;
	
	public class FireBoxPanel extends MPanel
	{
		private var _fireBoxMediator:FireBoxMediator;
		private var _bg:IMovieWrapper;
		private var _refiningBg:Bitmap;
		private var _btns:Array;
		private var _mTile:MTile;
		private var _currentIndex:int = -1;
		private var _mixBtn:MCacheAssetBtn1;
		private var _shopBtn:MSprite;
		private var _materialCheckBox:CheckBox;
//		private var _produceCheckbox:CheckBox;
		private var _currentSelect:int = -1;
		private var _successRateLabel:MAssetLabel;
		private var _moneyLabel:MAssetLabel;
		private var _currentMoney:int;

		private var _targetItemVector:Array = [];
		private var _materialVector:Array = new Array(6);
		private var _sortItemVector:Array = [];
		
		private var _descriptionCell:FireBoxBaseCell;
		private var _descriptionLabel:MAssetLabel;
		public static const LABEL_FORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,4);
		private var _currentSortOnIndex:int = -1;
		
		
		private var _assetsComplete:Boolean;
		private var _splitPanel:SplitPanel;
		
		/**
		 * 锻造
		 */		
		private var _TabBtn1:MSelectButton;
		/**
		 * 炼制 
		 */		
		private var _TabBtn2:MSelectButton;
		
		private var _openMarket:MAssetLabel;
		
		public function FireBoxPanel(argMediator:FireBoxMediator)
		{
			_fireBoxMediator = argMediator;
			super(new MCacheTitle1("",new Bitmap(new TitleTxtAsset())),true,-1);
			initialEvents();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(591,430);
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(9,25,573,398),new BackgroundType.BORDER_11()));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(13,29,191,390),new BackgroundType.BORDER_12()));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(206,29,372,390),new BackgroundType.BORDER_12()));
			_refiningBg = new Bitmap();
			_refiningBg.x = 207;
			_refiningBg.y = 30;
			addContent(_refiningBg as DisplayObject);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(283,88,42,42),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(371,88,42,42),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(459,88,42,42),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(283,166,42,42),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(371,166,42,42),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(459,166,42,42),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(285,90,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(373,90,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(461,90,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(285,168,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(373,168,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(461,168,38,38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(305,254,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(490,371,18,18),new Bitmap(MoneyIconCaches.copperAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(223,372,17,17),new Bitmap(new SearchBtnAsset() as BitmapData)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(349,53,50,16),new MAssetLabel(LanguageManager.getWord("ssztl.role.successRate"),MAssetLabel.LABEL_TYPE_B14,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(455,372,50,14),new MAssetLabel(LanguageManager.getWord("ssztl.common.fare"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(298,325,50,14),new MAssetLabel(LanguageManager.getWord("ssztl.furnace.compositeNum"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
			]);
			addContent(_bg as DisplayObject);
			
			_btns = [];
			for(var i:int = 0;i < ForgeTemplateList.list.length;i++)
			{
				var tmpBtn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,ForgeTemplateList.list[i].name);
				tmpBtn.move(i * 69 + 15,0);
				tmpBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
				addContent(tmpBtn);
				_btns.push(tmpBtn);
			}
			_TabBtn1 = new MSelectButton(new TabBtnAsset1());
			_TabBtn1.move(-29,33);			
			addContent(_TabBtn1);
			_TabBtn2 = new MSelectButton(new TabBtnAsset2());
			_TabBtn2.move(-29,95);
			_TabBtn2.selected = true;
			addContent(_TabBtn2);
			
			_mTile = new MTile(183,45,1);
			_mTile.setSize(183,357);
			_mTile.itemGapH = _mTile.itemGapW = 0;
			_mTile.verticalScrollPolicy = ScrollPolicy.AUTO;
			_mTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mTile.move(17,59);
			addContent(_mTile);
			
			_successRateLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_B14,TextFormatAlign.LEFT);
			_successRateLabel.move(410,53);
			addContent(_successRateLabel);
			
			_moneyLabel = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_moneyLabel.move(509,372);
			addContent(_moneyLabel)
			
			_materialCheckBox = new CheckBox();
			_materialCheckBox.label = LanguageManager.getWord("ssztl.furnace.showIntegralMaterial");
			_materialCheckBox.setSize(124,20);
			_materialCheckBox.move(446,5);
			addContent(_materialCheckBox);
			
			_descriptionCell = new FireBoxBaseCell();
			_descriptionCell.move(305,254);
			addContent(_descriptionCell);
			
			_descriptionLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_descriptionLabel.defaultTextFormat = LABEL_FORMAT;
			_descriptionLabel.setTextFormat(LABEL_FORMAT);
			_descriptionLabel.move(331+39,242+20);
			_descriptionLabel.wordWrap = true;
			_descriptionLabel.multiline = true;
			_descriptionLabel.width = 190;
			addContent(_descriptionLabel);
			
			var materialPoses:Array = [
				new Point(285,90),new Point(373,90),new Point(461,90),
				new Point(285,166),new Point(373,166),new Point(461,166),
			];
			function getCellPos():Array
			{
				var x:int = 7;
				var y:int = 27;
				return [new Point(271 + x,50 + y),new Point(349 + x,50 + y),new Point(427 + x,50 + y),new Point(505 + x,50 + y),new Point(583 + x,50 + y),
					new Point(271 + x,134 + y),new Point(349 + x,134 + y),new Point(427 + x,134 + y),new Point(505 + x,134 + y),new Point(583 + x,134 + y)];
			}
			
			for(var j:int = 0;j<_materialVector.length;j++)
			{				
				_materialVector[j] = new MaterialItemView();
				_materialVector[j].move(materialPoses[j].x,materialPoses[j].y);
				addContent(_materialVector[j]);
			}
			
			_mixBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.furnace.startMix"));
			_mixBtn.enabled = false;
			_mixBtn.move(342,360);
			addContent(_mixBtn);
			
			_openMarket = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_openMarket.move(241,372);
			addContent(_openMarket); 
			_openMarket.setHtmlValue("<a href=\'event:0\'><u>"+LanguageManager.getWord("ssztl.furnace.openMarket")+"</u></a>");
			
//			_shopBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.martLable"));
			_shopBtn = new MSprite();
			_shopBtn.graphics.beginFill(0xffffff,0);
			_shopBtn.graphics.drawRect(223,372,70,17);
			_shopBtn.graphics.endFill();
			_shopBtn.buttonMode = true;
			addContent(_shopBtn);
			
			_splitPanel = new SplitPanel();
			_splitPanel.move(356,322);
			addContent(_splitPanel);
			
			if(_fireBoxMediator.fireboxModule.toData.tabIndex1 != 0)
			{
				setIndex(_fireBoxMediator.fireboxModule.toData.tabIndex1);
//				setSortOnIndex(_fireBoxMediator.fireboxModule.toData.tabIndex2);
			}
			else
			{
				setIndex(0);
			}
			
		}
		
		private function initialEvents():void
		{
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagUpdateHandler);
			_mixBtn.addEventListener(MouseEvent.CLICK,mixBtnHandler);
//			_multiBtn.addEventListener(MouseEvent.CLICK,multiBtnHandler);
			_shopBtn.addEventListener(MouseEvent.CLICK,shopBtnHandler);
			_materialCheckBox.addEventListener(Event.CHANGE,materialCheckBoxHandler);
			_splitPanel.addEventListener(FireBoxEvent.COMPOSE_NUMBER_UPDATE, updateNeedCopperHandler);
			_TabBtn1.addEventListener(MouseEvent.CLICK, tabBtnClickHandler);
			
			ModuleEventDispatcher.addModuleEventListener(FireBoxModuleEvent.MIN_BTN_UPDATE,minBtnUpdate);
		}
		
		private function removeEvents():void
		{
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagUpdateHandler);
			_mixBtn.removeEventListener(MouseEvent.CLICK,mixBtnHandler);
//			_multiBtn.removeEventListener(MouseEvent.CLICK,multiBtnHandler);
			_shopBtn.removeEventListener(MouseEvent.CLICK,shopBtnHandler);
			_materialCheckBox.removeEventListener(Event.CHANGE,materialCheckBoxHandler);
			_splitPanel.removeEventListener(FireBoxEvent.COMPOSE_NUMBER_UPDATE, updateNeedCopperHandler);
			_TabBtn1.removeEventListener(MouseEvent.CLICK, tabBtnClickHandler);
			
			ModuleEventDispatcher.removeModuleEventListener(FireBoxModuleEvent.MIN_BTN_UPDATE,minBtnUpdate);
		}
		private function tabBtnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
//			dispose();
			SetModuleUtils.addFurnace();
//			
//			SetModuleUtils.addFireBox();
		}
		
		private function minBtnUpdate(evt:ModuleEvent):void
		{
			setIndex(_currentIndex);
			var old:int = _currentSelect;
//			updateListHeight();
			changeTabFireBoxCells();
			setTargetSelectIndex(old);
		}
		
		private function openMarkentClick(e:MouseEvent):void
		{
			SetModuleUtils.addConsign();
		}
		
		private function updateNeedCopperHandler(e:FireBoxEvent):void
		{
			var composeNum:int = _splitPanel.value;	
			var tmp:FormulaDataInfo = FormulaDataTemplateList.getFormularDataInfo(_targetItemVector[_currentSelect].info.formulaDataId);
			var needCopper:int = _splitPanel.value * tmp.costCopper;
			_moneyLabel.setValue(needCopper.toString());
		}
		
		private function mixBtnHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
//			if(GlobalData.bagInfo.currentSize >= GlobalData.selfPlayer.bagMaxCount)
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.bagFull"));
//				return;
//			}
//			if(_currentMoney > GlobalData.selfPlayer.userMoney.allCopper)
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
//				return;
//			}
			var tmp:FormulaDataInfo = FormulaDataTemplateList.getFormularDataInfo(_targetItemVector[_currentSelect].info.formulaDataId);
			var canCount:int = _splitPanel.value;
			var allCopper:int = canCount * tmp.costCopper;
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
			var tmpFormulaDataInfo:FormulaDataInfo = FormulaDataTemplateList.getFormularDataInfo(_targetItemVector[_currentSelect].info.formulaDataId);
			for(var i:int = 0;i < tmpFormulaDataInfo.needItemIds.length;i++)
			{
				if(GlobalData.bagInfo.hasBindItem(tmpFormulaDataInfo.needItemIds[i]))
				{
					MAlert.show(LanguageManager.getWord("ssztl.furnace.composeItemWillBeBind"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler,TextFormatAlign.CENTER,-1,true,false);
					return;
				}
			}
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					_fireBoxMediator.sendFire(_targetItemVector[_currentSelect].info.formulaDataId,_splitPanel.value);
				}
			}
			_fireBoxMediator.sendFire(_targetItemVector[_currentSelect].info.formulaDataId,_splitPanel.value);
			_mixBtn.enabled =false;
//			_multiBtn.enabled =false;
		}
		
//		private function multiBtnHandler(e:MouseEvent):void
//		{
//			var tmp:FormulaDataInfo = FormulaDataTemplateList.getFormularDataInfo(_targetItemVector[_currentSelect].info.formulaDataId);
//			var canCount:int = getCellCount();
//			var allCopper:int = canCount * tmp.costCopper;
//			if(canCount < 1)
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.furnace.mutrialNotEnough"));
//				return;
//			}
//			if(GlobalData.bagInfo.currentSize >= GlobalData.selfPlayer.bagMaxCount)
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.bagFull"));
//				return;
//			}
//			if(allCopper > GlobalData.selfPlayer.userMoney.allCopper)
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
//				return;
//			}
//			var content1:String = "将会合成" +canCount + "个" +tmp.outputName+"物品，是否批量合成？";
//			MAlert.show(content1,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler,TextFormatAlign.CENTER,-1,true,false);
//			function closeHandler(evt:CloseEvent):void
//			{
//				if(evt.detail == MAlert.OK)
//				{
//					send();
//				}
//			}
//			function send():void
//			{
//				_fireBoxMediator.sendMultiFire(_targetItemVector[_currentSelect].info.formulaDataId);
//				_mixBtn.enabled =false;
//				_multiBtn.enabled =false;
//			}
//		}
		
		private function shopBtnHandler(e:MouseEvent):void
		{
//			SetModuleUtils.addNPCStore(new ToNpcStoreData(102,-1));
//			SetModuleUtils.addBag();
			//开启商城搜索
			
			SetModuleUtils.addConsign();
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var index:int = _btns.indexOf(e.currentTarget as MCacheTabBtn1);
			setIndex(index);
		}
		
		private function setIndex(argIndex:int):void
		{
			if(_currentIndex == argIndex)return;
			if(_currentIndex != -1)
			{
				_btns[_currentIndex].selected = false;
			}
			_currentIndex = argIndex;
			_currentSelect = -1;
			_currentSortOnIndex = -1;
			_btns[_currentIndex].selected = true;
//			changeTabFireBoxCells();
			updateSortOnList();
		}
		
		private function updateSortOnList():void
		{
			clearCells();
			var tmpSortList:Array = ForgeTemplateList.list[_currentIndex].sortOnList;
			for (var i:int = 0;i <tmpSortList.length;i++)
			{
				var tmp:FireBoxSortItemView = new FireBoxSortItemView(tmpSortList[i]);
				tmp.addEventListener(MouseEvent.CLICK,sortItemSelectHandler);
				tmp.move(16,i*26+32);
				_sortItemVector.push(tmp);
				addContent(tmp);
			}
			if( _fireBoxMediator.fireboxModule.toData.tabIndex2 != 0)
			{
				setSortOnIndex(_fireBoxMediator.fireboxModule.toData.tabIndex2);
			}
			else
			{
				setSortOnIndex(0);
			}
			
		}
		
		private function sortItemSelectHandler(e:MouseEvent):void
		{
			var index:int = _sortItemVector.indexOf(e.currentTarget as FireBoxSortItemView);
			setSortOnIndex(index);
		}
		
		private function setSortOnIndex(argIndex:int):void
		{
			if(_currentSortOnIndex == argIndex)return;
			if(_currentSortOnIndex != -1)
			{
			}
			_currentSortOnIndex = argIndex;
			_currentSelect = -1;
			updateListHeight();
			changeTabFireBoxCells();
		}
		
		private function updateListHeight():void
		{
		    var _currentHeight:int = 32;
			var _allHeight:int = 382;
			var _contentHeight:int = _allHeight - _sortItemVector.length * 25;
			for(var i:int = 0;i < _sortItemVector.length;i++)
			{
				_sortItemVector[i].move(16,_currentHeight)
				_currentHeight += 26;
				if(i == _currentSortOnIndex)
				{
					_mTile.move(17,_currentHeight + 1);
					_mTile.height = _contentHeight;
					_currentHeight += _mTile.height;
				}
			}
		}
		
		/**
		 *切卡时更新格子 
		 * 
		 */		
		private function changeTabFireBoxCells():void
		{
			clearTargetItemCells();
			clearMaterialItemCells();
			for each(var i:FormulaInfo in FormulaTemplateList.getListByType(ForgeTemplateList.list[_currentIndex].id,_sortItemVector[_currentSortOnIndex].info.sortId,GlobalData.selfPlayer.career))
			{
				if(_materialCheckBox.selected && checkEnoughCount(i))
				{
					continue;
				}
				var tmp:TargetItemView = new TargetItemView(i);
				tmp.addEventListener(MouseEvent.CLICK,targetItemSelectHandler);
				_targetItemVector.push(tmp);
				_mTile.appendItem(tmp);
			}
			showMixNum();
			if(_targetItemVector.length > 0)setTargetSelectIndex(0);
		}
		
		private function setTargetSelectIndex(argIndex:int):void
		{
			if(_currentSelect == argIndex)return;
			if(_currentSelect != -1)
			{
				_targetItemVector[_currentSelect].select = false;
			}
			_currentSelect = argIndex;
			_targetItemVector[_currentSelect].select = true;
			
			changeSelectTargetItem();
		}
		
		private function changeSelectTargetItem():void
		{
			clearMaterialItemCells();
			var tmpInfo:FormulaDataInfo = FormulaDataTemplateList.getFormularDataInfo(_targetItemVector[_currentSelect].info.formulaDataId);			
			for(var i:int = 0;i<tmpInfo.needCounts.length;i++)
			{
				_materialVector[i].materialInfo = new FireBoxMaterialInfo(tmpInfo.needItemIds[i],tmpInfo.needCounts[i],GlobalData.bagInfo.getItemCountById(tmpInfo.needItemIds[i]));
				
			}
			_splitPanel.maxValue = getCellCount();
			_successRateLabel.text = tmpInfo.seccussRate.toString() + "%";
			_currentMoney = tmpInfo.costCopper * _splitPanel.value;
			_moneyLabel.text = _currentMoney.toString();
			_descriptionCell.info = tmpInfo.getTempalteInfo();
			var _color:String = CategoryType.getQualityColorString(tmpInfo.getTempalteInfo().quality);
			_descriptionLabel.htmlText = "<font color = '#"+_color+"'>" +tmpInfo.name + "</font>\n";// +  tmpInfo.getTempalteInfo().description;
			checkCellsCount();
		}
		
		
		private function showMixNum():void
		{
			var j:int=0;
			var tmpInfo:FormulaDataInfo;
			for(; j<_targetItemVector.length; j++)
			{
				tmpInfo = FormulaDataTemplateList.getFormularDataInfo(_targetItemVector[j].info.formulaDataId);			
				for(var i:int = 0;i<tmpInfo.needCounts.length;i++)
				{
					var itemCount:int = GlobalData.bagInfo.getItemCountById(tmpInfo.needItemIds[i]);
					var tempNum:int = itemCount / tmpInfo.needCounts[i];
					if(tempNum > 0)
					{
						_targetItemVector[j].num = tempNum;
					}
				}
			}
//			clearTargetItemCells();
//			clearMaterialItemCells();
		}
		
		private function targetItemSelectHandler(e:MouseEvent):void
		{
			var index:int = _targetItemVector.indexOf(e.currentTarget as TargetItemView);
			setTargetSelectIndex(index);
		}
		
		private function bagUpdateHandler(e:BagInfoUpdateEvent):void
		{
			updateCount();
			checkCellsCount();
		}
		
		private function updateCount():void
		{
			for each(var i:MaterialItemView in _materialVector)
			{
				if(i.materialInfo)
				{
					i.materialInfo.updateData(GlobalData.bagInfo.getItemCountById(i.materialInfo.templateInfoId));
				}
			}
		}
		
		public function addAssets():void
		{
			_refiningBg.bitmapData = AssetUtil.getAsset("ssztui.furnace.RefiningBgAsset",BitmapData) as BitmapData;
			_assetsComplete = true;
		}
		
		public function checkCellsCount():void
		{
			var mixCount:int = getCellCount();
			if(mixCount != 0)
			{
				_mixBtn.enabled = true;
//				_multiBtn.enabled = true;
			}
			else
			{
				_mixBtn.enabled = false;
//				_multiBtn.enabled =false;
			}
		}
		
		/**
		 * 可合成数 
		 * @return 
		 * 
		 */		
		public function getCellCount():int
		{
			var canCount:int = -1;
			for each(var i:MaterialItemView in _materialVector)
			{
				if(i.materialInfo && i.materialInfo.tempalteInfo)
				{
					var matchCount:int = i.materialInfo.bagCount / i.materialInfo.needCount;
					if(matchCount < canCount || canCount==-1)canCount = matchCount;
				}
			}
			return canCount;
		}
		
		public function checkEnoughCount(argFormulaInfo:FormulaInfo):Boolean
		{
			var tmpInfo:FormulaDataInfo = FormulaDataTemplateList.getFormularDataInfo(argFormulaInfo.formulaDataId);
			for(var i:int = 0;i<tmpInfo.needCounts.length;i++)
			{
				if(GlobalData.bagInfo.getItemCountById(tmpInfo.needItemIds[i]) < tmpInfo.needCounts[i])
				{
					return true
				}
			}
			return false;
		}
		
		private function materialCheckBoxHandler(e:Event):void
		{
			_currentSelect = -1;
			changeTabFireBoxCells();
		}
		
		public function getMaterialItemView(argTemplateId:int):MaterialItemView
		{
			for each(var i:MaterialItemView in _materialVector)
			{
				if(i && i.materialInfo.templateInfoId == argTemplateId)
				{
					return i;
				}
			}
			return null;
		}
		
		
		private function clearCells():void
		{
			clearTargetItemCells();
			clearMaterialItemCells();
			clearSortItemList();
		}
		
		private function clearTargetItemCells():void
		{
			for(var i:int = _targetItemVector.length - 1;i >=0;i--)
			{
				_targetItemVector.splice(i,1);
				_mTile.removeItemAt(i);
			}
		}
		
		private function clearMaterialItemCells():void
		{
			for(var i:int = _materialVector.length - 1;i >=0;i--)
			{
				_materialVector[i].materialInfo = null;
			}
		}
		
		private function clearSortItemList():void
		{
			for(var i:int = _sortItemVector.length - 1;i >= 0;i--)
			{
				if(_sortItemVector[i])
				{
					_sortItemVector[i].dispose();
					_sortItemVector[i] = null;
				}
			}
			_sortItemVector.length = 0;
		}
		
		override public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_fireBoxMediator = null;
			for each(var i:MCacheTabBtn1 in _btns)
			{
				i.removeEventListener(MouseEvent.CLICK,btnClickHandler);
				i.dispose();
				i = null;
			}
			_btns = null;
			_TabBtn1.dispose();
			_TabBtn1 = null;
			_TabBtn2.dispose();
			_TabBtn2 = null;
			if(_mTile)
			{
				_mTile.dispose();
				_mTile = null;
			}
			if(_mixBtn)
			{
				_mixBtn.dispose();
				_mixBtn = null;
			}
			if(_shopBtn)
			{
				_shopBtn.dispose();
				_shopBtn = null;
			}
			_materialCheckBox = null;
//			_produceCheckbox = null;
			_successRateLabel = null;
			_moneyLabel = null;
			for each(var j:TargetItemView in _targetItemVector)
			{
				if(j)
				{
					j.removeEventListener(MouseEvent.CLICK,targetItemSelectHandler);
					j.dispose();
					j = null;
				}
			}
			_targetItemVector = null;
			for each(var m:MaterialItemView in _materialVector)
			{
				if(m)
				{
					m.dispose();
					m = null;
				}
			}
			_materialVector = null;
			for each(var n:FireBoxSortItemView  in _sortItemVector)
			{
				if(n)
				{
					n.removeEventListener(MouseEvent.CLICK,sortItemSelectHandler);
					n.dispose();
					n = null;
				}
			}
			_sortItemVector = null;
			if(_descriptionCell)
			{
				_descriptionCell.dispose();
				_descriptionCell = null;
			}
			_descriptionLabel = null;
			GlobalData.furnaceState = 0;
			super.dispose();
		}
	}
}