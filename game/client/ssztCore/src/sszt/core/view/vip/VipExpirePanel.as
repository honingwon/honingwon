package sszt.core.view.vip
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.constData.VipType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToVipData;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.common.ItemBuySocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MYuanbaoAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.BtnAssetClose;
	import ssztui.ui.SplitCompartLine2;
	import ssztui.ui.WinTitleHintAsset;
	
	public class VipExpirePanel extends MSprite implements IPanel
	{
		public static const PANEL_WIDTH:int = 576;
		public static const PANEL_HEIGHT:int = 308;
		
		public static var _instance:VipExpirePanel;
		private var _bg:Bitmap;
		private var _closeBtn:MAssetButton1;
		private var _picPath:String;
		
//		private var _btnPay:MCacheAssetBtn1;
		private var _btnRenewal:MCacheAssetBtn1;
		private var _vipIcon:Array;
		private var _buyBtns:Array;
		private var _vipIds:Array = [206038,206039,206040];
		private var _count:int = 1;
		private var _shopType:int = 1;
		private var _shopItem:ShopItemInfo;
		
		public function VipExpirePanel()
		{
//			super(title, dragable, mode, closeable, toCenter, rect);
//			super(new MCacheTitle1("",new Bitmap(new WinTitleHintAsset())),true,-1,true,true);
//			initView();
		}
		
		private function initView():void
		{
			
			_bg = new Bitmap();
			addChild(_bg);
			
			_btnRenewal = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.renewalVip"));
			_btnRenewal.move(180,143);
//			addChild(_btnRenewal);
			
			_buyBtns = [];
			_vipIcon = [];
			for(var i:int = 0; i<3; i++)
			{
				var icon:Sprite = new Sprite();
				icon.graphics.beginFill(0,0);
				icon.graphics.drawRect(266+88*i,166,53,53);
				icon.graphics.endFill();
				addChild(icon);
				_vipIcon.push(icon);
				
				var buy:MCacheAssetBtn1 = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.buy"));
				buy.move(263+88*i,264);
				addChild(buy);
				_buyBtns.push(buy);
			}
			
			_closeBtn = new MAssetButton1(new BtnAssetClose());
			_closeBtn.move(PANEL_WIDTH-44,50);
			addChild(_closeBtn);
			
			_picPath = GlobalAPI.pathManager.getBannerPath("vipExpired.png");
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
			
//			_btnPay = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.charge"));
//			_btnPay.move(218,77);
//			addChild(_btnPay);
		}
		private function loadAvatarComplete(data:BitmapData):void
		{
			_bg.bitmapData = data;
		}
		public static function getInstance():VipExpirePanel
		{
			if (_instance == null){
				_instance = new VipExpirePanel();
			};
			return (_instance);
		}
		private function initEvents():void
		{
			_closeBtn.addEventListener(MouseEvent.CLICK,closeClickHandler);
			_btnRenewal.addEventListener(MouseEvent.CLICK,renewalHandler);
			for(var i:int = 0; i<3; i++)
			{
				_buyBtns[i].addEventListener(MouseEvent.CLICK,buyClickHandler);
				_vipIcon[i].addEventListener(MouseEvent.MOUSE_OVER,iconOverHandler);
				_vipIcon[i].addEventListener(MouseEvent.MOUSE_OUT,iconOutHandler);
			}
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
//			_btnPay.addEventListener(MouseEvent.CLICK,PayHandler);
		}
		
		private function removeEvents():void
		{
			_closeBtn.removeEventListener(MouseEvent.CLICK,closeClickHandler);
			_btnRenewal.removeEventListener(MouseEvent.CLICK,renewalHandler);
			for(var i:int = 0; i<3; i++)
			{
				_buyBtns[i].removeEventListener(MouseEvent.CLICK,buyClickHandler);
				_vipIcon[i].removeEventListener(MouseEvent.MOUSE_OVER,iconOverHandler);
				_vipIcon[i].removeEventListener(MouseEvent.MOUSE_OUT,iconOutHandler);
			}
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
//			_btnPay.removeEventListener(MouseEvent.CLICK,PayHandler);
		}
		private function renewalHandler(evt:MouseEvent):void
		{
			SetModuleUtils.addVip(new ToVipData(0));
		}
		private function PayHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			JSUtils.gotoFill();
		}
		private function iconOverHandler(evt:MouseEvent):void
		{
			var index:int = _vipIcon.indexOf(evt.currentTarget);
			var itemTemplate:ItemTemplateInfo = ItemTemplateList.getTemplate(_vipIds[index]);
			TipsUtil.getInstance().show(itemTemplate,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function iconOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		private function buyClickHandler(evt:MouseEvent):void
		{
			var index:int = _buyBtns.indexOf(evt.currentTarget);
			
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			
			_shopItem = ShopTemplateList.getShop(_shopType).getItem(_vipIds[index]);
			if(GlobalData.tmpIsYellowVip == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.noYellowVip"));//ssztl.common.noYellowVip:非黄钻用户不能购买或使用VIP卡
				return;
			}
			
			var result:String = _shopItem.priceEnough(_count);
			if(result != "")
			{
				if(_shopItem.payType == 1&&GlobalData.canCharge)
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
			if(!_shopItem.bagHasEmpty(_count))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagLeftSizeNotEnough"));
				return ;
			}
			
			
			var itemTemplateInfo:ItemTemplateInfo = _shopItem.template;
			var message:String = LanguageManager.getWord("ssztl.common.buyWillCost3",_count,_shopItem.template.name,_shopItem.price*_count,_shopItem.getPriceTypeString());
			if(GlobalData.selfPlayer.getVipType() == VipType.NORMAL)
			{
				MYuanbaoAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null, buyMAlertHandler);
			}
			else
			{
				var cardLevel:int;
				var myVipType:int = GlobalData.selfPlayer.getVipType();
				var myLevel:int = myVipType;
				if(itemTemplateInfo.templateId == CategoryType.VIP_WEEK_CARD) cardLevel = VipType.VIP;
				if(itemTemplateInfo.templateId == CategoryType.VIP_MONTH_CARD) cardLevel = VipType.BETTERVIP;
				if(itemTemplateInfo.templateId == CategoryType.VIP_YEAR_CARD) cardLevel = VipType.BESTVIP;
				
				if(myVipType == VipType.OneDay) myLevel = -1;
				if(myVipType == VipType.OneHour) myLevel = -2;
				
				
				if(myLevel == cardLevel)
				{
					MYuanbaoAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null, buyMAlertHandler);
				}
				else if(myLevel > cardLevel)
				{
					MAlert.show(LanguageManager.getWord("ssztl.core.maxVip"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK);
				}else
				{
					var name:String = itemTemplateInfo.name;
					
					var id:int;
					if(GlobalData.selfPlayer.getVipType() == VipType.VIP) id = CategoryType.VIP_WEEK_CARD;
					else if(GlobalData.selfPlayer.getVipType() == VipType.BETTERVIP) id = CategoryType.VIP_MONTH_CARD;
					else if(GlobalData.selfPlayer.getVipType() == VipType.BESTVIP) id = CategoryType.VIP_YEAR_CARD;
					else if(GlobalData.selfPlayer.getVipType() == VipType.OneDay) id = CategoryType.VIP_DAY_CARD;
					else if(GlobalData.selfPlayer.getVipType() == VipType.OneHour) id = CategoryType.VIP_HOUR_CARD;
					var name2:String = ItemTemplateList.getTemplate(id).name;
					
					MAlert.show(LanguageManager.getWord("ssztl.common.useXWillReplaceY",name,name2),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,vipUseCloseHandler);
					function vipUseCloseHandler(evt:CloseEvent):void
					{
						if(evt.detail == MAlert.OK)
						{
							MYuanbaoAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null, buyMAlertHandler);
						}
					}
				}
			}
		}
		private function buyMAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MYuanbaoAlert.OK)
			{
				ItemBuySocketHandler.sendBuy(_shopItem.id,_count,true);
			}
		}
		private function closeClickHandler(evt:MouseEvent):void
		{
			dispose();
		}
		public function doEscHandler():void
		{
			dispose();
		}
		private function sizeChangeHandler(evt:CommonModuleEvent):void
		{
			move(Math.round((CommonConfig.GAME_WIDTH - PANEL_WIDTH)/2),Math.round((CommonConfig.GAME_HEIGHT - PANEL_HEIGHT)/2));
		}
		public function show():void
		{
			initView();
//			GlobalAPI.layerManager.getPopLayer().addChild(this);
			GlobalAPI.layerManager.addPanel(this);
			sizeChangeHandler(null);
			initEvents();
		}
		override public function dispose():void
		{
			removeEvents();
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
			if(_bg)
			{
				_bg = null;
			}
			if(_btnRenewal)
			{
				_btnRenewal.dispose();
				_btnRenewal = null;
			}
//			if(_btnPay)
//			{
//				_btnPay.dispose();
//				_btnPay = null;
//			}
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}