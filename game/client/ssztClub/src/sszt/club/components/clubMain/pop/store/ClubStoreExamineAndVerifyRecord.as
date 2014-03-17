package sszt.club.components.clubMain.pop.store
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	
	import sszt.club.datas.storeInfo.ExamineAndVerifyRecordInfo;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubStoreDealItemRequestSocketHandler;
	import sszt.constData.CategoryType;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	
	public class ClubStoreExamineAndVerifyRecord extends Sprite
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
//		private var _txtItemName:MAssetLabel;
		private var _txtName:MAssetLabel;
		private var _txtDate:MAssetLabel;
		private var _btnRefuse:MCacheAssetBtn1;
		private var _btnOK:MCacheAssetBtn1;
		private var _recordInfo:ExamineAndVerifyRecordInfo;
		private var _itemCell:ClubStoreAppliedItemCell;
		
		public function ClubStoreExamineAndVerifyRecord(mediator:ClubMediator)
		{
			_mediator = mediator;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, 233, 48);
			graphics.endFill();
			
//			_bg = BackgroundUtils.setBackground([
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5, 5, 38, 38),new Bitmap(CellCaches.getCellBg()))
//			]);
//			addChild(_bg as DisplayObject);
			
//			_bgTxt = new MAssetLabel(
//				LanguageManager.getWord('ssztl.club.applingItem'),
//				MAssetLabel.LABEL_TYPE2,
//				TextFieldAutoSize.LEFT
//			);
//			addChild(_bgTxt);
//			_bgTxt.move(44, 21);
			
//			_txtItemName = new MAssetLabel('',MAssetLabel.LABEL_TYPE7,TextFieldAutoSize.LEFT);
//			addChild(_txtItemName);
//			_txtItemName.move(46,6);
			
			_txtName = new MAssetLabel('昵称',MAssetLabel.LABEL_TYPE21,TextFieldAutoSize.LEFT);
			addChild(_txtName);
			_txtName.move(50,10);
			
			_txtDate = new MAssetLabel('2012-00-00',MAssetLabel.LABEL_TYPE20,TextFieldAutoSize.LEFT);
			addChild(_txtDate);
			_txtDate.move(50,30);
			
			_itemCell = new ClubStoreAppliedItemCell();
			addChild(_itemCell);
			_itemCell.move(7,9);
			
			_btnOK = new MCacheAssetBtn1(1, 1,LanguageManager.getWord('ssztl.common.agree'));
			addChild(_btnOK);
			_btnOK.move(143,5);
			
			_btnRefuse = new MCacheAssetBtn1(1, 1,LanguageManager.getWord('ssztl.common.refuse'));
			addChild(_btnRefuse);
			_btnRefuse.move(143,28);
			
			this.visible = false;
		}
		
		private function initEvent():void
		{
			_btnOK.addEventListener(MouseEvent.CLICK, btnOKClickHandler);
			_btnRefuse.addEventListener(MouseEvent.CLICK, btnRefuseClickHandler);
		}
		
		private function removeEvent():void
		{
			_btnOK.removeEventListener(MouseEvent.CLICK, btnOKClickHandler);
			_btnRefuse.removeEventListener(MouseEvent.CLICK, btnRefuseClickHandler);
		}
		
		private function btnRefuseClickHandler(event:MouseEvent):void
		{
//			_mediator.clubModule.storeExamineAndVerifyPanel.currentPage = 1;
			ClubStoreDealItemRequestSocketHandler.send(recordInfo.recordId, 0);
		}
		
		private function btnOKClickHandler(event:MouseEvent):void
		{
//			_mediator.clubModule.storeExamineAndVerifyPanel.currentPage = 1;
			ClubStoreDealItemRequestSocketHandler.send(recordInfo.recordId, 1);
		}
		
		public function get recordInfo():ExamineAndVerifyRecordInfo
		{
			return _recordInfo;
		}
		
		public function set recordInfo(examineAndVerifyRecordInfo:ExamineAndVerifyRecordInfo):void
		{
			if(examineAndVerifyRecordInfo)
			{
				this.visible = true;
				_recordInfo = examineAndVerifyRecordInfo;				
				_itemCell.itemInfo = _recordInfo.itemInfo;				
//				_txtItemName.setValue(_recordInfo.itemInfo.template.name);
//				_txtItemName.textColor = CategoryType.getQualityColor(_recordInfo.itemInfo.template.quality);
				_txtName.setValue(_recordInfo.name);
				_txtDate.setValue(getDateString());
			}
			else
			{
				_recordInfo = null;
				_itemCell.itemInfo = null;
//				_txtItemName.setValue('');
				_txtName.setValue('');
				_txtDate.setValue('');
				this.visible = false;
			}
		}
		
		private function getDateString():String
		{
			var date:Date = _recordInfo.date;
			var month:String = (date.month + 1 > 9) ? String(date.month + 1) : "0" + String(date.month + 1);
			var day:String = (date.date > 9) ? String(date.date) : "0" + String(date.date);
			var hour:String = (date.hours > 9) ? String(date.hours) : "0" + String(date.hours);
			var minute:String = (date.minutes > 9) ? String(date.minutes) : "0" + String(date.minutes);
			return month + "-" + day + " " + hour + ":" + minute;
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
//			if(_txtItemName)
//			{
//				_txtItemName = null;
//			}
			if(_txtName)
			{
				_txtName = null;
			}
			if(_txtDate)
			{
				_txtDate = null;
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
			if(_btnRefuse)
			{
				_btnRefuse.dispose();
				_btnRefuse = null;
			}
			if(_btnOK)
			{
				_btnOK.dispose();
				_btnOK = null;
			}
		}
	}
}