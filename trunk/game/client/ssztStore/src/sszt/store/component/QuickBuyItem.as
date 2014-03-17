package sszt.store.component
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	
	import ssztui.store.BtnBuyAsset;
	import ssztui.ui.CellBigBgAsset;

	public class QuickBuyItem extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _nameValue:MAssetLabel;
		private var _priceValue:MAssetLabel;
		private var _cell:GoodCell;
		private var _buyBtn:MAssetButton1;
		private var _shopItemInfo:ShopItemInfo;
		private var _line:Sprite;
		
		public function QuickBuyItem(shopItemInfo:ShopItemInfo)
		{
			_shopItemInfo = shopItemInfo;
			init();
			initEvent();
		}
		private function init():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(0,10,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(54,37,18,18),new Bitmap(MoneyIconCaches.qqMoneyAsset)),
			]);
			addChild(_bg as DisplayObject);
			
			_cell = new GoodCell();
			_cell.move(0,10);
			addChild(_cell);
			_cell.info = _shopItemInfo.template;
			
			_nameValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT);
			_nameValue.move(54,11);
			addChild(_nameValue);
			_nameValue.setHtmlValue(_shopItemInfo.template.name);
			_nameValue.textColor = CategoryType.getQualityColor(_shopItemInfo.template.quality);
			
			_priceValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_priceValue.move(71,38);
			addChild(_priceValue);
			
			if(GlobalData.tmpIsYellowVip == 1)
			{
				_priceValue.setLabelType(MAssetLabel.LABEL_TYPE22);
				_priceValue.setHtmlValue(Math.floor(_shopItemInfo.price*0.8).toString());
			}
			else
			{
				_priceValue.setLabelType(MAssetLabel.LABEL_TYPE20);
				_priceValue.setHtmlValue(_shopItemInfo.price.toString());
			}
			
			_buyBtn = new MAssetButton1(new BtnBuyAsset());
			_buyBtn.move(107,35);
			addChild(_buyBtn);
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(107,37,50,12),new MAssetLabel(LanguageManager.getWord("ssztl.common.buy"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER)));
			
			_line = new Sprite();
			_line.graphics.beginFill(0,0);
			_line.graphics.drawRect(53,38,16,38);
			_line.graphics.endFill();
			addChild(_line);
		}
		private function initEvent():void
		{
			_buyBtn.addEventListener(MouseEvent.CLICK,buyHandler);
			_line.addEventListener(MouseEvent.MOUSE_OVER,QMoneyOverHandler);
			_line.addEventListener(MouseEvent.MOUSE_OUT,QMoneyOutHandler);
		}
		
		private function removeEvent():void
		{
			_buyBtn.removeEventListener(MouseEvent.CLICK,buyHandler);
			_line.removeEventListener(MouseEvent.MOUSE_OVER,QMoneyOverHandler);
			_line.removeEventListener(MouseEvent.MOUSE_OUT,QMoneyOutHandler);
		}
		
		private function QMoneyOverHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.common.QMoney"),null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		private function QMoneyOutHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		private function buyHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			
			
			if(!_shopItemInfo.bagHasEmpty(1))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagLeftSizeNotEnough"));
				return;
			}
			
			if(_shopItemInfo.payType == 10)
			{	
				JSUtils.funPayToken(_shopItemInfo.id,1);
			}
		}
		public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
		}
		
	}
}