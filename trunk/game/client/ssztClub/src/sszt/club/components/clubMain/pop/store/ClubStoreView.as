package sszt.club.components.clubMain.pop.store
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.club.events.ClubStoreUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubStoreGetSocketHandler;
	import sszt.club.socketHandlers.ClubStoreOpenStateSocketHandler;
	import sszt.club.socketHandlers.ClubStorePageUpdateSocketHandler;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.club.ClubSelfExploitUpdateSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MSelectButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.selectBtns.MCacheSelectBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;

	/**
	 * 查看仓库选项卡。
	 * 修改：王鸿源(honingwon@gmail.com)
	 * 时间：2012-10-17
	 * */
	public class ClubStoreView extends Sprite implements IClubStoreView
	{
		private var _mediator:ClubMediator;

		private var _bg:IMovieWrapper;
		
		private var _getBtn:MCacheAssetBtn1;
		
		private var _btnGetAppliedItemRecords:MCacheAssetBtn1;
		private var _btnExamineAndVerify:MCacheAssetBtn1;
		private var _btnOpenTheBag:MCacheAssetBtn1;
		
		private var _tile:MTile;
		/**
		 * 存储物品单元。
		 * */
		private var _list:Array;
		/**
		 * 分页按钮集合。
		 * */
		private var _pageBtns:Array;
		/**
		 * 分页当前页索引。
		 * */
		private var _currentPage:int;						//0开始
		private var _selectedItem:ClubStoreCell;
		private var _bgCell:ClubStoreBgCell;
//		/**
//		 * 说明文本
//		 * */
//		private var _descriptField:MAssetLabel;
		/**
		 * 仓库容量。
		 * */
		private const MAX_SIZE:int = 10 * 5 * 3;
		/**
		 * 每页物品个数。
		 * */
		private const PAGE_SIZE:int = 10 * 5;
		
		public function ClubStoreView(mediator:ClubMediator)
		{
			_mediator = mediator;
			_currentPage = -1;
			super();
			initView();
			initEvent();
			
//			ClubStoreOpenStateSocketHandler.send(true);
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,0,390,235)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,5,380,38),new Bitmap(CellCaches.getCellBgPanel10())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,43,380,38),new Bitmap(CellCaches.getCellBgPanel10())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,81,380,38),new Bitmap(CellCaches.getCellBgPanel10())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,119,380,38),new Bitmap(CellCaches.getCellBgPanel10())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,157,380,38),new Bitmap(CellCaches.getCellBgPanel10())),
			]);
			addChild(_bg as DisplayObject);
			
//			_descriptField = new MAssetLabel(LanguageManager.getWord("ssztl.club.clubStorePrompt"),
//				[new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x8c7158,null,null,null,null,null,null,null,null,null,3),null]);
//			_descriptField.move(34,234);
//			addChild(_descriptField);
			
			_getBtn = new MCacheAssetBtn1(0, 2, LanguageManager.getWord("ssztl.club.getItem"));			
			_getBtn.move(254,232);
			addChild(_getBtn);
			_getBtn.visible = false
				
			_btnGetAppliedItemRecords = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.club.appliedItemRecords"));
//			addChild(_btnGetAppliedItemRecords);
			_btnGetAppliedItemRecords.move(4,229);
			
			_btnExamineAndVerify = new MCacheAssetBtn1(0, 3,LanguageManager.getWord("ssztl.club.examineAndVerify"));
//			addChild(_btnExamineAndVerify);
			_btnExamineAndVerify.move(75,229);
//			if(!ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty))
//			{
//				_btnExamineAndVerify.enabled = false;
//			}
			
			_btnOpenTheBag = new MCacheAssetBtn1(0, 3, LanguageManager.getWord("ssztl.club.openTheBag"));
			addChild(_btnOpenTheBag);
			_btnOpenTheBag.move(7,202);
			
//			_btnGetStoreRecords = new MCacheAssetBtn1(0, 3, LanguageManager.getWord("ssztl.club.storeRecords"));
//			addChild(_btnGetStoreRecords);
//			_btnGetStoreRecords.move(246, 229);
			
//			_pageBtns = new Vector.<MCacheSelectBtn1>();
//			var labels:Vector.<String> = Vector.<String>(["1","2","3"]);
			_pageBtns = [];
			var labels:Array = ["1","2","3"];
			for(var i:int = 0; i < labels.length; i++)
			{
				var btn:MCacheSelectBtn1 = new MCacheSelectBtn1(0,0,labels[i]);
				btn.move(304+26*i,203);
				addChild(btn);
				_pageBtns.push(btn);
			}
			currentPage = 0;
			_pageBtns[currentPage].selected = true;
			
			_list = [];
			
			_tile = new MTile(38,38,10);
			_tile.setSize(380,190);
			_tile.move(5,5);
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = "off";
			addChild(_tile);
			
			for(var j:int = 0; j < PAGE_SIZE; j++)
			{
				var cell:ClubStoreCell = new ClubStoreCell();
				
				_tile.appendItem(cell);
				_list.push(cell);
			}
			
			_bgCell = new ClubStoreBgCell();
			_bgCell.move(5,5);
			addChild(_bgCell);
		}
		
		private function initEvent():void
		{
			_getBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			
			_btnGetAppliedItemRecords.addEventListener(MouseEvent.CLICK, getAppliedItemRecords);
			_btnExamineAndVerify.addEventListener(MouseEvent.CLICK, examineAndVerify);
			_btnOpenTheBag.addEventListener(MouseEvent.CLICK, openTheBag);
//			_btnGetStoreRecords.addEventListener(MouseEvent.CLICK, getStoreRecords);
			
			for(var i:int = 0; i < _pageBtns.length; i++)
			{
				_pageBtns[i].addEventListener(MouseEvent.CLICK,pageBtnClickHandler);
			}
			
			for each(var cell:ClubStoreCell in _list)
			{
				cell.addEventListener(MouseEvent.CLICK,cellClickHandler);
				cell.addEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
				cell.addEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
			}
			_mediator.clubInfo.clubStoreInfo.addEventListener(ClubStoreUpdateEvent.ITEM_UPDATE,itemUpdateHandler);
		}
		
		private function removeEvent():void
		{
			_getBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			for(var i:int = 0; i < _pageBtns.length; i++)
			{
				_pageBtns[i].removeEventListener(MouseEvent.CLICK,pageBtnClickHandler);
			}
			for each(var cell:ClubStoreCell in _list)
			{
				cell.removeEventListener(MouseEvent.CLICK,cellClickHandler);
				cell.removeEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
				cell.removeEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
			}
			_mediator.clubInfo.clubStoreInfo.removeEventListener(ClubStoreUpdateEvent.ITEM_UPDATE,itemUpdateHandler);
		}
		
		private function getStoreRecords(event:MouseEvent):void
		{
			_mediator.showStoreRecordsPanel();
		}
		
		private function openTheBag(event:MouseEvent):void
		{
			SetModuleUtils.addBag(GlobalAPI.layerManager.getTopPanelRec())
		}
		
		private function examineAndVerify(event:MouseEvent):void
		{
			_mediator.showStoreExamineAndVerifyPanel()
		}
		
		private function getAppliedItemRecords(event:MouseEvent):void
		{
			_mediator.showStoreAppliedItemRecordsPanel();
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_selectedItem == null || _selectedItem.itemInfo == null)
				MAlert.show(LanguageManager.getWord("ssztl.club.selectWantGetItem"),LanguageManager.getWord("ssztl.common.alertTitle"));
			else
			{
				if(ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty))
				{
					ClubStoreGetSocketHandler.send(_selectedItem.itemInfo.itemId);
					_getBtn.enabled = false;
				}
				else
				{
					MAlert.show(LanguageManager.getWord("ssztl.club.willCostExploit", _selectedItem.itemInfo.count),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
				}
			}
		}
		
		private function closeHandler(e:CloseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(e.detail == MAlert.OK)
			{
				if(GlobalData.selfPlayer.selfExploit < _selectedItem.itemInfo.count)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.club.selfExploitNotEnough"));	
					return;
				}
				ClubStoreGetSocketHandler.send(_selectedItem.itemInfo.itemId);
				_getBtn.enabled = false;
			}
		}
		
		private function pageBtnClickHandler(e:MouseEvent):void
		{
			var index:int = _pageBtns.indexOf(e.currentTarget as MCacheSelectBtn1);
			if(currentPage == index)return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_pageBtns[currentPage].selected = false;
			currentPage = index;
			_pageBtns[currentPage].selected = true;
			if(_selectedItem)
			{
				_selectedItem.selected = false;
				_selectedItem = null;
			}
		}
		
		private function cellClickHandler(e:MouseEvent):void
		{
			var cell:ClubStoreCell = e.currentTarget as ClubStoreCell;
			if(_selectedItem)_selectedItem.selected = false;
			_selectedItem = cell;
			_selectedItem.selected = true;
		}
		private function itemOverHandler(evt:MouseEvent):void
		{
			var _cur:ClubStoreCell = evt.currentTarget as ClubStoreCell;
			_cur.over = true;
		}
		private function itemOutHandler(evt:MouseEvent):void
		{
			var _cur:ClubStoreCell = evt.currentTarget as ClubStoreCell;
			_cur.over = false;
		}
		
		private function itemUpdateHandler(e:ClubStoreUpdateEvent):void
		{
//			var list:Vector.<ItemInfo> = _mediator.clubInfo.clubStoreInfo.storeList;
			var list:Array = _mediator.clubInfo.clubStoreInfo.storeList;
			for(var i:int = 0; i < list.length; i++)
			{
				_list[i].itemInfo = list[i];
			}
			_getBtn.enabled = true;
		}
		
		private function clearItems():void
		{
			for each(var cell:ClubStoreCell in _list)
			{
				if(cell)cell.itemInfo = null;
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
		}
		
		public function set currentPage(value:int):void
		{
			if(_currentPage == value)
				return;
			_currentPage = value;
			ClubStorePageUpdateSocketHandler.send(_currentPage + 1);
		}
		public function get currentPage():int
		{
			return _currentPage;
		}
		
		public function assetsCompleteHandler():void{}
		
		public function dispose():void
		{
			removeEvent();
//			ClubStoreOpenStateSocketHandler.send(false);
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			
			if(_btnGetAppliedItemRecords)
			{
				_btnGetAppliedItemRecords.dispose();
				_btnGetAppliedItemRecords = null;
			}
			if(_btnExamineAndVerify)
			{
				_btnExamineAndVerify.dispose();
				_btnExamineAndVerify = null;
			}
			if(_btnOpenTheBag)
			{
				_btnOpenTheBag.dispose();
				_btnOpenTheBag = null;
			}
//			if(_btnGetStoreRecords)
//			{
//				_btnGetStoreRecords.dispose();
//				_btnGetStoreRecords = null;
//			}
			
			if(_getBtn)
			{
				_getBtn.dispose();
				_getBtn = null;
			}
			if(_pageBtns)
			{
				for each(var btn:MCacheSelectBtn1 in _pageBtns)
				{
					btn.dispose();
				}
			}
			_pageBtns = null;
			if(_tile)
			{
				_tile.clearItems();
				_tile.dispose();
				_tile = null;
			}
			if(_list)
			{
				for each(var cell:ClubStoreCell in _list)
				{
					if(cell)cell.dispose();
				}
			}
			_list = null;
			_mediator = null;
		}
	}
}