package sszt.common.vip.component.cell
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.LayerType;
	import sszt.constData.VipType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.common.ItemBuySocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MYuanbaoAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.vip.VipSortTitleAsset1;
	import ssztui.vip.VipSortTitleAsset2;
	import ssztui.vip.VipSortTitleAsset3;
	
	public class VipCardCell extends BaseItemInfoCell
	{
		private var _shopType:int = 1;
		private var _shopItem:ShopItemInfo;
		private var _count:int = 1;
		
		private var _bg:IMovieWrapper;
		private var _txtName:MAssetLabel;
		private var _txtPriceOld:MAssetLabel
		private var _txtPrice:MAssetLabel;
		private var _btnBuy:MCacheAssetBtn1;
		private var _title:Bitmap;
		private var _line:Shape;
		
		public function VipCardCell(templateId:int)
		{
			super();
			_shopItem = ShopTemplateList.getShop(_shopType).getItem(templateId);
			initView();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(	BackgroundType.DISPLAY, new Rectangle(1,38,112,2), new MCacheSplit2Line()),
				new BackgroundInfo(	BackgroundType.DISPLAY, new Rectangle(33,48,50,50), new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(45,108,16,14), new Bitmap(MoneyIconCaches.yuanBaoAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(45,127,16,14), new Bitmap(MoneyIconCaches.yuanBaoAsset)),
				new BackgroundInfo(
					BackgroundType.DISPLAY, new Rectangle(11,107,35,16),
					new MAssetLabel(LanguageManager.getWord("ssztl.store.price"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)
				),
				new BackgroundInfo(
					BackgroundType.DISPLAY, new Rectangle(11,126,35,16),
					new MAssetLabel(LanguageManager.getWord("ssztl.store.curPrice"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)
				),
			]);
			addChild(_bg as DisplayObject);
			
			this.info = _shopItem.template;
			//			_txtName = new MAssetLabel(_shopItem.template.name, MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			//			_txtName.move(51, 0);
			//			addChild(_txtName);
			
			_title = new Bitmap();
			_title.x = 7;
			_title.y = 13;
			addChild(_title);
			if(_shopItem.template.name == LanguageManager.getWord("ssztl.common.vipCard1"))
			{
				_title.bitmapData = new VipSortTitleAsset3();
			}
			else if(_shopItem.template.name == LanguageManager.getWord("ssztl.common.vipCard2"))
			{
				_title.bitmapData = new VipSortTitleAsset2();
			}
			else if(_shopItem.template.name == LanguageManager.getWord("ssztl.common.vipCard3"))
			{
				_title.bitmapData = new VipSortTitleAsset1();
			}
			
			_txtPriceOld = new MAssetLabel(String(_shopItem.originalPrice),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_txtPriceOld.move(63,107);
			addChild(_txtPriceOld);
			
			_txtPrice = new MAssetLabel(String(_shopItem.price), MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtPrice.move(63,126);
			addChild(_txtPrice);
			
			_line = new Shape();	
			_line.graphics.lineStyle(1,0xd9ad60);
			_line.graphics.moveTo(63,115);
			_line.graphics.lineTo(63 + _txtPriceOld.textWidth,115);
			_line.graphics.endFill();
			addChild(_line);
			
			_btnBuy = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.buyAndUse"));
			_btnBuy.move(23,150);
			addChild(_btnBuy);
			_btnBuy.addEventListener(MouseEvent.CLICK, btnBuyClickHandler);
		}
		
		private function btnBuyClickHandler(event:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			
			if(GlobalData.functionYellowEnabled && GlobalData.tmpIsYellowVip == 0)
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
			
			//			var message:String = LanguageManager.getWord("ssztl.common.buyWillCost3",_count,_shopItem.template.name,_shopItem.price*_count,_shopItem.getPriceTypeString());
			//			MYuanbaoAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null, buyMAlertHandler);
		}
		
		private function buyMAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MYuanbaoAlert.OK)
			{
				ItemBuySocketHandler.sendBuy(_shopItem.id,_count,true);
			}
		}
		
		/**
		 * 初始化物品图标的位置和大小
		 * */
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(36,51,44,44);
		}
		
		override protected function getLayerType():String
		{
			return LayerType.STORE_ICON;
		}
		
		override public function dispose():void
		{
			_btnBuy.removeEventListener(MouseEvent.CLICK, btnBuyClickHandler);
			if(_shopItem)
			{
				_shopItem = null;
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_title){
				_title.bitmapData.dispose();
				_title = null;
			}
			if(_txtName)
			{
				_txtName = null;
			}
			if(_txtPrice)
			{
				_txtPrice = null;
			}
			if(_line)
			{
				_line.graphics.clear();
				_line = null;
			}
			if(_txtPriceOld)
			{
				_txtPriceOld = null;
			}
			if(_btnBuy)
			{
				_btnBuy.dispose();
				_btnBuy = null;
			}
			
			super.dispose();
		}
	}
}