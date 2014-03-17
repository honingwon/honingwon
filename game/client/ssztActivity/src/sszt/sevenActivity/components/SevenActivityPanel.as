package sszt.sevenActivity.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.openActivity.SevenActivityTemplateList;
	import sszt.core.data.openActivity.SevenActivityTemplateListInfo;
	import sszt.core.socketHandlers.activity.SevenActivityInfoSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.events.ActivityEvent;
	import sszt.events.ModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.sevenActivity.mediator.SevenActivityMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.activity.BtnPageAsset2;
	import ssztui.sevenActivity.TitleAsset;
	
	public class SevenActivityPanel extends MPanel implements ITick
	{
		private var _bg:IMovieWrapper;
		
		private var _contentGg:Bitmap;
		private var _mediator:SevenActivityMediator;
		private var _itemTile:MTile;
		private var _itemList:Array;
		private var _listBox:MSprite;
		private var _listMask:MSprite;
		
		private var _pagePrevBtn:MAssetButton1;
		private var _pageNextBtn:MAssetButton1;
		private var _moveTo:int;
//		private var _today:Bitmap;
		
		private var _currentPage:int = 0;
		
		public function SevenActivityPanel(mediator:SevenActivityMediator)
		{
			_titleHeight = 38;
			super(new MCacheTitle1("",new Bitmap(new TitleAsset())),true,-1,true,true);
			_mediator = mediator;
			initEvent();
			initData();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(796,440);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,10,780,422)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,14,772,412)),
			]); 
			addContent(_bg as DisplayObject);
			
			_contentGg = new Bitmap();
			_contentGg.x = 14;
			_contentGg.y = 16;
			addContent(_contentGg as DisplayObject);
			
			_pagePrevBtn = new MAssetButton1(new BtnPageAsset2() as MovieClip);
			_pagePrevBtn.move(20,190);
			addContent(_pagePrevBtn);
			
			_pageNextBtn = new MAssetButton1(new BtnPageAsset2() as MovieClip);
			_pageNextBtn.scaleX = -1;
			_pageNextBtn.move(776,190);
			addContent(_pageNextBtn);
			
			_listBox = new MSprite();
			_listBox.move(60,26);
			addContent(_listBox);
			
			_listMask = new MSprite();
			_listMask.graphics.beginFill(0,0);
			_listMask.graphics.drawRect(0,0,169*4,395);
			_listMask.graphics.endFill();
			_listBox.addChild(_listMask);
			
			_itemList = [];
			_itemTile = new MTile(169,395,7);
			_itemTile.setSize(169*7,395);
			_itemTile.itemGapW = 0;
			_itemTile.horizontalScrollPolicy = _itemTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_listBox.addChild(_itemTile);
			_listBox.mask = _listMask;
			
		}
		
		private function initEvent():void
		{
			_pagePrevBtn.addEventListener(MouseEvent.CLICK,prevClickHanlder);
			_pageNextBtn.addEventListener(MouseEvent.CLICK,nextClickHanlder);
			
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.SEVEN_ACTIVITY_INFO,sevenActivityInfo);
		}
		
		public function reward2GotHandler():void
		{
//			_itemList
			var item:SevenActivityItemView;
			for each(item in _itemList)
			{
				item.gotBtn2Visible = false;
			}
		}
		private function removeEvent():void
		{
			_pagePrevBtn.removeEventListener(MouseEvent.CLICK,prevClickHanlder);
			_pageNextBtn.removeEventListener(MouseEvent.CLICK,nextClickHanlder);
			
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.SEVEN_ACTIVITY_INFO,sevenActivityInfo);
		}
		
		private function initData():void
		{
			if(!GlobalData.sevenActInfo.isInit)
			{
				SevenActivityInfoSocketHandler.send();
			}
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(Math.abs(_moveTo-_itemTile.x) > 0.5)
			{
				_itemTile.x += (_moveTo-_itemTile.x)/5;
			}
			else
			{
				_itemTile.x = _moveTo;
				GlobalAPI.tickManager.removeTick(this);
			}
		}
		
		/**
		 * 设置模板数据
		 */		
		private function setTemplateListData():void
		{
			clearData();
			var sevenActObj:SevenActivityTemplateListInfo;
			for(var i:int = 1; i<=SevenActivityUtils.sevenNum; i++)
			{
				sevenActObj = SevenActivityTemplateList.getActivity(i);
				var item:SevenActivityItemView = new SevenActivityItemView(sevenActObj);
				_itemTile.appendItem(item);
				_itemList.push(item);
			}
			var day:int = GlobalData.sevenActInfo.getDay();
//			if(day < 8)
//			{
//				_today = new Bitmap(new BgItemOverAsset());
//				_today.x = (day-1)*_itemTile.itemWidth;
//				_listBox.addChild(_today);
//			}
			_currentPage = day >5 ? 3  : day - 2;
			_currentPage = _currentPage < 0 ? 0 : _currentPage;
			setIndex();
		}
		
		private function prevClickHanlder(e:MouseEvent):void
		{
			if(_currentPage <= 0) return;
			_currentPage--;
			setIndex();
		}
		
		private function nextClickHanlder(e:MouseEvent):void
		{
			if(_currentPage >= 3) return;
			_currentPage++;
			setIndex();
		}
		private function setIndex():void
		{
			_moveTo = -_currentPage*_itemTile.itemWidth;
			GlobalAPI.tickManager.addTick(this);
		}
		
		private function sevenActivityInfo(evt:ModuleEvent):void
		{
			setTemplateListData();
		}
		
		private function clearData():void
		{
//			var i:int = 0;
//			if (_itemList)
//			{
//				while (i < _itemList.length)
//				{
//					
//					_itemList[i].dispose();
//					i++;
//				}
//				_itemList = [];
//			}
//			if(_today && _today.bitmapData)
//			{
//				_today.bitmapData.dispose();
//				_today = null;
//			}
			if(_itemTile)
			{
				_itemTile.disposeItems();
			}
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
//			if(_today && _today.bitmapData)
//			{
//				_today.bitmapData.dispose();
//				_today = null;
//			}
			if(_contentGg && _contentGg.bitmapData)
			{
				_contentGg.bitmapData.dispose();
				_contentGg = null;
			}
			_pagePrevBtn = null;
			_pageNextBtn = null;
			_itemTile = null;
			_itemList = null;
			super.dispose();
		}
		
		public function assetsCompleteHandler():void
		{
			_contentGg.bitmapData = AssetUtil.getAsset("ssztui.sevenActivity.MainBgAsset",BitmapData) as BitmapData;
		}
	}
}