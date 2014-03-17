package sszt.furnace.components
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.flash_proxy;
	
	import sszt.constData.CategoryType;
	import sszt.constData.PropertyType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.bag.ClientBagInfoUpdateEvent;
	import sszt.core.data.bag.PetBagInfoUpdateEvent;
	import sszt.core.data.furnace.parametersList.DecomposeCopperTemplateList;
	import sszt.core.data.furnace.parametersList.RebuildTemplateList;
	import sszt.core.data.item.ItemFreeProperty;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.item.PropertyInfo;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.furnace.components.btn.MFurnaceCacheSelectBtn;
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
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.furnace.BorderCellBgAsset;
	import ssztui.furnace.BorderCellBgAsset2;
	import ssztui.furnace.LabelStrongAsset2;
	import ssztui.furnace.LockIcoAsset;
	import ssztui.furnace.TrackBgAsset;
	import ssztui.furnace.UpArrowBgAsset;
	import ssztui.furnace.iconAddAsset;
	import ssztui.furnace.iconLowerAsset;

	public class RebuildTabPanel extends BaseFurnaceTabPanel
	{
		
		public static const LABEL_FORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,4);
		
		private const Max_Property_Num:int = 6;
		
		private var _bg:IMovieWrapper;
//		private var _getBackBtn:MCacheAsset1Btn;
		private var _rebuildBtn:MCacheAssetBtn1;
		private var _rebuildBtn2:MCacheAssetBtn1;
//		private var _lastConfigBtn:MCacheAsset1Btn;
		private var _useMoneyTextField:MAssetLabel;
//		private var _successRateTextFiled:TextField;
		private var _showCell:BaseItemInfoCell;
		private var _lockCell:BaseItemInfoCell;
		
		private var _currentEquipQuality:int;
		private var _currentSuccessRate:int;
		private var _currentMoney:int;
		
//		private var _label:MAssetLabel;
//		private var _rebuildResultField:TextField;
		private var _rebuildResultField:MAssetLabel;
		private var _equipScoreLabel:MAssetLabel;
		
		private var _previewText:Bitmap;
		
		private var _oldPropertyList:Array;
		private var _oldPropertyLocks:Array;
		private var _oldPropertyIndexList:Array;
		
		private var _PropertyList:Array;
		private var _PropertyLocks:Array;
		
		private var _rebuildEffect:BaseLoadEffect;
		
		private var _oldFightTextField:MAssetLabel;
		private var _newFightTextField:MAssetLabel;
		private var _lockNumLable:MAssetLabel;
		private var _lockNum:int;
		private var _bagLockNum:int;
		
		private var _strengInfo:MSprite;
		private var _barBg:Bitmap;
		private var _bgProperty:Bitmap;
		private var _fightLabel:Bitmap;
		private var _fightNumber:MSprite;
		
		private var _lockCellDiv:MSprite;
		
		private static const REBUILD_LOCK_ID:int = 201029;
		/**装备重铸材料**/
//		public static const REBUILD_MATERIAL_CATEGORYID_LIST:Vector.<int> = Vector.<int>([CategoryType.REBUILD,CategoryType.REBUILDLUCKYSYMBOL]);
		public static const REBUILD_MATERIAL_CATEGORYID_LIST:Array = [CategoryType.REBUILD,CategoryType.REBUILDLUCKYSYMBOL];
		
		public function RebuildTabPanel(mediator:FurnaceMediator)
		{
			super(mediator);
		}
		
				
		override protected function init():void
		{
			_previewText = new Bitmap();
			_previewText.x = 11;
			_previewText.y = 60;
			addChild(_previewText);
			
			_bgProperty = new Bitmap();
			_bgProperty.x = 19;
			_bgProperty.y = 82;
			addChild(_bgProperty);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(11,12,50,50),new Bitmap(new BorderCellBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(102,28,50,50),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(181,30,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(17,18,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addChild(_bg as DisplayObject);
			// topBar
			_strengInfo = new MSprite();
			_strengInfo.move(84,230);
			addChild(_strengInfo);
			_barBg = new Bitmap();
			_strengInfo.addChild(_barBg);
			_fightLabel = new Bitmap(new LabelStrongAsset2());
			_fightLabel.x = 28;
			_fightLabel.y = 9;
			_strengInfo.addChild(_fightLabel);
			_fightNumber = new MSprite();
			_fightNumber.move(75,5);
			_strengInfo.addChild(_fightNumber);
//			_strengInfo.addChild(MBackgroundLabel.getDisplayObject(new Rectangle(64,9,120,14),new MAssetLabel(LanguageManager.getWord("ssztl.common.fightValueEx"),MAssetLabel.LABEL_TYPE20,"left")));
			_strengInfo.visible = false;
			super.init();	
			
			/** 锁 **/
			_lockCellDiv = new MSprite();
			_lockCellDiv.move(229,30);
			addChild(_lockCellDiv);
			_lockCellDiv.addChild(MBackgroundLabel.getDisplayObject(new Rectangle(0,0,46,46),new Bitmap(new BorderCellBgAsset2() as BitmapData)));
			_lockCellDiv.addChild(MBackgroundLabel.getDisplayObject(new Rectangle(4,4,38,38),new Bitmap(CellCaches.getCellBg())));
			_lockCellDiv.visible = false;
			
			_lockCell = new FurnaceCell();
			_lockCell.move(4,4);
			var lock:ItemInfo = new ItemInfo();
			lock.templateId = REBUILD_LOCK_ID;
			_lockCell.itemInfo = lock;
			_lockCellDiv.addChild(_lockCell);	
			
			_lockNumLable = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.RIGHT);//洗炼分数
			_lockNumLable.move(40,29);
			_lockCellDiv.addChild(_lockNumLable);
			_lockNum = 0;
			
			/**---------------处理显示的textField---------------**/
			
			_oldFightTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_oldFightTextField.setLabelType([new TextFormat("Microsoft YaHei",15,0xffcc00,null,null)]);
			_oldFightTextField.move(120,4);
			_oldFightTextField.setSize(100,22);
//			_strengInfo.addChild(_oldFightTextField);
			
			_newFightTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_newFightTextField.setLabelType([new TextFormat("Microsoft YaHei",22,0x72ff00,null,null)]);
			_newFightTextField.move(190,-2);
			_newFightTextField.setSize(200,22);
//			_strengInfo.addChild(_newFightTextField);
			
			_useMoneyTextField = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_useMoneyTextField.move(65,320);
			addChild(_useMoneyTextField);
			/**--------------------------------------------**/
						
			_rebuildBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.furnace.beginRebuild"));
			_rebuildBtn.enabled = false;
			_rebuildBtn.move(115,269);//64,269);
			addChild(_rebuildBtn);
			
			_rebuildBtn2 = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.furnace.Replace"));
			_rebuildBtn2.visible = false;
			_rebuildBtn2.move(166,269);
			addChild(_rebuildBtn2);

			initProperty();
			_rebuildResultField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,"left");
			_rebuildResultField.multiline = true;
			_rebuildResultField.mouseEnabled = _rebuildResultField.mouseWheelEnabled = false;
//			_rebuildResultField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x41D913,null,null,null,null,null,null,null,null,null,3);
			_rebuildResultField.width = 100;
//			_rebuildResultField.x = 125;
//			_rebuildResultField.y = 60;
			_rebuildResultField.move(26,149);
			_rebuildResultField.defaultTextFormat = LABEL_FORMAT;
			_rebuildResultField.setTextFormat(LABEL_FORMAT);
			_rebuildResultField.visible = false;
			addChild(_rebuildResultField);
			
			_equipScoreLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);//洗炼分数
			_equipScoreLabel.textColor = 0xEC7E13;
			_equipScoreLabel.move(40,200);
			addChild(_equipScoreLabel);
			
			_showCell = new FurnaceCell();
			_showCell.move(17,18);
			addChild(_showCell);
			
		}
		
		override public function show():void
		{
			super.show();
			/**加载数据到快速购买**/
			furnaceInfo.currentBuyType = FurnaceBuyType.REBUILD;
			/**加载数据到另外两个面板**/
			furnaceInfo.initialFurnaceVector(qualityItemListChecker,REBUILD_MATERIAL_CATEGORYID_LIST);
			/**监听背包变化**/
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);			
			furnaceModule.furnaceInfo.addEventListener(FuranceEvent.REBUILD_SUCCESS,rebuildHandler);
//			_getBackBtn.addEventListener(MouseEvent.CLICK,backBtnHandler);
			_rebuildBtn.addEventListener(MouseEvent.CLICK,rebuildBtnHandler);
			_rebuildBtn2.addEventListener(MouseEvent.CLICK,rebuildBtn2Handler);
//			_lastConfigBtn.addEventListener(MouseEvent.CLICK,lastConfigClickHandler);
			hideRebuildResult();
			_bagLockNum = furnaceInfo.getFurnaceItemNumByTemplateId(REBUILD_LOCK_ID);
			
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
			furnaceModule.furnaceInfo.removeEventListener(FuranceEvent.REBUILD_SUCCESS,rebuildHandler);
//			_getBackBtn.removeEventListener(MouseEvent.CLICK,backBtnHandler);
			_rebuildBtn.removeEventListener(MouseEvent.CLICK,rebuildBtnHandler);
			_rebuildBtn2.removeEventListener(MouseEvent.CLICK,rebuildBtn2Handler);
//			_lastConfigBtn.removeEventListener(MouseEvent.CLICK,lastConfigClickHandler);
//			backBtnHandler(null);
			
			GlobalData.petBagInfo.removeEventListener(PetBagInfoUpdateEvent.ITEM_ID_UPDATE,petBagItemUpdateHandler);
		}
		
		override protected function equipFillAgain(argItemId:Number):void
		{
			super.equipFillAgain(argItemId);
			var item:ItemInfo = GlobalData.bagInfo.getItemByItemId(argItemId);
			showItemFreeProperty(item);
//			if(item)
//				setEquipScore(item.score);
		}
		
		override public function addAssets():void
		{
			_previewText.bitmapData = AssetUtil.getAsset("ssztui.furnace.TextPreviewAsset",BitmapData) as BitmapData;
			_barBg.bitmapData = AssetUtil.getAsset("ssztui.furnace.BarBgAsset1" ,BitmapData) as BitmapData;
			_bgProperty.bitmapData = AssetUtil.getAsset("ssztui.furnace.RebuildBgAsset" ,BitmapData) as BitmapData;
		}
		
		//初始化洗炼属性
		private function initProperty():void
		{
			_oldPropertyList = new Array();
			_oldPropertyLocks = new Array();
			_oldPropertyIndexList = new Array();
			_PropertyList = new Array();
			_PropertyLocks = new Array();
			var topx:int = 26;
			var topy:int = 106;
			for(var i:int = 0;i < Max_Property_Num;i++)
			{
				var btn:MFurnaceCacheSelectBtn = new MFurnaceCacheSelectBtn(0,0);
				btn.move(topx, i * 20 + topy+1);
				btn.visible = false;
				btn.addEventListener(MouseEvent.CLICK, updateLockNum);
				_oldPropertyLocks.push(btn);
				addChild(btn);	
				var lable:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
				lable.move(topx+20, i * 20 + topy);
				_oldPropertyList.push(lable);
				_oldPropertyIndexList.push(0);
				addChild(lable);
				
				var ioc:Bitmap = new Bitmap();
				ioc.bitmapData = new LockIcoAsset() as BitmapData;
				ioc.x = topx + 153;
				ioc.y = i * 20 + topy+1;
				ioc.visible = false;
				_PropertyLocks.push(ioc);
				addChild(ioc);	
				var lable1:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
				lable1.move(topx + 173, i * 20 + topy);
				lable1.visible = false;
				_PropertyList.push(lable1);
				addChild(lable1);
			}
		}
		private function updateLockNum(e:MouseEvent):void
		{
			if((e.target as MFurnaceCacheSelectBtn).selected)
			{
				_lockNum ++;
			}
			else
			{
				_lockNum --;				
			}
			updateLockNumLable();
			if(_cells[1].furnaceItemInfo)
				updateData(_cells[0].furnaceItemInfo.bagItemInfo,_cells[1].furnaceItemInfo.bagItemInfo);
		}
		private function updateLockNumLable():void
		{
			if(_lockNum < 0) _lockNum = 0;	
			if(_lockNum > _bagLockNum)
				_lockNumLable.htmlText =  "<font color = '#ff0000'>" + _bagLockNum.toString() +"/"+ _lockNum + "</font>";
			else
				_lockNumLable.text = _bagLockNum.toString() +"/"+ _lockNum;	
			_lockCellDiv.visible = _lockNum==0?false:true;
		}
			
		private function showItemFreeProperty(item:ItemInfo):void
		{
			if(item)
			{	_lockNum = 0;
				var i:int = 0; var j:int = 0;
				var oldFight:Number = 0;
				var newFight:Number = 0;
				for each(var m:ItemFreeProperty in item.freePropertyVector)
				{
					var name:String = PropertyType.getName(m.propertyId);
					//计算星级
					var star:int = -1;
					for(var n:int = 0;n < item.template.freePropertyList.length;n++)
					{
						if(item.template.freePropertyList[n].propertyId == m.propertyId)
						{							
							if(item.template.freePropertyList[n].propertyValue < 9)
								star = m.propertyValue;
							else
								star = Math.ceil(m.propertyValue/(item.template.freePropertyList[n].propertyValue / 9));
							break;
						}
					}
					var color:uint;
					if(star < 4 )
						color = 0x00cc00;//lv
					else if(star < 7)
						color = 0x00ccff;//lan
					else if(star < 9)
						color = 0xcc00ff;//z
					else
						color = 0xff9900;//s
					
					if(m.lockState < ItemFreeProperty.UNLOCK_REBUILD)
					{
						(_oldPropertyList[i] as MAssetLabel).setValue(name + " "  + m.propertyValue.toString());
						(_oldPropertyList[i] as MAssetLabel).visible = true;
						(_oldPropertyList[i] as MAssetLabel).textColor = color;
						_oldPropertyIndexList[i] = m.index;
						if(m.lockState == ItemFreeProperty.LOCK)
						{
							(_oldPropertyLocks[i] as MFurnaceCacheSelectBtn).selected = true;
							_lockNum ++;							
						}
						else
							(_oldPropertyLocks[i] as MFurnaceCacheSelectBtn).selected = false;
						(_oldPropertyLocks[i] as MFurnaceCacheSelectBtn).visible = true;
						oldFight += PropertyType.getAttributeFight(m.propertyId, m.propertyValue);
						i++;
					}
					else
					{
						(_PropertyList[j] as MAssetLabel).setValue(name + " "  + m.propertyValue.toString());
						(_PropertyList[j] as MAssetLabel).visible = true;
						(_PropertyList[j] as MAssetLabel).textColor = color;
						(_PropertyLocks[j] as Bitmap).visible = m.lockState == ItemFreeProperty.LOCK_REBUILD;
						newFight += PropertyType.getAttributeFight(m.propertyId, m.propertyValue);
						j++;
					}					
				}
				if(j > 0)
				{
					_rebuildBtn.move(64,269);
					_rebuildBtn2.visible = true;
//				if(oldFight > 0)
					_oldFightTextField.setValue(Math.round(oldFight).toString());
//				else
//					_oldFightTextField.setValue("");
//				if(newFight > 0)
					_newFightTextField.setValue(Math.round(newFight).toString());
//				else
//					_newFightTextField.setValue("");
					setNumbers(newFight-oldFight);
					_strengInfo.visible = true;
				}else{
					_rebuildBtn.move(115,269);
					_rebuildBtn2.visible = false;
					_strengInfo.visible = false;
				}
					
			}
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
			while(_fightNumber && _fightNumber.numChildren>0){
				_fightNumber.removeChildAt(0);
			}
			var mark:Bitmap = new Bitmap();
			mark.bitmapData = n>-1?new iconAddAsset():new iconLowerAsset();
			_fightNumber.addChild(mark);
			
			var f:String = Math.abs(n).toString();
			for(var i:int=0; i<f.length; i++)
			{
				var mc:Bitmap = new Bitmap(_numAssets[int(f.charAt(i))]);
				mc.x = 15+i*15; 
				_fightNumber.addChild(mc);
			}
		}

		private function hideRebuildResult():void
		{
//			_label.visible = false;
			_rebuildResultField.visible = false;
		}
		
		private function rebuildHandler(evt:FuranceEvent):void
		{
			if(_rebuildEffect)
			{
				_rebuildEffect.dispose();
				_rebuildEffect = null; 
			}
			if(!_rebuildEffect)
			{
				_rebuildEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.STRENGTHEN_EFFECT));//XILIAN_EFFECT
				_rebuildEffect.move(128,54);
				_rebuildEffect.addEventListener(Event.COMPLETE,rebuildCompleteHandler);
				_rebuildEffect.play(SourceClearType.TIME,300000);
				addChild(_rebuildEffect);
			}
		}
		private function rebuildCompleteHandler(evt:Event):void
		{
			_rebuildEffect.removeEventListener(Event.COMPLETE,rebuildCompleteHandler);
			_rebuildEffect.dispose();
			_rebuildEffect = null;
		}
		
		/**监听背包信息更新**/
		private function bagItemUpdateHandler(e:BagInfoUpdateEvent):void
		{
//			var tmpItemIdList:Vector.<Number> = e.data as Vector.<Number>;
			var tmpItemIdList:Array = e.data as Array;
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				furnaceInfo.updateBagToFurnace(tmpItemIdList[i],qualityItemListChecker,REBUILD_MATERIAL_CATEGORYID_LIST);
			}
			_bagLockNum = furnaceInfo.getFurnaceItemNumByTemplateId(REBUILD_LOCK_ID);
			updateLockNumLable();
		}
		
		/**检测列表过滤条件**/
		private function qualityItemListChecker(argItemInfo:ItemInfo):Boolean
		{
			if(argItemInfo && argItemInfo.template.canRebuild && 
				argItemInfo.template.quality != 0)
			{
				return true;
			}
			return false;
		}
		
		
		private function backBtnHandler(evt:MouseEvent):void
		{
			clearCells();
			hideRebuildResult();
		}
		
		private function clearCells(isIncludeEquip:Boolean = true):void
		{
			var _beginIndex:int = 0;
			if(!isIncludeEquip)
			{				
				_beginIndex = 1;
			}
			else
			{
				_showCell.itemInfo = null;
			}
			for(var i:int = _cells.length - 1;i >= _beginIndex;i--)
			{
				if(_cells[i].furnaceItemInfo)
				{
					_cells[i].furnaceItemInfo.removePlace(i);
					_cells[i].furnaceItemInfo.setBack();
					_cells[i].furnaceItemInfo = null;
				}
			}
			_rebuildBtn.enabled = false;
			_rebuildBtn.move(115,269);
			_rebuildBtn2.visible = false;
			for(var j:int = 0;j < Max_Property_Num;j++)
			{
				_oldPropertyLocks[j].visible = false;
				
				_oldPropertyList[j].visible = false;				
				_PropertyLocks[j].visible = false;
				_PropertyList[j].visible = false;
				_oldPropertyIndexList[j] = 0;
			}
//			_currentSuccessRate = 0;
//			_currentMoney = 0;
//			_successRateTextFiled.text = "";
			_useMoneyTextField.text = "0";
			_equipScoreLabel.text = "";
			_lockNumLable.text = "";
			_lockNum = 0;
			_lockCellDiv.visible = false;
			_oldFightTextField.setValue("");
			_newFightTextField.setValue("");
			_strengInfo.visible = false;
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
			tmpInfo.enchase1 = argInfo.bagItemInfo.enchase1;
			tmpInfo.enchase2 = argInfo.bagItemInfo.enchase2;
			tmpInfo.enchase3 = argInfo.bagItemInfo.enchase3;
			tmpInfo.enchase4 = argInfo.bagItemInfo.enchase4;
			tmpInfo.enchase5 = argInfo.bagItemInfo.enchase5;
			tmpInfo.isExist = argInfo.bagItemInfo.isExist;
			tmpInfo.attack = argInfo.bagItemInfo.attack;
			tmpInfo.defence = argInfo.bagItemInfo.defence;
			tmpInfo.durable = argInfo.bagItemInfo.durable;
			tmpInfo.freePropertyVector =getfreePropertyVector(tmpInfo.templateId);
			tmpInfo.lastUseTime = argInfo.bagItemInfo.lastUseTime;
			tmpInfo.isInCooldown = argInfo.bagItemInfo.isInCooldown;
			_showCell.itemInfo = tmpInfo;
		}
		
		private function rebuildBtn2Handler(e:MouseEvent):void
		{
			var isPetEquip:Boolean;
			
			if(CategoryType.isPetEquip(FurnaceCell(_cells[0]).furnaceItemInfo.bagItemInfo.template.categoryId) && FurnaceCell(_cells[0]).furnaceItemInfo.bagItemInfo.place < 30 )
			{
				isPetEquip = true;
			}
			
			_mediator.sendReplace(_cells[0].furnaceItemInfo.bagItemInfo.place,isPetEquip);
			_rebuildBtn.move(115,269);
			_rebuildBtn2.visible = false;
		}
		//鉴定极品预览
		private function getfreePropertyVector(id:int):Array
		{
			var freePropertyVct:Array = new Array();
			var len:int = ItemTemplateList.getTemplate(id).quality;
			var val:int = ItemTemplateList.getTemplate(id).freePropertyList[0].propertyValue;
			var valid:int = ItemTemplateList.getTemplate(id).freePropertyList[0].propertyId;
			for(var i:int = 0;i<len+2;i++)
			{
				if(ItemTemplateList.getTemplate(id).freePropertyList[i])
				{
					var tmpInfo:ItemFreeProperty = new ItemFreeProperty();
					tmpInfo.index = Number(i);
					tmpInfo.propertyId = valid;
					tmpInfo.propertyValue = val;
					tmpInfo.lockState = Number(0);
					freePropertyVct.push(tmpInfo);
				}
			}
			return freePropertyVct;
		}
		
		private function rebuildBtnHandler(e:MouseEvent):void
		{
			var isPetEquip:Boolean;
			
			if(CategoryType.isPetEquip(FurnaceCell(_cells[0]).furnaceItemInfo.bagItemInfo.template.categoryId) && FurnaceCell(_cells[0]).furnaceItemInfo.bagItemInfo.place < 30 )
			{
				isPetEquip = true;
			}
			
			var tmpLucyBagPlace:int = 0;
//			if(_cells[2].furnaceItemInfo)tmpLucyBagPlace = _cells[2].furnaceItemInfo.bagItemInfo.place;
			if(_currentMoney > GlobalData.selfPlayer.userMoney.allCopper)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
				return;
			}
			if(_lockNum > _bagLockNum)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.rebuildLockNotEnough"));
				return;
			}
			
			var lockList:Array = new Array();
			for(var i:int = 0; i < Max_Property_Num; i++)
			{
				if(_oldPropertyLocks[i].visible && _oldPropertyLocks[i].selected)				
					lockList.push(_oldPropertyIndexList[i]);
			}
			
			for(var n:int = 0; n < _PropertyList.length; n++)
			{
				if(_PropertyList[n].visible && _PropertyList[n].textColor >= 0xcc00ff && !_PropertyLocks[n].visible)
				{
					MAlert.show(LanguageManager.getWord("ssztl.furnace.rebuildHighValue"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
					return;
				}
			}
//			for each(var j:FurnaceCell in _cells)
//			{
//				if(!_cells[0].furnaceItemInfo.bagItemInfo.isBind && j.furnaceItemInfo && j.furnaceItemInfo.bagItemInfo.isBind)
//				{
//					MAlert.show(LanguageManager.getWord("ssztl.furnace.rebuildWillBeBind"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
//					return;
//				}
//			}
			
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					_mediator.sendRebuild(_cells[0].furnaceItemInfo.bagItemInfo.place,_cells[1].furnaceItemInfo.bagItemInfo.place,lockList,tmpLucyBagPlace,isPetEquip);
					_rebuildBtn.enabled = false;
				}
			}
			_mediator.sendRebuild(_cells[0].furnaceItemInfo.bagItemInfo.place,_cells[1].furnaceItemInfo.bagItemInfo.place,lockList,tmpLucyBagPlace,isPetEquip);
			_rebuildBtn.enabled = false;
		}
				
		override protected function getCellPos():Array
		{
			return [new Point(108,34),new Point(185,34)];
		}
		
		override protected function getBackgroundName():Array
		{
//			return [LanguageManager.getWord("ssztl.furnace.equip"),LanguageManager.getWord("ssztl.furnace.rebuild"),
//				LanguageManager.getWord("ssztl.furnace.rebuildLock")];
			return [LanguageManager.getWord("ssztl.furnace.equip"),LanguageManager.getWord("ssztl.common.material")];
		}
		
		override protected function getAcceptCheckers():Array
		{
			return [equipChecker,rebuildStoneChecker,luckyBagChecker];
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
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.onlyInputRebuildEquip"));
					break;
				case FurnaceTipsType.NOEQUIP:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputRebuildEquipFirst"));
					break;
				case FurnaceTipsType.STONE:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.checkRebuildStone"));
					break;
				case FurnaceTipsType.NOSTONE:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputRebuildStoneFirst"));
					break;
				case FurnaceTipsType.PROTECTBAG:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.inputProtectSymbol"));
					break;
				case FurnaceTipsType.LUCKYBAG:
					QuickTips.show(LanguageManager.getWord("ssztl.furnace.placeUnOpen"));
					break;
			}
		}
		
		private function equipChecker(info:ItemInfo):int
		{
			if(!CategoryType.isEquip(info.template.categoryId))return FurnaceTipsType.EQUIP;
			return FurnaceTipsType.SUCCESS;
		}
		
		private function rebuildStoneChecker(info:ItemInfo):int
		{
			var tmpEquip:ItemInfo = _cells[0].itemInfo;
			if(!tmpEquip){return FurnaceTipsType.NOEQUIP}
			else
			{
				if(info.template.categoryId == CategoryType.REBUILD)
				{
					if(info.template.property3 == tmpEquip.template.quality)
					{
						return FurnaceTipsType.SUCCESS;
					}
					else 
					{
						return FurnaceTipsType.STONE;
					}
				}
				else
				{
					return FurnaceTipsType.STONE;
				}
			}
			return FurnaceTipsType.SUCCESS;
		}
		
		private function luckyBagChecker(info:ItemInfo):int
		{
			if(!_cells[1].itemInfo)
			{
				return FurnaceTipsType.NOSTONE;
			}
			else
			{
				if(info.template.categoryId != CategoryType.REBUILDLUCKYSYMBOL)
//				if(info.template.categoryId != -1)
				{
					return FurnaceTipsType.LUCKYBAG;
				}
			}
			return FurnaceTipsType.SUCCESS;
		}
		
//		private function setEquipScore(argScore:int):void
//		{
//			if(argScore != 0)
//			{
//				_equipScoreLabel.text = LanguageManager.getWord("ssztl.rank.equipScore") + "：" + argScore.toString();
//			}
//		}
		
		override protected function putAgainHandler(e:FuranceEvent):void
		{
			super.putAgainHandler(e);
			
		}
		override protected function updateFurnaceHandler(evt:FuranceEvent):void
		{
			var _place:int =evt.data["place"] as int;
			var tmpEquipItemId:Number;
			if(_place == 0 && _cells[_place].furnaceItemInfo)tmpEquipItemId = _cells[_place].furnaceItemInfo.bagItemInfo.itemId;
			var _furnaceItemInfo:FurnaceItemInfo = evt.data["info"] as FurnaceItemInfo;
			_cells[_place].furnaceItemInfo = _furnaceItemInfo; 
			
			var isAutoFill:Boolean = false;
			//更新格子视图后续处理
			switch(_place)
			{
				case 0:
					if(!_furnaceItemInfo)
					{
						backBtnHandler(null);
					}
					else
					{
						isAutoFill = true;
						if(_furnaceItemInfo.bagItemInfo.freePropertyVector.length>0)
						{
//							showRebuildResult(itemFreePropertyToString(_furnaceItemInfo.bagItemInfo));
							showItemFreeProperty(_furnaceItemInfo.bagItemInfo);
							updateLockNumLable();
						}
//						setEquipScore(_furnaceItemInfo.bagItemInfo.score);
						updateShowCell(_furnaceItemInfo);
					}
//					hideRebuildResult();
					break
				case 1:
					if(_furnaceItemInfo)
					{
						updateData(_cells[0].furnaceItemInfo.bagItemInfo,_furnaceItemInfo.bagItemInfo);
//						showRebuildResult("");
					}
					else
					{
						clearCells(false);
					}
					break;
			}
			if(isAutoFill)
			{
//				autoFillCells(CategoryType.REBUILD,true);
				autoFillCells(CategoryType.REBUILD,_cells[0].furnaceItemInfo.bagItemInfo.isBind,_cells[0].furnaceItemInfo.bagItemInfo.template.quality);
			}
		}
		
		private function updateData(argEquipItemInfo:ItemInfo,argItemInfo:ItemInfo):void
		{
			/**成功率计算公式**/
//			updateSuccessRate(argEquipItemInfo);
			
//			if(_lockNum <= _bagLockNum)
//			{
				_rebuildBtn.enabled = true;
				/**金钱消耗系数表**/
				_currentMoney = DecomposeCopperTemplateList.getDecomposeCopper(argEquipItemInfo.template.quality).needCopper;
				_useMoneyTextField.text =_currentMoney.toString();
//			}
//			else
//			{
//				_rebuildBtn.enabled = false;
//				_currentMoney = 0;
//				_useMoneyTextField.text = "0";
//			}
		}
		
		/**更新成功率**/
//		private function updateSuccessRate(argEquipItemInfo:ItemInfo):void
//		{
//			var count:int = 0;
////			if(_cells[2].furnaceItemInfo)count++;
//			/**几率  幸运符数量**/
////			_currentSuccessRate = RebuildTemplateList.getRebuildInfo(argEquipItemInfo.template.categoryId,argEquipItemInfo.template.quality).successRates + count * 3;
//			_currentSuccessRate = 100;
//			if(_currentSuccessRate > 100)_currentSuccessRate = 100;
////			_successRateTextFiled.text = _currentSuccessRate.toString() + "%";
//		}
		
		override protected function materialAddHandler(e:FuranceEvent):void
		{
			if(_cells[0].furnaceItemInfo)autoFillCells(CategoryType.REBUILD,_cells[0].furnaceItemInfo.bagItemInfo.isBind,_cells[0].furnaceItemInfo.bagItemInfo.template.quality);
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
			if(_barBg && _barBg.bitmapData)
			{
				_barBg.bitmapData.dispose();
				_barBg = null;
			}
			if(_bgProperty && _bgProperty.bitmapData)
			{
				_bgProperty.bitmapData.dispose();
				_bgProperty = null;
			}
			if(_fightLabel && _fightLabel.bitmapData)
			{
				_fightLabel.bitmapData.dispose();
				_fightLabel = null;
			}
			if(_rebuildBtn)
			{
				_rebuildBtn.dispose();
				_rebuildBtn = null;
			}
			if(_rebuildResultField && _rebuildResultField.parent)
			{
				_rebuildResultField.parent.removeChild(_rebuildResultField);
			}
			if(_previewText && _previewText.bitmapData)
			{
				_previewText.bitmapData.dispose();
				_previewText = null;
			}
			
			if(_oldPropertyLocks)
			{
				for( var j:int=0;j<_oldPropertyLocks.length;j++)
				{
					_oldPropertyLocks[j].dispose();
					_PropertyLocks[j].bitmapData.dispose();
				}
			}
			_strengInfo = null;
			_lockCellDiv = null;
			_oldPropertyLocks = null;
			_PropertyLocks = null;
			_oldPropertyList = null;
			_PropertyList = null;
			_oldPropertyIndexList = null;
			
			_rebuildResultField = null;
			_useMoneyTextField = null;
			_oldFightTextField = null;
			_newFightTextField = null;
//			_successRateTextFiled = null;
		}
	}
}