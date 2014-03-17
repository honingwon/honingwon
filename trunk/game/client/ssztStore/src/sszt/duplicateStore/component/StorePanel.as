package sszt.duplicateStore.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Mouse;
	
	import sszt.constData.CommonConfig;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.scene.BaseSceneObjInfo;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.tips.TipsUtil;
	import sszt.duplicateStore.component.secs.IGoodTabPanel;
	import sszt.duplicateStore.component.secs.NormalGoodTabPanel;
	import sszt.duplicateStore.event.StoreEvent;
	import sszt.duplicateStore.mediator.StoreMediator;
	import sszt.duplicateStore.socket.GetDuplicateShopSaleNumSocketHandler;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.SelectedBorder;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.btns.tabBtns.MCacheTab1Btn;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.store.BtnPayAsset;
	import ssztui.ui.BindCopperAsset;
	import ssztui.ui.BindYuanBaoAsset;
	import ssztui.ui.BorderAsset7;
	import ssztui.ui.BtnAssetClose;
	import ssztui.ui.CopperAsset;
	import ssztui.ui.YuanBaoAsset;

	
	public class StorePanel extends MPanel 
	{
		public static var copperAsset:BitmapData;
		public static var bindCopperAsset:BitmapData;
		public static var yuanBaoAsset:BitmapData;
		public static var bindYuanBaoAsset:BitmapData;
		public static var starAsset:BitmapData;
		
		private var _mediator:StoreMediator;
		private var _shopType:int;
		private var _goodType:int = 0;
		private var _currentPage:int = 0;
//		private var _btns:Vector.<MCacheTab1Btn>;
//		private var _tabPanels:Vector.<IGoodTabPanel>;
		private var _btns:Array;
		private var _tabPanels:Array;
//		private var _chargeBtn:MAssetButton1;
		private var _yuanBao:MAssetLabel;
		private var _bindYuanBao:MAssetLabel;
		private var _score:MAssetLabel;
//		private var _classes:Vector.<Class>;
		private var _classes:Array;
		private var _pageView:PageView;
		
		private var _bg:IMovieWrapper;
		private var _assetsComplete:Boolean;
		private var _chargeBtn:MAssetButton1;
		
		private var _npcInfo:NpcTemplateInfo;
		
		public function StorePanel(mediator:StoreMediator,data:ToStoreData)
		{
			_assetsComplete = false;
			_mediator = mediator;
			_shopType = data.type;
			_goodType = data.tabIndex;
			_npcInfo = NpcTemplateList.getNpc(data.npcId);
			copperAsset = MoneyIconCaches.copperAsset;
			bindCopperAsset = MoneyIconCaches.bingCopperAsset;
			yuanBaoAsset = MoneyIconCaches.yuanBaoAsset;
			bindYuanBaoAsset = MoneyIconCaches.bingYuanBaoAsset;
			
			GetDuplicateShopSaleNumSocketHandler.sendDiscount(_shopType);
			
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.NPCStoreTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.NPCStoreTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title), true, -1,true,false);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(401,455);
			
			_bg = BackgroundUtils.setBackground([
//				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(0,12,466,448),new WinBgAsset()),
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8,4,385,443)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(13,9,375,402)),
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(50,417,84,22)),
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(196,417,84,22)),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(54,421,16,14),new Bitmap(yuanBaoAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(200,421,16,14),new Bitmap(bindYuanBaoAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(17,420,50,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.yuanBao")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(139,420,50,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.bindYuanBao2")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
			]);
			addContent(_bg as DisplayObject);
			
			_classes = [NormalGoodTabPanel];
			
//			_btns = new Vector.<MCacheTab1Btn>();
			_btns = new Array();
			var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,"副本商店");
			btn.move(221,34);
			_btns.push(btn);
//			addChild(btn);
//			var shop:ShopTemplateInfo = ShopTemplateList.getShop(_shopType);
//			for(var i:int =0;i<shop.categoryNames.length;i++)
//			{
//				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,shop.categoryNames[i]);
//				btn.move(221+i*69,34);
//				_btns.push(btn);
//				addChild(btn);
//			}
//			var btn1:MCacheTabBtn1 = new MCacheTabBtn1(0,2,LanguageManager.getWord("ssztl.duplicateStore.storeItemSale"));
//			btn1.move(221 + i*69,34);
//			_btns.push(btn1);
//			addChild(btn1);
			
			_btns[_goodType].selected = true;
//			_tabPanels = new Vector.<IGoodTabPanel>(_classes.length);
			_tabPanels = new Array();
			
			_pageView = new PageView();
			_pageView.move(134,383);
			addContent(_pageView);
			
			_yuanBao = new MAssetLabel(String(GlobalData.selfPlayer.userMoney.yuanBao),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_yuanBao.move(73,420);
			addContent(_yuanBao);
			
			_bindYuanBao = new MAssetLabel(String(GlobalData.selfPlayer.userMoney.bindYuanBao),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_bindYuanBao.move(219,420);
			addContent(_bindYuanBao);
			
			_score = new MAssetLabel(LanguageManager.getWord("ssztl.common.YuanBaoScore") + "：" +  String(GlobalData.selfPlayer.yuanBaoScore),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_score.textColor = 0xffc500;
			_score.move(636,424);
//			addChild(_score);
			
			move(Math.round((CommonConfig.GAME_WIDTH - 466)/2),Math.round((CommonConfig.GAME_HEIGHT - 460)/2));
			
			_chargeBtn = new MAssetButton1(ssztui.store.BtnPayAsset);
			_chargeBtn.move(289,414);
//			addContent(_chargeBtn);
			if(!GlobalData.canCharge)_chargeBtn.enabled = false;
			
			initEvent();
		}
		
		public function assetsCompleteHandler():void
		{
			_assetsComplete = true;
			for(var i:int = 0; i < _tabPanels.length; i++)
			{
				if(_tabPanels[i] != null)
					(_tabPanels[i] as IGoodTabPanel).assetsCompleteHandler();
			}
		}
		public function updateSaleNum(data:IPackageIn):void
		{
			setTabPanel(_goodType);
			_mediator.storeModule.cheapInfo.dispatchEvent(new StoreEvent(StoreEvent.DISCOUNT_UPDATE,data));
		}
		public function updateBuyNum(data:IPackageIn):void
		{
			var isSucc:Boolean = data.readBoolean();
			var itemId:int = data.readInt();
			var num:int = data.readInt();
			if(isSucc)
			{
				_mediator.storeModule.cheapInfo.shop.buySaleNum(itemId, num);
				setTabPanel(_goodType);	
			}
			else
			{
				MAlert.show(LanguageManager.getWord("ssztl.common.buyFail"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK,null,null);
			}
		}
		
		private function setTabPanel(index:int):void
		{
			var shop:ShopTemplateInfo = ShopTemplateList.getShop(_shopType);
			var tmpIndex:int = index > 1 ? 2 : index;
			if(index == shop.categoryNames.length) tmpIndex = 3;
			if(_tabPanels[tmpIndex] == null)
			{
				_tabPanels[tmpIndex] = new _classes[tmpIndex](_shopType,_mediator);
				if(_assetsComplete)
				{
					(_tabPanels[tmpIndex] as IGoodTabPanel).assetsCompleteHandler();
				}
				_tabPanels[tmpIndex].move(13,9);
			}
			addContent(_tabPanels[tmpIndex] as DisplayObject);
			if(tmpIndex < 3)
			{
				_pageView.visible = true;
				var pageSize:int = index>1?12:8;
				_pageView.totalRecord = shop.shopItemInfos[_goodType].length;
				_pageView.pageSize = pageSize;
				_tabPanels[tmpIndex].showGoods(_currentPage,_goodType);
			}else
			{
				_tabPanels[tmpIndex].show();
				_pageView.visible = false;
			}	
		}
		
		private function initEvent():void
		{
			for(var i:int =0;i<_btns.length;i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_chargeBtn.addEventListener(MouseEvent.CLICK,chargeClickHandler);
			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.UPDATE_YUANBAO_SCORE,updateYuanBaoScore);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			_mediator.storeModule.addEventListener(StoreEvent.COUNT_CHANGE, showItemList);
			
			GlobalData.selfScenePlayerInfo.addEventListener(BaseSceneObjInfoUpdateEvent.MOVE,storeSelfMoveHandler);
		}
		
		private function removeEvent():void
		{
			for(var i:int =0;i<_btns.length;i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_chargeBtn.removeEventListener(MouseEvent.CLICK,chargeClickHandler);
			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.UPDATE_YUANBAO_SCORE,updateYuanBaoScore);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			_mediator.storeModule.removeEventListener(StoreEvent.COUNT_CHANGE, showItemList);
			
			GlobalData.selfScenePlayerInfo.removeEventListener(BaseSceneObjInfoUpdateEvent.MOVE,storeSelfMoveHandler);
		}
		
		private function showItemList(e:StoreEvent):void
		{
			setTabPanel(_goodType);
		}
		
		private function storeSelfMoveHandler(e:BaseSceneObjInfoUpdateEvent):void
		{
			if(_npcInfo == null)return;
			var selfInfo:BaseSceneObjInfo = e.currentTarget as BaseSceneObjInfo;
			var dis:Number = Math.sqrt(Math.pow(selfInfo.sceneX - _npcInfo.sceneX,2) + Math.pow(selfInfo.sceneY - _npcInfo.sceneY,2));
			if(dis > CommonConfig.NPC_PANEL_DISTANCE)
				dispose();
		}
		
		private function overHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.store.ScoreTip"),null,new Rectangle(evt.stageX,evt.stageY,0,0));	
		}
		
		private function outHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - width,parent.stage.stageHeight - height));
		}
		
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		
		private function sizeChangeHandler(evt:CommonModuleEvent):void
		{
			move(Math.round((CommonConfig.GAME_WIDTH - 466)/2),Math.round((CommonConfig.GAME_HEIGHT - 460)/2));
		}
		
		private function chargeClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
//			MAlert.show("此功能暂未开放,敬请期待",LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK);
			JSUtils.gotoFill();
		}
		
		private function pageChangeHandler(evt:PageEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			var shop:ShopTemplateInfo = ShopTemplateList.getShop(_shopType);
			_currentPage = _pageView.currentPage - 1;
			var index:int = _goodType>1?2:_goodType;
			if(_goodType == shop.categoryNames.length) index = 3;
			_tabPanels[index].showGoods(_currentPage,_goodType);
		}
		
		private function moneyUpdateHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			_yuanBao.setValue(String(GlobalData.selfPlayer.userMoney.yuanBao));
			_bindYuanBao.setValue(String(GlobalData.selfPlayer.userMoney.bindYuanBao));
		}
		
		private function updateYuanBaoScore(evt:SelfPlayerInfoUpdateEvent):void
		{
			_score.setValue(LanguageManager.getWord("ssztl.common.YuanBaoScore") + "：" + String(GlobalData.selfPlayer.yuanBaoScore));
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			var shop:ShopTemplateInfo = ShopTemplateList.getShop(_shopType);
			var index:int = _btns.indexOf(evt.currentTarget);
			if(_goodType == index) return;
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			var tempIndex:int = _goodType > 1 ? 2:_goodType;
			if(_goodType == shop.categoryNames.length) tempIndex = 3;
			_tabPanels[tempIndex].hide();
			_btns[_goodType].selected = false;
			_goodType = index;
			_btns[_goodType].selected = true;
			_currentPage = 0;
			setTabPanel(_goodType);
			_pageView.setPage(_currentPage + 1);
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_btns)
			{
				for(var i:int =0;i<_btns.length;i++)
				{
					_btns[i].dispose();
					_btns[i] = null;
				}
				_btns = null;
			}
			if(_tabPanels)
			{
				for(var j:int=0;j<_tabPanels.length;j++)
				{
					if(_tabPanels[j])
					{
						_tabPanels[j].dispose();
						_tabPanels[j] = null;
					}
				}
				_tabPanels = null;
			}
			if(_chargeBtn)
			{
				_chargeBtn.dispose();
				_chargeBtn = null;
			}
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			if(copperAsset)
			{
				copperAsset = null;
			}
			if(bindCopperAsset)
			{
				bindCopperAsset = null;
			}
			if(yuanBaoAsset)
			{
				yuanBaoAsset = null;
			}
			if(bindYuanBaoAsset)
			{
				bindYuanBaoAsset = null;
			}
			starAsset = null;
			_yuanBao = null;
			_bindYuanBao = null;
			_classes = null;
			_mediator = null;
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}