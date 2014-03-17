package sszt.mounts.component
{
	import fl.controls.CheckBox;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.mounts.component.items.MountsSkillBookItemView;
	import sszt.mounts.event.MountsEvent;
	import sszt.mounts.mediator.MountsMediator;
	import sszt.mounts.socketHandler.MountsGetSkillBookListSocketHandler;
	import sszt.mounts.socketHandler.MountsRefreshSkillBooksSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTodayAlert;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.pet.BarAssetLP;
	import ssztui.pet.BarAssetLPBg;
	import ssztui.pet.TitleSkillAsset;
	
	public class MountsRefreshSkillBooksPanel extends MPanel
	{
		private const BOOKS_AMOUNT_MAX:int = 12;
		private const LUCY_VALUE_MAX:int = 1000;
		
		private var _mediator:MountsMediator;
		private var _myYuanbao:int;
		private var _myBindYuanbao:int;
		private var _luckyValue:int;
		
		private var _luckyImgCache:BitmapData;
		private var _checkboxUseBindMoney:CheckBox;
		private var _luckyImg:Bitmap;
		private var _btnRefresh:MCacheAssetBtn1;
		private var _btnRefreshOnce:MCacheAssetBtn1;
		
		private var _bg:IMovieWrapper;
		private var _bgTxtUseBindMoney:MAssetLabel;
		private var _bgTxtTips:MAssetLabel;
		private var _bgTxtLuckyPoint:MAssetLabel;
		/**
		 * MountsSkillBookItemView
		 * */
		private var _bookItemList:Array;
		private var _tile:MTile;
		
		public function MountsRefreshSkillBooksPanel(mediator:MountsMediator)
		{
			super(new MCacheTitle1("",new Bitmap(new TitleSkillAsset())), true,-1);
			_mediator = mediator;
			_mediator.module.mountsInfo.initMountsRefreshSkillBooksInfo();
			updateMoneyInfo(null);
			_luckyImgCache = new BarAssetLP();
			initView();
			addEvent();
			
			MountsGetSkillBookListSocketHandler.send();
		}
		
		private function updateMoneyInfo(e:Event):void
		{
			_myYuanbao = GlobalData.selfPlayer.userMoney.yuanBao;
			_myBindYuanbao = GlobalData.selfPlayer.userMoney.bindYuanBao;
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(488, 323);
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8, 2, 472, 315)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(14, 8, 460, 254)),
				new BackgroundInfo(BackgroundType.BORDER_13, new Rectangle(16, 10, 456, 250)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(14, 265, 460, 45)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(23, 17, 72, 106)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(97, 17, 72, 106)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(171, 17, 72, 106)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(245, 17, 72, 106)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(319, 17, 72, 106)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(393, 17, 72, 106)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(23, 125, 72, 106)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(97, 125, 72, 106)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(171, 125, 72, 106)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(245, 125, 72, 106)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(319, 125, 72, 106)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(393, 125, 72, 106)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(34, 26, 50, 50), new Bitmap(CellCaches.getCellBigBg()) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(108, 26, 50, 50), new Bitmap(CellCaches.getCellBigBg()) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(182, 26, 50, 50), new Bitmap(CellCaches.getCellBigBg()) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(256, 26, 50, 50), new Bitmap(CellCaches.getCellBigBg()) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(330, 26, 50, 50), new Bitmap(CellCaches.getCellBigBg()) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(404, 26, 50, 50), new Bitmap(CellCaches.getCellBigBg()) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(34, 134, 50, 50), new Bitmap(CellCaches.getCellBigBg()) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(108, 134, 50, 50), new Bitmap(CellCaches.getCellBigBg()) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(182, 134, 50, 50), new Bitmap(CellCaches.getCellBigBg()) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(256, 134, 50, 50), new Bitmap(CellCaches.getCellBigBg()) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(330, 134, 50, 50), new Bitmap(CellCaches.getCellBigBg()) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(404, 134, 50, 50), new Bitmap(CellCaches.getCellBigBg()) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(73, 275, 169, 24), new Bitmap(new BarAssetLPBg()) )
			]);
			addContent(_bg as DisplayObject);
			
			_bgTxtUseBindMoney = new MAssetLabel(LanguageManager.getWord('ssztl.pet.bingCopperFresh'), MAssetLabel.LABEL_TYPE2, TextFieldAutoSize.LEFT);
			_bgTxtUseBindMoney.move(45, 234);
			addContent(_bgTxtUseBindMoney);
			
			_bgTxtLuckyPoint = new MAssetLabel(LanguageManager.getWord('ssztl.role.lucky'), MAssetLabel.LABEL_TYPE8, TextFieldAutoSize.LEFT);
			_bgTxtLuckyPoint.move(25, 278);
			addContent(_bgTxtLuckyPoint);
			
			_bgTxtTips = new MAssetLabel(LanguageManager.getWord('ssztl.mounts.tipsGetSkillBooks'), MAssetLabel.LABEL_TYPE8, TextFieldAutoSize.LEFT);
			_bgTxtTips.move(244, 234);
			addContent(_bgTxtTips);
			
			_checkboxUseBindMoney = new CheckBox();
			_checkboxUseBindMoney.setSize(16, 16);
			_checkboxUseBindMoney.move(25, 236);
			addContent(_checkboxUseBindMoney);
			
			_luckyImg = new Bitmap();
			_luckyImg.x = 73;
			_luckyImg.y = 275;
			addContent(_luckyImg);
			
			_btnRefresh = new MCacheAssetBtn1(0, 3, LanguageManager.getWord('ssztl.pet.batchFresh'));
			_btnRefresh.move(306, 275);
			addContent(_btnRefresh);
			
			_btnRefreshOnce = new MCacheAssetBtn1(0, 3, LanguageManager.getWord('ssztl.pet.freshSkill'));
			_btnRefreshOnce.move(387, 275);
			addContent(_btnRefreshOnce);
			
			_tile = new MTile(74, 108, 6);
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.setSize(444, 216);
			_tile.move(23, 17);
			addContent(_tile);
			
			_bookItemList = [];
			var tmpBooksItem:MountsSkillBookItemView;
			for(var i:int = 0; i < BOOKS_AMOUNT_MAX; i++)
			{
				tmpBooksItem = new MountsSkillBookItemView(_mediator);
				_tile.appendItem(tmpBooksItem);
				_bookItemList.push(tmpBooksItem);
			}
		}
		
		private function addEvent():void
		{
			_btnRefresh.addEventListener(MouseEvent.CLICK, yesNoRefresh);
			_btnRefreshOnce.addEventListener(MouseEvent.CLICK, yesNoRefreshOnce);
			_mediator.module.mountsInfo.mountsRefreshSkillBooksInfo.addEventListener(MountsEvent.GET_SKILL_BOOK_LIST, update);
			_mediator.module.mountsInfo.mountsRefreshSkillBooksInfo.addEventListener(MountsEvent.GET_SKILL_BOOK_SUCCESSED, getSkillBookSuccessedHandler);
			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE, updateMoneyInfo);
		}
		
		private function removeEvent():void
		{
			_btnRefresh.removeEventListener(MouseEvent.CLICK, yesNoRefresh);
			_btnRefreshOnce.removeEventListener(MouseEvent.CLICK, yesNoRefreshOnce);
			_mediator.module.mountsInfo.mountsRefreshSkillBooksInfo.removeEventListener(MountsEvent.GET_SKILL_BOOK_LIST, update);
			_mediator.module.mountsInfo.mountsRefreshSkillBooksInfo.removeEventListener(MountsEvent.GET_SKILL_BOOK_SUCCESSED, getSkillBookSuccessedHandler);
			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE, updateMoneyInfo);
		}
		
		private function getSkillBookSuccessedHandler(e:Event):void
		{
			updateLuckyValue();
			var gotBooksPlace:int = _mediator.module.mountsInfo.mountsRefreshSkillBooksInfo.gotbooksPlace;
			var bookItem:MountsSkillBookItemView;
			for(var i:int = 0; i < BOOKS_AMOUNT_MAX; i++)
			{
				bookItem = MountsSkillBookItemView(_bookItemList[i]);
				if(!bookItem.visible)
				{
					continue;
				}
				if(bookItem.info.place == gotBooksPlace)
				{
					bookItem.info = null;
				}
				else
				{
					bookItem.btnGet.enabled = bookItem.btnGet.mouseEnabled = false;
				}
			}
			QuickTips.show(LanguageManager.getWord('ssztl.mounts.getSkillBookItemSuccessedTip'));
		}
		
		private function update(event:Event):void
		{
			updateBooks();
			updateLuckyValue();
		}
		
		private function updateBooks():void
		{
			clearBooks();
			var list:Array = _mediator.module.mountsInfo.mountsRefreshSkillBooksInfo.booksList;
			for(var i:int = 0; i < list.length; i++)
			{
				(_bookItemList[i] as MountsSkillBookItemView).info = list[i];
			}
		}
		
		private function clearBooks():void
		{
			for(var i:int = 0; i < _bookItemList.length; i++)
			{
				(_bookItemList[i] as MountsSkillBookItemView).info = null;
			}
		}
		
		private function updateLuckyValue():void
		{
			_luckyValue = _mediator.module.mountsInfo.mountsRefreshSkillBooksInfo.lucyValue;
			var percentage:Number = _luckyValue / LUCY_VALUE_MAX;
			if(_luckyImg.bitmapData)
			{
				_luckyImg.bitmapData.dispose();
			}
			_luckyImg.bitmapData = cutImg(_luckyImgCache, percentage);
		}
		
		private function cutImg(srcBitmapData:BitmapData, percentage:Number):BitmapData
		{
			var bmd:BitmapData;
			var bmdWidth:int = srcBitmapData.width * percentage;
			if(bmdWidth != 0)
			{
				var bmdHeight:int = srcBitmapData.height;
				bmd = new BitmapData(bmdWidth, bmdHeight);
				var rect:Rectangle = new Rectangle(0, 0, bmdWidth, bmdHeight);
				var pt:Point = new Point(0, 0);
				bmd.copyPixels(srcBitmapData, rect, pt);
			}
			return bmd;
		}
		
		
		private function yesNoRefreshOnce(event:MouseEvent):void
		{
			if(_mediator.module.mountsInfo.mountsRefreshSkillBooksInfo.lucyValue>0)
			{
				MTodayAlert.show(3,LanguageManager.getWord("ssztl.mounts.refreshAlert"),LanguageManager.getWord("ssztl.common.prompt"),MTodayAlert.OK|MTodayAlert.CANCEL,null,function(evt:CloseEvent):void
				{
					if(evt.detail == MTodayAlert.OK)
						sendRefreshOnceRequest();
				});
			}
			else
				sendRefreshOnceRequest();
			
			
		}
		/**
		 * 刷新一次技能书
		 * */
		private function sendRefreshOnceRequest():void
		{
			
			//使用非绑元宝
			if(!_checkboxUseBindMoney.selected && _myYuanbao >= 10)
			{
				MountsRefreshSkillBooksSocketHandler.send(1);
			}
			else if(!_checkboxUseBindMoney.selected && _myYuanbao < 10)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnoughShort'));
				//				goingCharge();
			}
				//使用绑定元宝
			else if(_checkboxUseBindMoney.selected && _myBindYuanbao >= 10)
			{
				MountsRefreshSkillBooksSocketHandler.send(0);
			}
			else
			{
				QuickTips.show(LanguageManager.getWord('ssztl.common.bindYuanBaoNotEnoughShort'));
			}
		
		}
		
		private function yesNoRefresh(event:MouseEvent):void
		{
			if(_mediator.module.mountsInfo.mountsRefreshSkillBooksInfo.lucyValue>0)
			{
				MTodayAlert.show(3,LanguageManager.getWord("ssztl.mounts.refreshAlert"),LanguageManager.getWord("ssztl.common.prompt"),MTodayAlert.OK|MTodayAlert.CANCEL,null,function(evt:CloseEvent):void
				{
					if(evt.detail == MTodayAlert.OK)
						sendRefreshRequest();
				});
			}
			else
				sendRefreshRequest();
		
			
		}
		
		/**
		 * 批量刷新技能书
		 * */
		private function sendRefreshRequest():void
		{
				//使用非绑元宝
				if(!_checkboxUseBindMoney.selected && _myYuanbao >= 110)
				{
					MountsRefreshSkillBooksSocketHandler.send(3);
				}
				else if(!_checkboxUseBindMoney.selected && _myYuanbao < 110)
				{
					QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnoughShort'));
	//				goingCharge();
				}
					//使用绑定元宝
				else if(_checkboxUseBindMoney.selected && _myBindYuanbao >= 110)
				{
					MountsRefreshSkillBooksSocketHandler.send(2);
				}
				else
				{
					QuickTips.show(LanguageManager.getWord('ssztl.common.bindYuanBaoNotEnoughShort'));
				}
		}
		
		private function goingCharge():void
		{
			//MAlert.show(LanguageManager.getWord("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,chargeAlertHandler);
			QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnough'));
		}
		
		private function chargeAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				JSUtils.gotoFill();
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			_mediator.module.mountsInfo.clearMountsRefreshSkillBooksInfo();
			_mediator = null;
			if(_checkboxUseBindMoney)
			{
				_checkboxUseBindMoney = null;
			}
			if(_luckyImg && _luckyImg.bitmapData)
			{
				_luckyImg.bitmapData.dispose();
				_luckyImg = null;
			}
			if(_luckyImgCache)
			{
				_luckyImgCache.dispose();
			}
			if(_btnRefresh)
			{
				_btnRefresh.dispose();
				_btnRefresh = null;
			}
			if(_btnRefreshOnce)
			{
				_btnRefreshOnce.dispose();
				_btnRefreshOnce = null;
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bgTxtUseBindMoney)
			{
				_bgTxtUseBindMoney = null;
			}
			if(_bgTxtTips)
			{
				_bgTxtTips = null;
			}
			if(_bgTxtLuckyPoint)
			{
				_bgTxtLuckyPoint = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			for(var i:int = 0; i < _bookItemList.length; i++)
			{
				(_bookItemList[i] as MountsSkillBookItemView).dispose();
				_bookItemList[i] = null;
			}
			_bookItemList = null;
		}
	}
}