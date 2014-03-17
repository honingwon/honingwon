package sszt.furnace.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.bag.ClientBagInfoUpdateEvent;
	import sszt.core.data.furnace.parametersList.StoneComposeTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.furnace.components.cell.FurnaceBaseCell;
	import sszt.furnace.components.cell.FurnaceCell;
	import sszt.furnace.data.FurnaceBuyType;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.data.lastConfig.ConfigItemInfo;
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
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.MCacheAssetBtn2;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.furnace.BorderCellBgAsset;
	import ssztui.furnace.DownArrowBgAsset;
	import ssztui.ui.CellBgAsset;

	public class ComposeTabPanel extends BaseFurnaceTabPanel
	{
		private var _bg:IMovieWrapper;
		private var _mixBtn:MCacheAssetBtn1;
//		private var _lastConfigBtn:MCacheAssetBtn1;
//		private var _successRateTextField:TextField;
		private var _useMoneyTextField:MAssetLabel;
//		private var _currentSuccessRate:int;
		private var _currentMoney:int;
		private var _resultCell:FurnaceBaseCell;		
		private var _composeEffect:BaseLoadEffect;
		private var _successEffect:MovieClip;
		private var _targetName:MAssetLabel;
		private var _stuffName:MAssetLabel;
		
		private var _inputLabel:TextField;
		private var _upBtn:MCacheAssetBtn2;
		private var _downBtn:MCacheAssetBtn2;
		private var _maxBtn:MCacheAssetBtn2;
		private var _composeNum:int;
		private var _maxComposeNum:int;
		
//		public static const COMPOSE_STONE_CATEGORYID_LIST:Vector.<int> = CategoryType.ENCHASESTONE_TYPE;
		public static const COMPOSE_STONE_CATEGORYID_LIST:Array = CategoryType.COMPOSE_STONE_TYPE;
		/**宝石合成材料**/
//		public static const COMPOSE_MATERIAL_CATEGORYID_LIST:Vector.<int> = Vector.<int>([CategoryType.STONECOMPOSESYMBOL]);
		public static const COMPOSE_MATERIAL_CATEGORYID_LIST:Array = [CategoryType.STONECOMPOSESYMBOL];
		
		public function ComposeTabPanel(mediator:FurnaceMediator)
		{
			super(mediator);
		}
		
		override protected function init():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(139,230,80,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(152,117,28,39),new Bitmap(new DownArrowBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(142,57,50,50),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(142,157,50,50),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(148,163,38,38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(79,233,120,14),new MAssetLabel(LanguageManager.getWord("ssztl.furnace.compositeNum"),MAssetLabel.LABEL_TYPE20,"left")),
			]);
			addChild(_bg as DisplayObject);
			super.init();
			
		
			_resultCell = new FurnaceBaseCell();
			_resultCell.move(148,163);
			addChild(_resultCell);
			
			/**---------------处理显示的textField---------------**/
			_useMoneyTextField = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_useMoneyTextField.move(65,320);
			addChild(_useMoneyTextField);
			
			_targetName = new MAssetLabel("",MAssetLabel.LABEL_TYPE_B14);
			_targetName.move(166,207);
			addChild(_targetName);
			_targetName.setHtmlValue("");
			
			_stuffName = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			_stuffName.move(166,106);
			addChild(_stuffName);
			_stuffName.setHtmlValue("");
			
			//选择数量
			_inputLabel = new TextField();
			_inputLabel.type = TextFieldType.INPUT; 
			_inputLabel.textColor = 0xffd700;
			_inputLabel.defaultTextFormat = new TextFormat("Tahoma",12,0xFFfccc,null,null,null,null,null,TextFormatAlign.CENTER);
			_inputLabel.height = 16;
			_inputLabel.width = 40;	
			_inputLabel.maxChars = 3;
			_inputLabel.x = 160;
			_inputLabel.y = 232;
			_inputLabel.text = "0";
			addChild(_inputLabel);
			
			_downBtn = new MCacheAssetBtn2(1);
			addChild(_downBtn);
			_downBtn.move(141,232);
			_upBtn = new MCacheAssetBtn2(0);
			addChild(_upBtn);
			_upBtn.move(199,232);
			_maxBtn = new MCacheAssetBtn2(13);
			addChild(_maxBtn);
			_maxBtn.move(220,232);
			
			_mixBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.furnace.compose"));
			_mixBtn.enabled = false;
			_mixBtn.move(115,269);
			addChild(_mixBtn);
			
		}
		
		override public function show():void
		{
			super.show();
			/**加载数据到快速购买**/
			furnaceInfo.currentBuyType = FurnaceBuyType.COMPOSE;
			/**加载数据到另外两个面板**/
			furnaceInfo.initialFurnaceVector(qualityItemListChecker,COMPOSE_MATERIAL_CATEGORYID_LIST);
			/**监听背包变化**/
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_mixBtn.addEventListener(MouseEvent.CLICK,mixBtnHandler);
			_downBtn.addEventListener(MouseEvent.CLICK,downBtnHandler);
			_upBtn.addEventListener(MouseEvent.CLICK,upBtnHandler);
			_maxBtn.addEventListener(MouseEvent.CLICK,maxBtnHandler);
			_inputLabel.addEventListener(KeyboardEvent.KEY_UP, inputLabelHandler);
//			_lastConfigBtn.addEventListener(MouseEvent.CLICK,lastConfigBtnHandler);
			furnaceModule.furnaceInfo.addEventListener(FuranceEvent.COMPOSE_SUCCESS,composeHandler);
		}
		
		override public function hide():void
		{
			super.hide();
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_mixBtn.removeEventListener(MouseEvent.CLICK,mixBtnHandler);
			_downBtn.removeEventListener(MouseEvent.CLICK,downBtnHandler);
			_upBtn.removeEventListener(MouseEvent.CLICK,upBtnHandler);
			_maxBtn.removeEventListener(MouseEvent.CLICK,maxBtnHandler);
			_inputLabel.removeEventListener(KeyboardEvent.KEY_UP, inputLabelHandler);
//			_lastConfigBtn.removeEventListener(MouseEvent.CLICK,lastConfigBtnHandler);
			furnaceModule.furnaceInfo.addEventListener(FuranceEvent.COMPOSE_SUCCESS,composeHandler);
//			clearCells();
		}
		
		override public function addAssets():void
		{
//			_equipBg.bitmapData = AssetUtil.getAsset("ssztui.furnace.ComposeBgAsset" ,BitmapData) as BitmapData;
		}
		private function inputLabelHandler(e:KeyboardEvent):void
		{
			var temp:int = int(_inputLabel.text);
			if(temp > 0 && temp < _maxComposeNum)
			{
				_composeNum = temp;
				updateData();
			}				
			else
				_inputLabel.text = _composeNum.toString();
		}		
		
		private function downBtnHandler(e:MouseEvent):void
		{
			if(_composeNum > 0)
			{
				_composeNum--;
				_inputLabel.text = _composeNum.toString();
				updateData();
			}
		}
		private function upBtnHandler(e:MouseEvent):void
		{
			if(_composeNum < _maxComposeNum)
			{
				_composeNum++;
				_inputLabel.text = _composeNum.toString();
				updateData();
			}
		}
		
		private function maxBtnHandler(e:MouseEvent):void
		{
			_composeNum = _maxComposeNum;
			_inputLabel.text = _composeNum.toString();			
			updateData();
		}
		private function mixBtnHandler(e:MouseEvent):void
		{
			if(GlobalData.bagInfo.currentSize >= GlobalData.selfPlayer.bagMaxCount)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagFull"));
				return;
			}
			
			if(_currentMoney > GlobalData.selfPlayer.userMoney.allCopper)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.ComposeMoneyNotEnoughFail"));
				return;
			}
			if(_maxComposeNum <= 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.ComposeStoneNotEnoughFail"));
				return;
			}
			//不为空格子
			var unNullCount:int;
			var isBindCount:int;
			for each(var j:FurnaceCell in _cells)
			{
				if(j.furnaceItemInfo)
				{
					unNullCount++;
					if(j.furnaceItemInfo.bagItemInfo.isBind)
					{
						isBindCount ++;
					}
				}
			}
			//全部为绑定或者全部不绑定时不提示
			if(isBindCount == unNullCount || isBindCount == 0)
			{				
				_mediator.sendCompose(_cells[0].furnaceItemInfo.bagItemInfo.templateId, _composeNum, _mediator.furnaceModule.furnacePanel.getUseBindItem());
				_mixBtn.enabled = false;			
			}
			else
			{
//				if((isBindCount = isBindCount - 1))
//				{
//					_mediator.sendCompose(tmpProtectBagPlace,tmpStonePlaceVector);
//					_mixBtn.enabled = false;	
//				}
//				else
//				{
					MAlert.show(LanguageManager.getWord("ssztl.furnace.existBindItem"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
//				}
			}
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					_mediator.sendCompose(_cells[0].furnaceItemInfo.bagItemInfo.templateId, _composeNum, _mediator.furnaceModule.furnacePanel.getUseBindItem());
//					_mediator.sendCompose(tmpProtectBagPlace,tmpStonePlaceVector);
					_mixBtn.enabled = false;	
				}
			}
			
		}
		
		private function lastConfigBtnHandler(e:MouseEvent):void
		{
			clearCells();
			var tmpList:Array = furnaceInfo.furnaceLastConfigInfo.configItemList;
			var tmpFurnaceItemInfo:FurnaceItemInfo;
			for(var i:int = 0;i < tmpList.length;i++)
			{
				tmpFurnaceItemInfo = furnaceInfo.getFurnaceItemInfoByTemplateId(tmpList[i].templateId,furnaceInfo.furnaceLastConfigInfo.isBind);
				if(tmpFurnaceItemInfo == null)continue;
				otherClick(tmpFurnaceItemInfo);	
			}
		}
		
		private function composeHandler(evt:FuranceEvent):void
		{
			if(!_successEffect)
			{
				_successEffect =  AssetUtil.getAsset("ssztui.furnace.EffectFurnaceComposeAsset",MovieClip) as MovieClip;
				_successEffect.x = 166;
				_successEffect.y = 135;
				addChild(_successEffect);
				_successEffect.addEventListener(Event.ENTER_FRAME,efFrameHandler);
			}else{
				_successEffect.gotoAndPlay(1);
			}
			/* 2013.5.15 old Effect
			if(!_composeEffect)
			{
				_composeEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.STRENGTHEN_EFFECT)); //COMPOSITE_EFFECT
				_composeEffect.move(155,165);
				_composeEffect.addEventListener(Event.COMPLETE,composeCompleteHandler);
				_composeEffect.play(SourceClearType.TIME,300000);
				addChild(_composeEffect);
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
		private function composeCompleteHandler(evt:Event):void
		{
			_composeEffect.removeEventListener(Event.COMPLETE,composeCompleteHandler);
			_composeEffect.dispose();
			_composeEffect = null;
		}
		
		
		/**监听背包信息更新**/
		private function bagItemUpdateHandler(e:BagInfoUpdateEvent):void
		{
//			var tmpItemIdList:Vector.<Number> = e.data as Vector.<Number>;
			var tmpItemIdList:Array = e.data as Array;
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				furnaceInfo.updateBagToFurnace(tmpItemIdList[i],qualityItemListChecker,COMPOSE_MATERIAL_CATEGORYID_LIST);
			}
			if(_cells[0] && _cells[0].furnaceItemInfo)
			{
				var itemNum:int = furnaceInfo.getFurnaceStoneNumByTemplateId(_cells[0].furnaceItemInfo.bagItemInfo.templateId);
				_maxComposeNum = itemNum / 4;
				if (itemNum >= 4)
					_stuffName.setHtmlValue("<font color='#ffcc00'>"+ itemNum +"/4</font>");
				else
					_stuffName.setHtmlValue("<font color='#ff0000'>"+ itemNum +"/4</font>");
			}
		}
		
		/**检测列表过滤条件**/
		private function qualityItemListChecker(argItemInfo:ItemInfo):Boolean
		{
			if(argItemInfo && argItemInfo.template.property3 <= 10 &&
				(COMPOSE_STONE_CATEGORYID_LIST.indexOf(argItemInfo.template.categoryId)+1) &&
				argItemInfo.template.quality != 0)
			{
				if(argItemInfo.template.categoryId == 329 && argItemInfo.template.property3 >6)
				{
					return false;
				}
				return true;
			}
			return false;
		}
		
		override protected function otherCellClickHandler(e:FuranceEvent):void
		{
			var tmpFurnaceItemInfo:FurnaceItemInfo = e.data as FurnaceItemInfo;
			otherClick(tmpFurnaceItemInfo);
		}
		
		private function otherClick(argFurnaceItemInfo:FurnaceItemInfo):void
		{
			if(argFurnaceItemInfo.bagItemInfo.template.property3 > 9)
				return; 
			/**判断宝石**/
			var num:int = 1;
			if(getStoneCount() == num)
			{
				clearCells();
			}
			else if (getStoneCount() > 0 && _cells[0].furnaceItemInfo.bagItemInfo.templateId != argFurnaceItemInfo.bagItemInfo.templateId)
			{
				clearCells();
			}
			
			if (argFurnaceItemInfo.count < num)
				num = argFurnaceItemInfo.count;
			for(var i:int = getFirstNullCellInfoPlace(); i < num; i++)
			{
//				furnaceInfo.setToPlace(argFurnaceItemInfo,i);
				updateFurnaceHandler(new FuranceEvent(FuranceEvent.FURANCE_CELL_UPDATE,{info:argFurnaceItemInfo,place:i}));
			}
			
		}
		
		

		override protected function getCellPos():Array
		{
			return [new Point(148,62)];
		}
		
		
		override protected function getBackgroundName():Array
		{
			return [
				LanguageManager.getWord("ssztl.common.stone")];
		}
		
		private function protectBagChecker(info:ItemInfo):Boolean
		{
			if(info.template.categoryId == CategoryType.STONECOMPOSESYMBOL && getStoneCount() >= 2) 
			{
				return true;
			}
			return false;
		}
		
		/**取当前宝石数量**/
		private function getStoneCount():int
		{
			var count:int = 0;
			if(_cells[0].furnaceItemInfo)count++;
			return count;
		}
		
		/**取第一个不为空的格子位置**/
		private function getFirstUnnullCellInfoPlace():int
		{
			for(var i:int = 1;i < _cells.length;i++)
			{
				if(_cells[i].furnaceItemInfo)
				{
					return i;
				}
			}
			return -1;
		}
		private function getFirstNullCellInfoPlace():int
		{
			for(var i:int = 0;i < _cells.length;i++)
			{
				if(!_cells[i].furnaceItemInfo)
				{
					return i;
				}
			}
			return 0;			
		}
		
		override protected function middleCellClearHandler(e:FuranceEvent):void
		{
			clearCells();
		}
		
		private function clearCells():void
		{
			for(var i:int = _cells.length - 1;i >= 0;i--)
			{
				if(_cells[i].furnaceItemInfo)
				{
//					_cells[i].furnaceItemInfo.removePlace(i);
//					_cells[i].furnaceItemInfo.setBack();
					_cells[i].furnaceItemInfo = null;
				}
			}
			_stuffName.setValue("");
			//清空txt、等资源
			_resultCell.info = null;
			_mixBtn.enabled = false;
//			_currentSuccessRate = 0;
			_currentMoney = 0;
//			_successRateTextField.text = "";
			_useMoneyTextField.text = "0";
			_composeNum = 0;
			_maxComposeNum = 0;
			_inputLabel.text = "0";
		}
		
		override protected function updateFurnaceHandler(evt:FuranceEvent):void
		{
			var _place:int =evt.data["place"] as int;
			var _furnaceItemInfo:FurnaceItemInfo = evt.data["info"] as FurnaceItemInfo;			
			var tempInfo:FurnaceItemInfo = _cells[_place].furnaceItemInfo;
			_cells[_place].furnaceItemInfo = _furnaceItemInfo;
			if(_furnaceItemInfo)
			{
				var itemNum:int = furnaceInfo.getFurnaceStoneNumByTemplateId(_furnaceItemInfo.bagItemInfo.templateId);
				_maxComposeNum = itemNum / 4;
				if (itemNum >= 4)
					_stuffName.setHtmlValue("<font color='#ffcc00'>"+ itemNum +"/4</font>");
				else
					_stuffName.setHtmlValue("<font color='#ff0000'>"+ itemNum +"/4</font>");
				maxBtnHandler(null);
				_resultCell.info = ItemTemplateList.getTemplate(_furnaceItemInfo.bagItemInfo.templateId+1);
			}
			else
			{
				tempInfo.setTo();//抵消背包物品数量减少
				clearCells();
			}
			

		}
		
		private function updateData():void
		{
			/**成功率计算公式**/
//			updateSuccessRate();
			_mixBtn.enabled = true;
			/**所消耗金钱值为：系数**/
			_currentMoney = StoneComposeTemplateList.getStoneComposeInfo(_cells[0].furnaceItemInfo.bagItemInfo.template.property3).copper * _composeNum;
//			_currentMoney = 1000;
			_useMoneyTextField.text =_currentMoney.toString();
		}
		
		/**更新成功率**/
//		private function updateSuccessRate():void
//		{
//			_currentSuccessRate = (getStoneCount() - 1) * 25;
//			if(_cells[0].furnaceItemInfo) _currentSuccessRate += 25;
//			_successRateTextField.text = _currentSuccessRate.toString() + "%";
//		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_mixBtn)
			{
				_mixBtn.dispose();
				_mixBtn = null;
			}
//			if(_lastConfigBtn)
//			{
//				_lastConfigBtn.dispose();
//				_lastConfigBtn = null;
//			}
			if(_resultCell)
			{
				_resultCell.dispose();
				_resultCell = null;
			}
			if(_upBtn)
			{
				_upBtn.dispose();
				_upBtn = null;
			}
			if(_downBtn)
			{
				_downBtn.dispose();
				_downBtn = null;
			}
			if(_maxBtn)
			{
				_maxBtn.dispose();
				_maxBtn = null;
			}
			_inputLabel = null;
//			_successRateTextField = null;
			_targetName = null;
			_stuffName = null;
			_useMoneyTextField = null;
		}
	}
}