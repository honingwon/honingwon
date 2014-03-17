package sszt.store.component
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.store.MysteryShopItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.store.socket.MysteryShopBuySocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MYuanbaoAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	
	import ssztui.store.BtnBuyAsset;
	import ssztui.store.mysticBuyedAsset;
	import ssztui.store.mysticItemAsset;
	import ssztui.ui.CellBigBgAsset;

	public class RefreshableItemView extends MSprite
	{
		private var _shopInfo:MysteryShopItemInfo;
		private var _bg:IMovieWrapper;
		private var _cell:GoodCell;
		private var _nameValue:MAssetLabel;
		private var _priceValue:MAssetLabel;
		private var _buyBtn:MAssetButton1;
		private var _currency:Bitmap;
		private var _buyed:Bitmap;
		
		public function RefreshableItemView(shopInfo:MysteryShopItemInfo)
		{
			_shopInfo = shopInfo;
			initView();
			initEvent();
			setData();
		}
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(0,0,207,87),new Bitmap(new mysticItemAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(16,19,50,50),new Bitmap(new CellBigBgAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_cell = new GoodCell();
			_cell.move(16,19);
			addChild(_cell);
			
			_nameValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_nameValue.move(82,21);
			addChild(_nameValue);
			
			_priceValue = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_priceValue.move(100,48);
			addChild(_priceValue);
			
			_currency = new Bitmap();
			_currency.x = 81;
			_currency.y = 47;
			addChild(_currency);
			
			_buyBtn = new MAssetButton1(new BtnBuyAsset());
			_buyBtn.move(149,57);
			addChild(_buyBtn);
			_buyBtn.label = LanguageManager.getWord("ssztl.common.buy");
//			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(149,59,50,12),new MAssetLabel(LanguageManager.getWord("ssztl.common.buy"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER)));
			
			_buyed = new Bitmap(new mysticBuyedAsset());
			_buyed.x = 134;
			_buyed.y = 40;
			addChild(_buyed);
		}
		private function initEvent():void
		{
			_buyBtn.addEventListener(MouseEvent.CLICK,buyClickHandler);
		}
		private function removeEvent():void
		{
			_buyBtn.removeEventListener(MouseEvent.CLICK,buyClickHandler);
		}
		public function setData():void
		{
			if(!_shopInfo) return;
			
			_cell.info = _shopInfo.template;
				
			_nameValue.textColor = CategoryType.getQualityColor(_shopInfo.template.quality);
			_nameValue.setHtmlValue(_shopInfo.template.name + "×" + _shopInfo.num);
			_priceValue.setValue(String(_shopInfo.price));
			
			if(_shopInfo.isExist)
			{
				_buyBtn.visible = false;
			}else
			{
				_buyed.visible = false;
			}
			addGoldIcon();
		}
		public function addGoldIcon():void
		{
			
			switch (_shopInfo.payType)
			{
				case 1:
					_currency.bitmapData = MoneyIconCaches.yuanBaoAsset;
					break;
				case 2:
					_currency.bitmapData = MoneyIconCaches.bingYuanBaoAsset;
					break;
				case 3:
					_currency.bitmapData = MoneyIconCaches.copperAsset;
					break;
				case 4:
					_currency.bitmapData = MoneyIconCaches.bingCopperAsset;
					break;
				case 10:
					_currency.bitmapData = MoneyIconCaches.qqMoneyAsset;
					break;
				default:
					_currency = new Bitmap();
					break;
			}
		}
		public function buyClickHandler(e:MouseEvent):void
		{
			if(!_shopInfo.bagHasEmpty(_shopInfo.num))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagLeftSizeNotEnough"));
				return;
			}
			var result:String = _shopInfo.priceEnough();
			if(result != "")
			{
				if(_shopInfo.payType == 1&&GlobalData.canCharge)
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
			var message:String = LanguageManager.getWord("ssztl.common.buyWillCost",_shopInfo.num,_shopInfo.template.name,_shopInfo.price,_shopInfo.getPriceTypeString());
			MYuanbaoAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null,buyMAlertHandler);	
//			MysteryShopBuySocketHandler.send(_shopInfo.place);
		}
		private function buyMAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MYuanbaoAlert.OK)
			{
				MysteryShopBuySocketHandler.send(_shopInfo.place);
			}
		}
		override public function dispose():void
		{
			removeEvent();
			_nameValue = null;
			_priceValue = null;
			_shopInfo = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_buyBtn)
			{
				_buyBtn.dispose();
				_buyBtn = null;
			}
			if(_currency)
			{
				_currency = null;
			}
			if(_buyed && _buyed.bitmapData)
			{
				_buyed.bitmapData.dispose();
				_buyed = null;
			}
		}
	}
}