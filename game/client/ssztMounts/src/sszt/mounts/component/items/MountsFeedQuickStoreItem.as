package sszt.mounts.component.items
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.common.ItemBuySocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.cell.BaseBigCell;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MYuanbaoAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	import ssztui.ui.StoreItemBgAsset;
	
	public class MountsFeedQuickStoreItem extends Sprite
	{
		private var _type:int;
		private var _shopItem:ShopItemInfo;
		private var _count:int;
		
		private var _bg:IMovieWrapper;
		private var _cell:BaseBigCell;
		private var _txtName:MAssetLabel;
		private var _txtPrice:MAssetLabel;
		private var _btnUp:MBitmapButton;
		private var _btnDown:MBitmapButton;
		private var _countValue:TextField;
		private var _btnBuy:MCacheAssetBtn1;
		private var _line:Shape;
		
		private var _txtPrice2:MAssetLabel;
		
		public function MountsFeedQuickStoreItem(id:Number, type:int)
		{
			super();
			_type = type;
			_shopItem = ShopTemplateList.getShop(_type).getItem(id);
			_count = 1;
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			var moneyAsset:BitmapData;
			switch(_shopItem.payType)
			{
				case 0:
				{
					moneyAsset = MoneyIconCaches.bingCopperAsset;
					break;
				}
				case 1:
				{
					moneyAsset = MoneyIconCaches.yuanBaoAsset;
					break;
				}
				case 2:
				{
					moneyAsset = MoneyIconCaches.bingYuanBaoAsset;
					break;
				}
				case 3:
				{
					moneyAsset = MoneyIconCaches.copperAsset;
					break;
				}
				case 10:
				{
					moneyAsset = MoneyIconCaches.qqMoneyAsset;
				}
				default:
				{
					break;
				}
			}
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(0,0,230,87)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(61,34,108,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(61,57,108,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(170,34,53,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,31,50,50),new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(148,37,18,18),new Bitmap(moneyAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(148,59,18,18),new Bitmap(moneyAsset)),
				
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(65,37,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.singlePrice"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(65,59,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.yellowVip")+"：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
			]);
			addChild(_bg as DisplayObject);	
			
			if(_shopItem.payType==10)
			{
				addChild(MBackgroundLabel.getDisplayObject(new Rectangle(65,37,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.singlePrice"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)));
				addChild(MBackgroundLabel.getDisplayObject(new Rectangle(65,59,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.yellowVip")+"：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)));
			}
			else
			{
				addChild(MBackgroundLabel.getDisplayObject(new Rectangle(65,37,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.store.price"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)));
				addChild(MBackgroundLabel.getDisplayObject(new Rectangle(65,59,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.store.curPrice"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)));
			}
			
			_cell = new BaseBigCell();
			_cell.info = _shopItem.template;
			_cell.move(8, 31);
			addChild(_cell);
			
			_txtName = new MAssetLabel("", MAssetLabel.LABEL_TYPE20);
			_txtName.textColor = CategoryType.getQualityColor(_shopItem.template.quality);
			_txtName.move(115,10);
			addChild(_txtName);
			_txtName.setHtmlValue(_shopItem.template.name);
			
			_txtPrice = new MAssetLabel(String(_shopItem.originalPrice), MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtPrice.move(100,37);
			addChild(_txtPrice);
			
			_txtPrice2 = new MAssetLabel(_shopItem.price.toString(), MAssetLabel.LABEL_TYPE22, TextFieldAutoSize.LEFT);
			_txtPrice2.move(100,59);
			addChild(_txtPrice2);
			
			if(_shopItem.payType != 10)
			{
				_line = new Shape();	
				_line.graphics.lineStyle(1,0xffffff);
				_line.graphics.moveTo(100,45);
				_line.graphics.lineTo(103+_txtPrice.textWidth,45);
				_line.graphics.endFill();
				addChild(_line);
			}
			
			_countValue = new TextField();
			_countValue.width = 30;
			_countValue.height = 16;
			_countValue.x = 174;
			_countValue.y = 37;
			_countValue.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,TextFormatAlign.CENTER);
			_countValue.maxChars = 3;
			_countValue.restrict = "0123456789";
			_countValue.text = "1";
			_countValue.type = TextFieldType.INPUT;
			_countValue.selectable = true;
			addChild(_countValue);
			
			_btnUp = new MBitmapButton(new SmallBtnAmountUpAsset());
			_btnUp.move(201,36);
			addChild(_btnUp);
			
			_btnDown = new MBitmapButton(new SmallBtnAmountDownAsset());
			_btnDown.move(201,45);
			addChild(_btnDown);
			
			_btnBuy = new MCacheAssetBtn1(0,1,LanguageManager.getWord("ssztl.common.buy"));
			_btnBuy.move(169,56);
			addChild(_btnBuy);
			
		}
		
		private function initEvent():void
		{
			_btnUp.addEventListener(MouseEvent.CLICK,btnUpClickHandler);
			_btnDown.addEventListener(MouseEvent.CLICK,btnDownClickHandler);
			_btnBuy.addEventListener(MouseEvent.CLICK,btnBuyHandler);
			_countValue.addEventListener(Event.CHANGE,changeHandler);
		}
		
		private function removeEvent():void
		{
			_btnUp.removeEventListener(MouseEvent.CLICK,btnUpClickHandler);
			_btnDown.removeEventListener(MouseEvent.CLICK,btnDownClickHandler);
			_btnBuy.removeEventListener(MouseEvent.CLICK,btnBuyHandler);
			_countValue.removeEventListener(Event.CHANGE,changeHandler);
		}
		
		private function changeHandler(event:Event):void
		{
			_count = int(_countValue.text);
		}
		
		private function btnBuyHandler(event:MouseEvent):void
		{
			if(_count <= 0) return;
			if(_shopItem == null) return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(!_shopItem.bagHasEmpty(_count))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagLeftSizeNotEnough"));
				return;
			}
			if(_shopItem.payType == 10)
			{
				JSUtils.funPayToken(_shopItem.id,_count);
			}
			else
			{
				var result:String = _shopItem.priceEnough(_count);
				if(result != "")
				{
					if(_shopItem.payType == 1 && GlobalData.canCharge)
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
				var message:String = LanguageManager.getWord("ssztl.common.buyWillCost",_count,_shopItem.template.name, _shopItem.price*_count,_shopItem.getPriceTypeString());
				MYuanbaoAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null,buyMAlertHandler);
			}
		}
		
		private function buyMAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MYuanbaoAlert.OK)
			{
				ItemBuySocketHandler.sendBuy(_shopItem.id,_count);
			}
		}
		
		private function btnDownClickHandler(event:MouseEvent):void
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
		
		private function btnUpClickHandler(event:MouseEvent):void
		{
			if(_count>= 999) return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_count = _count +1;
			_countValue.text = String(_count);
		}
		
		public function dispose():void
		{
			removeEvent();
			_shopItem = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
			_txtName = null;
			_txtPrice = null;
			if(_btnUp)
			{
				_btnUp.dispose();
				_btnUp = null;
			}
			if(_btnDown)
			{
				_btnDown.dispose();
				_btnDown = null;
			}
			_countValue = null;
			if(_btnBuy)
			{
				_btnBuy.dispose();
				_btnBuy = null;
			}
		}
	}
}