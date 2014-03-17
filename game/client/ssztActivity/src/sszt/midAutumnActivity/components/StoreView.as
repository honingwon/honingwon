package sszt.midAutumnActivity.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.itemDiscount.ItemDiscountSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.events.WelfareEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.midAutumnActivity.components.item.ShopItem;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.activity.IconStarAsset;
	import ssztui.midAutmn.IntervalAsset;
	
	public class StoreView extends Sprite
	{
		private var _bg:IMovieWrapper;
		
		private var _txtTitle:MAssetLabel;
		private var _txtTime:MAssetLabel;
		private var _txtDetail:MAssetLabel;
		private var _getReward:MCacheAssetBtn1;
		
		private var _tile:MTile;
		
//		private var _icon1:Bitmap;
//		private var _icon2:Bitmap;
//		private var _icon3:Bitmap;
		private var _itemList:Array;
		
		public function StoreView()
		{
			initView();
			initEvent();
			ItemDiscountSocketHandler.sendDiscount();
		}
		public function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(19,42,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.activity.activityTime")+"：",MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(19,64,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.midAutumnActivity.rewardLevel")+"：",MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(19,86,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.scene.activityDescription")+"：",MAssetLabel.LABEL_TYPE20,"left")),
			
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(80,64,15,15),new Bitmap(new IconStarAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(95,64,15,15),new Bitmap(new IconStarAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(110,64,15,15),new Bitmap(new IconStarAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(125,64,15,15),new Bitmap(new IconStarAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(143,180,1,133),new Bitmap(new IntervalAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(279,180,1,133),new Bitmap(new IntervalAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_txtTitle = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_txtTitle.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),20,0xffcc00,true)]);
			_txtTitle.move(211,10);
			addChild(_txtTitle);
			_txtTitle.setHtmlValue(LanguageManager.getWord("ssztl.midAutumnActivity.acName3"));
			
			_txtTime = new MAssetLabel(LanguageManager.getWord("ssztl.midAutumnActivity.endTime"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtTime.move(79,42);
			addChild(_txtTime);
			
			_txtDetail = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtDetail.wordWrap = true;
			_txtDetail.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xfffccc,null,null,null,null,null,null,null,null,null,6)]);
			_txtDetail.setSize(322,68);
			_txtDetail.move(79,86);
			addChild(_txtDetail);
			_txtDetail.setHtmlValue(LanguageManager.getWord("ssztl.midAutumnActivity.acDetail3"));
			
			_tile = new MTile(135,155,3);
			_tile.setSize(407,155);
			_tile.move(8,174);
			_tile.itemGapW = 1;
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			_itemList = [];
			
			for(var i:int = 0; i<3; i++)
			{
				var item:ShopItem = new ShopItem();
				_tile.appendItem(item);
				_itemList.push(item);
			}
		}
		public function initEvent():void
		{
			ModuleEventDispatcher.addModuleEventListener(WelfareEvent.DISCOUNT_UPDATE,discountHandler);
		}
		public function removeEvent():void
		{
			ModuleEventDispatcher.removeModuleEventListener(WelfareEvent.DISCOUNT_UPDATE,discountHandler);
		}
		
		private function discountHandler(evt:WelfareEvent):void
		{
			for(var i:int = 0; i<3; ++i)
			{
				_itemList[i].cheapItem = GlobalData.cheapInfo.cheapItems[i];
			}
		}
		
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function show():void
		{
			
		}
		
		public function assetsCompleteHandler():void
		{
			
		}
		
		public function hide():void
		{
			this.parent.removeChild(this);
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_txtTitle = null;
			_txtTime = null;
			_txtDetail = null;
			_getReward = null;
			if(_tile)
			{
				_tile.disposeItems();
				_tile = null;
			}
			_itemList = null;
		}
		
	}
}