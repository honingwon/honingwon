package sszt.club.components.clubMain.pop.sec.src
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import sszt.club.components.clubMain.pop.items.ClubEventItem;
	import sszt.club.datas.eventInfo.ClubEventItemInfo;
	import sszt.club.events.ClubEventUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubEventUpdateSocketHandler;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class ClubEventView extends MSprite implements IClubLogView
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _pageView:PageView;
		private var _tile:MTile;
		private var _list:Array;
		
		private const PAGESIZE:int = 10;
		
		public function ClubEventView(mediator:ClubMediator)
		{
			_mediator = mediator;
			_mediator.clubInfo.initEventInfo();
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(405,2,11,17),new MCacheSplit3Line()),	
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(176,2,28,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.content"),MAssetLabel.LABELTYPE14)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(476,2,28,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.time"),MAssetLabel.LABELTYPE14))
			]);
			addChild(_bg as DisplayObject);
			
			_pageView = new PageView(PAGESIZE);
			_pageView.move(460,370);
			addChild(_pageView);
			
			_list = [];
			_tile = new MTile(565,20);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = "off";
			_tile.setSize(565,320);
			_tile.itemGapH = 13;
			_tile.move(0,30);
			addChild(_tile);
			
//			getData();
		}
		
		private function initEvent():void
		{
			_mediator.clubInfo.clubEventInfo.addEventListener(ClubEventUpdateEvent.CLUE_EVENT_UPDATE,eventUpdateHandler);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		
		private function removeEvent():void
		{
			_mediator.clubInfo.clubEventInfo.removeEventListener(ClubEventUpdateEvent.CLUE_EVENT_UPDATE,eventUpdateHandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		
		private function eventUpdateHandler(e:ClubEventUpdateEvent):void
		{
			_tile.clearItems();
			_list.length = 0;
			
			var list:Array = _mediator.clubInfo.clubEventInfo.clubEventList;
			for each(var info:ClubEventItemInfo in list)
			{
				var item:ClubEventItem = new ClubEventItem(info);
				_tile.appendItem(item);
				_list.push(item);
			}
			_pageView.totalRecord = _mediator.clubInfo.clubEventInfo.total;
		}
		
		private function pageChangeHandler(e:PageEvent):void
		{
			getData();
		}
		
		private function getData():void
		{
//			ClubEventUpdateSocketHandler.send(_pageView.currentPage,PAGESIZE);
		}
		
		public function show():void
		{
			getData();
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_list)
			{
				for each(var item:ClubEventItem in _list)
				{
					item.dispose();
				}
			}
			_list = null;
			_mediator.clubInfo.clearEventInfo();
			_mediator = null;
			super.dispose();
		}
	}
}