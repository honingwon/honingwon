package sszt.store.component.secs
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mhqy.ui.BtnAsset2;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.DateUtil;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.store.command.StoreEndCommand;
	import sszt.store.component.AuctionCell;
	import sszt.store.datas.AuctionItem;
	import sszt.store.datas.AuctionMessageItem;
	import sszt.store.event.StoreEvent;
	import sszt.store.mediator.StoreMediator;
	import mhsm.ui.Btn2BgAsset;
	
	public class AutionTabPanel extends Sprite implements IGoodTabPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:StoreMediator;
		private var _btn1:MCacheAsset1Btn;
		private var _btn2:MCacheAsset1Btn;
		private var _tile1:MTile;
		private var _tile2:MTile;
		private var _countDownView1:CountDownView;
		private var _countDownView2:CountDownView;
		private var _lowPrice1:MAssetLabel;
		private var _highPrice1:MAssetLabel;
		private var _lowPrice2:MAssetLabel;
		private var _highPrice2:MAssetLabel;
		private var _yourPrice1:MAssetLabel;
		private var _yourPrice2:MAssetLabel;
		private var _cell1:AuctionCell;
		private var _cell2:AuctionCell;
		private var _auctionInfo1:AuctionItem;
		private var _auctionInfo2:AuctionItem;
		
		public function AutionTabPanel(type:int,mediator:StoreMediator)
		{
			_mediator = mediator;
			super();
			init();
		}
		
		private function init():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,0,329,360)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(336,0,329,360)),
				new BackgroundInfo(BackgroundType.BORDER_5,new Rectangle(9,166,311,185)),
				new BackgroundInfo(BackgroundType.BORDER_5,new Rectangle(345,166,311,185)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(13,126,297,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(349,126,297,2),new MCacheSplit2Line()),
				]);
			addChild(_bg as DisplayObject);
	
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(118,51,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.store.yuanBaoStartPrice"),MAssetLabel.LABELTYPE13)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(118,68,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.store.maxPrice"),MAssetLabel.LABELTYPE16)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(454,51,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.store.copperStartPrice"),MAssetLabel.LABELTYPE13)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(454,68,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.store.maxPrice"),MAssetLabel.LABELTYPE16)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(119,99,70,16),new MAssetLabel(LanguageManager.getWord("ssztl.store.timeDown"),MAssetLabel.LABELTYPE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(455,99,70,16),new MAssetLabel(LanguageManager.getWord("ssztl.store.timeDown"),MAssetLabel.LABELTYPE2)));
					
			_lowPrice1 = new MAssetLabel("",MAssetLabel.LABELTYPE13,TextFormatAlign.CENTER);
			_lowPrice1.move(189,51);
			addChild(_lowPrice1);
			_lowPrice2 = new MAssetLabel("",MAssetLabel.LABELTYPE13,TextFormatAlign.CENTER);
			_lowPrice2.move(460,51);
			addChild(_lowPrice2);
			_highPrice1 = new MAssetLabel("",MAssetLabel.LABELTYPE16,TextFormatAlign.CENTER);
			_highPrice1.move(189,68);
			addChild(_highPrice1);
			_highPrice2 = new MAssetLabel("",MAssetLabel.LABELTYPE16,TextFormatAlign.CENTER);
			_highPrice2.move(460,68);
			addChild(_highPrice2);
			_yourPrice1 = new MAssetLabel("",MAssetLabel.LABELTYPE16,TextFormatAlign.CENTER);
			_yourPrice1.move(40,141);
			addChild(_yourPrice1);
			_yourPrice2 = new MAssetLabel("",MAssetLabel.LABELTYPE16,TextFormatAlign.CENTER);
			_yourPrice2.move(376,141);
			addChild(_yourPrice2);
			_countDownView1 = new CountDownView();
			_countDownView1.move(191,99);
			addChild(_countDownView1);
			_countDownView2 = new CountDownView();
			_countDownView2.move(525,99);
			addChild(_countDownView2);
			_btn1 = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.store.iWantOffer"));
			_btn1.move(218,135);
			_btn1.enabled = false;
			addChild(_btn1);
			_btn2 = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.store.iWantOffer"));
			_btn2.move(554,135);
			_btn2.enabled = false;
			addChild(_btn2);
			_cell1 = new AuctionCell();
			_cell1.move(51,51);
			addChild(_cell1);
			_cell2 = new AuctionCell();
			_cell2.move(387,51);
			addChild(_cell2);
			
			_tile1 = new MTile(228,25);
			_tile1.setSize(296,170);
			_tile1.move(20,175);
			addChild(_tile1);
			_tile1.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile1.verticalScrollPolicy = ScrollPolicy.ON;
			_tile2 = new MTile(228,25);
			_tile2.setSize(296,170);
			_tile2.move(356,175);
			addChild(_tile2);
			_tile2.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile2.verticalScrollPolicy = ScrollPolicy.ON;
			
//			_countDownView1.start(100);
//			_countDownView2.start(100);
			
			initEvent();
		}
		
		public function assetsCompleteHandler():void
		{
			
		}
		
		private function initEvent():void
		{
			_btn1.addEventListener(MouseEvent.CLICK,btn1ClickHandler);
			_btn2.addEventListener(MouseEvent.CLICK,btn2ClickHandler);
			_countDownView1.addEventListener(Event.COMPLETE,complete1Handler);
			_countDownView2.addEventListener(Event.COMPLETE,complete2Handler);
		}
		
		private function removeEvent():void
		{
			_btn1.removeEventListener(MouseEvent.CLICK,btn1ClickHandler);
			_btn2.removeEventListener(MouseEvent.CLICK,btn2ClickHandler);
			_countDownView1.removeEventListener(Event.COMPLETE,complete1Handler);
			_countDownView2.removeEventListener(Event.COMPLETE,complete2Handler);
		}
		
		private function btn1ClickHandler(evt:MouseEvent):void
		{
			_mediator.showAuctionPanel(_auctionInfo1);
		}
		
		private function btn2ClickHandler(evt:MouseEvent):void
		{
			_mediator.showAuctionPanel(_auctionInfo2);	
		}
		
		private function complete1Handler(evt:Event):void
		{
			_lowPrice1.setValue("");
			_highPrice1.setValue("");
			_yourPrice1.setValue("");
			_btn1.enabled = false;
			_cell1.info = null;
			_cell1.count = 0;
			_tile1.clearItems();
		}
		
		private function complete2Handler(evt:Event):void
		{
			_lowPrice2.setValue("");
			_highPrice2.setValue("");
			_yourPrice2.setValue("");
			_btn2.enabled = false;
			_cell2.info = null;
			_cell2.count = 0;
			_tile2.clearItems();
		}
		
		private function setData(evt:StoreEvent):void
		{
			clear();
			var list:Array = _mediator.storeModule.auctionInfo.list;
			for each(var i:AuctionItem in list)
			{
				if(i.type == 1)
				{
					_auctionInfo1 = i;
					_auctionInfo1.addEventListener(StoreEvent.APPEND_AUCTION_MESSAGE,auction1UpdateHandler);
					_lowPrice1.setValue(_auctionInfo1.lowPrice.toString());
					_highPrice1.setValue(_auctionInfo1.highPrice.toString());
					_countDownView1.start(getCountDownTime());
					_cell1.count = _auctionInfo1.count;
					_cell1.info = ItemTemplateList.getTemplate(_auctionInfo1.templateId);
					_btn1.enabled = true;
					updateTile1();
				}else if(i.type == 2)
				{
					_auctionInfo2 = i;
					_auctionInfo2.addEventListener(StoreEvent.APPEND_AUCTION_MESSAGE,auction2UpdateHandler);
					_lowPrice2.setValue(_auctionInfo2.lowPrice.toString());
					_highPrice2.setValue(_auctionInfo2.highPrice.toString());
					_countDownView2.start(getCountDownTime());
					_cell2.count = _auctionInfo2.count;
					_cell2.info = ItemTemplateList.getTemplate(_auctionInfo2.templateId);
					_btn2.enabled = true;
					updateTile2();
				}
			}
		}
		
		private function auction1UpdateHandler(evt:StoreEvent):void
		{
			var message:AuctionMessageItem = evt.data as AuctionMessageItem;
			_highPrice1.setValue(message.price.toString());
			var text:TextField = createMessageItem(message,1);
			_tile1.appendItem(text);
		}
		
		private function auction2UpdateHandler(evt:StoreEvent):void
		{
			var message:AuctionMessageItem = evt.data as AuctionMessageItem;
			_highPrice2.setValue(message.price.toString());
			var text:TextField = createMessageItem(message,2);
			_tile2.appendItem(text);
		}
		
		private function updateTile1():void
		{
			var textItem:TextField;
			for each(var i:AuctionMessageItem in _auctionInfo1.messages)
			{
				textItem = createMessageItem(i,1);
				_tile1.appendItem(textItem);
			}
		}
		
		private function updateTile2():void
		{
			var textItem:TextField;
			for each(var i:AuctionMessageItem in _auctionInfo2.messages)
			{
				textItem = createMessageItem(i,2);
				_tile2.appendItem(textItem);
			}
		}
		
		private function createMessageItem(item:AuctionMessageItem,type:int):TextField
		{
			var str:String;
			if(type == 1) str = LanguageManager.getWord("ssztl.common.yuanBao2");
			else str = LanguageManager.getWord("ssztl.common.copper2");
			var textItem:TextField = new TextField();
			textItem.height = 20;
			textItem.width = 220;
			textItem.textColor = 0xffffff;
			textItem.htmlText = "<font color = '#00ff00'>[[" + item.serverId + "]" + item.nick + "]</font>" + "出价" + "<font color = '#fffc00'>" + 
				item.price + str + "</font>";
			return textItem;
		}
		
		private function getCountDownTime():int
		{
			var date:Date = GlobalData.systemDate.getSystemDate();
			var hour:int;
			if(date.getHours() == 12) hour = 12;
			else if (date.getHours() == 18) hour = 18;
			else hour = 0;
			var date1:Date = new Date(date.getFullYear(),date.getMonth(),date.date,hour,30,0,0);
			var del:Number = DateUtil.getTimeBetween(date,date1);
			return del/1000;
		}
		
		private function clear():void
		{
			complete1Handler(null);
			complete2Handler(null);
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		public function show():void
		{
//			if((GlobalData.systemDate.getSystemDate().hours == 12 && GlobalData.systemDate.getSystemDate().minutes < 30) ||
//				(GlobalData.systemDate.getSystemDate().hours == 18 && GlobalData.systemDate.getSystemDate().minutes < 30))
//			{
				_mediator.storeModule.auctionInfo.addEventListener(StoreEvent.AUCTION_UPDATE,setData);
//				_mediator.getAuctionData();
//			}
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{		
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_btn1.dispose();
			_btn1 = null;
			_btn2.dispose();
			_btn2 = null;
			if(_tile1)
			{
				_tile1.dispose();
				_tile1 = null;
			}
			if(_tile2)
			{
				_tile2.dispose();
				_tile2 = null;
			}
			if(_auctionInfo1)
			{
				_auctionInfo1.removeEventListener(StoreEvent.APPEND_AUCTION_MESSAGE,auction1UpdateHandler);
				_auctionInfo1 = null;
			}
			if(_auctionInfo2)
			{
				_auctionInfo2.removeEventListener(StoreEvent.APPEND_AUCTION_MESSAGE,auction2UpdateHandler);
				_auctionInfo2 = null;
			}
			if(_cell1)
			{
				_cell1.dispose();
				_cell1 = null;
			}
			if(_cell2)
			{
				_cell2.dispose();
				_cell2 = null;
			}
			_yourPrice1 = null;
			_yourPrice2 = null;
			_lowPrice1 = null;
			_lowPrice2 = null;
			_highPrice1 = null;
			_highPrice2 = null;
			if(_countDownView1)
			{
				_countDownView1.removeEventListener(Event.COMPLETE,complete1Handler);
				_countDownView1.dispose();
				_countDownView1 = null;
			}
			if(_countDownView2)
			{
				_countDownView2.removeEventListener(Event.COMPLETE,complete2Handler);
				_countDownView2.dispose();
				_countDownView2 = null;
			}
			if(parent) parent.removeChild(this);
		}
		
		public function showGoods(page:int, type:int):void
		{	
		}
	}
}