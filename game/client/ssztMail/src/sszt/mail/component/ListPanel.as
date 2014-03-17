package sszt.mail.component
{
	import fl.controls.CheckBox;
	import fl.controls.ScrollPolicy;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.mail.MailEvent;
	import sszt.core.data.mail.MailItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.mail.MailClearSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.mail.mediator.MailMediator;
	import sszt.mail.socket.MailDeleteSocketHandler;
	import sszt.mail.socket.MailReadSocketHandler;
	import sszt.mail.socket.MailReceiveSocketHandler;
	import sszt.mail.utils.AttachUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.mail.MailTypeGmAsset;
	
	/**
	 * 修改：王鸿源  honingwon@gmail.com
	 * 日期：2012-10-23
	 * */
	public class ListPanel extends Sprite
	{
		private var _mediator:MailMediator;
		private var _tile:MTile;
//		private var _cellList:Vector.<MailItemView>;
		private var _cellList:Array;
		private var _currentCell:MailItemView;
//		private var _btns:Vector.<MCacheTabBtn1>;
		private var _btns:Array;
		private var _labels:Array;
		private var _currentType:int = 0;
		private var _currentPage:int = 1;
		
		private var _pageView:PageView;
		private var _checkBox:CheckBox;
		private var _deleteBtn:MCacheAssetBtn1;
		private var _getBtn:MCacheAssetBtn1;
//		private var _getAllBtn:MCacheAssetBtn1;		
		private var _clearBtn:MCacheAssetBtn1;
		private var _writeBtn:MCacheAssetBtn1;
		
		public static var typeGmAsset:MailTypeGmAsset;
		
		private static const PAGE_SIZE:int = 6;
		
		public function ListPanel(mediator:MailMediator)
		{
			_mediator = mediator;
			typeGmAsset = new MailTypeGmAsset();
			super();
			init();
		}
		
		private function init():void
		{
			_labels = new Array();
			_labels = [LanguageManager.getWord("ssztl.common.all"),
				LanguageManager.getWord("ssztl.common.system"),
				LanguageManager.getWord("ssztl.mail.personal"),
				LanguageManager.getWord("ssztl.mail.unread"),
				LanguageManager.getWord("ssztl.mail.read")];
//			_btns = new Vector.<MCacheTabBtn1>();
			_btns = [];
			for(var i:int =0;i<_labels.length;i++)
			{
				var tab:MCacheTabBtn1 = new MCacheTabBtn1(0, 0, _labels[i]);
				tab.move(15 + i*47, 0);
				addChild(tab);
				_btns.push(tab);
			}
			_btns[0].selected = true;
			
			_tile = new MTile(259,50,1);
			_tile.itemGapH = 1;
			_tile.itemGapW = 0;
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			_tile.setSize(259,305);
			_tile.move(17,34);
			addChild(_tile);
			
//			_cellList = new Vector.<MailItemView>();
			_cellList = [];
			for(i = 0 ;i<PAGE_SIZE;i++)
			{
				var item:MailItemView = new MailItemView(_mediator);
				item.addEventListener(MouseEvent.CLICK,clickHandler)
				_tile.appendItem(item);
				_cellList.push(item);
			}
			
			_checkBox = new CheckBox();
			_checkBox.setSize(60, 20);
			_checkBox.move(15, 378);
			_checkBox.label = LanguageManager.getWord("ssztl.common.selectAll");
			addChild(_checkBox);
			
			_deleteBtn = new MCacheAssetBtn1(0, 1, LanguageManager.getWord("ssztl.common.delete"));
			_deleteBtn.move(83, 374);
			addChild(_deleteBtn);
			
			_getBtn = new MCacheAssetBtn1(0, 3 ,LanguageManager.getWord("ssztl.mail.accept"));
			_getBtn.move(140, 374);
			addChild(_getBtn);
			
			
//			_getAllBtn = new MCacheAssetBtn1(0, 3 ,LanguageManager.getWord("ssztl.mail.receiveAll"));
//			_getAllBtn.move(133, 345);
//			addChild(_getAllBtn);
//			_getAllBtn.visible = false;
			
			_clearBtn = new MCacheAssetBtn1(0, 2, LanguageManager.getWord("ssztl.mail.clean"));
			_clearBtn.move(212, 374);
			addChild(_clearBtn);
			_clearBtn.visible =  false;
			
			_writeBtn = new MCacheAssetBtn1(0, 3, LanguageManager.getWord("ssztl.mail.writeMail"));
			_writeBtn.move(212, 374);
			addChild(_writeBtn);
			
			_pageView = new PageView(6, false, 112);
			_pageView.move(99,341);
			addChild(_pageView);
			
			loadHandler(null);
			initEvent();
		}
		
		private function initEvent():void
		{
			for(var i:int = 0;i<_btns.length;i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			
			_deleteBtn.addEventListener(MouseEvent.CLICK,deleteClickHandler);
			_getBtn.addEventListener(MouseEvent.CLICK,getClickHandler);
			_clearBtn.addEventListener(MouseEvent.CLICK,clearClickHandler);
			_checkBox.addEventListener(Event.CHANGE,checkHandler);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			_writeBtn.addEventListener(MouseEvent.CLICK,writeClickHandler);
			
			GlobalData.mailInfo.addEventListener(MailEvent.MAIL_READ,readHandler);
			GlobalData.mailInfo.addEventListener(MailEvent.MAIL_LOAD_FINISH,newMailHandler);
			GlobalData.mailInfo.addEventListener(MailEvent.MAIL_DELETE,deleteUpdateHandler);
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0;i<_btns.length;i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			
			_deleteBtn.removeEventListener(MouseEvent.CLICK,deleteClickHandler);
			_getBtn.removeEventListener(MouseEvent.CLICK,getClickHandler);
			_clearBtn.removeEventListener(MouseEvent.CLICK,clearClickHandler);
			_checkBox.removeEventListener(Event.CHANGE,checkHandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			
			GlobalData.mailInfo.removeEventListener(MailEvent.MAIL_READ,readHandler);
			GlobalData.mailInfo.removeEventListener(MailEvent.MAIL_LOAD_FINISH,newMailHandler);
			GlobalData.mailInfo.removeEventListener(MailEvent.MAIL_DELETE,deleteUpdateHandler);
		}
		
		private function writeClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_mediator.showWritePanel(GlobalData.selfPlayer.serverId);
		}
		
		private function deleteUpdateHandler(evt:MailEvent):void
		{
			_checkBox.selected = false;
			loadHandler(null);
		}
		
		public function showFirst():void
		{
			if(_cellList[0].mailItemInfo)
			{
				if(_currentCell) _currentCell.selected = false;
				_currentCell = _cellList[0];
				_currentCell.selected = true;
				_mediator.showReadPanel(_cellList[0].mailItemInfo);
			}
		}
		
		private function newMailHandler(evt:MailEvent):void
		{
			_btns[_currentType].selected = false;
			_currentType = 0;
			_btns[_currentType].selected = true;
			_currentPage = 1;
			_checkBox.selected = false;
			loadHandler(null);
		}
		
		public function get currrentPage():int
		{
			return _currentPage;
		}
		
		public function get currentType():int
		{
			return _currentType;	
		}
		
		private function pageChangeHandler(evt:PageEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			_currentPage = _pageView.currentPage;
			_checkBox.selected = false;
			if(_currentCell) 
				_currentCell.selected = false;
			_currentCell = null;
			loadHandler(null);
		}
		
		private function checkHandler(evt:Event):void
		{
			if(_checkBox.selected)
			{
				for(var i:int = 0;i<_cellList.length;i++)
				{
					_cellList[i].checkBox.selected = true;
				}
			}
			else
			{
				for(i = 0;i<_cellList.length;i++)
				{
					_cellList[i].checkBox.selected = false;
				}
			}
		}
		
		private function readHandler(evt:MailEvent):void
		{
			var id:Number = evt.data as Number;
			for(var i:int = 0;i<_cellList.length;i++)
			{
				if(_cellList[i].mailItemInfo)
				{
					if(id == _cellList[i].mailItemInfo.mailId)
					{
						_cellList[i].setRead();
						break;
					}
				}
			}
			if(!GlobalData.mailInfo.hasUnread())
			{
				GlobalData.mailIcon.hide();
			}else
			{
				GlobalData.mailIcon.updateCount(GlobalData.mailInfo.getUnReadCount());
			}
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			var cell:MailItemView = evt.currentTarget as MailItemView;
			if(_currentCell)
			{
				_currentCell.selected = false;
			}
			_currentCell = cell;
			_currentCell.selected = true;
			_mediator.showReadPanel(_currentCell.mailItemInfo);
			if(!_currentCell.mailItemInfo.isRead)
			{
//				_currentCell.setRead();
				GlobalData.mailInfo.change(_currentCell.mailItemInfo.mailId);
				MailReadSocketHandler.sendRead(_currentCell.mailItem.mailId);
			}	
		}
		
		private function deleteClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var hasAttach:Boolean = false;
			var count:int = 0;
			//检测已选邮件有无附件
			for(var i:int = 0;i<_cellList.length;i++)
			{
				if(_cellList[i].mailItemInfo)
				{
					if(_cellList[i].checkBox.selected)
					{
						count ++;
						if(_cellList[i].hasAttachment)
						{
							hasAttach = true ;
							break;
						}
					}
				}		
			}
			if(count == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mail.noSelectMail"));
			}
			else if(hasAttach)
			{
				MAlert.show(LanguageManager.getWord("ssztl.mail.includeAttach"),
					LanguageManager.getWord("ssztl.common.alertTitle"),
					MAlert.OK|MAlert.CANCEL,
					null,
					deleteAlertHandler);	
			}else
			{
				MAlert.show(LanguageManager.getWord("ssztl.mail.sureDeleteSelect"),
					LanguageManager.getWord("ssztl.common.alertTitle"),
					MAlert.OK|MAlert.CANCEL,
					null,
					deleteAlertHandler);
			}
		}
		
		private function deleteAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				deleteMail();
			}
		}
		
		private function deleteMail():void
		{
			var count:int = 0;
			for(var i:int = 0;i<_cellList.length;i++)
			{
				if(_cellList[i].mailItemInfo)
				{
					if(_cellList[i].checkBox.selected)
					{
						MailDeleteSocketHandler.sendDelete(_cellList[i].mailItemInfo.mailId);
						count++;
					}
				}
			}
			if(count == 0) return;
		}
		
		private function getClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			//选中邮件计数器
			var count:int = 0 ;
			//带有物品的附件的计数器
			var attachCount:int = 0;
			for(var i:int =0;i<_cellList.length;i++)
			{
				if(_cellList[i].mailItemInfo)
				{
					if(_cellList[i].checkBox.selected)
					{
						if(AttachUtils.hasAttachment(_cellList[i].mailItemInfo.attachFetch,_cellList[i].mailItemInfo))
						{
							MailReceiveSocketHandler.sendReceive(_cellList[i].mailItemInfo.mailId,0);
							attachCount++;
						}
						else if(AttachUtils.hasMoney(_cellList[i].mailItem))
						{
							MailReceiveSocketHandler.sendReceive(_cellList[i].mailItemInfo.mailId,0);
						}
						count++;
					}
				}
			}
			if(count == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mail.noSelectMail"));
			}
			if(attachCount + GlobalData.bagInfo.currentSize > GlobalData.selfPlayer.bagMaxCount)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mail.bagFull"));
			}
		}
		
		private function getAllClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var count:int = 0 ;
			var attachCount:int = 0;
			for(var i:int =0;i<_cellList.length;i++)
			{
				if(_cellList[i].mailItemInfo)
				{
					if(_cellList[i].checkBox.selected)
					{
						if(AttachUtils.hasAttachment(_cellList[i].mailItemInfo.attachFetch,_cellList[i].mailItemInfo))
						{
							MailReceiveSocketHandler.sendReceive(_cellList[i].mailItemInfo.mailId,0);
							attachCount++;
						}else if(AttachUtils.hasMoney(_cellList[i].mailItem))
						{
							MailReceiveSocketHandler.sendReceive(_cellList[i].mailItemInfo.mailId,0);
						}
						count++;
					}
				}
			}
			if(count == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mail.noSelectMail"));
			}
			if(attachCount + GlobalData.bagInfo.currentSize > GlobalData.selfPlayer.bagMaxCount)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mail.bagFull"));
			}
		}
		
		private function clearClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			MAlert.show(LanguageManager.getWord("ssztl.mail.sureDeleteNoAttachMail"),
				LanguageManager.getWord("ssztl.common.alertTitle"),
				MAlert.OK|MAlert.CANCEL,
				null,
				clearHandler);
			function clearHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
//					var list:Vector.<MailItemInfo> = GlobalData.mailInfo.mails;
//					var data:Vector.<Number> = new Vector.<Number>();
					var list:Array = GlobalData.mailInfo.mails;
					var data:Array = [];
					var len:int = list.length;
					for(var i:int =0;i< len;i++)
					{
						if(!AttachUtils.hasAttachment(list[i].attachFetch,list[i])&&!AttachUtils.hasMoney(list[i]))
						{
							data.push(list[i].mailId);
						}
					}
					MailClearSocketHandler.sendClear(data);	
					GlobalData.mailInfo.clear(data);
					loadHandler(null);
				}
			}
		}
		
		private function clearView():void
		{
			for(var i:int = 0;i<_cellList.length;i++)
			{
				_cellList[i].mailItemInfo = null;
			}
		}
		
		private function loadHandler(evt:MailEvent):void
		{
			clearView();
//			var list:Vector.<MailItemInfo> = GlobalData.mailInfo.getListByType(_currentType,_currentPage-1);
			var list:Array = GlobalData.mailInfo.getListByType(_currentType,_currentPage-1);
			if(_currentPage > GlobalData.mailInfo.currentCount/PAGE_SIZE && GlobalData.mailInfo.currentCount%PAGE_SIZE == 0 && _currentPage > 1)
			{
				_currentPage = _currentPage -1;
				list = GlobalData.mailInfo.getListByType(_currentType,_currentPage - 1);
			}
			_pageView.setPage(_currentPage);
			_pageView.totalRecord = GlobalData.mailInfo.currentCount;
			for(var i:int = 0;i <list.length;i++)
			{
				_cellList[i].mailItemInfo = list[i];
			}
		}
		
		public function loadData():void
		{
			loadHandler(null);
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			var index:int = _btns.indexOf(evt.currentTarget as MCacheTabBtn1);
			if(index == _currentType) return;
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			_btns[_currentType].selected = false;
			_currentType = index;
			_btns[_currentType].selected = true;
			_currentPage = 1;
			_checkBox.selected = false;
			if(_currentCell) _currentCell.selected = false;
			_currentCell = null;
			loadHandler(null);
		}
		
		public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_cellList)
			{
				for(var i:int = 0;i<_cellList.length;i++)
				{
					_cellList[i].dispose();
				}
				_cellList = null;
			}
			if(_currentCell)
			{
				_currentCell.dispose();
				_currentCell = null;
			}
			if(_btns)
			{
				for(i = 0;i<_btns.length;i++)
				{
					_btns[i].dispose();
				}
				_btns = null;
			}
			_labels = null;
			_pageView.dispose();
			_checkBox = null;
			_deleteBtn.dispose();
			_deleteBtn = null;
			_getBtn.dispose();
			_getBtn = null;
//			_getAllBtn.dispose();
//			_getAllBtn = null;
			_clearBtn.dispose();
			_clearBtn = null;
			_writeBtn.dispose();
			_writeBtn = null;
			typeGmAsset.dispose();
			if(parent) parent.removeChild(this);
		}
	}
}