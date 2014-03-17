package sszt.store.component
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.utils.JSUtils;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	
	import ssztui.store.BtnPayYellowAsset1;
	import ssztui.store.BtnPayYellowAsset12;
	import ssztui.store.QuickBuyTitleAsset;
	import ssztui.store.YellowVipAdAsset;
	import ssztui.ui.SplitCompartLine2;

	public class QuickBuyPanel extends MSprite
	{
		private var _bg:IMovieWrapper;
		private var _itemTile:MTile;
		private var _itemList:Array;
		private var _shopItemInfoList:Array;
		/**
		 * 开通黄钻 
		 */
		private var _openYellowBtn:MAssetButton1;
		
		public function QuickBuyPanel()
		{
			var shop:ShopTemplateInfo =ShopTemplateList.getShop(1);
			_shopItemInfoList = shop.getItems(4,0,6);
			
			init();
			initEvent();
		}
		private function init():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_TIP, new Rectangle(0,0,178,435),new Bitmap(new QuickBuyTitleAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,107,178,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,174,178,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,241,178,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,310,178,25),new Bitmap(new SplitCompartLine2())),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(42,13,87,21),new Bitmap(new QuickBuyTitleAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(37,326,104,45),new Bitmap(new YellowVipAdAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_itemTile = new MTile(158,67,1);
			_itemTile.setSize(158,268);
			_itemTile.move(11,41);
			_itemTile.itemGapH = 0;
			_itemTile.horizontalScrollPolicy = _itemTile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_itemTile);
			
			_itemList = [];
			var shopItemInfo:ShopItemInfo;
			for(var i:int = 0; i< 4; i++)
			{
				shopItemInfo = _shopItemInfoList[i]
				var item:QuickBuyItem = new QuickBuyItem(shopItemInfo);
				_itemTile.appendItem(item);
				_itemList.push(item);
			}
			
			/**
			 * 设置续费
			 */	
			
			if(GlobalData.tmpIsYellowVip == 1)
				_openYellowBtn = new MAssetButton1(new BtnPayYellowAsset12() as MovieClip);
			else
				_openYellowBtn = new MAssetButton1(new BtnPayYellowAsset1() as MovieClip);
			_openYellowBtn.move(25,380);
			addChild(_openYellowBtn);
		}
		private function initEvent():void
		{
			_openYellowBtn.addEventListener(MouseEvent.CLICK,openYClick);
		}
		
		private function removeEvent():void
		{
			_openYellowBtn.removeEventListener(MouseEvent.CLICK,openYClick);
		}
		private function openYClick(e:MouseEvent):void
		{
			JSUtils.gotoPayYellow();
		}
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			for(var i:int = 0; i< 4; i++)
			{
				if(_itemList[i])
				{
					_itemList[i].dispose();
					_itemList[i] = null;
				}
			}
			_itemTile = null;
			_itemList = null;
			super.dispose();
		}
	}
}