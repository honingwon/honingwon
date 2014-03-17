package sszt.club.components.clubMain.pop.camp
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.club.components.clubMain.pop.items.ClubBossItemView;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.camp.ClubBossTemplateInfo;
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
	
	public class ClubBossPanel extends MPanel implements ITick
	{
		private var _bossArr:Array;
		private var _callingBossHandler:Function;
		
		private var _bg:IMovieWrapper;
		private var _bgImg:Bitmap;
		
		private var _listBox:MSprite;
		private var _listMask:MSprite;
		private var _bossTile:MTile;
		private var _bossIntroView:ClubBossIntroView;
		private var _rewardsTile:MTile;
		private var _pagePrevBtn:MAssetButton1;
		private var _pageNextBtn:MAssetButton1;
		
		private var _currentBossItemView:ClubBossItemView;
		private var _bossItemViewList:Array;
		private var _iconArray:Array;
		
		private var _moveTo:int;
		private var _tip:MAssetLabel;
		
		public function ClubBossPanel(callingBossHandler:Function,bossArr:Array)
		{
			_callingBossHandler = callingBossHandler;
			_bossArr = bossArr;
			
			super(new MCacheTitle1("",new Bitmap(new ClubTitleBossAsset())),true,-1);
			
			_bossItemViewList = _bossTile.getItems();
			currentBossItemView = _bossItemViewList[0];
			
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
			_bossTile = new MTile(100,138,9);
			_bossTile.setSize(900,138);
			_bossTile.horizontalScrollPolicy = _bossTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_bossTile.itemGapW = _bossTile.itemGapH = 0;
			_listBox.addChild(_bossTile);
			_bossTile.mask = _listMask;
			
			_pagePrevBtn = new MAssetButton1(new BtnPageAsset() as MovieClip);
			_pagePrevBtn.move(10,76);
			addContent(_pagePrevBtn);
			
			_pageNextBtn = new MAssetButton1(new BtnPageAsset() as MovieClip);
			_pageNextBtn.scaleX = -1;
			_pageNextBtn.move(384,76);
			addContent(_pageNextBtn);
			  
			_bossIntroView = new ClubBossIntroView();
			_bossIntroView.move(24,193);
			addContent(_bossIntroView);
			
			_rewardsTile = new MTile(40,40,6);
			_rewardsTile.setSize(240,40);
			_rewardsTile.horizontalScrollPolicy = _rewardsTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_rewardsTile.itemGapW = _rewardsTile.itemGapH = 0;
			_rewardsTile.move(104,253);
			addContent(_rewardsTile);
			
			var bossItemView:ClubBossItemView;
			var bossTemplateInfo:ClubBossTemplateInfo;
			for each(bossTemplateInfo in _bossArr)
			{
				bossItemView = new ClubBossItemView(bossTemplateInfo,_callingBossHandler);
				_bossTile.appendItem(bossItemView);
				var icon:Bitmap = new Bitmap();
				icon.x = icon.y = 16;
				bossItemView.addChild(icon);
				_iconArray.push(icon);
			}
			
			_tip = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_tip.setLabelType([new TextFormat("SimSun",12,0x968063,null,null,null,null,null,null,null,null,null,5)]);
			_tip.move(30,318);
			addContent(_tip);
			_tip.setHtmlValue(LanguageManager.getWord("ssztl.club.callBossTip"));
		}
		
		private function initEvent():void
		{
			var bossItemView:ClubBossItemView;
			for each(bossItemView in _bossItemViewList)
			{
				bossItemView.addEventListener(MouseEvent.CLICK,bossItemViewClicked);
			}
			_pagePrevBtn.addEventListener(MouseEvent.CLICK,prevClickHanlder);
			_pageNextBtn.addEventListener(MouseEvent.CLICK,nextClickHanlder);
		}
		
		private function removeEvent():void
		{
			var bossItemView:ClubBossItemView;
			for each(bossItemView in _bossItemViewList)
			{
				bossItemView.removeEventListener(MouseEvent.CLICK,bossItemViewClicked);
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
			if(Math.abs(_moveTo-_bossTile.x) > 0.5)
			{
				_bossTile.x += (_moveTo-_bossTile.x)/5;
			}
			else
			{
				_bossTile.x = _moveTo;
				GlobalAPI.tickManager.removeTick(this);
			}
		}
		
		private function bossItemViewClicked(event:MouseEvent):void
		{
			var bossItemView:ClubBossItemView = event.currentTarget as ClubBossItemView;
			currentBossItemView = bossItemView;
		}
		
		public function set currentBossItemView(bossItemView:ClubBossItemView):void
		{
			if(_currentBossItemView == bossItemView)return;
			if(_currentBossItemView)
			{
				_currentBossItemView.selected = false;
			}
			_currentBossItemView = bossItemView;
			_currentBossItemView.selected = true;
			
			_bossIntroView.bossInfo = _currentBossItemView.bossInfo;
			_bossIntroView.needLevel = _currentBossItemView.bossInfo.guild_level;
			clearRewardsView();
			
			var drop:Array = _currentBossItemView.bossInfo.drop;
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
			var bossItemView:ClubBossItemView;
			for each(bossItemView in _bossItemViewList)
			{
				bossItemView.callBtn.enabled = false;
			}
		}
		
		public function set remaingCallingTimes(text:String):void
		{
			bossIntroView.remainingCallingTimes = text;
		}
		
		public function get bossIntroView():ClubBossIntroView
		{
			return _bossIntroView;
		}
		public function assetsCompleteHandler():void
		{
			_bgImg.bitmapData = AssetUtil.getAsset("ssztui.club.CampBgAsset", BitmapData) as BitmapData;
			for(var i:int=0; i<_iconArray.length; i++)
			{
				_iconArray[i].bitmapData = AssetUtil.getAsset("ssztui.club.ClubIconBossAsset"+i, BitmapData) as BitmapData;
			}
		}
		
		public function set clubRich(rich:int):void
		{
			_bossIntroView.clubRich = rich;
		}
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			
			_bossArr = null;
			_callingBossHandler = null;
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bgImg && _bgImg.bitmapData)
			{
				_bgImg.bitmapData.dispose();
				_bg = null;
			}
			
			if(_bossTile)
			{
				_bossTile.disposeItems();
				_bossTile.dispose();
				_bossTile = null;
			}
			if(_bossIntroView)
			{
				_bossIntroView.dispose();
				_bossIntroView = null;
			}
			if(_rewardsTile)
			{
				_rewardsTile.disposeItems();
				_rewardsTile.dispose();
				_rewardsTile = null;
			}
			GlobalAPI.tickManager.removeTick(this);
		}
	}
}