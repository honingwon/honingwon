package sszt.welfare.component.cell
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import mhsm.ui.BarAsset6;
	
	import sszt.constData.CategoryType;
	import sszt.constData.LayerType;
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
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.WelfareEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
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
	import sszt.welfare.component.WelfarePanel;
	
	import ssztui.ui.CellBigBgAsset;
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	import ssztui.welfare.BtnBuyAsset;
	
	
	/**
	 * 抢购物品
	 * @author Administrator
	 * 
	 */
	public class  DiscountCell extends BaseCell implements ITick
	{
		private var _bg:IMovieWrapper;
		private var _cheapItem:CheapItem;
		private var _nameValue:MAssetLabel;
		private var _priceValue:MAssetLabel;
		private var _priceLabel:MAssetLabel;
		private var _newPriceValue:MAssetLabel;
		private var _newPriceLabel:MAssetLabel;
		private var _buyBtn:MAssetButton1;
		private var _goldBg1:Bitmap;
		private var _goldBg2:Bitmap;
		private var _bar5:BarAsset6;
		private var _up:MBitmapButton;
		private var _down:MBitmapButton;
		private var _countValue:TextField;
		private var _count:int = 1;
		private var _shopType:int;
		private var _line:Shape;
		private var _leftCountLabel:MAssetLabel;
		private var _limitCount:MAssetLabel;
		private var _countDowmView:CountDownView;
		private var _noTimeLabel:MAssetLabel;
		private var detal:Number = 0;
		private static const FLASHTIME:int = 15000;
		
		
		public function DiscountCell(type:int)
		{
			_shopType = type;
			_cheapItem = null;
			super();
			initView();
			detal = getTimer();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				/*new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,0,217,84)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,1,211,26),new Bitmap(new StoreBgAsset3())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,28,52,52),new Bitmap(new StoreCellBgAsset())),*/
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(6,24,50,50),new Bitmap(new CellBigBgAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_nameValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_nameValue.move(103,3);
			addChild(_nameValue);
			
			_priceValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_priceValue.move(115,28);
			addChild(_priceValue);
			
			_newPriceValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE21,TextFormatAlign.LEFT);
			_newPriceValue.move(115,50);
			addChild(_newPriceValue);
			
			_priceLabel = new MAssetLabel(LanguageManager.getWord("ssztl.store.price"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_priceLabel.move(62,28);
			addChild(_priceLabel);
			
			_newPriceLabel = new MAssetLabel(LanguageManager.getWord("ssztl.store.curPrice"),MAssetLabel.LABEL_TYPE21,TextFormatAlign.LEFT);
			_newPriceLabel.move(62,50);
			addChild(_newPriceLabel);			
			
			_buyBtn = new MAssetButton1(new BtnBuyAsset());
			_buyBtn.move(150,47);
			addChild(_buyBtn);
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(150,50,46,12),new MAssetLabel(LanguageManager.getWord("ssztl.common.buy"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER)));
			
			var _bit1:DisplayObject = new BackgroundType.BORDER_7();
			_bit1.x = 150;
			_bit1.y = 25;
			_bit1.width = 46;
			_bit1.height = 22;
//			addChild(_bit1);
			_up = new MBitmapButton(new SmallBtnAmountUpAsset());
			_up.move(174,27);
//			addChild(_up);
			_down = new MBitmapButton(new SmallBtnAmountDownAsset());
			_down.move(174,36);
//			addChild(_down);
			_countValue = new TextField();
			_countValue.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc);
			_countValue.type = TextFieldType.INPUT;
			_countValue.autoSize = TextFormatAlign.CENTER;
			_countValue.maxChars = 3;
			_countValue.restrict ="0123456789";
			_countValue.width = 20;
			_countValue.height = 16;
			_countValue.text = "1";
			_countValue.x = 157;
			_countValue.y = 29;
//			addChild(_countValue);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(140,75,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.store.leftNum"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(149,28,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.store.limitCount"),MAssetLabel.LABEL_TYPE24,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(6,75,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.store.leftTime"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			
			_leftCountLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			_leftCountLabel.move(175,75);
			addChild(_leftCountLabel);
			
			_limitCount = new MAssetLabel("",MAssetLabel.LABEL_TYPE24,TextFormatAlign.LEFT);
			_limitCount.move(184,28);
			addChild(_limitCount);
			
			_countDowmView = new CountDownView();
			_countDowmView.setColor(0xd9ad60);
			_countDowmView.move(66,75);
			addChild(_countDowmView);
			
			_noTimeLabel = new MAssetLabel(LanguageManager.getWord("ssztl.store.noLimitedTime"),MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_noTimeLabel.move(104,75);
			addChild(_noTimeLabel);
			_noTimeLabel.visible = false;
			
			_up.addEventListener(MouseEvent.CLICK,upClickHandler);
			_down.addEventListener(MouseEvent.CLICK,downClickHandler);
			_buyBtn.addEventListener(MouseEvent.CLICK,buyHandler);
			_countValue.addEventListener(Event.CHANGE,changeHandler);
			
			this.visible = false;
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
//				ItemBuySocketHandler.sendBuy(_cheapItem.shopInfo.id,_count);
				ItemDiscountBuySocketHandler.send(_cheapItem.shopInfo.id,_count);
			}
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
			_figureBound = new Rectangle(9,27,44,44);
			_levelPic.x = 10;
			_levelPic.y = 28;
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
				_priceValue.setValue(String(_cheapItem.shopInfo.originalPrice));
				
				addGoldIcon();
				
				if(_line && _line.parent) _line.parent.removeChild(_line);
				_line = new Shape();	
				_line.graphics.lineStyle(1,0xFFFFFF);
				_line.graphics.moveTo(117,36);
				_line.graphics.lineTo(118 + _priceValue.textWidth,36);
				_line.graphics.endFill();
				addChild(_line);
				
				_newPriceValue.setValue(String(_cheapItem.shopInfo.price));
				_count = 1;
				_countValue.text = String(_count);
				
				cheapProcess();
			}else
			{
				removeGoldIcon();
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
				_leftCountLabel.setValue("0");
				_limitCount.setHtmlValue("0");
				_countDowmView.visible = false;
				_noTimeLabel.visible = true;
				_noTimeLabel.setValue(LanguageManager.getWord("ssztl.store.noOpen"));
				_buyBtn.enabled = false;
			}
			else if(_cheapItem.cheapType == 1)
			{
				if(_cheapItem.leftCount == 0 || _cheapItem.leftTime == 0) _buyBtn.enabled = false;
				if(_cheapItem.leftTime > 0) _countDowmView.addEventListener(Event.COMPLETE,timeEndHandler);
				if(_cheapItem.leftCount > 0)
				{
					_cheapItem.addEventListener(WelfareEvent.COUNT_CHANGE,countChangeHandler);
					GlobalAPI.tickManager.addTick(this);
				}
				_leftCountLabel.setValue(String(_cheapItem.leftCount));
				_limitCount.setValue(String(_cheapItem.limitCount));
				_countDowmView.start(_cheapItem.leftTime);
			}else if(cheapItem.cheapType == 2)
			{
				if(_cheapItem.leftCount == 0) _buyBtn.enabled = false;
				if(_cheapItem.leftCount > 0)
				{
					_cheapItem.addEventListener(WelfareEvent.COUNT_CHANGE,countChangeHandler);
					GlobalAPI.tickManager.addTick(this);
				}
				_leftCountLabel.setValue(String(_cheapItem.leftCount));
				_limitCount.setValue(String(_cheapItem.limitCount));
				_countDowmView.visible = false;
				_noTimeLabel.visible = true;
				_noTimeLabel.setValue(LanguageManager.getWord("ssztl.store.noLimitedTime"));
			}else
			{
				_leftCountLabel.setValue(LanguageManager.getWord("ssztl.store.noLimitedNum"));	
				_limitCount.setValue(String(_cheapItem.limitCount));
				_countDowmView.visible = true;
				_noTimeLabel.visible = false;
				if(_cheapItem.leftTime > 0) _countDowmView.addEventListener(Event.COMPLETE,timeEndHandler);
				_countDowmView.start(_cheapItem.leftTime);
			}
		}
		
		private function countChangeHandler(evt:WelfareEvent):void
		{
			_leftCountLabel.setValue(String(_cheapItem.leftCount));
			_limitCount.setValue(String(_cheapItem.limitCount));
			if(_cheapItem.leftCount == 0) _buyBtn.enabled = false;
		}
		
		private function timeEndHandler(evt:Event):void
		{
			_buyBtn.enabled = false;
		}
		
		public function addGoldIcon():void
		{
			switch (_cheapItem.shopInfo.payType)
			{
				case 1:
					_goldBg1 = new Bitmap(WelfarePanel.yuanBaoAsset);
					_goldBg2 = new Bitmap(WelfarePanel.yuanBaoAsset);
					break;
				case 2:
					_goldBg1 = new Bitmap(WelfarePanel.bindYuanBaoAsset);
					_goldBg2 = new Bitmap(WelfarePanel.bindYuanBaoAsset);
					break;
				case 3:
					_goldBg1 = new Bitmap(WelfarePanel.copperAsset);
					_goldBg2 = new Bitmap(WelfarePanel.copperAsset);
					break;
				case 4:
					_goldBg1 = new Bitmap(WelfarePanel.bindCopperAsset);
					_goldBg2 = new Bitmap(WelfarePanel.bindCopperAsset);
					break;
				default:
					_goldBg1 = new Bitmap(WelfarePanel.copperAsset);
					_goldBg2 = new Bitmap(WelfarePanel.copperAsset);
					break;
			}
			_goldBg1.x = 97;
			_goldBg1.y = 27;
			addChild(_goldBg1);
			
			_goldBg2.x = 97;
			_goldBg2.y = 49;
			addChild(_goldBg2);
		}
		
		public function removeGoldIcon():void
		{
			if(_goldBg1 && _goldBg1.parent)
			{
				removeChild(_goldBg1);
				removeChild(_goldBg2);
			}
		}
		
		public function get cheapItem():CheapItem
		{
			return _cheapItem;
		}
		
		override protected function getLayerType():String
		{
			return LayerType.STORE_ICON;
		}
		
						
		override public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			_up.removeEventListener(MouseEvent.CLICK,upClickHandler);
			_down.removeEventListener(MouseEvent.CLICK,downClickHandler);
			_buyBtn.removeEventListener(MouseEvent.CLICK,buyHandler);
			_countValue.removeEventListener(Event.CHANGE,changeHandler);
			_cheapItem = null;
			_nameValue = null;
			_priceValue = null;
			_priceLabel = null;
			_newPriceLabel = null;
			_newPriceValue = null;
			_leftCountLabel = null;
			_limitCount = null;
			_noTimeLabel = null;
			if(_countDowmView)
			{
				_countDowmView.dispose();
				_countDowmView = null;
			}
			if(_buyBtn)
			{
				_buyBtn.dispose();
				_buyBtn = null;
			}
			if(_goldBg1 && _goldBg1.parent)
			{
				removeChild(_goldBg1);
				removeChild(_goldBg2);
			}
			_goldBg1 = null;
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
//			if(WelfarePanel.selectBorder.parent == this)
//			{
//				removeChild(WelfarePanel.selectBorder);
//			}
			_countValue = null;
			super.dispose();
		}
	}
}