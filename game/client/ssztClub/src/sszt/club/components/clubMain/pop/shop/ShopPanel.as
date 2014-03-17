package sszt.club.components.clubMain.pop.shop
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.club.events.ClubShopInfoUpdateEvent;
	import sszt.club.events.ClubShopLevelUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubDetailSocketHandler;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.club.ClubSelfExploitUpdateSocketHandler;
	import sszt.core.socketHandlers.common.ItemBuySocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.ModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheCompartLine;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit4Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.club.ClubShopTitleAsset;
	import ssztui.ui.CellBigBgAsset;
	import ssztui.ui.SplitCompartLine;
	import ssztui.ui.SplitCompartLine2;
	
	public class ShopPanel extends MPanel
	{
		private const PAGE_SIZE:int = 2*4; //6 * 5;
		
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
//		private var _bgExtra:Bitmap;
		private var _tile:MTile;
//		private var _items:Vector.<ShopItemCell>;
//		private var _tabBtns:Vector.<MCacheTab1Btn>;
		private var _items:Array;
		private var _tabBtns:Array;
		private var _cashBtn:MCacheAssetBtn1;
		private var _pageView:PageView;
		private var _shopTemplate:ShopTemplateInfo;
		private var _currentIndex:int = -1;
		private var _detailPanel:ShopItemDetailView;
		private var _currentCell:ShopItemCell;
		private var _leftExploitField:MAssetLabel;
		private var _needTotalExploit:MAssetLabel;
//		private var _leftCopperField:MAssetLabel;
		
		public function ShopPanel(mediator:ClubMediator)
		{
			_mediator = mediator;
			_mediator.clubInfo.initShopInfo();
			_mediator.clubInfo.initDetailInfo();
//			_mediator.clubInfo.initMemeberInfo();
			super(new MCacheTitle1("",new Bitmap(new ClubShopTitleAsset())),true,-1);
			
//			_mediator.getDetailInfo();
			ClubSelfExploitUpdateSocketHandler.send();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(397,466);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8,25,381,433)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(12,29,373,394)),
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(82,428,105,22)),
				
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(18,35,180,88)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(199,35,180,88)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(18,124,180,88)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(199,124,180,88)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(18,213,180,88)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(199,213,180,88)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(18,302,180,88)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(199,302,180,88)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(49,86,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(49,175,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(49,264,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(49,353,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(230,86,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(230,175,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(230,264,140,5),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(230,353,140,5),new Bitmap(new SplitCompartLine2())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(24,41,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(205,41,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(24,130,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(205,130,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(24,219,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(205,219,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(24,308,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(205,308,50,50),new Bitmap(new CellBigBgAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(24,431,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.club.personalContribute")  + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT))
				
			]);
			addContent(_bg as DisplayObject);
			
			_pageView = new PageView(PAGE_SIZE, false, 112);
			_pageView.move(144,394);
			addContent(_pageView);
			
			_shopTemplate = ShopTemplateList.getShop(ShopID.CLUB);
//			var len:int = _shopTemplate.categoryNames.length;
//			_tabBtns = new Vector.<MCacheTab1Btn>(len);
			var nameList:Array = [LanguageManager.getWord("ssztl.club.level1Shop"),
				LanguageManager.getWord("ssztl.club.level2Shop"),
				LanguageManager.getWord("ssztl.club.level3Shop"),
				LanguageManager.getWord("ssztl.club.level4Shop"),
				LanguageManager.getWord("ssztl.club.level5Shop")];
			_tabBtns = new Array(nameList.length);
			for(var i:int = 0; i < nameList.length; i++)
			{
				var tabBtn:MCacheTabBtn1 = new MCacheTabBtn1(0, 0, nameList[i]);
				tabBtn.move(i * 47 + 15, 0);
				_tabBtns[i] = tabBtn;
				addContent(tabBtn);
				tabBtn.addEventListener(MouseEvent.CLICK,tabClickHandler);
			}
			
//			var tmpLevel:int = _mediator.clubInfo.deviceInfo.shopLevel;
//			if(GlobalData.selfPlayer.clubLevel > 5) tmpLevel = 5;
//			for(var m:int = 0;m < tmpLevel;m++)
//			{
//				_tabBtns[m].enabled = true;
//			}
			
			_tile = new MTile(180,88,2);
			_tile.setSize(361,355);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.itemGapW = _tile.itemGapH = 1;
			_tile.move(18,35);
			addContent(_tile);
//			_items = new Vector.<ShopItemCell>(20);
			_items = new Array(PAGE_SIZE);
			for(var j:int = 0; j < PAGE_SIZE; j++)
			{
				var item:ShopItemCell = new ShopItemCell();
				_tile.appendItem(item);
				_items[j] = item;
				item.addEventListener(MouseEvent.CLICK, itemClickHandler);
			}
			
			_detailPanel = new ShopItemDetailView();
			_detailPanel.move(425,30);
//			addContent(_detailPanel);
			
			_cashBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.buy"));
			_cashBtn.move(425,227);
//			addContent(_cashBtn);
			
			_leftExploitField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_leftExploitField.move(88,431);
			addContent(_leftExploitField);
			_leftExploitField.setValue(GlobalData.selfPlayer.selfExploit.toString());// + "/" + GlobalData.selfPlayer.totalExploit);

			_needTotalExploit = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_needTotalExploit.move(351, 204);
			//addContent(_needTotalExploit);
			
			initEvent();
			initData();
//			setIndex(0);
		}
		
		public function assetsCompleteHandler():void
		{
//			_bgExtra.bitmapData = AssetUtil.getAsset("ssztui.club.ClubShopBgAsset", BitmapData) as BitmapData;
		}
		
		private function initData():void
		{
			ClubDetailSocketHandler.send(GlobalData.selfPlayer.clubId); 
		}
		
		private function initEvent():void
		{
//			_mediator.clubInfo.clubShopInfo.addEventListener(ClubShopInfoUpdateEvent.SELF_EXPLOIT_UPDATE,exploitUpdateHandler);
//			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.SELFEXPLOIT_UPDATE,exploitUpdateHandler);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			_cashBtn.addEventListener(MouseEvent.CLICK,cashClickHandler);
			
			ModuleEventDispatcher.addModuleEventListener(ClubShopLevelUpdateEvent.UPDATE_SHOP_LEVEL,updateShopeLevel);
		}
		
		private function removeEvent():void
		{
//			_mediator.clubInfo.clubShopInfo.removeEventListener(ClubShopInfoUpdateEvent.SELF_EXPLOIT_UPDATE,exploitUpdateHandler);
//			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.SELFEXPLOIT_UPDATE,exploitUpdateHandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			_cashBtn.removeEventListener(MouseEvent.CLICK,cashClickHandler);
			
			ModuleEventDispatcher.removeModuleEventListener(ClubShopLevelUpdateEvent.UPDATE_SHOP_LEVEL,updateShopeLevel);
		}
		
		private function exploitUpdateHandler(e:SelfPlayerInfoUpdateEvent):void
		{
			_leftExploitField.setValue(String(GlobalData.selfPlayer.selfExploit));
//			_leftExploitField.setValue(GlobalData.selfPlayer.selfExploit + "/" + GlobalData.selfPlayer.totalExploit);
		}
		
//		private function moneyUpdateHandler(e:SelfPlayerInfoUpdateEvent):void
//		{
//			_leftCopperField.setValue(String(GlobalData.selfPlayer.userMoney.copper));
//		}
		
		private function cashClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_currentIndex >= _mediator.clubInfo.deviceInfo.shopLevel)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.upgradeClubShop"));
				return;
			}
			if(_currentCell == null)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.selectBuyItem"));
				return;
			}
			if(_currentCell.shopItemInfo.payType == 8)
			{
				var total:int = int(_needTotalExploit.text);
				if(GlobalData.selfPlayer.totalExploit < total)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.club.allContributeNotEnough"));
					return;
				}
				if(_detailPanel.getNeedMoney() > GlobalData.selfPlayer.selfExploit)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.club.contributeNotEnough"));
					return;
				}
			}
			ItemBuySocketHandler.sendBuy(_currentCell.shopItemInfo.id,_detailPanel.getCount());
		}
		
		private function updateShopeLevel(evt:ModuleEvent):void
		{
			setIndex(0);
		}
		
		private function setIndex(index:int):void
		{
			if(_currentIndex == index)return;
			if(_currentIndex != -1)
			{
				_tabBtns[_currentIndex].selected = false;
			}
			_currentIndex = index;
			_tabBtns[_currentIndex].selected = true;
			_pageView.currentPage = 1;
			_pageView.totalRecord = _shopTemplate.shopItemInfos[_currentIndex].length;
			_needTotalExploit.setValue(getNeedTotalExploit(index).toString());
			setData();
		}
		
		private function getNeedTotalExploit(index:int):int
		{
			switch (index)
			{
				case 0:
					if(!_mediator.clubInfo.deviceInfo)
					{
						_mediator.clubInfo.initClubDeviceInfo();
					}
					return	_mediator.clubInfo.deviceInfo.shop1Exploit;
					break;
				case 1:
					return _mediator.clubInfo.deviceInfo.shop2Exploit;
					break;
				case 2:
					return _mediator.clubInfo.deviceInfo.shop3Exploit;
					break;
				case 3:
					return _mediator.clubInfo.deviceInfo.shop4Exploit;
					break;
				case 4:
					return _mediator.clubInfo.deviceInfo.shop5Exploit;
					break;
			}
			return 0;
		}
		
		private function pageChangeHandler(evt:PageEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			setData();
		}
		
		private function setData():void
		{
			for each(var i:ShopItemCell in _items)
			{
				i.shopItemInfo = null;
			}
//			var list:Vector.<ShopItemInfo> = _shopTemplate.getItems(_pageSize,_pageView.currentPage - 1,_currentIndex);
			var list:Array = _shopTemplate.getItems(PAGE_SIZE, _pageView.currentPage - 1,_currentIndex);
			var len:int = list.length;
			for(var j:int = 0; j < len; j++)
			{
				_items[j].shopItemInfo = list[j];
			}
			if(_items[0].shopItemInfo != null)setSelected(_items[0]);
			else
			{
				if(_currentCell)
				{
					_currentCell.selected = false;
					_currentCell = null;
				}
			}
			var locked:Boolean;
			if(_currentIndex >= _mediator.clubInfo.deviceInfo.shopLevel) locked = true;
			else locked = false;
			filterCell(locked);
		}
		
		private function tabClickHandler(evt:MouseEvent):void
		{
			var index:int = _tabBtns.indexOf(evt.currentTarget as MCacheTabBtn1);
			setIndex(index);
		}
		
		private function filterCell(value:Boolean):void
		{
			for(var i:int = 0;i<_items.length;i++)
			{
				_items[i].locked = value;
			}
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			setSelected(evt.currentTarget as ShopItemCell);
		}
		
		private function setSelected(cell:ShopItemCell):void
		{
			if(!cell.info)return;
			if(_currentCell)_currentCell.selected = false;
			_currentCell = cell;
			_currentCell.selected = true;
			_detailPanel.info = _currentCell.shopItemInfo;
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_cashBtn)
			{
				_cashBtn.dispose();
				_cashBtn = null;
			}
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			if(_tabBtns)
			{
				for each(var btn:MCacheTabBtn1 in _tabBtns)
				{
					btn.removeEventListener(MouseEvent.CLICK,tabClickHandler);
					btn.dispose()
				}
			}
			_tabBtns = null;
			if(_items)
			{
				for each(var cell:ShopItemCell in _items)
				{
					cell.removeEventListener(MouseEvent.CLICK,itemClickHandler);
					cell.dispose();
				}
			}
			_items = null;
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_detailPanel)
			{
				_detailPanel.dispose();
				_detailPanel = null;
			}
			_currentCell = null;
			_shopTemplate = null;
			_mediator.clubInfo.clearShopInfo();
			_mediator = null;
		}
	}
}