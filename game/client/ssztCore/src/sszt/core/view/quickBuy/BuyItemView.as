package sszt.core.view.quickBuy
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
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
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
	import sszt.ui.mcache.btns.MCacheAssetBtn2;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	import ssztui.ui.StoreItemBgAsset;
	
	public class BuyItemView extends Sprite
	{
		private var _id:Number;
		private var _cell:BaseCell;
		private var _name:MAssetLabel;
		private var _price:MAssetLabel;
		private var _nPrice:MAssetLabel;
		private var _count:TextField;
		private var _countValue:int = 1;
		private var _upBtn:MBitmapButton;
		private var _downBtn:MBitmapButton;
		private var _buyBtn:MCacheAssetBtn1;
		private var _line:Shape;
		private var _shopItem:ShopItemInfo;
		private var _bg:IMovieWrapper;
		private var _type:int;
		private static const CLOSE:String = "close";
		
		
		public function BuyItemView(id:Number,type:int)
		{
			super();
			_id = id;
			_type = type;
			_shopItem = ShopTemplateList.getShop(_type).getItem(_id);
			init();
		}
		
		private function init():void
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
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,230,87),new Bitmap(new StoreItemBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,31,50,50),new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(150,36,18,18),new Bitmap(moneyAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(150,59,18,18),new Bitmap(moneyAsset))
				
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(65,37,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.singlePrice"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(65,59,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.yellowVip")+"：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
			]);
			addChild(_bg as DisplayObject);	
			if(_shopItem.payType==10)
			{
				addChild(MBackgroundLabel.getDisplayObject(new Rectangle(65,37,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.singlePrice"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)));
				addChild(MBackgroundLabel.getDisplayObject(new Rectangle(65,59,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.yellowVip")+"：",MAssetLabel.LABEL_TYPE21,TextFormatAlign.LEFT)));
				_price = new MAssetLabel(String(_shopItem.price),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
				_nPrice = new MAssetLabel(String(Math.floor(_shopItem.price*0.8)),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			}
			else
			{
				_price = new MAssetLabel(String(_shopItem.originalPrice),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
				_nPrice = new MAssetLabel(String(_shopItem.price),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
				
				addChild(MBackgroundLabel.getDisplayObject(new Rectangle(65,37,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.store.price"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)));
				addChild(MBackgroundLabel.getDisplayObject(new Rectangle(65,59,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.store.curPrice"),MAssetLabel.LABEL_TYPE21,TextFormatAlign.LEFT)));
			}
			if(_shopItem)
			{
				_name = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
				_name.textColor = CategoryType.getQualityColor(_shopItem.template.quality);
				_name.move(115,7);
				addChild(_name);
				_name.setHtmlValue(_shopItem.template.name);
				//+ + _shopItem.getPriceTypeString()
				
				//String(_shopItem.originalPrice)
				
				_price.move(100,37);
				addChild(_price);
				
				_nPrice.move(100,59);
				addChild(_nPrice);
				
				_cell = new BaseBigCell();
				_cell.info = _shopItem.template;
				_cell.move(8,31);
				addChild(_cell);
				if(_shopItem.payType != 10)
				{
					_line = new Shape();	
					_line.graphics.lineStyle(1,0xffffff);
					_line.graphics.moveTo(100,45);
					_line.graphics.lineTo(103+_price.textWidth,45);
					_line.graphics.endFill();
					addChild(_line);
				}
			}
			
			_count = new TextField();
			_count.width = 30;
			_count.height = 16;
			_count.x = 171;
			_count.y = 37;
			_count.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc);
			_count.type = TextFieldType.INPUT;
			_count.autoSize = TextFormatAlign.CENTER;
			_count.maxChars = 3;
			_count.restrict ="0123456789";
			_count.text = "1";
			addChild(_count);
			
			_upBtn = new MBitmapButton(new SmallBtnAmountUpAsset());
			_upBtn.move(201,36);
			addChild(_upBtn);
			
			_downBtn = new MBitmapButton(new SmallBtnAmountDownAsset());
			_downBtn.move(201,45);
			addChild(_downBtn);
			
			_buyBtn = new MCacheAssetBtn1(0,1,LanguageManager.getWord("ssztl.common.buy"));
			_buyBtn.move(169,56);
			addChild(_buyBtn);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_upBtn.addEventListener(MouseEvent.CLICK,upClickHandler);
			_downBtn.addEventListener(MouseEvent.CLICK,downClickHandler);
			_buyBtn.addEventListener(MouseEvent.CLICK,buyClickHandler);
			_count.addEventListener(Event.CHANGE,changeHandler);
			
//			_line.addEventListener(MouseEvent.MOUSE_OVER,QMoneyOverHandler);
//			_line.addEventListener(MouseEvent.MOUSE_OUT,QMoneyOutHandler);
		}
		
		private function removeEvent():void
		{
			_upBtn.removeEventListener(MouseEvent.CLICK,upClickHandler);
			_downBtn.removeEventListener(MouseEvent.CLICK,downClickHandler);
			_buyBtn.removeEventListener(MouseEvent.CLICK,buyClickHandler);
			_count.removeEventListener(Event.CHANGE,changeHandler);
			
//			_line.removeEventListener(MouseEvent.MOUSE_OVER,QMoneyOverHandler);
//			_line.removeEventListener(MouseEvent.MOUSE_OUT,QMoneyOutHandler);
		}
		private function QMoneyOverHandler(e:MouseEvent):void
		{
			var str:String = "";
			switch(_shopItem.payType)
			{
				case 0:
				{
					str = LanguageManager.getWord("ssztl.common.bindCopper2");
					break;
				}
				case 1:
				{
					str = LanguageManager.getWord("ssztl.common.yuanBao");
					break;
				}
				case 2:
				{
					str = LanguageManager.getWord("ssztl.common.bindYuanBao2");
					break;
				}
				case 3:
				{
					str = LanguageManager.getWord("ssztl.common.copper");
					break;
				}
				case 10:
				{
					str = LanguageManager.getWord("ssztl.common.QMoney");
				}
				default:
				{
					break;
				}
			}
			if(str != "")
				TipsUtil.getInstance().show(str,null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		private function QMoneyOutHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function changeHandler(evt:Event):void
		{
			_countValue = int(_count.text);
		}
		
		private function upClickHandler(evt:MouseEvent):void
		{
			if(_countValue>= 999) return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_countValue = _countValue +1;
			_count.text = String(_countValue);
		}
		
		private function downClickHandler(evt:MouseEvent):void
		{
			if(_countValue <= 1)
			{
				_countValue = 1;
			}else
			{
				_countValue = _countValue - 1;
				SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			}
			_count.text = String(_countValue);
		}
		
		private function buyClickHandler(evt:MouseEvent):void
		{
			if(_countValue <= 0) return;
			if(_shopItem == null) return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(!_shopItem.bagHasEmpty(_countValue))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagLeftSizeNotEnough"));
				return;
			}
			if(_shopItem.payType == 10)
			{
				JSUtils.funPayToken(_shopItem.id,_countValue);
			}
			else
			{
				var result:String = _shopItem.priceEnough(_countValue);
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
				var message:String = LanguageManager.getWord("ssztl.common.buyWillCost",_countValue,_shopItem.template.name, _shopItem.price*_countValue,_shopItem.getPriceTypeString());
				MYuanbaoAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null,buyMAlertHandler);
				BuyPanel.getInstance().dispose();
			}
			
		}
		
		private function buyMAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MYuanbaoAlert.OK)
			{
				ItemBuySocketHandler.sendBuy(_shopItem.id,_countValue);
			}
		}
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
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
			if(_line && _line.parent)
			{
				_line.parent.removeChild(_line);
				_line.graphics.clear();
				_line = null;
			}
			_name = null;
			_price = null;
			_nPrice = null;
			_upBtn.dispose();
			_upBtn = null;
			_downBtn.dispose();
			_downBtn = null;
			_buyBtn.dispose();
			_buyBtn = null;
		}
	}
}