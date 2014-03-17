package sszt.scene.components.shenMoWar.crystalWar.shop
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.tabBtns.MCacheTab1Btn;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit4Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.common.ItemBuySocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.SceneWarMediator;
	
	public class CrystalWarShopPanel extends MPanel
	{
		private const _pageSize:int = 20;
		
		private var _mediator:SceneWarMediator;
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
//		private var _items:Vector.<ShopItemCell>;
//		private var _tabBtns:Vector.<MCacheTab1Btn>;
		private var _items:Array;
		private var _tabBtns:Array;
		private var _cashBtn:MCacheAsset1Btn;
		private var _cancelBtn:MCacheAsset1Btn;
		private var _pageView:PageView;
		private var _shopTemplate:ShopTemplateInfo;
		private var _currentIndex:int = -1;
		private var _detailPanel:CrystalWarShopItemDetailView;
		private var _currentCell:CrystalWarShopItemCell;
		private var _leftHonorField:MAssetLabel;
//		private var _leftCopperField:MAssetLabel;
		
		public function CrystalWarShopPanel(mediator:SceneWarMediator)
		{
			_mediator = mediator;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("sszt.scene.ShenMoWarShopAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("sszt.scene.ShenMoWarShopAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(401,291);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,401,262)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,30,393,5),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(6,35,236,222)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,43,220,40),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,88,220,40),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,133,220,40),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,178,220,40),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(246,61,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(9,222,230,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(244,133,151,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(313,107,55,19)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(44,272,70,19)),
//				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(155,272,70,19))
			]);
			addContent(_bg as DisplayObject);
			
//			var label1:MAssetLabel = new MAssetLabel("铜币：",MAssetLabel.LABELTYPE14);
//			label1.move(8,274);
//			addContent(label1);

			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.exploit"),MAssetLabel.LABELTYPE14);
			
			label2.move(8,274);
			addContent(label2);
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.buyItem"),MAssetLabel.LABELTYPE14);
			label3.move(292,39);
			addContent(label3);
			var label4:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.changeConsume"),MAssetLabel.LABELTYPE14);
			label4.move(292,140);
			addContent(label4);
			
			var descriptionLabel:MAssetLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			descriptionLabel.move(250,215);
			descriptionLabel.width = 150;
			descriptionLabel.wordWrap = true;
			descriptionLabel.multiline = true;
			addContent(descriptionLabel);
			descriptionLabel.htmlText = LanguageManager.getWord("ssztl.scene.warStoreDescript");
			
			
			
			_pageView = new PageView(20);
			_pageView.move(35,229);
			addContent(_pageView);
			_shopTemplate = ShopTemplateList.getShop(106);
//			var len:int = _shopTemplate.categoryNames.length;
//			_tabBtns = new Vector.<MCacheTab1Btn>(len);
			
			var nameList:Array = [LanguageManager.getWord("ssztl.common.purpleEquip"),
				LanguageManager.getWord("ssztl.common.stoneSymbol"),
				LanguageManager.getWord("ssztl.common.sundries")];
			
			_tabBtns = new Array(nameList.length);
			for(var i:int = 0; i < nameList.length; i++)
			{
				var tabBtn:MCacheTab1Btn = new MCacheTab1Btn(0,1,nameList[i]);
				tabBtn.move(i * 67 + 10,9);
				_tabBtns[i] = tabBtn;
				addContent(tabBtn);
				tabBtn.addEventListener(MouseEvent.CLICK,tabClickHandler);
			}
			
			
			_tile = new MTile(44,44,5);
			_tile.setSize(224,179);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.itemGapW = 1;
			_tile.itemGapH = 1;
			_tile.move(12,41);
			addContent(_tile);
//			_items = new Vector.<ShopItemCell>(20);
			_items = new Array(20);
			for(var j:int = 0; j < 20; j++)
			{
				var item:CrystalWarShopItemCell = new CrystalWarShopItemCell();
				_tile.appendItem(item);
				_items[j] = item;
				item.addEventListener(MouseEvent.CLICK,itemClickHandler);
			}
			
			_detailPanel = new CrystalWarShopItemDetailView();
			_detailPanel.move(244,38);
			addContent(_detailPanel);
			
			_cashBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.scene.exchange"));
			_cashBtn.move(245,268);
			addContent(_cashBtn);
			_cancelBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.common.cannel"));
			_cancelBtn.move(325,268);
			addContent(_cancelBtn);
			
			_leftHonorField = new MAssetLabel("",MAssetLabel.LABELTYPE4,TextFormatAlign.LEFT);
			_leftHonorField.setSize(65,20);
			_leftHonorField.move(48,274);
			addContent(_leftHonorField);
			_leftHonorField.setValue(String(GlobalData.selfPlayer.honor));
//			_leftCopperField = new MAssetLabel("",MAssetLabel.LABELTYPE4,TextFormatAlign.LEFT);
//			_leftCopperField.setSize(65,20);
//			_leftCopperField.move(48,274);
//			addContent(_leftCopperField);
//			_leftCopperField.setValue(String(GlobalData.selfPlayer.userMoney.copper));
			
			initEvent();
			
			setIndex(0);
		}
		
		private function initEvent():void
		{
//			_mediator.clubInfo.clubShopInfo.addEventListener(ClubShopInfoUpdateEvent.SELF_EXPLOIT_UPDATE,exploitUpdateHandler);
//			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.SELFHONOR_UPDATE,honorUpdateHandler);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			_cashBtn.addEventListener(MouseEvent.CLICK,cashClickHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,cancelClickHandler);
		}
		
		private function removeEvent():void
		{
//			_mediator.clubInfo.clubShopInfo.removeEventListener(ClubShopInfoUpdateEvent.SELF_EXPLOIT_UPDATE,exploitUpdateHandler);
//			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.SELFHONOR_UPDATE,honorUpdateHandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			_cashBtn.removeEventListener(MouseEvent.CLICK,cashClickHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,cancelClickHandler);
		}
		
		private function honorUpdateHandler(e:SelfPlayerInfoUpdateEvent):void
		{
			_leftHonorField.setValue(String(GlobalData.selfPlayer.honor));
		}
		
//		private function moneyUpdateHandler(e:SelfPlayerInfoUpdateEvent):void
//		{
//			_leftCopperField.setValue(String(GlobalData.selfPlayer.userMoney.copper));
//		}
		
		private function cashClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_currentCell == null)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.selectBuyItem"));
				return;
			}
			 if(_currentCell.shopItemInfo.payType == 6)
			{
				if(_detailPanel.getNeedMoney() > GlobalData.selfPlayer.honor)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.warValueNotEnough"));
					return;
				}
			}
			ItemBuySocketHandler.sendBuy(_currentCell.shopItemInfo.id,_detailPanel.getCount());
		}
		
		private function cancelClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			dispose();
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
			setData();
		}
		
		private function pageChangeHandler(evt:PageEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			setData();
		}
		
		private function setData():void
		{
			for each(var i:CrystalWarShopItemCell in _items)
			{
				i.shopItemInfo = null;
			}
//			var list:Vector.<ShopItemInfo> = _shopTemplate.getItems(_pageSize,_pageView.currentPage - 1,_currentIndex);
			var list:Array = _shopTemplate.getItems(_pageSize,_pageView.currentPage - 1,_currentIndex);
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
		}
		
		private function tabClickHandler(evt:MouseEvent):void
		{
			var index:int = _tabBtns.indexOf(evt.currentTarget as MCacheTab1Btn);
			setIndex(index);
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			setSelected(evt.currentTarget as CrystalWarShopItemCell);
		}
		
		private function setSelected(cell:CrystalWarShopItemCell):void
		{
			if(!cell.info)return;
			if(_currentCell)_currentCell.selected = false;
			_currentCell = cell;
			_currentCell.selected = true;
			_detailPanel.info = _currentCell.shopItemInfo;
		}
		
		override public function dispose():void
		{
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
			if(_cancelBtn)
			{
				_cancelBtn.dispose();
				_cancelBtn = null;
			}
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			if(_tabBtns)
			{
				for each(var btn:MCacheTab1Btn in _tabBtns)
				{
					btn.removeEventListener(MouseEvent.CLICK,tabClickHandler);
					btn.dispose()
				}
			}
			_tabBtns = null;
			if(_items)
			{
				for each(var cell:CrystalWarShopItemCell in _items)
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
			_mediator = null;
			_leftHonorField = null;
			super.dispose();
		}
	}
}