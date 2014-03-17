package sszt.club.components.clubMain.pop.store
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
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
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.club.ClubStoreTitleAsset;
	
	/**
	 * 我的申请选项卡。
	 * 修改：Aron
	 * 时间：2013-5-29
	 * */
	public class ClubStoreApplyView extends Sprite implements IClubStoreView
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _bgTxtTip:MAssetLabel;
		private var _tile:MTile;
		private var _records:Array;
		private var _pager:PageView;
		private const PAGE_SIZE:uint = 6;
		private var _currentPage:int = 1;
		
		public function ClubStoreApplyView(mediator:ClubMediator)
		{
			//super(new MCacheTitle1("",new Bitmap(new ClubStoreTitleAsset())),true,-1);
			//			super(new MCacheTitle1(LanguageManager.getWord("ssztl.club.appliedItemRecords")),true,-1);
			_mediator = mediator;
			initView();
			initEvent();
			ClubStoreAppliedItemRecordsSocketHandler.send(1);
		}
		
		private function initView():void
		{
			//			setContentSize(259,319);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,0,390,214)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,213,390,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(6,6,188,56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(6,64,188,56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(6,122,188,56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(196,6,188,56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(196,64,188,56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(196,122,188,56)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(13,15,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(13,73,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(13,131,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(203,15,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(203,73,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(203,131,38,38),new Bitmap(CellCaches.getCellBg()))
			]);
			addChild(_bg as DisplayObject);
			
			_bgTxtTip = new MAssetLabel(LanguageManager.getWord('ssztl.club.appliedItemRecordsTip'),MAssetLabel.LABEL_TYPE20,TextFieldAutoSize.LEFT);
			addChild(_bgTxtTip);
			_bgTxtTip.move(10,219);
			
			_tile = new MTile(188,56,2);
			_tile.itemGapH = _tile.itemGapW = 2;
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			_tile.setSize(378,172);
			_tile.move(6,6);
			addChild(_tile);
			
			_records = [];
			for(var i:int = 0; i < PAGE_SIZE; i++)
			{
				var record:ClubStoreAppliedItemRecord = new ClubStoreAppliedItemRecord(_mediator);
				_tile.appendItem(record);
				_records.push(record);
			}
			
			_pager = new PageView(6, false, 94);
			_pager.move(149,184);
			addChild(_pager);
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
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function show():void
		{
			//			ClubSelfExploitUpdateSocketHandler.send();
			ClubStoreAppliedItemRecordsSocketHandler.send(1);
		}
		public function assetsCompleteHandler():void{}
		
		public function dispose():void
		{
			removeEvent();
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