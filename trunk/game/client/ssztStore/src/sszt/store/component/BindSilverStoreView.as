package sszt.store.component
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.shop.ShopTemplateInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.store.component.secs.AutionTabPanel;
	import sszt.store.component.secs.HotGoodTabPanel;
	import sszt.store.component.secs.IGoodTabPanel;
	import sszt.store.component.secs.NormalGoodTabPanel;
	import sszt.store.component.secs.RideGoodTabPanel;
	import sszt.store.mediator.StoreMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.store.BtnPayAsset;
	import ssztui.store.ItemSelectedBgAsset;
	import ssztui.store.TitleAsset;
	import ssztui.store.YellowVipAdAsset;
	import ssztui.ui.BtnAssetClose;
	import ssztui.ui.SplitCompartLine2;
	import ssztui.ui.TitleBackgroundLeftAsset;
	import ssztui.ui.TitleBackgroundRightAsset;
	
	public class BindSilverStoreView extends MSprite
	{
		private var _mediator:StoreMediator;
		private var _shopType:int;
		private var _goodType:int = 0;
		private var _currentPage:int = 0;
		private var _btns:Array;
		private var _tabPanels:Array;
		private var _classes:Array;
		private var _pageView:PageView;
		
		private var _bg:IMovieWrapper;
		private var _assetsComplete:Boolean;
		
		private var _tabViewBox:Sprite;
		private var _titleTip:MAssetLabel;
		
		public function BindSilverStoreView(mediator:StoreMediator,data:ToStoreData)
		{
			_assetsComplete = false;
			_mediator = mediator;
			_shopType = data.type;
			_goodType = 5
			
			init();
			initEvent();
		}
		
		protected function init():void
		{
			_tabViewBox = new Sprite();
			addChild(_tabViewBox);
			
			_titleTip = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.CENTER);
			_titleTip.textColor = 0xffcc66;
			_titleTip.move(316,15);
			addChild(_titleTip);
			_titleTip.setHtmlValue(LanguageManager.getWord("ssztl.common.bangGoldMarketTip"));
			
			_classes = [HotGoodTabPanel];
			
			_btns = new Array();
			var shopCategoryNames:Array = ['绑定银两市场']
			for(var i:int =0;i<shopCategoryNames.length;i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,shopCategoryNames[i]);
				btn.move(94+i*69,40);
				_btns.push(btn);
//				addChild(btn);
			}
			
			//			var btn1:MCacheTabBtn1 = new MCacheTabBtn1(0,2,LanguageManager.getWord("ssztl.store.storeItemSale"));
			//			btn1.move(221 + i*69,34);
			//			_btns.push(btn1);
			//			addChild(btn1);
			
			_btns[0].selected = true;
			//			_tabPanels = new Vector.<IGoodTabPanel>(_classes.length);
			_tabPanels = new Array();
			
			_pageView = new PageView();
			_pageView.move(250,317);
			addChild(_pageView);
			
			setTabPanel(0);
		}
		
		public function assetsCompleteHandler():void
		{
			_assetsComplete = true;
			for(var i:int = 0; i < _tabPanels.length; i++)
			{
				if(_tabPanels[i] != null)
					(_tabPanels[i] as IGoodTabPanel).assetsCompleteHandler();
			}
		}
		
		private function setTabPanel(index:int):void
		{
			var shop:ShopTemplateInfo = ShopTemplateList.getShop(_shopType);
			var tmpIndex:int = index > 1 ? 2 : index;
			if(index == shop.categoryNames.length) tmpIndex = 3;
			if(_tabPanels[tmpIndex] == null)
			{
				_tabPanels[tmpIndex] = new _classes[tmpIndex](_shopType,_mediator);
				if(_assetsComplete)
				{
					(_tabPanels[tmpIndex] as IGoodTabPanel).assetsCompleteHandler();
				}
				_tabPanels[tmpIndex].move(5,47);
			}
			_tabViewBox.addChild(_tabPanels[tmpIndex] as DisplayObject);
			if(tmpIndex < 3)
			{
				_pageView.visible = true;
				var pageSize:int = index==1?6:9;
				_pageView.totalRecord = shop.shopItemInfos[5].length;
				_pageView.pageSize = pageSize;
				_pageView.x = index==1?140:250;
				_tabPanels[tmpIndex].showGoods(_currentPage,_goodType);
			}else
			{
				_tabPanels[tmpIndex].show();
				_pageView.visible = false;
			}	
		}
		
		private function initEvent():void
		{
			for(var i:int =0;i<_btns.length;i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		
		private function removeEvent():void
		{
			for(var i:int =0;i<_btns.length;i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		
		private function pageChangeHandler(evt:PageEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			var shop:ShopTemplateInfo = ShopTemplateList.getShop(_shopType);
			_currentPage = _pageView.currentPage - 1;
			var index:int = _goodType>1?2:_goodType;
			if(_goodType == shop.categoryNames.length) index = 3;
			_tabPanels[0].showGoods(_currentPage,_goodType);
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			var shop:ShopTemplateInfo = ShopTemplateList.getShop(_shopType);
			var index:int = _btns.indexOf(evt.currentTarget);
			if(_goodType == index) return;
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			var tempIndex:int = _goodType > 1 ? 2:_goodType;
			if(_goodType == shop.categoryNames.length) tempIndex = 3;
			_tabPanels[tempIndex].hide();
			_btns[_goodType].selected = false;
			_goodType = index;
			_btns[_goodType].selected = true;
			_currentPage = 0;
			setTabPanel(_goodType);
			_pageView.setPage(_currentPage + 1);
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_btns)
			{
				for(var i:int =0;i<_btns.length;i++)
				{
					_btns[i].dispose();
					_btns[i] = null;
				}
				_btns = null;
			}
			if(_tabPanels)
			{
				for(var j:int=0;j<_tabPanels.length;j++)
				{
					if(_tabPanels[j])
					{
						_tabPanels[j].dispose();
						_tabPanels[j] = null;
					}
				}
				_tabPanels = null;
			}
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			_titleTip = null;
			_classes = null;
			_mediator = null;
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}