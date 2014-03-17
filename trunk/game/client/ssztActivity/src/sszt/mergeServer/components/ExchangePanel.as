package sszt.mergeServer.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.mergeServer.components.item.ExchangeItem;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.midAutmn.moonCakeIconAsset;
	import ssztui.ui.SplitCompartLine2;

	public class ExchangePanel extends Sprite
	{
		private var _bg:Bitmap;
		private var _itemTile:MTile;
		private var _itemList:Array;
		
		private var _txtTag:MAssetLabel;
		private var _txtTotal:MAssetLabel;
		private var _moonCake:Bitmap;
		private var _btnReturn:MCacheAssetBtn1;
		
		public function ExchangePanel()
		{
			initView();
			initEvent();
		}
		public function initView():void
		{
			_bg = new Bitmap();
			addChild(_bg);
			
			_itemTile = new MTile(80,118,3);
			_itemTile.setSize(298,265);
			_itemTile.move(60,14);
			_itemTile.itemGapW = 29;
			_itemTile.itemGapH = 28;
			_itemTile.horizontalScrollPolicy = _itemTile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_itemTile);
			
			_itemList = [];
			for(var i:int = 0; i<6; i++)
			{
				var item:ExchangeItem = new ExchangeItem();
				_itemTile.appendItem(item);
				_itemList.push(item);
			} 
			
			_moonCake = new Bitmap(new moonCakeIconAsset());
			_moonCake.x = 142;
			_moonCake.y = 303;
			addChild(_moonCake);
			
			_txtTag = new MAssetLabel(LanguageManager.getWord("ssztl.midAutumnActivity.moonCakeTotal"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_txtTag.move(59,302);
			addChild(_txtTag);
			
			_txtTotal = new MAssetLabel("10",MAssetLabel.LABEL_TYPE20,"left");
			_txtTotal.move(160,302);
			addChild(_txtTotal);
			
			_btnReturn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.return"));
			_btnReturn.move(331,296);
			addChild(_btnReturn);
		}
		public function initEvent():void
		{
			_btnReturn.addEventListener(MouseEvent.CLICK,returnClick);
		}
		public function removeEvent():void
		{
			_btnReturn.removeEventListener(MouseEvent.CLICK,returnClick);
		}
		private function returnClick(e:MouseEvent):void
		{
			hide();
		}
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function show():void
		{
			
		}
		public function hide():void
		{
			this.parent.removeChild(this);
		}
		public function assetsCompleteHandler():void
		{
			_bg.bitmapData = AssetUtil.getAsset("ssztui.midAutmn.bgExchangeAsset",BitmapData) as BitmapData;
		}
		public function dispose():void
		{
			removeEvent();
			if(_bg && _bg.bitmapData)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			if(_moonCake && _moonCake.bitmapData)
			{
				_moonCake.bitmapData.dispose();
				_moonCake = null;
			}
			if(_itemTile)
			{
				_itemTile.disposeItems();
				_itemTile = null;
			}
			_txtTag = null;
			_txtTotal = null;
			_btnReturn = null;
			_itemList = null;
		}
	}
}