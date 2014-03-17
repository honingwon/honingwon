package sszt.club.components.clubMain.pop.store
{
	import fl.controls.ComboBox;
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import sszt.club.datas.storeInfo.ClubStoreRecordInfo;
	import sszt.club.datas.storeInfo.StoreEventItemInfo;
	import sszt.club.events.ClubStoreUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubStoreEventSocketHandler;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	/**
	 * 修改：王鸿源(honingwon@gmail.com)
	 * 时间：2012-10-17
	 * */
	public class ClubStoreEventView extends Sprite implements IClubStoreView
	{
		public static const OPERATION_CODE_GET:int = 0;
		public static const OPERATION_CODE_ADD:int = 1;
		public static const OPERATION_CODE_ALL:int = 2;
		
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _listView:MScrollPanel;
		
		private var _tableHeadDate:MAssetLabel;
		private var _tableHeadContent:MAssetLabel;
		private var _tableHeadFilter:ComboBox;
		private var _tile:MTile;
		private var _tileGet:MTile;
		private var _tileAdd:MTile;
		private var _records:Array;
		private var _recordsAdd:Array;
		private var _recordsGet:Array;
		private var _pager:PageView;
		private var _currentPage:int = 1;
		private var _currentType:int = OPERATION_CODE_ALL;
		
		private const PAGE_SIZE:int = 8;
		
		public function ClubStoreEventView(mediator:ClubMediator)
		{
			_mediator = mediator;
			super();
			initView();
			initEvent();			
			ClubStoreEventSocketHandler.send();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,0,390,239)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(4,4,382,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(95,5,2,19),new MCacheSplit1Line()),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(317,5,2,19),new MCacheSplit1Line()),
				
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(4,26,364,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(4,56,364,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(4,86,364,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(4,116,364,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(4,146,364,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(4,176,364,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(4,206,364,2)),
			]);
			addChildAt(DisplayObject(_bg),0);
			
//			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(340,7,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.operation"),MAssetLabel.LABEL_TYPE_TITLE)));
			
			_tableHeadDate = new MAssetLabel(LanguageManager.getWord('ssztl.common.time'),MAssetLabel.LABEL_TYPE_TITLE2,TextFieldAutoSize.LEFT);
			addChild(_tableHeadDate);
			_tableHeadDate.move(37,7);
			
			_tableHeadContent = new MAssetLabel(LanguageManager.getWord('ssztl.club.content'),MAssetLabel.LABEL_TYPE_TITLE2,TextFieldAutoSize.LEFT);
			addChild(_tableHeadContent);
			_tableHeadContent.move(195,7);			
			
			_tile = new MTile(382,30);
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.verticalScrollPolicy = ScrollPolicy.AUTO;
			_tile.verticalScrollBar.lineScrollSize = 30;
			_tile.setSize(383, 30 * 7);
			addChild(_tile);
			_tile.move(4,27);
			
			_tileGet = new MTile(382,25);
			_tileGet.itemGapH = _tile.itemGapW = 0;
			_tileGet.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tileGet.verticalScrollPolicy = ScrollPolicy.AUTO;
			_tileGet.verticalScrollBar.lineScrollSize = 30;
			_tileGet.setSize(383, 30 * 7);
			addChild(_tileGet);
			_tileGet.move(4,27);
			_tileGet.visible = false;
			
			_tileAdd = new MTile(382,30);
			_tileAdd.itemGapH = _tile.itemGapW = 0;
			_tileAdd.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tileAdd.verticalScrollPolicy = ScrollPolicy.AUTO;
			_tileAdd.verticalScrollBar.lineScrollSize = 30;
			_tileAdd.setSize(383, 30 * 7);
			addChild(_tileAdd);
			_tileAdd.move(4,27);
			_tileAdd.visible = false;
			
			_pager = new PageView(PAGE_SIZE, false, 133);
			addChild(_pager);
			_pager.move(128, 233);
			_pager.visible = false;
			
			_tableHeadFilter = new ComboBox();
			_tableHeadFilter.setSize(69, 22);
			_tableHeadFilter.addItem(
				{
					label : LanguageManager.getWord('ssztl.common.all'),
					data : OPERATION_CODE_ALL
				}
			);
			_tableHeadFilter.addItem(
				{
					label : ClubStoreRecord.TYPE_TXT_GET,
					data : OPERATION_CODE_GET
				}
			);
			_tableHeadFilter.addItem(
				{
					label : ClubStoreRecord.TYPE_TXT_ADD,
					data : OPERATION_CODE_ADD
				}
			);
			addChild(_tableHeadFilter);
			_tableHeadFilter.move(317,4);
		}
		
		public function assetsCompleteHandler():void
		{
			
		}
		
		private function initEvent():void
		{
//			_mediator.clubInfo.clubStoreInfo.addEventListener(ClubStoreUpdateEvent.EVENTLIST_UPDATE,listUpdateHandler);
			
			_tableHeadFilter.addEventListener(Event.CHANGE, tableHeadFilterChangeHandler);
			_pager.addEventListener(PageEvent.PAGE_CHANGE, pagerChangeHandler);
			_mediator.clubInfo.clubStoreInfo.addEventListener(ClubStoreUpdateEvent.EVENTLIST_UPDATE, updateRecordsHandler);
		}
		
		private function removeEvent():void
		{
//			_mediator.clubInfo.clubStoreInfo.removeEventListener(ClubStoreUpdateEvent.EVENTLIST_UPDATE,listUpdateHandler);
			
			_tableHeadFilter.removeEventListener(Event.CHANGE, tableHeadFilterChangeHandler);
			_pager.removeEventListener(PageEvent.PAGE_CHANGE, pagerChangeHandler);
			_mediator.clubInfo.clubStoreInfo.removeEventListener(ClubStoreUpdateEvent.EVENTLIST_UPDATE, updateRecordsHandler);
		}				
		
		private function listUpdateHandler(e:ClubStoreUpdateEvent):void
		{
//			var list:Vector.<StoreEventItemInfo> = _mediator.clubInfo.clubStoreInfo.storeEventList;
			var list:Array = _mediator.clubInfo.clubStoreInfo.storeEventList;
			var i:int;
			var currentHeight:int = 0;
			for(i = 0; i < _listView.getContainer().numChildren; i++)
			{
				_listView.getContainer().removeChildAt(0);
			}
			for(i = 0; i < list.length; i++)
			{
				var textfield:TextField = new TextField();
				var color:uint = list[i].type == 0 ? 0x61F5FF : 0xFF9860;
				textfield.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,color,null,null,null,null,null,null,null,null,null,8);
				textfield.filters = [new GlowFilter(0,1,2,2,4.5)];
				textfield.width = 412;
				textfield.wordWrap = true;
				textfield.mouseEnabled = textfield.mouseWheelEnabled = false;
				textfield.y = currentHeight;
				textfield.text = list[i].mes;
				textfield.height = textfield.textHeight;
				_listView.getContainer().addChild(textfield);
				currentHeight += textfield.height;
			}
			_listView.getContainer().height = currentHeight;
			_listView.update();
		}
		private function updateRecordsHandler(event:Event):void
		{
			var list:Array = _mediator.clubInfo.clubStoreInfo.storeEventList;
			_records = [];
			_recordsGet = [];
			_recordsAdd = [];
			for(var i:int = 0; i < list.length; i++)
			{
				var record:ClubStoreRecord =  new ClubStoreRecord;
				_tile.appendItem(record);
				_records[i] = record;
				(record as ClubStoreRecord).info = list[i];
				
				if( ( list[i] as ClubStoreRecordInfo ).type == ClubStoreRecordInfo.TYPE_ADD )
				{
					var recordAdd:ClubStoreRecord =  new ClubStoreRecord;
					_tileAdd.appendItem(recordAdd);
					_recordsAdd[i] = recordAdd;
					(recordAdd as ClubStoreRecord).info = list[i];
				}
				else
				{
					var recordGet:ClubStoreRecord =  new ClubStoreRecord;
					_tileGet.appendItem(recordGet);
					_recordsGet[i] = recordGet;
					(recordGet as ClubStoreRecord).info = list[i];
				}
			}
		}
		
		private function tableHeadFilterChangeHandler(event:Event):void
		{
			trace(_tableHeadFilter.selectedItem.label, _tableHeadFilter.selectedItem.data);
			switch(_tableHeadFilter.selectedItem.data)
			{
				case ClubStoreRecordsPanel.OPERATION_CODE_ALL :
					_tile.visible = true;
					_tileGet.visible = false;
					_tileAdd.visible = false;
					break;
				case ClubStoreRecordsPanel.OPERATION_CODE_ADD :
					_tile.visible = false;
					_tileGet.visible = false;
					_tileAdd.visible = true;
					break;
				case ClubStoreRecordsPanel.OPERATION_CODE_GET :
					_tile.visible = false;
					_tileGet.visible = true;
					_tileAdd.visible = false;
					break;
			}
		}	
		
		private function pagerChangeHandler(event:Event):void
		{
		}
		
		public function move(x:Number,y:Number):void
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
			ClubStoreEventSocketHandler.send();
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_mediator)
			{
				_mediator = null;
			}
			if(_tableHeadDate)
			{
				_tableHeadDate = null;
			}
			if(_tableHeadContent)
			{
				_tableHeadContent = null;
			}
			if(_tableHeadFilter)
			{
				_tableHeadFilter = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_tileAdd)
			{
				_tileAdd.dispose();
				_tileAdd = null;
			}
			if(_tileGet)
			{
				_tileGet.dispose();
				_tileGet = null;
			}
			if(_records)
			{
				for( var i:int = 0; i < _records.length; i++)
				{
					if(_records[i])
					{
						ClubStoreRecord(_records[i]).dispose();
					}
				}
			}
			if(_recordsAdd)
			{
				for( i = 0; i < _recordsAdd.length; i++)
				{
					if(_recordsAdd[i])
					{
						ClubStoreRecord(_recordsAdd[i]).dispose();
					}
				}
			}
			if(_recordsGet)
			{
				for( i = 0; i < _recordsGet.length; i++)
				{
					if(_recordsGet[i])
					{
						ClubStoreRecord(_recordsGet[i]).dispose();
					}
				}
			}
			if(_pager)
			{
				_pager.dispose();
				_pager = null;
			}
		}
	}
}