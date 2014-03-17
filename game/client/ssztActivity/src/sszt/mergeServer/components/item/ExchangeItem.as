package sszt.mergeServer.components.item
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.midAutmn.moonCakeIconAsset;
	import ssztui.ui.CellBgAsset;

	public class ExchangeItem extends Sprite
	{
		private var _bg:IMovieWrapper;
		
		private var _name:MAssetLabel;
		private var _price:MAssetLabel;
		private var _buy:MCacheAssetBtn1;
		
		public function ExchangeItem()
		{
			initView();
			initEvent();
		}
		public function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(23,28,38,38),new Bitmap(new CellBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(21,70,16,16),new Bitmap(new moonCakeIconAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_name = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_name.move(39,8);
			addChild(_name);
			_name.setHtmlValue("铁");
			
			_price = new MAssetLabel("20",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_price.move(39,70);
			addChild(_price);
			
			_buy = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.scene.exchange"));
			_buy.move(20,94);
			addChild(_buy);
		}
		public function initEvent():void
		{
		}
		public function removeEvent():void
		{
			
		}
		public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_name = null;
			_buy = null;
			_price = null;
		}
	}
}