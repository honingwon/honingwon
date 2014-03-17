package sszt.bag.component
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import sszt.bag.component.btn.BagDropBtnCell;
	import sszt.bag.component.btn.BagSplitBtnCell;
	import sszt.bag.event.BagCellEvent;
	import sszt.bag.mediator.BagMediator;
	import sszt.constData.CategoryType;
	import sszt.constData.CommonBagType;
	import sszt.constData.CommonConfig;
	import sszt.constData.ShopID;
	import sszt.constData.VipType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.KeyType;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.bag.BagType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToBagData;
	import sszt.core.data.module.changeInfos.ToConsignData;
	import sszt.core.data.module.changeInfos.ToNpcStoreData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.module.changeInfos.ToVipData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.doubleClicks.DoubleClickManager;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.bag.BagExtendSocketHandler;
	import sszt.core.socketHandlers.bag.ItemArrangeSocketHandler;
	import sszt.core.socketHandlers.bag.ItemMoveSocketHandler;
	import sszt.core.socketHandlers.bag.ItemRetrieveSocketHandler;
	import sszt.core.socketHandlers.common.ItemUseSocketHandler;
	import sszt.core.socketHandlers.vip.PlayerVipAwardSocketHandler;
	import sszt.core.socketHandlers.vip.PlayerVipDetailSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.JSUtils;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.timerEffect.TimerEffect;
	import sszt.core.view.tips.GuideTip;
	import sszt.core.view.tips.ItemUseTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CellEvent;
	import sszt.events.ChatModuleEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.events.ModuleEvent;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.selectBtns.MCacheSelectBtn;
	import sszt.ui.mcache.btns.selectBtns.MCacheSelectBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.labelField.MLabelField2Bg;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.bag.BagTitleAsset;
	import ssztui.ui.SplitCompartLine2;

	public class BagPanel extends MPanel implements ITick
	{	
		public static const PAGE_SIZE:uint = 36;
		
		private var _cellList:Array;               
		private var _tile:MTile;                              //排版工具
		private var _allItemBtn:MCacheTabBtn1;        //全部
		private var _equipmentBtn:MCacheTabBtn1;         //任务道具
		private var _drugsBtn:MCacheTabBtn1;            //药物
		private var _gemstoneBtn:MCacheTabBtn1;        //宝石
		private var _goodsBtn:MCacheTabBtn1;          //物品
		private var _btnArray:Array;                   

		private var _pages:Array;	
		private var _pagesBtns:Array;   //页数按钮
		
//		private var _vipBtn:MBitmapButton;                 //vip按钮
				
		private var _splitBtn:BagSplitBtnCell;            //拆分按钮
		private var _tidyBtn:MCacheAssetBtn1;              //整理按钮
		/**
		 * 出售 
		 */
		private var _dropBtn:BagDropBtnCell;
		private var _sellBtn:MCacheAssetBtn1; 				//挂售
		
		private var _count:int = 0;                      //整理操作间隔变量
		private var _seconds:int = 5;

		private var _yuanBaoView:MAssetLabel;               //元宝
		private var _bingYuanBaoView:MAssetLabel;           //绑定元宝
		private var _copperView:MAssetLabel;                //铜币
		private var _bindCopperView:MAssetLabel;           //绑定铜币	
		private var _currentType:int;                     //当前物品类型
		private var _currentPage:int;                    //当前背包页
		private var _mediator:BagMediator;
		private var _bg:IMovieWrapper;
		private var _bagCellEmpty:BagEmptyCell;
		private var _otherIndexUpdateInterval:Number = 0;
		
//		private var _cellTypes:Vector.<Vector.<int>>;
//		private var _currentCellType:Vector.<int>;
		private var _cellTypes:Array;
		private var _currentCellType:Array;
		
		private var _bagSizeValue:MAssetLabel;
		
		private var _tempPoint:Point;
		private var _tipsLabel:Array;
		private var _tipBtns:Array;
		private var _timeoutIndex:int = -1;
		
		private var _vipBg:Bitmap;
		
		private var _yuanBaoAsset:Bitmap;
		private var _bindYuanBaoAsset:Bitmap;
		private var _copperAsset:Bitmap;
		private var _bindCopperAsset:Bitmap;
		
		private var _vipWelfare:MCacheAssetBtn1;
		private var _farDrug:MCacheAssetBtn1;
		private var _farStore:MCacheAssetBtn1;
		private var _taoBaoStore:MCacheAssetBtn1;
		private var _returnCity:MCacheAssetBtn1;
	
		public function BagPanel(mediator:BagMediator,data:ToBagData)
		{
			_cellList = new Array();
			super(new MCacheTitle1("",new Bitmap(new BagTitleAsset())),true,-1,true,false,data.rect);
			if(!data.rect)
			{
				var x:int = CommonConfig.GAME_WIDTH / 2;
				var y:int = CommonConfig.GAME_HEIGHT / 2 - 445 / 2
				
				move(x, y);
			}
			_mediator = mediator;
			_currentType = BagType.ALLITEM;
			_currentPage = 0;
			
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.BAG));
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(279,415);
			
			_vipBg = new Bitmap();
			_vipBg.x = 275; //252;
			_vipBg.y = 13;
			addContent(_vipBg as DisplayObject);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,263,382)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(16,33,247,273)),
				
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(53,311,103,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(158,311,103,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(53,335,103,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(158,335,103,22)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,363,259,25),new Bitmap(new SplitCompartLine2())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,40,234,38),new Bitmap(CellCaches.getCellBgPanel61())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,79,234,38),new Bitmap(CellCaches.getCellBgPanel61())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,118,234,38),new Bitmap(CellCaches.getCellBgPanel61())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,157,234,38),new Bitmap(CellCaches.getCellBgPanel61())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,196,234,38),new Bitmap(CellCaches.getCellBgPanel61())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,235,234,38),new Bitmap(CellCaches.getCellBgPanel61()))
			]);
			addContent(_bg as DisplayObject);

			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(19,315,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.yuanBao")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(19,339,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.copper")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			
			_yuanBaoAsset = new Bitmap(MoneyIconCaches.yuanBaoAsset);
			_yuanBaoAsset.x = 55;
			_yuanBaoAsset.y = 313;
			addContent(_yuanBaoAsset);
			_bindYuanBaoAsset = new Bitmap(MoneyIconCaches.bingYuanBaoAsset);
			_bindYuanBaoAsset.x = 160;
			_bindYuanBaoAsset.y = 313;
			addContent(_bindYuanBaoAsset);
			_copperAsset = new Bitmap(MoneyIconCaches.copperAsset);
			_copperAsset.x = 55;
			_copperAsset.y = 337;
			addContent(_copperAsset);
			_bindCopperAsset = new Bitmap(MoneyIconCaches.bingCopperAsset);
			_bindCopperAsset.x = 160;
			_bindCopperAsset.y = 337;
			addContent(_bindCopperAsset);
			
			
			
			_tipsLabel = [
				LanguageManager.getWord("ssztl.bag.splitTip"),
				LanguageManager.getWord("ssztl.bag.tidyTip"),
				LanguageManager.getWord("ssztl.bag.sellTip"),
				LanguageManager.getWord("ssztl.bag.consignTip"),
				LanguageManager.getWord("ssztl.common.currencyTip1"),
				LanguageManager.getWord("ssztl.common.currencyTip2"),
				LanguageManager.getWord("ssztl.common.currencyTip3"),
				LanguageManager.getWord("ssztl.common.currencyTip4"),
			];
			
			//扩展背包容量。			
			_cellTypes = [CategoryType.ALL_TYPES,CategoryType.EQUIP_TYPES,CategoryType.DRUG_TYPES,CategoryType.STONE_TYPES,CategoryType.GOOD_TYPES];
			_currentCellType = _cellTypes[_currentType];
			
			/**分类按钮 全部,装备，药品，宝石,物品*/
			_allItemBtn = new MCacheTabBtn1(0,0,LanguageManager.getWord("ssztl.common.all"));
			_allItemBtn.move(15,0);
			addContent(_allItemBtn);
			_equipmentBtn = new MCacheTabBtn1(0,0,LanguageManager.getWord("ssztl.common.equip2"));
			_equipmentBtn.move(63,0);
			addContent(_equipmentBtn);
			_drugsBtn=new MCacheTabBtn1(0,0,LanguageManager.getWord("ssztl.common.drug"));
			_drugsBtn.move(111,0);
			addContent(_drugsBtn);
			_gemstoneBtn=new MCacheTabBtn1(0,0,LanguageManager.getWord("ssztl.common.stone"));
			_gemstoneBtn.move(159,0);
			addContent(_gemstoneBtn);
			_goodsBtn = new MCacheTabBtn1(0,0,LanguageManager.getWord("ssztl.common.item"));
			_goodsBtn.move(207,0);
			addContent(_goodsBtn);
			_btnArray = [_allItemBtn,_equipmentBtn,_drugsBtn,_gemstoneBtn,_goodsBtn];
			_btnArray[_currentType].selected = true;
			
//			_vipBtn = new MBitmapButton(new VipBtnAsset());
//			_vipBtn.move(199,4);
//			addContent(_vipBtn);
			
			/**分页按钮*/
			 _pages = ["1","2","3","4","5","6"]; 
			_pagesBtns=new Array();
			for(var i:int = 0;i < 6;i++)
			{
				var page:MCacheSelectBtn1 = new MCacheSelectBtn1(0,0,_pages[i]);
				_pagesBtns.push(page);
				_pagesBtns[i].move(100+i*26,277);
				addContent(page);	
			}
			_pagesBtns[_currentPage].selected = true;
			
			//拖动监听格子
			_bagCellEmpty = new BagEmptyCell();
			_bagCellEmpty.move(0,0);
			addContent(_bagCellEmpty);
			
			/**背包的格子*/
			_tile = new MTile(38,38,6);
			_tile.itemGapH = _tile.itemGapW = 1;
			_tile.setSize(233,233);
			_tile.move(23,40);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addContent(_tile);
					
			for(var j:int = 0;j < PAGE_SIZE;j++)
			{
				var cell:BagCell = new BagCell(clickHandler,doubleClickHandler);
				cell.addEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
				cell.addEventListener(MouseEvent.CLICK,cellClickHandler);
				cell.addEventListener(BagCellEvent.CELL_MOVE,cellMoveHandler);
				cell.addEventListener(BagCellEvent.ITEM_SPLIT,itemSplitHandler);
				cell.addEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
				cell.addEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
				_tile.appendItem(cell);
				_cellList.push(cell);
			}
			
			/**元宝与铜币的绑定与非绑定*/
			_yuanBaoView= new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_yuanBaoView.move(76,315);
			_yuanBaoView.setValue(GlobalData.selfPlayer.userMoney.yuanBao.toString());
			addContent(_yuanBaoView);
			_copperView = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_copperView.move(76,339);
			_copperView.setValue(GlobalData.selfPlayer.userMoney.copper.toString());
			addContent(_copperView);
			_bingYuanBaoView = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_bingYuanBaoView.move(181,315);
			addContent(_bingYuanBaoView);
			_bingYuanBaoView.setValue(GlobalData.selfPlayer.userMoney.bindYuanBao.toString());
			_bindCopperView = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_bindCopperView.move(181,339);
			_bindCopperView.setValue(GlobalData.selfPlayer.userMoney.bindCopper.toString());
			addContent(_bindCopperView);
						
			_splitBtn = new BagSplitBtnCell();
			_splitBtn.move(20,372);
			addContent(_splitBtn);
			_tidyBtn = new MCacheAssetBtn1(0,1,LanguageManager.getWord("ssztl.common.tidy"));
			addContent(_tidyBtn);
			if(GlobalData.selfPlayer.stallName != "")
				_tidyBtn.enabled = false;
			_tidyBtn.move(81,372);	
			_dropBtn = new BagDropBtnCell();
			_dropBtn.move(142,372);
			addContent(_dropBtn);
			_sellBtn = new MCacheAssetBtn1(0,1,LanguageManager.getWord("ssztl.common.consign"));
			_sellBtn.move(203,372);
			addContent(_sellBtn);
			
//			new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(53,311,103,22)),
//			new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(158,311,103,22)),
//			new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(53,335,103,22)),
//			new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(158,335,103,22)),
			
			_tipBtns = [_splitBtn,_tidyBtn,_dropBtn,_sellBtn];
			
			for(var a:int = 0; a<4; a++)
			{
				var currency:Sprite = new Sprite();
				currency.graphics.beginFill(0,0);
				currency.graphics.drawRect(a==0||a==2?53:158,a<2?311:335,103,22);
				currency.graphics.endFill();
				addContent(currency);
				_tipBtns.push(currency);
			}
			
//			_timeAffect = new TimerEffect(5000,new Rectangle(_tidyBtn.x,_tidyBtn.y,_tidyBtn.width,_tidyBtn.height));
//			addContent(_timeAffect);
						
			_bagSizeValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			addContent(_bagSizeValue);
			_bagSizeValue.move(24,282);
			
			_vipWelfare = new MCacheAssetBtn1(1,2,LanguageManager.getWord("ssztl.bag.vipWelfare"));
			addContent(_vipWelfare);
			_vipWelfare.move(284,38);
			
			_farDrug = new MCacheAssetBtn1(1,2,LanguageManager.getWord("ssztl.bag.farDrug"));
			addContent(_farDrug);
			_farDrug.move(284,62);
			
			_farStore = new MCacheAssetBtn1(1,2,LanguageManager.getWord("ssztl.bag.farStore"));
			addContent(_farStore);
			_farStore.move(284,86);
			
			_taoBaoStore = new MCacheAssetBtn1(1,2,LanguageManager.getWord("ssztl.common.taoBaoStore"));
			addContent(_taoBaoStore);
			_taoBaoStore.move(284,110);
			
			_returnCity = new MCacheAssetBtn1(1,2,LanguageManager.getWord("ssztl.bag.returnCity"));
			addContent(_returnCity);
			_returnCity.move(284,134);
			_returnCity.visible = false;
			
//			if(GlobalData.selfPlayer.isGet)
//			{
//				_vipWelfare.enabled = false;
//			}
			
			if(GlobalData.selfPlayer.getVipType() == VipType.NORMAL)
			{
				_vipWelfare.enabled = _farStore.enabled = false;
			}
			
			initCells();
			initEvent();
			
			setGuideTipHandler(null);
		}
		
		private function itemOverHandler(evt:MouseEvent):void
		{
			var _cur:BagCell = evt.currentTarget as BagCell;
			_cur.over = true;
		}
		private function itemOutHandler(evt:MouseEvent):void
		{
			var _cur:BagCell = evt.currentTarget as BagCell;
			_cur.over = false;
		}
		
		public function assetsCompleteHandler():void
		{
			_vipBg.bitmapData = AssetUtil.getAsset("ssztui.bag.VipBgAsset",BitmapData) as BitmapData;
			
		}
		
		private function changePage(evt:Event):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			setCurrentPageSelect(_pagesBtns.indexOf(evt.currentTarget));	
		}
		
		private function changeBagType(evt:MouseEvent):void
		{  
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			setCurrentBagTypeSelect(_btnArray.indexOf(evt.currentTarget));
		}
		
		private function setCurrentBagTypeSelect(bagIndex:int):void
		{
			if(bagIndex==_currentType) return;
			_pagesBtns[0].selected = _pagesBtns[1].selected = _pagesBtns[2].selected = _pagesBtns[3].selected = _pagesBtns[4].selected = _pagesBtns[5].selected = false;
			_pagesBtns[0].selected = true;
			_currentPage = 0;
			_currentType = bagIndex;
			_currentCellType = _cellTypes[_currentType];
			for(var j:int =0;j<PAGE_SIZE;j++)
			{
				_cellList[j].setIndex(_currentType);
			}
			for(var i:int = 0; i < _btnArray.length;i++){
				_btnArray[i].selected=false;
			}
			
			_btnArray[_currentType].selected=true;						
			updateCells();
		}
		
		private function setCurrentPageSelect(pageIndex:int):void
		{
			if(_currentPage == pageIndex) return;
			_pagesBtns[0].selected = _pagesBtns[1].selected = _pagesBtns[2].selected = _pagesBtns[3].selected = _pagesBtns[4].selected = _pagesBtns[5].selected = false;
			_pagesBtns[pageIndex].selected = true;
			_currentPage = pageIndex;
			updateCells();
		}
		
		private function bagInfoUpdateHandler(evt:BagInfoUpdateEvent):void
		{
			_bagSizeValue.setValue(LanguageManager.getWord("ssztl.bag.bagSize")+ GlobalData.bagInfo.currentSize+"/"+ GlobalData.selfPlayer.bagMaxCount);
			
			var data:Object = evt.data;
			if(_currentType == 0)
			{
				for(var i:int = 0;i<data.length;i++)
				{
					var item:ItemInfo = GlobalData.bagInfo.getItem(data[i]);
					var place:int = data[i] - 30;
					if((place < (_currentPage + 1) * PAGE_SIZE) && (place >= (_currentPage * PAGE_SIZE)))
					{
						var cell:BagCell = _cellList[place % PAGE_SIZE];
						cell.itemInfo = item;
					}
				}
			}else
			{
				if(_otherIndexUpdateInterval == 0)
					_otherIndexUpdateInterval = setInterval(delayUpdate,300);
			}
		}
		
		private function vipWelfareClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			SetModuleUtils.addVip(new ToVipData(0));
		}
		private function farDurgClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			SetModuleUtils.addNPCStore(new ToNpcStoreData(ShopID.NPC_SHOP,1));
		}
		private function farStoreClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			SetModuleUtils.addWareHouse();
		}
		private function taoBaoStoreHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			SetModuleUtils.addBox(2);
		}
		private function returnCityHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
		}
		
		/**
		 *延时刷新 
		 * 
		 */		
		private function delayUpdate():void
		{
			clearInterval(_otherIndexUpdateInterval);
			_otherIndexUpdateInterval = 0;
//			var list:Vector.<ItemInfo> = GlobalData.bagInfo.getListByType(_currentCellType,_currentPage);
			var list:Array = GlobalData.bagInfo.getListByType(_currentCellType,_currentPage);
			var len:int = _cellList.length;
			var listLen:int = list.length;
			for(var i:int = 0; i < len; i++)
			{
				if(i >= listLen)_cellList[i].itemInfo = null;
				else _cellList[i].itemInfo = list[i];
			}
		}
		
		public function get currentType():int
		{
			return _currentType;
		}
		
		/**
		 *根据页数背包大小设置格子开关 
		 * 
		 */		
		private function initCells():void
		{
			clearItems();
			_bagSizeValue.setValue(LanguageManager.getWord("ssztl.bag.bagSize")+ GlobalData.bagInfo.currentSize+"/"+ GlobalData.selfPlayer.bagMaxCount);
			
			for(var i:int = 0; i < _cellList.length; i++)
			{
				var place:int = i + _currentPage * PAGE_SIZE;
				if(place >= GlobalData.selfPlayer.bagMaxCount)
				{
					_cellList[i].hasOpen = false;
				}
				else
				{
					_cellList[i].hasOpen = true;
					_cellList[i].itemInfo = GlobalData.bagInfo.getItem(place+30);
				}
				_cellList[i].place = place + 30;
			}
		}
		
		/**
		 *切换背包类型时更新格子 
		 * 
		 */		
		private function updateCells():void
		{
			clearItems();
			var list:Array = GlobalData.bagInfo.getListByType(_currentCellType,_currentPage);
			for(var i:int = 0; i < _cellList.length; i++)
			{
				var place:int = i + _currentPage * PAGE_SIZE;
				if(place >= GlobalData.selfPlayer.bagMaxCount)
				{
					_cellList[i].hasOpen = false;
				}
				else
				{
					_cellList[i].hasOpen = true;
				}
				_cellList[i].place = place + 30;
			}
			if(_currentType == BagType.ALLITEM)
			{
				initCells();
			}else
			{
				for( var t:int=0;t<list.length;t++)
				{
					_cellList[t].itemInfo = list[t];
				}
			}
		}
		
		
		private function clearItems():void
		{
			for each(var i:BagCell in _cellList)
			{
				i.itemInfo = null;
			}
		}
		
		private function cellDownHandler(evt:MouseEvent):void
		{
			
			var cell:BagCell = evt.currentTarget as BagCell;
			if(cell.itemInfo && cell.itemInfo.canOperate())
			{
				cell.dragStart();
				GlobalData.bagInfo.currentDrag = cell.itemInfo;
			}
		}
		
		private function cellClickHandler(evt:MouseEvent):void
		{
			var cell:BagCell = evt.currentTarget as BagCell;
//			if(cell.itemInfo && cell.itemInfo.canOperate()||!cell.hasOpen)
//			{
				DoubleClickManager.addClick(cell);
				GlobalData.bagInfo.currentDrag = null;
				_tempPoint = new Point(evt.stageX,evt.stageY);
//			}
		}
		
		private function cellMoveHandler(evt:BagCellEvent):void
		{
			var data:Object = evt.data;
			ItemMoveSocketHandler.sendItemMove(data["fromType"],data["place"],data["toType"],data["toPlace"],data["count"]);
			if(data["toPlace"] == -1)
			{
				GlobalAPI.dragManager.startDrag(_dropBtn as IDragable,true);
			}
		}
		
		private function clickHandler(cell:BagCell):void
		{
			if( GlobalData.clientBagInfo.bagSellIsOpen)
			{
				if(GlobalData.clientBagInfo.npcStoreList.length >= 12)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.sellListFull"));
					return ;
				}
				if(cell.itemInfo && !cell.itemInfo.template.canSell)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.itemUnsellable"));
					return;
				}
			}
			if(( GlobalData.clientBagInfo.bagSellIsOpen) && cell.itemInfo && !cell.itemInfo.lock)
			{
				GlobalData.clientBagInfo.addToNPCStore(cell.itemInfo);
			}
			else if(cell.itemInfo && cell.itemInfo.lock == false)
			{
				if(GlobalAPI.keyboardApi.keyIsDown(KeyType.SHIFT))
				{
					ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_ITEM,cell.itemInfo));
				}
				else
				{
					ItemUseTip.getInstance().show(cell as IDragable,_tempPoint);
				}
			}
			else if(!cell.hasOpen)
			{ 
				var list:Array = GlobalData.bagInfo.getItemById(CategoryType.BAG_EXTEND_S);
				if(list.length == 0) list = GlobalData.bagInfo.getItemById(CategoryType.BAG_EXTEND_T);
				if(list.length == 0)
				{
					MAlert.show(LanguageManager.getWord("ssztl.bag.BagExtendAlert",48),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,bagExtendCloseHandler);
				}else
				{
					ItemUseSocketHandler.sendItemUse(list[0].place);
				}
//				BuyPanel.getInstance().show(CategoryType.BAG_QUICK_BUY_LIST,new ToStoreData(103));
			}
			
		}
		
		private function bagExtendCloseHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.YES)
			{
				if(GlobalData.selfPlayer.userMoney.yuanBao<48)
				{
					//MAlert.show(LanguageManager.getWord	("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,buyHandler);
					QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnough'));
					return;
				}

				BagExtendSocketHandler.sendExtend(1);
			}
		}
		
		private function buyHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				JSUtils.gotoFill();
			}
		}
		private function doubleClickHandler(cell:BagCell):void
		{
			if(cell.itemInfo && cell.itemInfo.canOperate())
			{
				ModuleEventDispatcher.dispatchCellEvent(new CellEvent(CellEvent.CELL_DOUBLECLICK,cell));
			}
		}
				
		private function stallHandler(evt:MouseEvent):void
		{
			SetModuleUtils.addStall(GlobalData.selfPlayer.userId);
			this.move(580,62);
		}
		
		private function tidyHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if((GlobalData.clientBagInfo.npcStoreIsOpen || GlobalData.clientBagInfo.bagSellIsOpen) && GlobalData.clientBagInfo.npcStoreList.length > 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.bag.cleanBeforeTidy"));	
			}
			else if(GlobalData.isInTrade)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.bag.cannelBeforeTidy"));	
			}else
			{
				ItemArrangeSocketHandler.sendArrange(CommonBagType.BAG);
				_tidyBtn.enabled = false;
				GlobalAPI.tickManager.addTick(this);
				_tidyBtn.labelField.text = LanguageManager.getWord("ssztl.common.tidyLeftSecond",_seconds);
			}
		}
		
		public function update(time:int,dt:Number = 0.04):void
		{
			_count++;
			if(_count >= 25)
			{
				_seconds --;
				if(_seconds == 0)
				{
					_seconds = 5;
					GlobalAPI.tickManager.removeTick(this);
					_tidyBtn.labelField.text = LanguageManager.getWord("ssztl.common.tidy");
					_tidyBtn.enabled = true;
				}else
				{
					_tidyBtn.labelField.text = LanguageManager.getWord("ssztl.common.tidyLeftSecond",_seconds);
				}				
				_count = 0;
			}
		}
		
		private function splitHandler(evt:MouseEvent):void
		{	
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			GlobalAPI.dragManager.startDrag(evt.target as IDragable,true);
		}
		
		private function dropHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
//			GlobalAPI.dragManager.startDrag(evt.target as IDragable,true);
			SetModuleUtils.addBagSell();
		}
		
		private function sellHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			SetModuleUtils.addConsign(new ToConsignData(2));
		}
		
	
		
		private  function itemSplitHandler(evt:BagCellEvent):void
		{
			_mediator.showSplitPanel((evt.currentTarget as BagCell).itemInfo);
		}

		private function bagExtendHandler(evt:BagInfoUpdateEvent):void
		{
			var type:int = evt.data as int;
			if(type == 0)
			{
				initCells();
				QuickTips.show(LanguageManager.getWord("ssztl.bag.bagExtendSuccess"));
			}
			else
			{
				initCells();
				QuickTips.show(LanguageManager.getWord("ssztl.common.wareHouseExtend"));
			}
		}
		
		private function lockBtnHandler(evt:MouseEvent):void
		{
			GlobalAPI.dragManager.startDrag(evt.target as IDragable);
		}
		
		private function moneyUpdataHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			_yuanBaoView.setValue(GlobalData.selfPlayer.userMoney.yuanBao.toString());
			_bingYuanBaoView.setValue(GlobalData.selfPlayer.userMoney.bindYuanBao.toString());
			_copperView.setValue(GlobalData.selfPlayer.userMoney.copper.toString());
			_bindCopperView.setValue(GlobalData.selfPlayer.userMoney.bindCopper.toString());
		}
		
		private function stallUpdateHandler(e:SelfPlayerInfoUpdateEvent):void
		{
			if(GlobalData.selfPlayer.stallName != "")
				_tidyBtn.enabled = false;
			else
				_tidyBtn.enabled = true;
		}
		
		private function initEvent():void
		{
			_allItemBtn.addEventListener(MouseEvent.CLICK,changeBagType);
			_equipmentBtn.addEventListener(MouseEvent.CLICK,changeBagType);
			_drugsBtn.addEventListener(MouseEvent.CLICK,changeBagType);
			_gemstoneBtn.addEventListener(MouseEvent.CLICK,changeBagType);
			_goodsBtn.addEventListener(MouseEvent.CLICK,changeBagType);
			
			
			for(var i:int=0;i<6;i++)
			{
				_pagesBtns[i].addEventListener(MouseEvent.CLICK,changePage);
				_pagesBtns[i].addEventListener(MouseEvent.MOUSE_OVER,pageBtnOverHandler);
			}
			
			for(i = 0;i<_tipBtns.length;i++)
			{
				_tipBtns[i].addEventListener(MouseEvent.MOUSE_OVER,tipBtnOverHandler);
				_tipBtns[i].addEventListener(MouseEvent.MOUSE_OUT,tipBtnOutHandler);
			}
								
			_splitBtn.addEventListener(MouseEvent.CLICK,splitHandler);
			_tidyBtn.addEventListener(MouseEvent.CLICK,tidyHandler);
			_dropBtn.addEventListener(MouseEvent.CLICK,dropHandler);
			_sellBtn.addEventListener(MouseEvent.CLICK,sellHandler);

			_vipWelfare.addEventListener(MouseEvent.CLICK,vipWelfareClickHandler);
			_farDrug.addEventListener(MouseEvent.CLICK,farDurgClickHandler);
			_farStore.addEventListener(MouseEvent.CLICK,farStoreClickHandler);
			_taoBaoStore.addEventListener(MouseEvent.CLICK,taoBaoStoreHandler);
			_returnCity.addEventListener(MouseEvent.CLICK,returnCityHandler);
			
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_UPDATE,bagInfoUpdateHandler);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.BAG_EXTEND,bagExtendHandler);
			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdataHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.STALLNAMEUPDATE,stallUpdateHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.DRAG_COMPLETE,dragCompleteHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.CLOSE_BAG,closeBagHandler);
		}
		
		
		private function removeEvent():void
		{
			_allItemBtn.removeEventListener(MouseEvent.CLICK,changeBagType);
			_equipmentBtn.removeEventListener(MouseEvent.CLICK,changeBagType);
			_drugsBtn.removeEventListener(MouseEvent.CLICK,changeBagType);
			_gemstoneBtn.removeEventListener(MouseEvent.CLICK,changeBagType);
			_goodsBtn.removeEventListener(MouseEvent.CLICK,changeBagType);
			
			_vipWelfare.removeEventListener(MouseEvent.CLICK,vipWelfareClickHandler);
			_farDrug.removeEventListener(MouseEvent.CLICK,farDurgClickHandler);
			_farStore.removeEventListener(MouseEvent.CLICK,farStoreClickHandler);
			_taoBaoStore.removeEventListener(MouseEvent.CLICK,taoBaoStoreHandler);
			_returnCity.removeEventListener(MouseEvent.CLICK,returnCityHandler);
			
		
			for(var i:int=0;i<6;i++){
				_pagesBtns[i].removeEventListener(MouseEvent.CLICK,changePage);
				_pagesBtns[i].removeEventListener(MouseEvent.MOUSE_OVER,pageBtnOverHandler);
			}
			
			for(i = 0;i<_tipBtns.length;i++)
			{
				_tipBtns[i].removeEventListener(MouseEvent.MOUSE_OVER,tipBtnOverHandler);
				_tipBtns[i].removeEventListener(MouseEvent.MOUSE_OUT,tipBtnOutHandler);
			}
										
			_splitBtn.removeEventListener(MouseEvent.CLICK,splitHandler);
			_tidyBtn.removeEventListener(MouseEvent.CLICK,tidyHandler);
			_dropBtn.removeEventListener(MouseEvent.CLICK,dropHandler);
			_sellBtn.removeEventListener(MouseEvent.CLICK,sellHandler);
			
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_UPDATE,bagInfoUpdateHandler);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.BAG_EXTEND,bagExtendHandler);
			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdataHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.STALLNAMEUPDATE,stallUpdateHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.DRAG_COMPLETE,dragCompleteHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.CLOSE_BAG,closeBagHandler);
		}
		
		private function tipBtnOverHandler(evt:MouseEvent):void
		{
			var index:int = _tipBtns.indexOf(evt.currentTarget);
			TipsUtil.getInstance().show(_tipsLabel[index],null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function tipBtnOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function pageBtnOverHandler(evt:MouseEvent):void
		{
			if(GlobalData.bagInfo.currentDrag != null)
			{
				setCurrentPageSelect(_pagesBtns.indexOf(evt.currentTarget));
			}
		}
		
		private function closeBagHandler(e:CommonModuleEvent):void
		{
			dispose();
		}
		
		private function dragCompleteHandler(evt:CommonModuleEvent):void
		{
			GlobalData.bagInfo.currentDrag = null;
		}
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.BAG)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addContent);
			}
		}
		
		private function showTipHandler(evt:MouseEvent):void
		{
//			TipsUtil.getInstance().show(_tipsLabel[index],null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function hideTipHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		override public function dispose():void
		{
			if(_timeoutIndex != -1)
			{
				clearTimeout(_timeoutIndex);
			}
			GlobalAPI.tickManager.removeTick(this);
			removeEvent();
			if(_cellList)
			{
				for(var i:int =0;i< _cellList.length;i++)
				{
					_cellList[i].removeEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
					_cellList[i].removeEventListener(MouseEvent.CLICK,cellClickHandler);
					_cellList[i].removeEventListener(BagCellEvent.CELL_MOVE,cellMoveHandler);
					_cellList[i].removeEventListener(BagCellEvent.ITEM_SPLIT,itemSplitHandler);
					_cellList[i].removeEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
					_cellList[i].removeEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
					_cellList[i].dispose();				
				}
			}
			_cellList = null;
			if(_otherIndexUpdateInterval != 0)
			{
				clearInterval(_otherIndexUpdateInterval);
			}
		    if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_allItemBtn)
			{
				_allItemBtn.dispose();
				_allItemBtn = null;
			}
			if(_equipmentBtn)
			{
				_equipmentBtn.dispose();
				_equipmentBtn = null;
			}
			if(_drugsBtn)
			{
				_drugsBtn.dispose();
				_drugsBtn = null;
			}
			if(_gemstoneBtn)
			{
				_gemstoneBtn.dispose();
				_gemstoneBtn = null;
			}
			if(_goodsBtn)
			{
				_goodsBtn.dispose();
				_goodsBtn = null;
			}
			if(_vipWelfare)
			{
				_vipWelfare.dispose();
				_vipWelfare = null;
			}
			if(_farDrug)
			{
				_farDrug.dispose();
				_farDrug = null;
			}
			if(_farStore)
			{
				_farStore.dispose();
				_farStore = null;
			}
			if(_taoBaoStore)
			{
				_taoBaoStore.dispose();
				_taoBaoStore = null;
			}
			if(_returnCity)
			{
				_returnCity.dispose();
				_returnCity = null;
			}
			
			
			if(_pagesBtns)
			{
				for( var j:int=0;j<_pagesBtns.length;j++)
				{
					_pagesBtns[j].dispose();
				}
				_pagesBtns = null;
			}
			
//			if(_vipBtn)
//			{
//				_vipBtn.dispose();
//				_vipBtn = null;
//			}
			if(_splitBtn)
			{
				_splitBtn.dispose();
				_splitBtn = null;
			}
			if(_tidyBtn)
			{
				_tidyBtn.dispose();
				_tidyBtn = null;
			}
			if(_dropBtn)
			{
				_dropBtn.dispose();
				_dropBtn = null;
			}
			if(_sellBtn)
			{
				_sellBtn.dispose()
				_sellBtn = null;
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bagCellEmpty)
			{
				_bagCellEmpty.dispose();
				_bagCellEmpty = null;
			}
			if(_vipBg && _vipBg.bitmapData)
			{
				_vipBg.bitmapData.dispose();
				_vipBg = null;
			}
			_cellTypes = null;
			_currentCellType = null;	
			_yuanBaoView = null;
			_bingYuanBaoView = null;
			_copperView = null;
			_bindCopperView  = null;
			_bagSizeValue = null;
			_pages = null;
			_tempPoint = null;
			_btnArray = null;
			_mediator = null;
			_yuanBaoAsset  = null;
			_bindYuanBaoAsset  = null;
			_copperAsset  = null;
			_bindCopperAsset  = null;
			super.dispose();
		}
	}
}