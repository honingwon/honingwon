package sszt.club.components.clubMain.pop.store
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import sszt.club.datas.storeInfo.AppliedItemRecordInfo;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubStoreCancelItemRequestSocketHandler;
	import sszt.constData.CategoryType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.page.PageView;
	
	internal class ClubStoreAppliedItemRecord extends Sprite
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _bgTxt:MAssetLabel;
		private var _txtItemName:MAssetLabel;
		private var _btnCancel:MCacheAssetBtn1;
		private var _recordInfo:AppliedItemRecordInfo;
		private var _itemCell:ClubStoreAppliedItemCell;
		
		
		public function ClubStoreAppliedItemRecord(mediator:ClubMediator)
		{
			_mediator = mediator;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, 188, 56);
			graphics.endFill();
			
//			_bg = BackgroundUtils.setBackground([
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5, 5, 38, 38),new Bitmap(CellCaches.getCellBg()))
//			]);
//			addChild(_bg as DisplayObject);
			
			_bgTxt = new MAssetLabel(LanguageManager.getWord('ssztl.club.applingItem'),MAssetLabel.LABEL_TYPE_TAG,TextFieldAutoSize.LEFT);
			addChild(_bgTxt);
			_bgTxt.move(50,30);
			
			_txtItemName = new MAssetLabel('',MAssetLabel.LABEL_TYPE7,TextFieldAutoSize.LEFT);
			addChild(_txtItemName);
			_txtItemName.move(50,10);
			
			_itemCell = new ClubStoreAppliedItemCell();
			addChild(_itemCell);
			_itemCell.move(7,9);
			
			_btnCancel = new MCacheAssetBtn1(1, 1,LanguageManager.getWord('ssztl.common.cannel'));
			addChild(_btnCancel);
			_btnCancel.move(141,16);
			
			this.visible = false;
		}
		
		private function initEvent():void
		{
			_btnCancel.addEventListener(MouseEvent.CLICK, btnCancelClickHandler);
		}
		
		private function removeEvent():void
		{
			_btnCancel.removeEventListener(MouseEvent.CLICK, btnCancelClickHandler);
		}
		
		public function get recordInfo():AppliedItemRecordInfo
		{
			return _recordInfo;
		}
		
		public function set recordInfo(appliedItemRecordInfo:AppliedItemRecordInfo):void
		{
			if(appliedItemRecordInfo)
			{
				this.visible = true;
				_recordInfo = appliedItemRecordInfo;				
				_itemCell.itemInfo = appliedItemRecordInfo.itemInfo;
				_txtItemName.setValue(appliedItemRecordInfo.itemInfo.template.name);
				_txtItemName.textColor = CategoryType.getQualityColor(appliedItemRecordInfo.itemInfo.template.quality);
			}
			else
			{
				_recordInfo = null;
				_itemCell.itemInfo = null;
				_txtItemName.setValue('');
				this.visible = false;
			}
		}
		
		private function btnCancelClickHandler(event:MouseEvent):void
		{
//			_mediator.clubModule.storeAppliedItemRecordsPanel.currentPage = 1;
			ClubStoreCancelItemRequestSocketHandler.send(recordInfo.recordId);
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bgTxt)
			{
				_bgTxt = null;
			}
			if(_txtItemName)
			{
				_txtItemName = null;
			}
			if(_btnCancel)
			{
				_btnCancel.dispose();
				_btnCancel = null;
			}
			if(_recordInfo)
			{
				_recordInfo = null;
			}
			if(_itemCell)
			{
				_itemCell.dispose();
				_itemCell = null;
			}
			if(_mediator)
			{
				_mediator = null;
			}
		}
	}
}