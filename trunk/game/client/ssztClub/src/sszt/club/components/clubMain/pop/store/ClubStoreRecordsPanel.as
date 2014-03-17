package sszt.club.components.clubMain.pop.store
{
	import fl.controls.ComboBox;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import sszt.club.datas.storeInfo.ClubStoreRecordInfo;
	import sszt.club.events.ClubStoreUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubStoreEventSocketHandler;
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
	
	public class ClubStoreRecordsPanel extends MPanel
	{
		public static const OPERATION_CODE_GET:int = 0;
		public static const OPERATION_CODE_ADD:int = 1;
		public static const OPERATION_CODE_ALL:int = 2;
		
		private var _bg:IMovieWrapper;
		private var _mediator:ClubMediator;
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
		
		public function ClubStoreRecordsPanel(mediator:ClubMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1("",new Bitmap(new ClubStoreTitleAsset())),true,-1);
			initView();
			initEvent();
			ClubStoreEventSocketHandler.send();
		}
		
		private function initView():void
		{
			setContentSize(409, 271);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(
					BackgroundType.BORDER_11,
					new Rectangle(8, 7, 393, 255)
				),
				new BackgroundInfo(
					BackgroundType.BORDER_6,
					new Rectangle(340, 9, 59, 22)
				)
			]);
			addContent(_bg as DisplayObject);
			
			_tableHeadDate = new MAssetLabel(
				LanguageManager.getWord('ssztl.common.time'),
				MAssetLabel.LABEL_TYPE2,
				TextFieldAutoSize.LEFT
				);
			addContent(_tableHeadDate);
			_tableHeadDate.move(40, 12);
			
			_tableHeadContent = new MAssetLabel(
				LanguageManager.getWord('ssztl.club.content'),
				MAssetLabel.LABEL_TYPE2,
				TextFieldAutoSize.LEFT
			);
			addContent(_tableHeadContent);
			_tableHeadContent.move(199, 12);
			
			_tableHeadFilter = new ComboBox();
			_tableHeadFilter.setSize(59, 22);
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
			addContent(_tableHeadFilter);
			_tableHeadFilter.move(340, 9);
			
			_tile = new MTile(390, 25);
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.verticalScrollPolicy = ScrollPolicy.ON;
			_tile.setSize(390, 25 * 9);
			addContent(_tile);
			_tile.move(8, 34);
			
			_tileGet = new MTile(390, 25);
			_tileGet.itemGapH = _tile.itemGapW = 0;
			_tileGet.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tileGet.verticalScrollPolicy = ScrollPolicy.ON;
			_tileGet.setSize(390, 25 * 9);
			addContent(_tileGet);
			_tileGet.move(8, 34);
			_tileGet.visible = false;
			
			_tileAdd = new MTile(390, 25);
			_tileAdd.itemGapH = _tile.itemGapW = 0;
			_tileAdd.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tileAdd.verticalScrollPolicy = ScrollPolicy.ON;
			_tileAdd.setSize(390, 25 * 9);
			addContent(_tileAdd);
			_tileAdd.move(8, 34);
			_tileAdd.visible = false;
			
			_pager = new PageView(PAGE_SIZE, false, 133);
			addContent(_pager);
			_pager.move(128, 233);
			_pager.visible = false;
		}
		
		private function initEvent():void
		{
			_tableHeadFilter.addEventListener(Event.CHANGE, tableHeadFilterChangeHandler);
			_pager.addEventListener(PageEvent.PAGE_CHANGE, pagerChangeHandler);
			_mediator.clubInfo.clubStoreInfo.addEventListener(ClubStoreUpdateEvent.EVENTLIST_UPDATE, updateRecordsHandler);
		}
		
		private function removeEvent():void
		{
			_tableHeadFilter.removeEventListener(Event.CHANGE, tableHeadFilterChangeHandler);
			_pager.removeEventListener(PageEvent.PAGE_CHANGE, pagerChangeHandler);
			_mediator.clubInfo.clubStoreInfo.removeEventListener(ClubStoreUpdateEvent.EVENTLIST_UPDATE, updateRecordsHandler);
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
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
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