package sszt.club.components.clubMain.pop.camp
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.club.components.clubMain.pop.items.ClubCollectionItemView;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.camp.ClubCollectionTemplateInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.club.BtnPageAsset;
	import ssztui.club.ClubTitleBossAsset;
	import ssztui.club.ClubTitleCollectionAsset;

	
	public class ClubCollectionPanel extends MPanel implements ITick
	{
		private var _collectionArr:Array;
		private var _callingCollectionHandler:Function;
		
		private var _bg:IMovieWrapper;
		private var _bgImg:Bitmap;
		
		private var _listBox:MSprite;
		private var _listMask:MSprite;
		private var _collectionTile:MTile;
		private var _collectionIntroView:ClubCollectionIntroView;
		private var _rewardsTile:MTile;
		
		private var _pagePrevBtn:MAssetButton1;
		private var _pageNextBtn:MAssetButton1;
		private var _moveTo:int;
		private var _tip:MAssetLabel;
		
		private var _currentCollectionItemView:ClubCollectionItemView;
		private var _collectionItemViewList:Array;
		
		private var _iconArray:Array;
		
		public function ClubCollectionPanel(callingCollectionHandler:Function,collectionArr:Array)
		{
			_callingCollectionHandler = callingCollectionHandler;
			_collectionArr = collectionArr;
			
			super(new MCacheTitle1("",new Bitmap(new ClubTitleCollectionAsset())),true,-1);
			
			_collectionItemViewList = _collectionTile.getItems();
			
			currentCollectionItemView = _collectionItemViewList[0];
			
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(394,422);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,378,412)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,370,404)),
			]);
			addContent(_bg as DisplayObject);
			
			_bgImg = new Bitmap();
			_bgImg.x = 14;
			_bgImg.y = 8;
			addContent(_bgImg);
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(104,253,38,38),new Bitmap(CellCaches.getCellBg())));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(144,253,38,38),new Bitmap(CellCaches.getCellBg())));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(184,253,38,38),new Bitmap(CellCaches.getCellBg())));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(224,253,38,38),new Bitmap(CellCaches.getCellBg())));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(264,253,38,38),new Bitmap(CellCaches.getCellBg())));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(304,253,38,38),new Bitmap(CellCaches.getCellBg())));
			
			_listBox = new MSprite();
			_listBox.move(47,27);
			addContent(_listBox);
			
			_listMask = new MSprite();
			_listMask.graphics.beginFill(0x000000,1);
			_listMask.graphics.drawRect(0,0,300,138);
			_listMask.graphics.endFill();
			_listBox.addChild(_listMask);
			
			_moveTo = 0;
			_iconArray = [];
			_collectionTile = new MTile(100,138,9);
			_collectionTile.setSize(900,138);
			_collectionTile.horizontalScrollPolicy = _collectionTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_collectionTile.itemGapW = _collectionTile.itemGapH = 0;
			_listBox.addChild(_collectionTile);
			_collectionTile.mask = _listMask;
			
			_pagePrevBtn = new MAssetButton1(new BtnPageAsset() as MovieClip);
			_pagePrevBtn.move(10,76);
			addContent(_pagePrevBtn);
			
			_pageNextBtn = new MAssetButton1(new BtnPageAsset() as MovieClip);
			_pageNextBtn.scaleX = -1;
			_pageNextBtn.move(384,76);
			addContent(_pageNextBtn);
			
			_collectionIntroView = new ClubCollectionIntroView();
			_collectionIntroView.move(24,193);
			addContent(_collectionIntroView);
			
			_rewardsTile = new MTile(40,40,6);
			_rewardsTile.setSize(240,40);
			_rewardsTile.horizontalScrollPolicy = _rewardsTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_rewardsTile.itemGapW = _rewardsTile.itemGapH = 0;
			_rewardsTile.move(104,253);
			addContent(_rewardsTile);
			
			var collectionItemView:ClubCollectionItemView;
			var collectionTemplateInfo:ClubCollectionTemplateInfo;
			for each(collectionTemplateInfo in _collectionArr)
			{
				collectionItemView = new ClubCollectionItemView(collectionTemplateInfo,_callingCollectionHandler);
				_collectionTile.appendItem(collectionItemView);
				var icon:Bitmap = new Bitmap();
				icon.x = icon.y = 16;
				collectionItemView.addChild(icon);
				_iconArray.push(icon);
			}
			
			_tip = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_tip.setLabelType([new TextFormat("SimSun",12,0x968063,null,null,null,null,null,null,null,null,null,5)]);
			_tip.move(30,318);
			addContent(_tip);
			_tip.setHtmlValue(LanguageManager.getWord("ssztl.club.callCollectionTip"));
		}
		
		private function initEvent():void
		{
			var collectionItemView:ClubCollectionItemView;
			for each(collectionItemView in _collectionItemViewList)
			{
				collectionItemView.addEventListener(MouseEvent.CLICK,collectionItemViewClicked);
			}
			_pagePrevBtn.addEventListener(MouseEvent.CLICK,prevClickHanlder);
			_pageNextBtn.addEventListener(MouseEvent.CLICK,nextClickHanlder);
		}
		
		private function removeEvent():void
		{
			var collectionItemView:ClubCollectionItemView;
			for each(collectionItemView in _collectionItemViewList)
			{
				collectionItemView.removeEventListener(MouseEvent.CLICK,collectionItemViewClicked);
			}
			_pagePrevBtn.removeEventListener(MouseEvent.CLICK,prevClickHanlder);
			_pageNextBtn.removeEventListener(MouseEvent.CLICK,nextClickHanlder);
		}
		private function prevClickHanlder(e:MouseEvent):void
		{
			if(_moveTo<0) _moveTo += 300;
			GlobalAPI.tickManager.addTick(this);
		}
		private function nextClickHanlder(e:MouseEvent):void
		{
			if(_moveTo>-600) _moveTo -= 300;
			GlobalAPI.tickManager.addTick(this);
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(Math.abs(_moveTo-_collectionTile.x) > 0.5)
			{
				_collectionTile.x += (_moveTo-_collectionTile.x)/5;
			}
			else
			{
				_collectionTile.x = _moveTo;
				GlobalAPI.tickManager.removeTick(this);
			}
		}
		
		private function collectionItemViewClicked(event:MouseEvent):void
		{
			var collectionItemView:ClubCollectionItemView = event.currentTarget as ClubCollectionItemView;
			currentCollectionItemView = collectionItemView;
		}
		
		public function set currentCollectionItemView(collectionItemView:ClubCollectionItemView):void
		{
			if(_currentCollectionItemView == collectionItemView)return;
			if(_currentCollectionItemView)
			{
				_currentCollectionItemView.selected = false;
			}
			_currentCollectionItemView = collectionItemView;
			_currentCollectionItemView.selected = true;
			
			_collectionIntroView.collectionInfo = _currentCollectionItemView.collectionInfo;
			clearRewardsView();
			
			var drop:Array = _currentCollectionItemView.collectionInfo.drop;
			var itemId:int;
			var itemTemplateInfo:ItemTemplateInfo;
			var cell:BaseItemInfoCell;
			
			for each(itemId in drop)
			{
				itemTemplateInfo = ItemTemplateList.getTemplate(itemId);
				cell = new BaseItemInfoCell();
				cell.info = itemTemplateInfo;
				_rewardsTile.appendItem(cell);
			}
			
		}
		
		private function clearRewardsView():void
		{
			_rewardsTile.disposeItems();
		}
		
		public function disableAllButton():void
		{
			var collectionItemView:ClubCollectionItemView;
			for each(collectionItemView in _collectionItemViewList)
			{
				collectionItemView.callBtn.enabled = false;
			}
		}
		
		public function set remaingCallingTimes(text:String):void
		{
			collectionIntroView.remainingCallingTimes = text;
		}
		
		public function get collectionIntroView():ClubCollectionIntroView
		{
			return _collectionIntroView;
		}
		public function assetsCompleteHandler():void
		{
			_bgImg.bitmapData = AssetUtil.getAsset("ssztui.club.CampBgAsset", BitmapData) as BitmapData;
			for(var i:int=0; i<_iconArray.length; i++)
			{
				_iconArray[i].bitmapData = AssetUtil.getAsset("ssztui.club.ClubIconCollectionAsset"+i, BitmapData) as BitmapData;
			}
		}
		
		public function set clubRich(rich:int):void
		{
			_collectionIntroView.clubRich = rich;
		}
		
		public function set lastCalledCollectionTime(time:int):void
		{
			//可召唤
			if(time == 0)
			{
				_collectionIntroView.cd = time;
			}
			else
			{
				//已经过去的时间
				var past:int = GlobalData.systemDate.getSystemDate().time/1000 - time;
				_collectionIntroView.cd = 600 - past ;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			
			_collectionArr = null;
			_callingCollectionHandler = null;
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			
			if(_collectionTile)
			{
				_collectionTile.disposeItems();
				_collectionTile.dispose();
				_collectionTile = null;
			}
			if(_collectionIntroView)
			{
				_collectionIntroView.dispose();
				_collectionIntroView = null;
			}
			if(_rewardsTile)
			{
				_rewardsTile.disposeItems();
				_rewardsTile.dispose();
				_rewardsTile = null;
			}
		}
	}
}