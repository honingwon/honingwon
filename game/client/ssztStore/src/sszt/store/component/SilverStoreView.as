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
	
	public class SilverStoreView extends MSprite
	{
		private var _mediator:StoreMediator;
		private var _shopType:int;
		private var _goodType:int = 0;
		private var _currentPage:int = 0;
		private var _btns:Array;
		private var _tabPanels:Array;
		private var _yuanBao:MAssetLabel;
		private var _bindYuanBao:MAssetLabel;
		private var _score:MAssetLabel;
		private var _classes:Array;
		private var _pageView:PageView;
		
		private var _assetsComplete:Boolean;
		
		private var _tabViewBox:Sprite;
		
		private var _payBtn:MAssetButton1;
		
		public function SilverStoreView(mediator:StoreMediator,data:ToStoreData)
		{
			_assetsComplete = false;
			_mediator = mediator;
			_shopType = data.type;
			_goodType = data.tabIndex;
			
			init();
			initEvent();
		}
		
		protected function init():void
		{
			_tabViewBox = new Sprite();
			addChild(_tabViewBox);
			
			_classes = [HotGoodTabPanel,RideGoodTabPanel,NormalGoodTabPanel,AutionTabPanel];
			
			//			_btns = new Vector.<MCacheTab1Btn>();
			_btns = new Array();
			var shop:ShopTemplateInfo = ShopTemplateList.getShop(_shopType);
			var startX:int = Math.floor(633-83*(shop.categoryNames.length - 2))/2;
			for(var i:int =0;i<shop.categoryNames.length - 1;i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,i>4?3:2,shop.categoryNames[i]);
				btn.move(3+i*69,-29);
				_btns.push(btn);
				addChild(btn);
			}
			
			_btns[_goodType].selected = true;
			//			_tabPanels = new Vector.<IGoodTabPanel>(_classes.length);
			_tabPanels = new Array();
			
			_pageView = new PageView();
			_pageView.move(250,274);
			addChild(_pageView);
			
			_yuanBao = new MAssetLabel(LanguageManager.getWord("ssztl.common.yuanBao") + "：　 "+String(GlobalData.selfPlayer.userMoney.yuanBao),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_bindYuanBao = new MAssetLabel(LanguageManager.getWord("ssztl.common.bindYuanBao2") + "：　 "+String(GlobalData.selfPlayer.userMoney.bindYuanBao),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_score = new MAssetLabel(LanguageManager.getWord("ssztl.common.YuanBaoScore") + "：　 " +  String(GlobalData.selfPlayer.yuanBaoScore),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			
			_payBtn = new MAssetButton1(new BtnPayAsset() as MovieClip);
			_payBtn.move(521,316);
			addChild(_payBtn);
			
			setTabPanel(_goodType);
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
				_tabPanels[tmpIndex].move(5,5);
			}
			_tabViewBox.addChild(_tabPanels[tmpIndex] as DisplayObject);
			if(tmpIndex < 3)
			{
				_pageView.visible = true;
				var pageSize:int = index==1?6:9;
				_pageView.totalRecord = shop.shopItemInfos[_goodType].length;
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
			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.UPDATE_YUANBAO_SCORE,updateYuanBaoScore);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			
			_payBtn.addEventListener(MouseEvent.CLICK,goPayHandler);
		}
		
		private function removeEvent():void
		{
			for(var i:int =0;i<_btns.length;i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.UPDATE_YUANBAO_SCORE,updateYuanBaoScore);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		
			_payBtn.removeEventListener(MouseEvent.CLICK,goPayHandler);
		}
		private function goPayHandler(evt:MouseEvent):void
		{
			if(GlobalData.functionYellowEnabled)
				JSUtils.gotoFill();
			else
				JSUtils.gotoPage(GlobalData.fillPath2);
		}
		
		private function pageChangeHandler(evt:PageEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			var shop:ShopTemplateInfo = ShopTemplateList.getShop(_shopType);
			_currentPage = _pageView.currentPage - 1;
			var index:int = _goodType>1?2:_goodType;
			if(_goodType == shop.categoryNames.length) index = 3;
			_tabPanels[index].showGoods(_currentPage,_goodType);
		}
		
		private function moneyUpdateHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			_yuanBao.setValue(LanguageManager.getWord("ssztl.common.yuanBao2") + "：　 "+String(GlobalData.selfPlayer.userMoney.yuanBao));
			_bindYuanBao.setValue(LanguageManager.getWord("ssztl.common.bindYuanBao2") + "：　 "+String(GlobalData.selfPlayer.userMoney.bindYuanBao));
		}
		
		private function updateYuanBaoScore(evt:SelfPlayerInfoUpdateEvent):void
		{
			_score.setValue(LanguageManager.getWord("ssztl.common.YuanBaoScore") + "：　 " + String(GlobalData.selfPlayer.yuanBaoScore));
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
			if(_payBtn)
			{
				_payBtn.dispose();
				_payBtn = null;
			}
			_yuanBao = null;
			_bindYuanBao = null;
			_classes = null;
			_mediator = null;
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}