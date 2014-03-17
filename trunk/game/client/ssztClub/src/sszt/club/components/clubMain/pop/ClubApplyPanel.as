package sszt.club.components.clubMain.pop
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
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
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel2;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.club.ClubTitleAsset;
	
	public class ClubApplyPanel extends MPanel2
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
		private var _list:Array;
		private var _pageView:PageView;
		private var _clearCurrentBtn:MCacheAssetBtn1,_clearAllBtn:MCacheAssetBtn1;
		
		private const PAGESIZE:int = 6;
		
		public function ClubApplyPanel(mediator:ClubMediator)
		{
			_mediator = mediator;
			_mediator.clubInfo.initTryinInfo();
			super(new MCacheTitle1("",new Bitmap(new ClubTitleAsset())),true,-1);
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			setContentSize(466,255);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_9,new Rectangle(9,4,448,242)),
				new BackgroundInfo(BackgroundType.BORDER_10,new Rectangle(10,211,446,33)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(10,5,446,29)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(150,10,2,19),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(192,10,2,19),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(246,10,2,19),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(287,10,2,19),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(366,10,2,19),new MCacheSplit1Line()),
				
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(9,35,448,25)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(9,60,448,25)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(9,85,448,25)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(9,110,448,25)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(9,135,448,25)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(9,160,448,25)),
				

				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(48,11,64,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.applyPlayerName"),MAssetLabel.LABEL_TYPE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(159,11,28,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.level"),MAssetLabel.LABEL_TYPE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(210,11,28,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer"),MAssetLabel.LABEL_TYPE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(254,11,28,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.sex"),MAssetLabel.LABEL_TYPE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(304,11,52,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.applyTime"),MAssetLabel.LABEL_TYPE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(400,11,28,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.operation"),MAssetLabel.LABEL_TYPE2))
			]);
			
			addContent(_bg as DisplayObject);
			
			_list = [];
			_tile = new MTile(448,25);
			_tile.setSize(448,150);
			_tile.move(9,35);
			_tile.itemGapH = 0;
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = "off";
			addContent(_tile);
			
			_pageView = new PageView(PAGESIZE);
			_pageView.move(164,188);
			addContent(_pageView);
			
			_clearCurrentBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.club.cleanCurPage"));
			_clearCurrentBtn.move(305,216);
			addContent(_clearCurrentBtn);
			_clearAllBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.club.cleanAll"));
			_clearAllBtn.move(381,216);
			addContent(_clearAllBtn);
			
			if(ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty))
			{
				_clearAllBtn.enabled = _clearCurrentBtn.enabled = true;
			}
			else
			{
				_clearAllBtn.enabled = _clearCurrentBtn.enabled = false;
			}
			
			getData();
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