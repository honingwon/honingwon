package sszt.welfare.component
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.VipType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.welfare.component.view.ContinuousLoginRewardView;
	import sszt.welfare.component.view.DuplicateExpRewardView;
	import sszt.welfare.component.view.GetExpView;
	import sszt.welfare.component.view.HotGoodView;
	import sszt.welfare.component.view.NoVipView;
	import sszt.welfare.component.view.ShowAllRewards;
	import sszt.welfare.component.view.YesVipView;
	import sszt.welfare.mediator.WelfareMediator;
	
	import ssztui.ui.BtnAssetClose;
	import ssztui.ui.SplitCompartLine;
	import ssztui.ui.SplitCompartLine2;
	import ssztui.welfare.ShopBgAsset;
	import ssztui.welfare.ShowAllBgAsset;
	import ssztui.welfare.TagAsset1;
	import ssztui.welfare.TagAsset2;
	import ssztui.welfare.TagAsset3;
	import ssztui.welfare.TagAsset4;
	import ssztui.welfare.TitleAsset;
	
	public class WelfarePanel extends MPanel
	{
		public static var copperAsset:BitmapData;
		public static var bindCopperAsset:BitmapData;
		public static var yuanBaoAsset:BitmapData;
		public static var bindYuanBaoAsset:BitmapData;
		
		public static const DEFAULT_WIDTH:int = 692;
		public static const DEFAULT_HEIGHT:int = 405;
		
		private var _bg:IMovieWrapper;
		private var _bgWelfare:IMovieWrapper;
		
		private var _continuousLoginRewardView:ContinuousLoginRewardView;
		private var _duplicateExpRewardView:DuplicateExpRewardView;
		/**兑换经验*/
		private var _getExp:GetExpView;
		/**vip界面*/
		private var _yesVip:YesVipView;
		/**非vip界面*/	
		private var _noVip:NoVipView;
		/**抢购特区*/
		private var _hotGoodPanel:HotGoodView;
		
		private var _mediator:WelfareMediator;
		private var _tabs:Array;
		private var _tabClasses:Array;
		private var _tabLabel:Array;
		
		/**查看奖励**/
		private var _showAllRewards:MAssetLabel;
		private var _showPanel:ShowAllRewards;
		
		private var _welfareView:Sprite;
		private var _giftExchangeView:GiftExchangeView;
		private var _updatePostView:UpdatePostView;
		private var _currentIndex:int = -1;
		
		public function WelfarePanel(mediator:WelfareMediator)
		{
			copperAsset = MoneyIconCaches.copperAsset;
			bindCopperAsset = MoneyIconCaches.bingCopperAsset;
			yuanBaoAsset = MoneyIconCaches.yuanBaoAsset;
			bindYuanBaoAsset = MoneyIconCaches.bingYuanBaoAsset;
			
			super(new MCacheTitle1("",new Bitmap(new TitleAsset())), true,-1);
			_mediator = mediator;
			initView();
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(DEFAULT_WIDTH,DEFAULT_HEIGHT);
			
		}
		
		protected function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8,25,676,372)),
			]);
			addContent(_bg as DisplayObject);
			
			_welfareView = new Sprite();
			addContent(_welfareView);
			
			_updatePostView = new UpdatePostView();
			_updatePostView.move(13,30);
			addContent(_updatePostView);
			_updatePostView.visible = false;
			
			_giftExchangeView = new GiftExchangeView();			
			_giftExchangeView.move(13,30);
			addContent(_giftExchangeView);
			_giftExchangeView.visible = false;
			
			_tabClasses = [_welfareView,_updatePostView,_giftExchangeView];//,
			_tabLabel = [LanguageManager.getWord('ssztl.welfare.dayWelfare'),LanguageManager.getWord('ssztl.welfare.loginNotice'),LanguageManager.getWord('ssztl.welfare.giftExchange')];//
			_tabs = [];
			for(var i:int=0; i<_tabLabel.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,_tabLabel[i]);
				btn.move(15+i*69,0);
				_tabs.push(btn);
				addContent(btn);
			}
			_tabs[0].selected = true;
			
			_bgWelfare = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(13,30,248,189)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(261,30,208,189)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(13,222,248,169)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(261,222,208,169)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(472,30,207,361),new Bitmap(new ShopBgAsset())),
				
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(23,35,242,26)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(271,35,202,26)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(23,224,242,26)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(271,224,202,26)),				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,299,242,25),new Bitmap(new SplitCompartLine2())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(100,38,76,17),new Bitmap(new TagAsset1())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(330,39,74,17),new Bitmap(new TagAsset2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(83,229,109,17),new Bitmap(new TagAsset3())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(334,229,63,17),new Bitmap(new TagAsset4())),
				
			]);
			_welfareView.addChild(_bgWelfare as DisplayObject);
			
			_continuousLoginRewardView = new ContinuousLoginRewardView();
			_continuousLoginRewardView.move(13,30);
			_welfareView.addChild(_continuousLoginRewardView);
			
			_duplicateExpRewardView = new DuplicateExpRewardView();
			_duplicateExpRewardView.move(261,30);
			_welfareView.addChild(_duplicateExpRewardView);
			
			_getExp = new GetExpView();
			_getExp.move(13,222);
			_welfareView.addChild(_getExp);
			
			_yesVip = new YesVipView();
			_yesVip.move(261,222);
			_welfareView.addChild(_yesVip);
			
			_noVip = new NoVipView(_mediator);
			_noVip.move(261,222);
			_welfareView.addChild(_noVip);
			
			_hotGoodPanel = new HotGoodView(_mediator);
			_hotGoodPanel.move(472,30);
			_welfareView.addChild(_hotGoodPanel);
			
			//查看所有奖励
			_showAllRewards = new MAssetLabel("",MAssetLabel.LABEL_TYPE21,TextFormatAlign.LEFT);
			_showAllRewards.move(180,65);
			_welfareView.addChild(_showAllRewards);
			_showAllRewards.setHtmlValue("<a href=\'event:0\'><u>"+LanguageManager.getWord("ssztl.welfare.showAllRewards")+"</u></font>");
			_showAllRewards.mouseEnabled = true;
			
			initData();
			
			setIndex(0);
		}
		
		private function initData():void
		{
			if(GlobalData.selfPlayer.getVipType() == VipType.NORMAL)
			{
				_yesVip.visible = false;
				_noVip.visible = true;
			}
			else
			{
				_yesVip.visible = true;
				_yesVip.setData(GlobalData.selfPlayer.getVipType());
				_noVip.visible = false;
			}
		}
		
		private function initEvent():void
		{
			for(var i:int =0;i<_tabs.length;i++)
			{
				_tabs[i].addEventListener(MouseEvent.CLICK,tabClickHandler);
			}
			_showAllRewards.addEventListener(TextEvent.LINK,linkClickHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
		}
		
		private function setPanelPosition(e:Event):void
		{
			move( Math.round(CommonConfig.GAME_WIDTH - DEFAULT_WIDTH >> 1), Math.round(CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT >> 1));
		}
		
		private function removeEvent():void
		{
			for(var i:int =0;i<_tabs.length;i++)
			{
				_tabs[i].removeEventListener(MouseEvent.CLICK,tabClickHandler);
			}
			_showAllRewards.removeEventListener(TextEvent.LINK,linkClickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
		}
		private function tabClickHandler(evt:MouseEvent):void
		{
			var index:int = _tabs.indexOf(evt.currentTarget);
			setIndex(index);
		}
		private function setIndex(index:int):void
		{
			if(_currentIndex == index)return;
			if(_currentIndex > -1)
			{
				_tabClasses[_currentIndex].visible = false;
				_tabs[_currentIndex].selected = false;
			}
			_currentIndex = index;
			_tabClasses[_currentIndex].visible = true;
			_tabs[_currentIndex].selected = true;
		}
		private function linkClickHandler(evt:TextEvent):void
		{
			if(_showPanel && _showPanel.parent)
			{
//				_showPanel.parent.removeChild(_showPanel);
				_showPanel.hide();
			}else
			{
				_showPanel = new ShowAllRewards();
				_showPanel.move(262,31);
				addContent(_showPanel);
				_showPanel.show(255,65);
			}
		}
		private function tweenlComplete():void
		{
			_showPanel.visible = false;		
		}
		
		public function assetsCompleteHandler():void
		{
		}
		
		public function get continuousLoginRewardView():ContinuousLoginRewardView
		{
			return _continuousLoginRewardView;
		}
		
		public function get duplicateExpRewardView():DuplicateExpRewardView
		{
			return _duplicateExpRewardView;
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			super.dispose();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			} 
			if(_bgWelfare)
			{
				_bgWelfare.dispose();
				_bgWelfare = null;
			}
			if(_getExp)
			{
				_getExp.dispose();
			}
			if(_yesVip)
			{
				_yesVip.dispose();
			}
			if(_noVip)
			{
				_noVip.dispose();
			}
			if(_hotGoodPanel)
			{
				_hotGoodPanel.dispose();
			}
//			_getExp = null;
//			_yesVip = null;
//			_noVip = null;
//			_hotGoodPanel = null;
			removeEvent();
		}
	}
}