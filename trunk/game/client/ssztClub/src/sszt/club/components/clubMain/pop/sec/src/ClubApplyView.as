package sszt.club.components.clubMain.pop.sec.src
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import sszt.club.components.clubMain.pop.items.ClubApplyItem;
	import sszt.club.datas.tryin.TryinItemInfo;
	import sszt.club.events.TryinUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubClearTryinPageSocketHandler;
	import sszt.club.socketHandlers.ClubClearTryinSocketHandler;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class ClubApplyView extends MSprite implements IClubLogView
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
		private var _list:Array;
		private var _pageView:PageView;
		private var _clearCurrentBtn:MCacheAsset1Btn,_clearAllBtn:MCacheAsset1Btn;
		
		private const PAGESIZE:int = 10;
		
		public function ClubApplyView(mediator:ClubMediator)
		{
			_mediator = mediator;
			_mediator.clubInfo.initTryinInfo();
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(151,2,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(208,2,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(267,2,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(327,2,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(455,2,11,17),new MCacheSplit3Line()),

				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(48,2,64,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.applyPlayerName"),MAssetLabel.LABELTYPE14)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(170,2,28,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.level2"),MAssetLabel.LABELTYPE14)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(230,2,28,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer"),MAssetLabel.LABELTYPE14)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,2,28,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.sex"),MAssetLabel.LABELTYPE14)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(369,2,52,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.applyTime"),MAssetLabel.LABELTYPE14)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(498,2,28,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.operation"),MAssetLabel.LABELTYPE14))
			]);
			addChild(_bg as DisplayObject);
			
			_list = [];
			_tile = new MTile(565,24);
			_tile.setSize(565,320);
			_tile.move(0,28);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = "off";
			_tile.itemGapH = 9;
			addChild(_tile);
			
			_pageView = new PageView(PAGESIZE);
			_pageView.move(460,370);
			addChild(_pageView);
			
			_clearCurrentBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.club.cleanCurPage"));
			_clearCurrentBtn.move(6,368);
			addChild(_clearCurrentBtn);
			_clearAllBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.club.cleanAll"));
			_clearAllBtn.move(101,368);
			addChild(_clearAllBtn);
			
			if(ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty))
			{
				_clearAllBtn.enabled = _clearCurrentBtn.enabled = true;
			}
			else
			{
				_clearAllBtn.enabled = _clearCurrentBtn.enabled = false;
			}
			
//			getData();
		}
		
		private function initEvent():void
		{
			_mediator.clubInfo.clubTryinInfo.addEventListener(TryinUpdateEvent.TRYIN_UPDATE,tryinUpdateHandler);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			_clearCurrentBtn.addEventListener(MouseEvent.CLICK,clearCurrentClickHandler);
			_clearAllBtn.addEventListener(MouseEvent.CLICK,clearAllClickHandler);
		}
		
		private function removeEvent():void
		{
			_mediator.clubInfo.clubTryinInfo.removeEventListener(TryinUpdateEvent.TRYIN_UPDATE,tryinUpdateHandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			_clearCurrentBtn.removeEventListener(MouseEvent.CLICK,clearCurrentClickHandler);
			_clearAllBtn.removeEventListener(MouseEvent.CLICK,clearAllClickHandler);
		}
		
		private function tryinUpdateHandler(e:TryinUpdateEvent):void
		{
			_tile.clearItems();
			for each(var i:ClubApplyItem in _list)
			{
				i.dispose();
			}
			_list.length = 0;
			var list:Array = _mediator.clubInfo.clubTryinInfo.list;
			for each(var j:TryinItemInfo in list)
			{
				var item:ClubApplyItem  = new ClubApplyItem(j,acceptHandler,refuseHandler);
				_list.push(item);
				_tile.appendItem(item);
			}
			_pageView.totalRecord = _mediator.clubInfo.clubTryinInfo.totalListNum;
			if(list.length == 0)
			{
				_clearCurrentBtn.enabled = false;
				_clearAllBtn.enabled = false;
			}else
			{
				_clearCurrentBtn.enabled = true;
				_clearAllBtn.enabled = true;
			}
		}
		
		private function refuseHandler(info:TryinItemInfo):void
		{
			_mediator.refuseTryIn(info.id,_pageView.currentPage,PAGESIZE);
		}
		private function acceptHandler(info:TryinItemInfo):void
		{
			_mediator.acceptTryin(info.id,_pageView.currentPage,PAGESIZE);
		}
		
		private function pageChangeHandler(e:PageEvent):void
		{
			getData();
		}
		
		private function clearCurrentClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			ClubClearTryinPageSocketHandler.send(_pageView.currentPage,PAGESIZE);
		}
		
		private function clearAllClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			ClubClearTryinSocketHandler.send();
		}
		
		private function getData():void
		{
			_mediator.getTryinData(_pageView.currentPage,PAGESIZE);
		}
		
		public function show():void
		{
			_pageView.setPage(1,false);
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
				for each(var item:ClubApplyItem in _list)
				{
					item.dispose();
				}
			}
			_list = null;
			_mediator.clubInfo.clearTryinInfo();
			_mediator = null;
			super.dispose();
		}
	}
}