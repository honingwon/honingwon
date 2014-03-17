package sszt.store.component
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.ShopID;
	import sszt.constData.SourceClearType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.data.store.MysteryShopInfo;
	import sszt.core.data.store.MysteryShopItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.JSUtils;
	import sszt.core.utils.MoneyChecker;
	import sszt.core.utils.RichTextUtil;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.richTextField.RichTextField;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.MysteryShopMessageEvent;
	import sszt.events.StoreModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.store.mediator.StoreMediator;
	import sszt.store.socket.MysteryShopGetInfoSocketHandler;
	import sszt.store.socket.MysteryShopRefSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTextArea;
	import sszt.ui.container.MTile;
	import sszt.ui.container.MYuanbaoAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.store.mysticLuckyRankAsset;
	import ssztui.store.mysticTitleAsset;
	import ssztui.ui.BtnAssetClose;
	import ssztui.ui.SplitCompartLine2;
	import ssztui.ui.TitleBackgroundLeftAsset;
	import ssztui.ui.TitleBackgroundRightAsset;
	
	public class RefreshableStore extends MSprite implements IPanel
	{
		public static const PANEL_WIDTH:int = 666;
		public static const PANEL_HEIGHT:int = 435;
		
		private var _mediator:StoreMediator;
		private var _bg:IMovieWrapper;
		private var _upBg:IMovieWrapper;
		private var _banner:Bitmap;
		private var _bannerPath:String;
		
		private var _closeBtn:MAssetButton1;
		private var _dragArea:Sprite;
		
		private var _tile:MTile;
		private var _itemList:Array;
		
		private var _listView:MScrollPanel;
		private var _msgViewList:Array;
		
		private var _npcSpeak:MAssetLabel;
		private var _yuanbaoView:MAssetLabel;
		private var _copperView:MAssetLabel;
		private var _freeRrefresh:MAssetLabel;
		private var _btnRefresh:MCacheAssetBtn1;
//		private var _countDown:CountDownView;
		
		public function RefreshableStore()
		{
			init();
			initEvent();
			moneyUpdateHandler(null);
			updataItems(null);
			updataVipTimes(null);
			updataRefreshTime(null);
		}
		protected function init():void
		{
			sizeChangeHandler(null);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_1, new Rectangle(0,0,PANEL_WIDTH,PANEL_HEIGHT)),
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8,40,PANEL_WIDTH-16,PANEL_HEIGHT-48)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(12,44,PANEL_WIDTH-24,PANEL_HEIGHT-58)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(250,12,28,18),new Bitmap(new TitleBackgroundLeftAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(387,12,28,18),new Bitmap(new TitleBackgroundRightAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(281,9,103,24),new Bitmap(new mysticTitleAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_banner = new Bitmap();
			_banner.y = 48;
			_banner.x = 16;
			addChild(_banner);
			
			_upBg =  BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(196,179,18,18),new Bitmap(MoneyIconCaches.yuanBaoAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(311,179,18,18),new Bitmap(MoneyIconCaches.copperAsset)),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(161,180,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.yuanBao")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(276,180,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.copperLabel"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(399,49,248,27)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(507,55,46,15),new Bitmap(new mysticLuckyRankAsset())),
				
				//new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(391,394,105,15),new MAssetLabel(LanguageManager.getWord("ssztl.pet.timeForNextTime"),MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(134,394,180,15),new MAssetLabel(LanguageManager.getWord("ssztl.store.refreshAmountTip"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
			]);
			addChild(_upBg as DisplayObject);
			
			_bannerPath = GlobalAPI.pathManager.getBannerPath("mysticStoreBanner.jpg");
			GlobalAPI.loaderAPI.getPicFile(_bannerPath, loadBannerComplete,SourceClearType.NEVER);
			
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,PANEL_WIDTH,40);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_closeBtn = new MAssetButton1(new BtnAssetClose());
			_closeBtn.move(PANEL_WIDTH-28,6);
			addChild(_closeBtn);
			
			_itemList = [];
			_tile = new MTile(209,89,3);
			_tile.itemGapW = _tile.itemGapH = 0;
			_tile.setSize(627,188);
			_tile.move(20,208);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			_listView = new MScrollPanel();
			_listView.mouseEnabled = _listView.getContainer().mouseEnabled = true;
			_listView.move(408,78);
			_listView.setSize(240,120);
			_listView.horizontalScrollPolicy = ScrollPolicy.OFF;
			_listView.verticalScrollPolicy = ScrollPolicy.AUTO;
			addChild(_listView);
			_listView.update();
			
//			_luckyNote.htmlText = "<font color='#66cc33'>[风清阳]</font> 购买了 <font color='#00ccff'>六级攻击宝石</font>×10";
			
			_npcSpeak = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_npcSpeak.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,6)]);
			_npcSpeak.wordWrap = true;
			_npcSpeak.setSize(216,90);
			_npcSpeak.move(161,66);
			addChild(_npcSpeak);
			_npcSpeak.setHtmlValue(LanguageManager.getWord("ssztl.store.refreshableShopTip"));
			
			_yuanbaoView = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_yuanbaoView.move(215,180);
			addChild(_yuanbaoView);
			
			_copperView = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_copperView.move(328,180);
			addChild(_copperView);
			
			_freeRrefresh = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_freeRrefresh.move(25,394);
			addChild(_freeRrefresh);
			
//			_countDown = new CountDownView();
//			_countDown.setColor(0x33ff00);
//			_countDown.setSize(55,18);
//			_countDown.move(498,394);
//			addChild(_countDown);
//			_countDown.start(900);
			
			_btnRefresh = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.swordsMan.flush"));
			_btnRefresh.move(569,389);
			addChild(_btnRefresh);
			
			if(GlobalData.mysteryShopInfo.mysteryShopMsgInfo.flag)
			{
				initListView();
			}
			else
			{
				GlobalData.mysteryShopInfo.mysteryShopMsgInfo.addEventListener(MysteryShopMessageEvent.Mystery_MSG_LOADED,msgLoadedHandler);
			}
		}
		private function msgLoadedHandler(evt:MysteryShopMessageEvent):void
		{
			initListView();
			GlobalData.mysteryShopInfo.mysteryShopMsgInfo.removeEventListener(MysteryShopMessageEvent.Mystery_MSG_LOADED,msgLoadedHandler);
		}
		private function initListView():void
		{
			var msgList:Array = GlobalData.mysteryShopInfo.mysteryShopMsgInfo.msgList;
			var richTextField:RichTextField;
			var len:int = msgList.length <= 20 ? msgList.length : 20;
			var currentHeight:int = 0;
			
			_msgViewList = [];
			for(var i:int=0;i<len;i++)
			{
				richTextField = RichTextUtil.getOpenBoxRichText(msgList[i],225);
				richTextField.y = currentHeight;
				_listView.getContainer().addChild(richTextField);
				currentHeight += richTextField.height-8;
				_msgViewList.push(richTextField);
			}
			_listView.getContainer().height = currentHeight;
			_listView.update();
			
		}
		private function initEvent():void
		{
			_closeBtn.addEventListener(MouseEvent.CLICK,closeClickHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnRefresh.addEventListener(MouseEvent.MOUSE_OVER,refreshOverHandler);
			_btnRefresh.addEventListener(MouseEvent.MOUSE_OUT,tipHide);
			_btnRefresh.addEventListener(MouseEvent.CLICK,refreshClickHandler);
			
			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
			ModuleEventDispatcher.addStoreEventListener(StoreModuleEvent.MYSTERY_SHOPINFO_UPDATE,updataItems);
			ModuleEventDispatcher.addStoreEventListener(StoreModuleEvent.MYSTERY_VIPTIME_UPDATE,updataVipTimes);
			ModuleEventDispatcher.addStoreEventListener(StoreModuleEvent.MYSTERY_REFRESH_UPDATE,updataRefreshTime);
			
			GlobalData.mysteryShopInfo.mysteryShopMsgInfo.addEventListener(MysteryShopMessageEvent.Mystery_MSG_ADD,msgAddHandler);	
//			_countDown.addEventListener(Event.COMPLETE,cdComplete);
		}
		
		private function removeEvent():void
		{
			_closeBtn.removeEventListener(MouseEvent.CLICK,closeClickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnRefresh.removeEventListener(MouseEvent.MOUSE_OVER,refreshOverHandler);
			_btnRefresh.removeEventListener(MouseEvent.MOUSE_OUT,tipHide);
			_btnRefresh.removeEventListener(MouseEvent.CLICK,refreshClickHandler);
			
			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
			ModuleEventDispatcher.removeStoreEventListener(StoreModuleEvent.MYSTERY_SHOPINFO_UPDATE,updataItems);
			ModuleEventDispatcher.removeStoreEventListener(StoreModuleEvent.MYSTERY_VIPTIME_UPDATE,updataVipTimes);
			ModuleEventDispatcher.removeStoreEventListener(StoreModuleEvent.MYSTERY_REFRESH_UPDATE,updataRefreshTime);
			
			GlobalData.mysteryShopInfo.mysteryShopMsgInfo.removeEventListener(MysteryShopMessageEvent.Mystery_MSG_ADD,msgAddHandler);
			
//			_countDown.removeEventListener(Event.COMPLETE,cdComplete);
		}
		private function updataItems(evt:StoreModuleEvent):void
		{
			clearItems();
			if(!GlobalData.mysteryShopInfo.getItem(0)) return;
			for(var i:int=0;i<6;i++)
			{
				var shopItem:MysteryShopItemInfo = GlobalData.mysteryShopInfo.getItem(i);
				var item:RefreshableItemView = new RefreshableItemView(shopItem);
				_itemList.push(item);
				_tile.appendItem(item);
			}
		}
		private function updataVipTimes(evt:StoreModuleEvent):void
		{
			_freeRrefresh.setHtmlValue(LanguageManager.getWord("ssztl.store.refreshAmount",GlobalData.mysteryShopInfo.vipTimes));
			if(GlobalData.mysteryShopInfo.vipTimes > 0)
				_btnRefresh.label = LanguageManager.getWord("ssztl.swordsMan.flush") + "(" + GlobalData.mysteryShopInfo.vipTimes + ")";
			else
				_btnRefresh.label = LanguageManager.getWord("ssztl.swordsMan.flush");
		}
		private function updataRefreshTime(evt:StoreModuleEvent):void
		{
//			var diff:Number = Math.max(GlobalData.mysteryShopInfo.lastUpdate + 14400 - GlobalData.systemDate.getSystemDate().time/1000,0);
//			_countDown.start(diff);
		}
//		private function cdComplete(evt:Event):void
//		{
//			MysteryShopGetInfoSocketHandler.send();
//		}
		private function msgAddHandler(evt:MysteryShopMessageEvent):void
		{
			if(_msgViewList == null)
			{
				return;
			}
			var richTextField:RichTextField = RichTextUtil.getOpenBoxRichText(evt.data as String,225);
			_listView.getContainer().addChild(richTextField);
			_msgViewList.unshift(richTextField);
			
			while(_msgViewList.length > 20)
			{
				richTextField = _msgViewList.pop();
				if(_listView.getContainer().contains(richTextField))
				{
					_listView.getContainer().removeChild(richTextField);
					richTextField.dispose();
				}
			}
			
			var currentHeight:int = 0;
			for(var i:int = 0; i < _msgViewList.length; i++)
			{
				_msgViewList[i].y = currentHeight;
				currentHeight += _msgViewList[i].height-8;
			}
			_listView.getContainer().height = currentHeight;
			_listView.update();
			
		}
		private function moneyUpdateHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			_yuanbaoView.setValue(String(GlobalData.selfPlayer.userMoney.yuanBao));
			_copperView.setValue(String(GlobalData.selfPlayer.userMoney.copper));
		}
		private function refreshClickHandler(evt:MouseEvent):void
		{
			if(GlobalData.mysteryShopInfo.vipTimes == 0)
			{
				var result:String = MoneyChecker.priceEnough(1,20,1);
				if(result != "")
				{
					if(GlobalData.canCharge)
					{
						MAlert.show(LanguageManager.getWord("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,chargeAlertHandler);
						function chargeAlertHandler(evt:CloseEvent):void
						{
							if(evt.detail == MAlert.OK)
							{
								JSUtils.gotoFill();
							}
						}
					}else
					{
						QuickTips.show(result + LanguageManager.getWord("ssztl.common.cannotBuy"));
					}
					return;
				}
				var message:String = LanguageManager.getWord("ssztl.common.buyWillCost4",20);
				MYuanbaoAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null,buyMAlertHandler);
			}else
			{
				MysteryShopRefSocketHandler.send();
			}
		}
		private function buyMAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MYuanbaoAlert.OK)
			{
				MysteryShopRefSocketHandler.send();
			}
		}
		private function refreshOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.store.refreshBtnTip"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function tipHide(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		private function clearItems():void
		{
			for(var i:int =0;i<_itemList.length;i++)
			{
				_itemList[i] = null;
			}
			_tile.clearItems();
		}
		private function loadBannerComplete(data:BitmapData):void
		{
			_banner.bitmapData = data;
		}
		
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - PANEL_WIDTH,parent.stage.stageHeight - PANEL_HEIGHT));
		}
		
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		
		private function sizeChangeHandler(evt:CommonModuleEvent):void
		{
			move(Math.round((CommonConfig.GAME_WIDTH - PANEL_WIDTH)/2),Math.round((CommonConfig.GAME_HEIGHT - PANEL_HEIGHT)/2));
		}
		
		private function closeClickHandler(evt:MouseEvent):void
		{
			dispose();
		}
		public function doEscHandler():void
		{
			dispose();
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_upBg)
			{
				_upBg.dispose();
				_upBg = null;
			}
			if(_banner)
			{
				_banner = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_closeBtn)
			{
				_closeBtn.dispose();
				_closeBtn = null;
			}
			if(_btnRefresh)
			{
				_btnRefresh.dispose();
				_btnRefresh = null;
			}
			_listView = null;
//			if(_countDown)
//			{
//				_countDown.dispose();
//				_countDown = null;
//			}
			_freeRrefresh= null;
			_npcSpeak = null;
			_yuanbaoView = null;
			_copperView = null;
			_dragArea = null;
			_mediator = null;
			GlobalAPI.loaderAPI.removeAQuote(_bannerPath, loadBannerComplete);
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
		
	}
}