package sszt.midAutumnActivity.components.item
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import mx.messaging.channels.StreamingAMFChannel;
	
	import sszt.constData.CategoryType;
	import sszt.constData.LayerType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.itemDiscount.CheapItem;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.itemDiscount.ItemDiscountBuySocketHandler;
	import sszt.core.socketHandlers.itemDiscount.ItemDiscountUpdateSocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.WelfareEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MYuanbaoAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.ui.CellBigBgAsset;

	public class ShopItem extends BaseCell implements ITick
	{
		private var _bg:IMovieWrapper;
		
//		private var _cell:BigCell;
		private var _nameValue:MAssetLabel;
		private var _priceValue:MAssetLabel;
		private var _limitCount:MAssetLabel;
		private var _buy:MCacheAssetBtn1;
		
		private var _cheapItem:CheapItem;
		private var _count:int = 1;
		
		private var detal:Number = 0;
		private static const FLASHTIME:int = 15000;
		
		public function ShopItem()
		{
			_cheapItem = null;
			super();
			initView();
			detal = getTimer();
		}
		public function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(27,78,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.price")+"：",MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(27,98,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.store.limitCount"),MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(62,77,18,18),new Bitmap(MoneyIconCaches.yuanBaoAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(43,3,50,50),new Bitmap(new CellBigBgAsset()))
			]);
			addChild(_bg as DisplayObject);
			
//			_cell = new BigCell();
//			_cell.move(43,3);
//			addChild(_cell);
			
			_nameValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_nameValue.move(67,58);
			addChild(_nameValue);
//			_name.setHtmlValue("凤凰坐骑礼包");
			
			_priceValue = new MAssetLabel("20",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_priceValue.move(82,78);
			addChild(_priceValue);
			
			_limitCount = new MAssetLabel("5",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			_limitCount.move(62,98);
			addChild(_limitCount);
			
			_buy = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.buy"));
			_buy.move(33,124);
			addChild(_buy);
			_buy.addEventListener(MouseEvent.CLICK,buyHandler);
		}
		
		
		
		private function buyHandler(evt:MouseEvent):void
		{
			if(_count <= 0) return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_count > _cheapItem.maxCount)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.store.overMaxBuyNum"));
				return ;
			}
			if(_count > _cheapItem.leftCount)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.store.itemLeftNotEnough"));
				return;
			}
			var result:String = _cheapItem.shopInfo.priceEnough(_count);
			if(result != "")
			{
				if(_cheapItem.shopInfo.payType == 1 && GlobalData.canCharge)
				{
					MAlert.show(LanguageManager.getWord("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,chargeAlertHandler);
					//					QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnough'));
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
			if(!_cheapItem.shopInfo.bagHasEmpty(_count))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagLeftSizeNotEnough"));
				return ;
			}
			var message:String = LanguageManager.getWord("ssztl.common.buyWillCost",_count,_cheapItem.shopInfo.template.name,_cheapItem.shopInfo.price * _count,_cheapItem.shopInfo.getPriceTypeString());
			
			MYuanbaoAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null,buyMAlertHandler);
		}
		
		private function buyMAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MYuanbaoAlert.OK)
			{
				ItemDiscountBuySocketHandler.send(_cheapItem.shopInfo.id,_count);
			}
		}
		
		public function get cheapItem():CheapItem
		{
			return _cheapItem;
		}
		public function set cheapItem(item:CheapItem):void
		{
			if(_cheapItem == item) return;
			_cheapItem = item;
			if(_cheapItem)
			{
				info = _cheapItem.shopInfo.template;
			}else
			{
				info = null;
			}
			if(_cheapItem)
			{
				this.visible = true;
				_nameValue.textColor = CategoryType.getQualityColor(_cheapItem.shopInfo.template.quality);
				_nameValue.setValue(_cheapItem.shopInfo.template.name);
				
				_priceValue.setValue(String(_cheapItem.shopInfo.price));
				_count = 1;
				_limitCount.text = String(_count);
				cheapProcess();
			}
			else
			{
				this.visible = false;
			}
			
			if((_cheapItem.cheapType == 1 || _cheapItem.cheapType == 1) && _cheapItem.leftCount > 0)
			{
				ItemDiscountUpdateSocketHandler.send(_cheapItem.shopInfo.id);
			}
		}
		
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(getTimer() - detal >= FLASHTIME)
			{
				detal = getTimer();
				if((_cheapItem.cheapType == 1 || _cheapItem.cheapType == 1) && _cheapItem.leftCount > 0)
				{
					ItemDiscountUpdateSocketHandler.send(_cheapItem.shopInfo.id);
				}
			}
		}
		
		private function cheapProcess():void
		{
			if(_cheapItem.cheapType == 0)
			{
				_limitCount.setHtmlValue("0");
				_buy.enabled = false;
			}
			else if(_cheapItem.cheapType == 1)
			{
				if(_cheapItem.leftCount == 0 || _cheapItem.leftTime == 0) _buy.enabled = false;
				if(_cheapItem.leftCount > 0)
				{
					_cheapItem.addEventListener(WelfareEvent.COUNT_CHANGE,countChangeHandler);
					GlobalAPI.tickManager.addTick(this);
				}
				_limitCount.setValue(String(_cheapItem.limitCount));
			}
		}
		
		private function countChangeHandler(evt:WelfareEvent):void
		{
			_limitCount.setValue(String(_cheapItem.limitCount));
			if(_cheapItem.leftCount == 0) _buy.enabled = false;
		}
		
		
		override protected function getLayerType():String
		{
			return LayerType.STORE_ICON;
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(46,6,44,44);
//			_levelPic.x = 10;
//			_levelPic.y = 28;
		}
		
		public function get boundSprite():Sprite
		{
			return _boundSprite;
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().show(info,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height),false,0,false);
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		override public function dispose():void
		{
			_cheapItem.removeEventListener(WelfareEvent.COUNT_CHANGE,countChangeHandler);
			GlobalAPI.tickManager.removeTick(this);
			removeEvent();
			_buy.removeEventListener(MouseEvent.CLICK,buyHandler);
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_nameValue = null;
			_buy = null;
			_priceValue = null;
			_limitCount = null;
		}
	}
}