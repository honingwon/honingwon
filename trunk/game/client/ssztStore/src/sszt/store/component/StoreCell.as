package sszt.store.component
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mx.effects.easing.Elastic;
	
	import sszt.constData.CategoryType;
	import sszt.constData.LayerType;
	import sszt.core.caches.MoneyIconCaches;
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
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MYuanbaoAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	
	import ssztui.store.BtnBuyAsset;
	import ssztui.store.ItemBgAsset;
	import ssztui.ui.CellBigBgAsset;
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	
	public class StoreCell extends Sprite
	{
		private var _bgBox:Bitmap;
		private var _bg:IMovieWrapper;
		private var _cell:GoodCell;
		
		private var _shopItem:ShopItemInfo;
		private var _nameValue:MAssetLabel;
		private var _priceValue:MAssetLabel;
		private var _newPriceValue:MAssetLabel;
		private var _buyBtn:MAssetButton1;
		
		private var _up:MBitmapButton;
		private var _down:MBitmapButton;
		private var _countValue:TextField;
		private var _count:int = 1;
		private var _shopType:int;
		private var _line:Sprite;
		private var _selected:Boolean;
		private var _selectBg:Shape;
		public var selectArea:Sprite;
		
		private var _goldBg1:Bitmap;
		private var _goldBg2:Bitmap;
		private var _line2:Shape;
		
		public function StoreCell(type:int)
		{
			_shopType = type;
			_shopItem = null;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_bgBox = new Bitmap(new ItemBgAsset());
			addChild(_bgBox);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,31,50,50),new Bitmap(new CellBigBgAsset())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(130,36,18,18),new Bitmap(MoneyIconCaches.qqMoneyAsset)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(130,59,18,18),new Bitmap(MoneyIconCaches.qqMoneyAsset)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(172,38,30,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.QMoney"),MAssetLabel.LABEL_TYPE21,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(172,60,30,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.QMoney"),MAssetLabel.LABEL_TYPE21,TextFormatAlign.LEFT)),
				
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(65,37,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.singlePrice"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(65,59,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.yellowVip")+"：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
			]);
			addChild(_bg as DisplayObject);	
			
			_cell = new GoodCell();
			_cell.move(8,31);
			addChild(_cell);
			
			//205,85
			_nameValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.CENTER);
			_nameValue.move(103,7);
			addChild(_nameValue);
			
			_priceValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_priceValue.move(100,37);
			addChild(_priceValue);
			
			_newPriceValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE22 ,TextFormatAlign.LEFT);
			_newPriceValue.move(100,59);
			addChild(_newPriceValue);
			
			_buyBtn = new MAssetButton1(new BtnBuyAsset());//new MBitmapButton(new BuyBtnAsset());
			_buyBtn.move(151,57);
			addChild(_buyBtn);
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(151,59,50,12),new MAssetLabel(LanguageManager.getWord("ssztl.common.buy"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER)));
			
			//购买数量
			var _bit1:DisplayObject = new BackgroundType.BORDER_7();
			_bit1.x = 155;
			_bit1.y = 33;
			_bit1.width = 46;
			_bit1.height = 22;
//			addChild(_bit1);
			
			_up = new MBitmapButton(new SmallBtnAmountUpAsset());
			_up.move(178,36);
			addChild(_up);
			
			_down = new MBitmapButton(new SmallBtnAmountDownAsset());
			_down.move(178,45);
			addChild(_down);
			
			_countValue = new TextField();
			_countValue.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc);
			_countValue.type = TextFieldType.INPUT;
			_countValue.autoSize = TextFormatAlign.CENTER;
			_countValue.maxChars = 3;
			_countValue.restrict ="0123456789";
			_countValue.x = 156;
			_countValue.y = 37;
			_countValue.width = 25;
			_countValue.height = 16;
			_countValue.text = "1";
			addChild(_countValue);
			
			this.visible = false;
			
			_line = new Sprite();
			_line.graphics.beginFill(0,0);
			_line.graphics.drawRect(131,38,16,38);
			_line.graphics.endFill();
			addChild(_line);
		}
		
		private function initEvent():void
		{
			_up.addEventListener(MouseEvent.CLICK,upClickHandler);
			_down.addEventListener(MouseEvent.CLICK,downClickHandler);
			_buyBtn.addEventListener(MouseEvent.CLICK,buyHandler);
			_countValue.addEventListener(Event.CHANGE,changeHandler);
			
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			_line.addEventListener(MouseEvent.MOUSE_OVER,QMoneyOverHandler);
			_line.addEventListener(MouseEvent.MOUSE_OUT,QMoneyOutHandler);
		}
		
		private function removeEvent():void
		{
			_up.removeEventListener(MouseEvent.CLICK,upClickHandler);
			_down.removeEventListener(MouseEvent.CLICK,downClickHandler);
			_buyBtn.removeEventListener(MouseEvent.CLICK,buyHandler);
			_countValue.removeEventListener(Event.CHANGE,changeHandler);
			
			this.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			_line.removeEventListener(MouseEvent.MOUSE_OVER,QMoneyOverHandler);
			_line.removeEventListener(MouseEvent.MOUSE_OUT,QMoneyOutHandler);
		}
		private function overHandler(evt:MouseEvent):void
		{
			setBrightness(_bgBox,0.04);
		}
		private function outHandler(evt:MouseEvent):void
		{
			setBrightness(_bgBox,0);
		}
		private function QMoneyOverHandler(e:MouseEvent):void
		{
			if(_shopItem && _shopItem.payType == 10)
			{
				TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.common.QMoney"),null,new Rectangle(e.stageX,e.stageY,0,0));
			}
		}
		private function QMoneyOutHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		private function upClickHandler(evt:MouseEvent):void
		{
			if(_count>= 999) return;
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
			_count = int(_countValue.text);
		}
		
		private function buyHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			
			if(GlobalData.functionYellowEnabled &&	(_shopItem.template.templateId == CategoryType.VIP_WEEK_CARD || 
				_shopItem.template.templateId == CategoryType.VIP_MONTH_CARD || 
				_shopItem.template.templateId == CategoryType.VIP_YEAR_CARD) 
				&& GlobalData.tmpIsYellowVip == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.noYellowVip"));//ssztl.common.noYellowVip:非黄钻用户不能购买或使用VIP卡
				return;
			}
			
			if(_count <= 0) return;
			
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
				
				var message:String = LanguageManager.getWord("ssztl.common.buyWillCost",_count,_shopItem.template.name,_shopItem.price*_count,_shopItem.getPriceTypeString());
				
				MYuanbaoAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null,buyMAlertHandler);
			}
		}
		
		private function buyMAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MYuanbaoAlert.OK)
			{
//				ItemBuySocketHandler.sendBuy(_shopType,_shopItem.templateId,_count,_shopItem.payType);
				ItemBuySocketHandler.sendBuy(_shopItem.id,_count);
			}
		}
					
		public function set shopItem(item:ShopItemInfo):void
		{
			if(_shopItem == item) return;
			_shopItem = item;
			if(_shopItem)
			{
				_cell.info = _shopItem.template;
			}else
			{
				_cell.info = null;
			}
			if(_shopItem)
			{
				this.visible = true;
				_nameValue.textColor = CategoryType.getQualityColor(item.template.quality);
				_nameValue.setValue(item.template.name);
//				_nameValue.setHtmlValue("<b>"+item.template.name+"</b>");
				
				
				if(_shopItem.payType== 10)
				{
					_priceValue.setValue(String(_shopItem.price)); //String(_shopItem.originalPrice));
					_newPriceValue.setValue(Math.floor(_shopItem.price*0.8).toString());
				}
				else
				{
					_priceValue.setValue(_shopItem.originalPrice.toString());
					_newPriceValue.setValue(String(_shopItem.price));
				}
				
				addGoldIcon();
				
				
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
				
				if(_shopItem.payType != 10)
				{
					_line2 = new Shape();	
					_line2.graphics.lineStyle(1,0xffffff);
					_line2.graphics.moveTo(100,45);
					_line2.graphics.lineTo(103+_priceValue.textWidth,45);
					_line2.graphics.endFill();
					addChild(_line2);
				}
				
				/*
				if(_line && _line.parent) _line.parent.removeChild(_line);
				_line = new Shape();	
				_line.graphics.lineStyle(1,0xFFFFFF);
				_line.graphics.moveTo(114,43);
				_line.graphics.lineTo(117 + _priceValue.textWidth,43);
				_line.graphics.endFill();
				addChild(_line);
				*/
				_count = 1;
				_countValue.text = String(_count);
				
			}else
			{
				removeGoldIcon();
				this.visible = false;
			}
		}
		public function get shopItem():ShopItemInfo
		{
			return _shopItem;
		}
				
		public function addGoldIcon():void
		{
			
			switch (_shopItem.payType)
			{
				case 1:
					_goldBg1 = new Bitmap(StorePanel.yuanBaoAsset);
					_goldBg2 = new Bitmap(StorePanel.yuanBaoAsset);
					break;
				case 2:
					_goldBg1 = new Bitmap(StorePanel.bindYuanBaoAsset);
					_goldBg2 = new Bitmap(StorePanel.bindYuanBaoAsset);
					break;
				case 3:
					_goldBg1 = new Bitmap(StorePanel.copperAsset);
					_goldBg2 = new Bitmap(StorePanel.copperAsset);
					break;
				case 4:
					_goldBg1 = new Bitmap(StorePanel.bindCopperAsset);
					_goldBg2 = new Bitmap(StorePanel.bindCopperAsset);
					break;
				case 10:
					_goldBg1 = new Bitmap(MoneyIconCaches.qqMoneyAsset);
					_goldBg2 = new Bitmap(MoneyIconCaches.qqMoneyAsset);
					break;
				default:
					_goldBg1 = new Bitmap();
					_goldBg2 = new Bitmap();
					break;
			}
			
			_goldBg1.x = 130;
			_goldBg1.y = 37;
			addChild(_goldBg1);
			
			_goldBg2.x = 130;
			_goldBg2.y = 59;
			addChild(_goldBg2);
			
//			if(_shopItem.payType == 10)
//			{
//				_goldBg1.x = 131;
//				_goldBg2.x = 131;
//			}
		}
		
		public function removeGoldIcon():void
		{
			if(_goldBg1 && _goldBg1.parent)
			{
				removeChild(_goldBg1);
				removeChild(_goldBg2);
			}
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
//				_selectBg.visible = true;
				//StorePanel.selectBorder.move(-4,-4);
				StorePanel.selectBorder.x = 1;
				StorePanel.selectBorder.y = 1;
				addChild(StorePanel.selectBorder);
				
			}
			else
			{
				if(StorePanel.selectBorder.parent == this)
					removeChild(StorePanel.selectBorder);
//				_selectBg.visible = false;
			}
		}
		
		public function dispose():void
		{
			removeEvent();
			_shopItem = null;
			
			_nameValue = null;
			_priceValue = null;
			_newPriceValue = null;
			if(_bgBox && _bgBox.bitmapData)
			{
				_bgBox.bitmapData.dispose();
				_bgBox = null;
			}
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
			if(StorePanel.selectBorder.parent == this)
			{
				removeChild(StorePanel.selectBorder);
			}
			if(_line && _line.parent)
			{
				_line.parent.removeChild(_line);
				_line.graphics.clear();
				_line = null;
			}
			_countValue = null;
		}
		//value取值范围-1~1,对应Flash内容制作工具里的-100%-100%
		public static function setBrightness(obj:DisplayObject,value:Number):void {
			var colorTransformer:ColorTransform = obj.transform.colorTransform;
			var backup_filters:* = obj.filters;
			if (value >= 0) {
				colorTransformer.blueMultiplier = 1-value;
				colorTransformer.redMultiplier = 1-value;
				colorTransformer.greenMultiplier = 1-value;
				colorTransformer.redOffset = 255*value;
				colorTransformer.greenOffset = 255*value;
				colorTransformer.blueOffset = 255*value;
			}
			else {
				value=Math.abs(value)
				colorTransformer.blueMultiplier = 1-value;
				colorTransformer.redMultiplier = 1-value;
				colorTransformer.greenMultiplier = 1-value;
				colorTransformer.redOffset = 0;
				colorTransformer.greenOffset = 0;
				colorTransformer.blueOffset = 0;
			}
			obj.transform.colorTransform = colorTransformer;
			obj.filters = backup_filters;
		}
	}
}