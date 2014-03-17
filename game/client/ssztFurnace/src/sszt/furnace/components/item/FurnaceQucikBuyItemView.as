package sszt.furnace.components.item
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.common.ItemBuySocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.furnace.components.cell.FurnaceBaseCell;
	import sszt.furnace.data.FurnaceInfo;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MYuanbaoAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	
	
	public class FurnaceQucikBuyItemView extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _shopItemInfo:ShopItemInfo;
		private var _cell:FurnaceBaseCell;
		private var _upBtn:MBitmapButton;
		private var _downBtn:MBitmapButton;
		private var _buyText:MAssetLabel;
		private var _buyBtn:MSprite;
		private var _NameLabel:MAssetLabel;
		private var _countLabel:TextField;
		private var _count:int = 1;
		
		public function FurnaceQucikBuyItemView(argShopItemInfo:ShopItemInfo)
		{
			super();
			_shopItemInfo = argShopItemInfo;
			initialView();
			initialEvents();
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(0,0,120,48)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(44,23,44,20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,5,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addChild(_bg as DisplayObject);
			
			_cell = new FurnaceBaseCell();
			_cell.info = _shopItemInfo.template;
			_cell.move(4,5);
			addChild(_cell);
			
			_NameLabel = new MAssetLabel(_shopItemInfo.template.name,MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_NameLabel.textColor = CategoryType.getQualityColor(_shopItemInfo.template.quality);
			_NameLabel.move(43,6);
			addChild(_NameLabel);
			
			_upBtn = new MBitmapButton(new SmallBtnAmountUpAsset());
			_upBtn.move(67,24);
			addChild(_upBtn);
			
			_downBtn = new MBitmapButton(new SmallBtnAmountDownAsset());
			_downBtn.move(67,33);
			addChild(_downBtn);
			
			_buyText = new MAssetLabel("",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			_buyText.setHtmlValue("<u>" + LanguageManager.getWord("ssztl.common.buy") + "</u>");
			_buyText.move(88,26);
			addChild(_buyText);
			
//			_buyBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.buy"));
//			_buyBtn.move(93,19);
			_buyBtn = new MSprite();
			_buyBtn.graphics.beginFill(0xFFFFFF,0);
			_buyBtn.graphics.drawRect(88,27,27,16);
			_buyBtn.graphics.endFill();
			addChild(_buyBtn);
			_buyBtn.buttonMode = true;
			
			_countLabel = new TextField();
			_countLabel.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,TextFormatAlign.CENTER);
			_countLabel.textColor = 0xFFFCCC;
			_countLabel.maxChars = 3;
			_countLabel.restrict = "0123456789";
			_countLabel.text = _count.toString();
			_countLabel.width = 25;
			_countLabel.height = 18;
			_countLabel.type = TextFieldType.INPUT;
			_countLabel.selectable = true;
			_countLabel.x = 46;
			_countLabel.y = 25;
			addChild(_countLabel);
		}
		
		private function initialEvents():void
		{
			_upBtn.addEventListener(MouseEvent.CLICK,upBtnHandler);
			_downBtn.addEventListener(MouseEvent.CLICK,downBtnHandler);
			_buyBtn.addEventListener(MouseEvent.CLICK,buyBtnHandler);
			_countLabel.addEventListener(Event.CHANGE,countLabelHandler);
		}
		
		private function removeEvents():void
		{
			_upBtn.removeEventListener(MouseEvent.CLICK,upBtnHandler);
			_downBtn.removeEventListener(MouseEvent.CLICK,downBtnHandler);
			_buyBtn.removeEventListener(MouseEvent.CLICK,buyBtnHandler);
			_countLabel.removeEventListener(Event.CHANGE,countLabelHandler);
		}
		
		private function upBtnHandler(e:MouseEvent):void
		{
			if(_count < 999)
			{
				_count++;
			}
			updateLabel();
		}
		
		private function downBtnHandler(e:MouseEvent):void
		{
			if(_count > 1)
			{
				_count--;
			}
			updateLabel();
		}
		
		private function countLabelHandler(e:Event):void
		{
			_count = Number(_countLabel.text);
		}
		
		private function buyBtnHandler(e:MouseEvent):void
		{
			
			if(GlobalData.bagInfo.currentSize >= GlobalData.selfPlayer.bagMaxCount)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagFull"));
				return;
			}
			/*
			*/
			var message:String = LanguageManager.getWord("ssztl.common.buyWillCost",_count,_shopItemInfo.template.name, _shopItemInfo.price * _count,_shopItemInfo.getPriceTypeString());
			MYuanbaoAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null,buyMAlertHandler);
		}
		
		private function buyMAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MYuanbaoAlert.OK)
			{
//				ItemBuySocketHandler.sendBuy(101,_shopItemInfo.templateId,_count,_shopItemInfo.payType);
				var result:String = _shopItemInfo.priceEnough(_count);
				if(result != "")
				{
					if(_shopItemInfo.payType == 1&&GlobalData.canCharge)
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
				ItemBuySocketHandler.sendBuy(_shopItemInfo.id,_count);
			}
		}
		
		private function updateLabel():void
		{
			_countLabel.text = _count.toString();
		}
		
		public function get shopItemInfo():ShopItemInfo
		{
			return _shopItemInfo;
		}

		public function set shopItemInfo(value:ShopItemInfo):void
		{
			_shopItemInfo = value;
		}
		
		public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_shopItemInfo = null;
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
			if(_upBtn)
			{
				_upBtn.dispose();
				_upBtn = null;
			}
			if(_downBtn)
			{
				_downBtn.dispose();
				_downBtn = null;
			}
			if(_buyBtn)
			{
				_buyBtn.dispose();
				_buyBtn = null;
			}
			_buyText = null;
			_NameLabel = null;
			_countLabel = null;
		}

	}
}