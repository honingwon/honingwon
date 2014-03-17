package sszt.duplicateStore.component
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mhsm.ui.BarAsset3;
	import mhsm.ui.BarAsset6;
	import mhsm.ui.DownBtnAsset;
	import mhsm.ui.UpBtnAsset;
	
	import mx.messaging.AbstractConsumer;
	
	import sszt.constData.CategoryType;
	import sszt.constData.LayerType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.common.ItemBuySocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.duplicateStore.socket.DuplicateShopBuySockethandler;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.button.MSelectButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset5Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.MCacheAssetBtn2;
	
	import ssztui.store.BtnBuyAsset;
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	
	
	public class StoreCell extends BaseCell
	{
		private var _shopItem:ShopItemInfo;
		private var _nameValue:MAssetLabel;
		private var _priceValue:MAssetLabel;
		private var _priceLabel:MAssetLabel;
		private var _newPriceValue:MAssetLabel;
		private var _newPriceLabel:MAssetLabel;
		private var _buyBtn:MCacheAssetBtn1;
		private var _goldBg2:Bitmap;
		private var _bar5:BarAsset6;
		private var _up:MBitmapButton;
		private var _down:MBitmapButton;
		private var _countValue:TextField;
		private var _count:int = 1;
		private var _shopType:int;
		private var _selected:Boolean;
		private var _selectBg:Shape;
		public var selectArea:Sprite;
		
		
		public function StoreCell(type:int)
		{
			_shopType = type;
			_shopItem = null;
			super();
			initView();
		}
		
		private function upClickHandler(evt:MouseEvent):void
		{
			if(_count >= _shopItem.saleNum) return;
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
			if(int(_countValue.text) >= _shopItem.saleNum)
			{
				_count = _shopItem.saleNum;
				_countValue.text = String(_count);
			}
			else
			{
				_count = int(_countValue.text);
			}
		}
		
		private function buyHandler(evt:MouseEvent):void
		{
			if(_count <= 0) return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var result:String = _shopItem.priceEnough(_count);
			if(result != "")
			{
				if(_shopItem.payType == 1&&GlobalData.canCharge)
				{
					//MAlert.show(LanguageManager.getWord("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,chargeAlertHandler);
					QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnough'));
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
			if(_shopItem.price > 0)
			{
				var message:String = LanguageManager.getWord("ssztl.common.buyWillCost",_count,_shopItem.template.name,_shopItem.price*_count,_shopItem.getPriceTypeString());			
				MAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,buyMAlertHandler);
			}
			else
				DuplicateShopBuySockethandler.sendBuy(_shopItem.id,_count);;
			
		}
		
		private function buyMAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
//				ItemBuySocketHandler.sendBuy(_shopType,_shopItem.templateId,_count,_shopItem.payType);
				DuplicateShopBuySockethandler.sendBuy(_shopItem.id,_count);
			}
		}
					
		private function initView():void
		{
			//205,85
			_nameValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_nameValue.move(65,12);
			addChild(_nameValue);
			
			_newPriceValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE21,TextFormatAlign.LEFT);
			_newPriceValue.move(85,32);
			addChild(_newPriceValue);
					
			_priceValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE24,TextFormatAlign.LEFT);
			_priceValue.move(47,64);
			addChild(_priceValue);
						
			_priceLabel = new MAssetLabel(LanguageManager.getWord("ssztl.store.limitCount"),MAssetLabel.LABEL_TYPE24,TextFormatAlign.LEFT);
			_priceLabel.move(12,64);
			addChild(_priceLabel);
			
//			_newPriceLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.price")+"：",MAssetLabel.LABEL_TYPE21,TextFormatAlign.LEFT);
//			_newPriceLabel.move(62,57);
//			addChild(_newPriceLabel);
					
			_buyBtn = new MCacheAssetBtn1(0,1,LanguageManager.getWord("ssztl.common.buy"));
			_buyBtn.move(119,58);
			addChild(_buyBtn);
//			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(155,60,46,12),new MAssetLabel(LanguageManager.getWord("ssztl.common.buy"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER)));

			var _bit1:DisplayObject = new BackgroundType.BORDER_6();
			_bit1.x = 67;
			_bit1.y = 60;
			_bit1.width = 45;
			_bit1.height = 22;
			addChild(_bit1);
			
			_up = new MBitmapButton(new SmallBtnAmountUpAsset());
			_up.move(90,62);
			addChild(_up);
			
			_down = new MBitmapButton(new SmallBtnAmountDownAsset());
			_down.move(90,71);
			addChild(_down);
			
			_countValue = new TextField();
			_countValue.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc);
			_countValue.type = TextFieldType.INPUT;
			_countValue.maxChars = 3;
			_countValue.width = 22;
			_countValue.height = 14;
			_countValue.x = 70;
			_countValue.y = 64;
			_countValue.text = "1";		
			_countValue.autoSize = TextFormatAlign.CENTER;
			_countValue.restrict ="0123456789";
			addChild(_countValue);
			
			_up.addEventListener(MouseEvent.CLICK,upClickHandler);
			_down.addEventListener(MouseEvent.CLICK,downClickHandler);
			_buyBtn.addEventListener(MouseEvent.CLICK,buyHandler);
			_countValue.addEventListener(Event.CHANGE,changeHandler);
			
//			_selectBg = new Shape();
//			_selectBg.graphics.lineStyle(2,0xffffff,2);
//			_selectBg.graphics.drawRect(0,0,175,92);
//			addChild(_selectBg);
//			_selectBg.visible = false;			
			this.visible = false;
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
		
		override public function getSourceType():int
		{
			return CellType.STORECELL;
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(11,11,44,44);
		}
		
		public function set shopItem(item:ShopItemInfo):void
		{
			if(_shopItem == item) return;
			_shopItem = item;
			if(_shopItem)
			{
				info = _shopItem.template;
			}else
			{
				info = null;
			}
			if(_shopItem)
			{
				this.visible = true;
				_nameValue.textColor = CategoryType.getQualityColor(item.template.quality);
				_nameValue.setValue(item.template.name);
				_priceValue.setValue(String(_shopItem.saleNum));
				
				addGoldIcon();
				
				_newPriceValue.setValue(String(_shopItem.price));
				_count = _shopItem.saleNum;
				_countValue.text = String(_count);
				if(_shopItem.saleNum < 1)
					_buyBtn.enabled = false;
				else
					_buyBtn.enabled = true;
				
			}else
			{
				removeGoldIcon();
				this.visible = false;
			}
		}
				
		public function addGoldIcon():void
		{
			switch (_shopItem.payType)
			{
				case 1:
					_goldBg2 = new Bitmap(StorePanel.yuanBaoAsset);
					break;
				case 2:
					_goldBg2 = new Bitmap(StorePanel.bindYuanBaoAsset);
					break;
				case 3:
					_goldBg2 = new Bitmap(StorePanel.copperAsset);
					break;
				case 4:
					_goldBg2 = new Bitmap(StorePanel.bindCopperAsset);
					break;
				case 9:
					_goldBg2 = new Bitmap(StorePanel.starAsset);
					break;
				default:
					_goldBg2 = new Bitmap();
					break;
			}
			
			_goldBg2.x = 67;
			_goldBg2.y = 33;
			addChild(_goldBg2);
			
			if(_shopItem.payType == 9)
			{
				_goldBg2.y = 31;
			}
		}
		
		public function removeGoldIcon():void
		{
			if(_goldBg2 && _goldBg2.parent)
			{
				removeChild(_goldBg2);
			}
		}
		
		public function get shopItem():ShopItemInfo
		{
			return _shopItem;
		}
		
		override protected function getLayerType():String
		{
			return LayerType.STORE_ICON;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_up.removeEventListener(MouseEvent.CLICK,upClickHandler);
			_down.removeEventListener(MouseEvent.CLICK,downClickHandler);
			_buyBtn.removeEventListener(MouseEvent.CLICK,buyHandler);
			_countValue.removeEventListener(Event.CHANGE,changeHandler);
			_shopItem = null;
			
			_nameValue = null;
			_priceValue = null;
			_priceLabel = null;
			_newPriceLabel = null;
			_newPriceValue = null;
			if(_buyBtn)
			{
				_buyBtn.dispose();
				_buyBtn = null;
			}
			if(_goldBg2 && _goldBg2.parent)
			{
				removeChild(_goldBg2);
			}
			_goldBg2 = null
			_bar5 = null;
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