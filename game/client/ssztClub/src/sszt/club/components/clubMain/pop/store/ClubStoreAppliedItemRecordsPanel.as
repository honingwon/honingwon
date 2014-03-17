package sszt.club.components.clubMain.pop.store
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	
	import sszt.club.events.ClubStoreUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubStoreAppliedItemRecordsSocketHandler;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.club.ClubStoreTitleAsset;
	
	public class ClubStoreAppliedItemRecordsPanel extends MPanel
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _bgTxtTip:MAssetLabel;
		private var _tile:MTile;
		private var _records:Array;
		private var _pager:PageView;
		private const PAGE_SIZE:uint = 5;
		private var _currentPage:int = 1;
		
		public function ClubStoreAppliedItemRecordsPanel(mediator:ClubMediator)
		{
			//super(new MCacheTitle1("",new Bitmap(new ClubStoreTitleAsset())),true,-1);
			super(new MCacheTitle1(LanguageManager.getWord("ssztl.club.appliedItemRecords")),true,-1);
			_mediator = mediator;
			initView();
			initEvent();
			ClubStoreAppliedItemRecordsSocketHandler.send(1);
		}
		
		private function initView():void
		{
			setContentSize(259,319);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,3,243,311)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(13,8,233,48)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(13,58,233,48)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(13,108,233,48)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(13,158,233,48)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(13,208,233,48))
			]);
			addContent(_bg as DisplayObject);
			
			_bgTxtTip = new MAssetLabel(LanguageManager.getWord('ssztl.club.appliedItemRecordsTip'),MAssetLabel.LABEL_TYPE_EN,TextFieldAutoSize.LEFT);
			addContent(_bgTxtTip);
			_bgTxtTip.move(35,288);
			
			_tile = new MTile(233,48);
			_tile.itemGapH = 2;
			_tile.itemGapW = 0;
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			_tile.setSize(233,248);
			_tile.move(13,8);
			addContent(_tile);
			
			_records = [];
			for(var i:int = 0; i < PAGE_SIZE; i++)
			{
				var record:ClubStoreAppliedItemRecord = new ClubStoreAppliedItemRecord(_mediator);
				_tile.appendItem(record);
				_records.push(record);
			}
			
			_pager = new PageView(5, false, 94);
			_pager.move(82,260);
			addContent(_pager);
		}
		
		private function initEvent():void
		{
			_pager.addEventListener(PageEvent.PAGE_CHANGE, pageChangeHandler);
			_mediator.clubInfo.clubStoreInfo.addEventListener(ClubStoreUpdateEvent.APPLIED_ITEM_RECORDS_UPDATE, appliedItemRecordsUpdateHandler);
		}
		
		private function removeEvent():void
		{
			_pager.removeEventListener(PageEvent.PAGE_CHANGE, pageChangeHandler);
			if(_mediator.clubInfo.clubStoreInfo)
			{
				_mediator.clubInfo.clubStoreInfo.removeEventListener(ClubStoreUpdateEvent.APPLIED_ITEM_RECORDS_UPDATE, appliedItemRecordsUpdateHandler);
			}
		}
		
		public function get pager():PageView
		{
			return _pager;
		}
		
		public function set currentPage(page:int):void
		{
			_currentPage = page;
		}
		
		private function pageChangeHandler(event:Event):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			_currentPage = _pager.currentPage;
			ClubStoreAppliedItemRecordsSocketHandler.send(_currentPage);
		}
		
		private function appliedItemRecordsUpdateHandler(event:Event):void
		{
			clearRecordsView();
			var list:Array = _mediator.clubInfo.clubStoreInfo.appliedItemRecords;
			var total:int = _mediator.clubInfo.clubStoreInfo.appliedItemRecordsTotal;
			for(var i:int = 0; i < list.length; i++)
			{
				(_records[i] as ClubStoreAppliedItemRecord).recordInfo = list[i];
			}
			_pager.totalRecord = total;
			_pager.setPage(_currentPage);
		}
		
		private function clearRecordsView():void
		{
			for(var i:int = 0; i < _records.length; i++)
			{
				if( (_records[i] as ClubStoreAppliedItemRecord).recordInfo )
				{
					(_records[i] as ClubStoreAppliedItemRecord).recordInfo = null;
				}
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_records)
			{
				for(var i:int = 0; i<_records.length; i++)
				{
					_records[i].dispose();
				}
				_records = null;
			}
			if(_pager)
			{
				_pager.dispose();
				_pager = null;
			}
			if(_bgTxtTip)
			{
				_bgTxtTip = null;
			}
			if(_mediator)
			{
				_mediator = null;
			}
		}
	}
}