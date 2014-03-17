package sszt.club.components.clubMain.pop.shop
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.LayerType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.club.ItemUserShopBuySocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ClubBuyItemEvent;
	import sszt.events.ClubModuleEvent;
	import sszt.events.ModuleEvent;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	
	public class ShopItemCell extends BaseCell
	{
		private var _bg:IMovieWrapper;
		private var _shopItemInfo:ShopItemInfo;
		private var _selected:Boolean;
		
		private var _nameValue:MAssetLabel;
		private var _newPriceValue:MAssetLabel;
//		/**
//		 * 商品剩余数量
//		 */	
//		private var _surplusCount:MAssetLabel;
		/**
		 * 商品限购数量
		 */	
		private var _limitCount:MAssetLabel;
		
		private var _up:MBitmapButton;
		private var _down:MBitmapButton;
		private var _countValue:TextField;
		private var _buyBtn:MCacheAssetBtn1;
		
		private var _count:int = 1;
		
		public function ShopItemCell()
		{
			super();
			mouseChildren = mouseEnabled = false;
			initView();
		}
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(67,59,45,22)),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(65,30,55,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.singlePrice"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(11,63,55,17),new MAssetLabel(LanguageManager.getWord("ssztl.store.limitCount"),MAssetLabel.LABEL_TYPE24,TextFormatAlign.LEFT)),
			]);
			addChild(_bg as DisplayObject);
			
			//205,85
			_nameValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_nameValue.move(65,10);
			addChild(_nameValue);
			
			_newPriceValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_newPriceValue.move(100,30);
			addChild(_newPriceValue);
			
//			_surplusCount = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.RIGHT);
//			_surplusCount.move(51,40);
//			addChild(_surplusCount);
//			_surplusCount.setValue("10");
			
			_limitCount = new MAssetLabel("1",MAssetLabel.LABEL_TYPE24,TextFormatAlign.LEFT);
			_limitCount.move(47,64);
			addChild(_limitCount);
			
			_buyBtn = new MCacheAssetBtn1(0,1,LanguageManager.getWord("ssztl.common.buy"));
			_buyBtn.move(120,57);
			addChild(_buyBtn);
			
			_up = new MBitmapButton(new SmallBtnAmountUpAsset());
			_up.move(90,61);
			addChild(_up);
			
			_down = new MBitmapButton(new SmallBtnAmountDownAsset());
			_down.move(90,70);
			addChild(_down);
			
			_countValue = new TextField();
			_countValue.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc);
			_countValue.type = TextFieldType.INPUT;
			_countValue.maxChars = 3;
			_countValue.width = 22;
			_countValue.height = 14;
			_countValue.x = 70;
			_countValue.y = 63;
			_countValue.text = "1";		
			_countValue.autoSize = TextFormatAlign.CENTER;
			_countValue.restrict ="0123456789";
			addChild(_countValue);
			
			_up.addEventListener(MouseEvent.CLICK,upClickHandler);
			_down.addEventListener(MouseEvent.CLICK,downClickHandler);
			_buyBtn.addEventListener(MouseEvent.CLICK,buyHandler);
			_countValue.addEventListener(Event.CHANGE,changeHandler);
			
			ModuleEventDispatcher.addModuleEventListener(ClubBuyItemEvent.CLUB_BUY_ITEM,dataUpdateShop);
			
			this.visible = false;
		}
		
		public function get shopItemInfo():ShopItemInfo
		{
			return _shopItemInfo;
		}
		public function set shopItemInfo(value:ShopItemInfo):void
		{
			if(_shopItemInfo == value)return;
			_shopItemInfo = value;
			if(_shopItemInfo)
			{
				info = _shopItemInfo.template;
				
				_nameValue.textColor = CategoryType.getQualityColor(_shopItemInfo.template.quality);
				_nameValue.setValue(_shopItemInfo.template.name);
				
				_newPriceValue.setValue(_shopItemInfo.price  + _shopItemInfo.getPriceTypeString());
				
				mouseChildren = mouseEnabled = true;
				
				setLimitCountValue();
				this.visible = true;
			}
			else
			{
				info = null;
				mouseChildren = mouseEnabled = false;
				this.visible = false;
			}
		}
		
		private function setLimitCountValue():void
		{
			var obj:Object = GlobalData.clubShopInfo.shopInfo[_shopItemInfo.id];
			var tempCount:int = 0;
			var now:int =  GlobalData.systemDate.getSystemDate().valueOf()*0.001;
			if(obj)
			{
				if((now - obj.itemFinishTime) <= 60*60*24)
				{
					tempCount = _shopItemInfo.saleNum - obj.itemCount;
					_limitCount.text = tempCount.toString();
				}
				else
				{
					_limitCount.text = _shopItemInfo.saleNum.toString();
				}
			}
			else
			{
				_limitCount.text = _shopItemInfo.saleNum.toString();
			}
		}
		
		private function upClickHandler(evt:MouseEvent):void
		{
			if(_count >= shopItemInfo.saleNum) return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_count = _count +1;
			_countValue.text = String(_count);
		}
		
		private function downClickHandler(evt:MouseEvent):void
		{
			if(_count <= 1)
			{
				_count = 1;
			}else
			{
				_count = _count - 1;
				SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			}
			_countValue.text = String(_count);
		}
		
		private function changeHandler(evt:Event):void
		{
			if(int(_countValue.text) >= shopItemInfo.saleNum)
			{
				_count = shopItemInfo.saleNum;
				_countValue.text = String(_count);
			}
			else
			{
				_count = int(_countValue.text);
			}
		}
		
		private function dataUpdateShop(evt:ModuleEvent):void
		{
			if(shopItemInfo)
			{
				if(int(evt.data.id) == shopItemInfo.id)
				{
					setLimitCountValue();
				}
			}
		}	
		
		private function buyHandler(evt:MouseEvent):void
		{
			if(_count <= 0) return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var result:String = shopItemInfo.priceEnough(_count);
			if(result != "")
			{
				QuickTips.show(result + LanguageManager.getWord("ssztl.common.cannotBuy"));
				return;
			}
			if(!shopItemInfo.bagHasEmpty(_count))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagLeftSizeNotEnough"));
				return ;
			}
			if(shopItemInfo.price > 0)
			{
				var message:String = LanguageManager.getWord("ssztl.common.buyWillCost",_count,shopItemInfo.template.name,shopItemInfo.price*_count,shopItemInfo.getPriceTypeString());			
				MAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,buyMAlertHandler);
			}
		}
		
		private function buyMAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				ItemUserShopBuySocketHandler.send(shopItemInfo.id,_count); // 功勋兑换
			}
		}
		
		override public function set locked(value:Boolean):void
		{
			// TODO Auto Generated method stub
			super.locked = value;
			if(value)
			{
				_buyBtn.enabled = false;
			}
			else
			{
				_buyBtn.enabled = true;
			}
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(9,9,44,44);
		}
		override protected function getLayerType():String
		{
			return LayerType.STORE_ICON;
		}
		override public function getSourceType():int
		{
			return CellType.STORECELL;
		}
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
//			addChild(_surplusCount);
		}
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().show(ItemTemplateInfo(info),null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height),false,0,false);
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().hide();
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			if(_selected)
			{
				/*
				_selectedBg = new Shape();
				_selectedBg.graphics.lineStyle(1,0xfff372,1);
				_selectedBg.graphics.drawRoundRect(1,1,36,36,2,2);
				_selectedBg.graphics.endFill();
				*/
				
			}
			else
			{
			}
		}
		override public function dispose():void
		{
			super.dispose();
			_up.removeEventListener(MouseEvent.CLICK,upClickHandler);
			_down.removeEventListener(MouseEvent.CLICK,downClickHandler);
			_buyBtn.removeEventListener(MouseEvent.CLICK,buyHandler);
			_countValue.removeEventListener(Event.CHANGE,changeHandler);
			ModuleEventDispatcher.removeModuleEventListener(ClubBuyItemEvent.CLUB_BUY_ITEM,dataUpdateShop);
			_shopItemInfo = null;
			_limitCount = null;
			_nameValue = null;
			_newPriceValue = null;
//			_surplusCount = null;
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
			if(_up)
			{
				_up.dispose();
				_up = null;
			}
			if(_down)
			{
				_down.dispose();
				_down = null;
			}
			_countValue = null;
		}
		
		
	}
}