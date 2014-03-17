package sszt.club.components.clubMain.pop.manage.war
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import sszt.club.components.clubMain.pop.manage.war.itemView.DeclearItemView;
	import sszt.club.datas.war.ClubWarInfo;
	import sszt.club.datas.war.ClubWarItemInfo;
	import sszt.club.events.ClubWarInfoUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.mediators.ClubWarMediator;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class WarDeclearPanel extends Sprite implements IWarPanel
	{
		
		private var _bg:IMovieWrapper;
		private var _mediator:ClubWarMediator;
		private var _pageView:PageView;
		public static const PAGECOUNT:int = 8;
		
		private var _declearItemList:Array;
		private var _mTile:MTile;
		
		public function WarDeclearPanel(argMediator:ClubWarMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
			initialEvents();
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(105,2,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(214,2,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(256,2,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(326,2,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(394,2,11,17),new MCacheSplit3Line()),
						]);
			addChild(_bg as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(28,2,52,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubName"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(139,2,52,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubLeaderName"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(227,2,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.level2"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(270,2,52,17),new MAssetLabel(LanguageManager.getWord("ssztl.club.clubMemberNum"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(339,2,52,17),new MAssetLabel(LanguageManager.getWord("ssztl.club.warState"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(441,2,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.operation"),MAssetLabel.LABELTYPE14)));
			
			_pageView = new PageView(PAGECOUNT);
			_pageView.move(202,301);
			addChild(_pageView);
			
			_declearItemList = [];
			
			_mTile = new MTile(500,34);
			_mTile.itemGapH = _mTile.itemGapW = 0;
			_mTile.setSize(500,396);
			_mTile.move(0,20);
			addChild(_mTile);
			
		}
		
		public function getData():void
		{
			_mediator.getWarDeclearInfo(_pageView.currentPage,PAGECOUNT,"");
		}
		
		private function pageChangeHandler(evt:PageEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			getData();
		}
		
		private function initialEvents():void
		{
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			clubWarInfo.addEventListener(ClubWarInfoUpdateEvent.WAR_DECLEAR_INFO_INIT,initItemList);
		}
		
		private function removeEvents():void
		{
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			clubWarInfo.removeEventListener(ClubWarInfoUpdateEvent.WAR_DECLEAR_INFO_INIT,initItemList);
		}
		
		private function initItemList(e:ClubWarInfoUpdateEvent):void
		{
			clearList();
			var tmpItem:DeclearItemView;
			for each(var i:ClubWarItemInfo in clubWarInfo.warDeclearList)
			{
				tmpItem = new DeclearItemView(_mediator,i,_pageView.currentPage);
				_declearItemList.push(tmpItem);
				_mTile.appendItem(tmpItem);
			}
			_pageView.totalRecord = _mediator.clubInfo.clubWarInfo.declearListTotalNum;
		}
		
		private function clearList():void
		{
			_declearItemList.length = 0;
			_mTile.disposeItems();
		}
		
		
		public function show():void
		{
			getData();
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
			
		}
		
		private function get clubWarInfo():ClubWarInfo
		{
			return _mediator.clubInfo.clubWarInfo;
		}
		
		
		public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			for(var i:int= 0;i < _declearItemList.length;i++)
			{
				_declearItemList[i].dispose();
				_declearItemList[i] = null;
			}
			_declearItemList = null;
			if(_mTile)
			{
				_mTile.dispose();
				_mTile = null;
			}
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
	}
}