package sszt.activity.components.panels
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import sszt.activity.components.cell.AwardCell;
	import sszt.activity.components.itemView.BossItemView;
	import sszt.activity.events.ActivityInfoEvents;
	import sszt.activity.mediators.ActivityMediator;
	import sszt.activity.socketHandlers.BossInfoSocketHandler;
	import sszt.constData.BossType;
	import sszt.constData.CategoryType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.BossTemplateInfo;
	import sszt.core.data.activity.BossTemplateInfoList;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.assets.AssetSource;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.activity.BarBgAsset;
	import ssztui.activity.BtnPageAsset;
	import ssztui.activity.TagDLAsset;
	import ssztui.activity.WorldBossTitleAsset;
	
	public class ActivityBossPanel extends MPanel implements ITick
	{
		private var _mediator:ActivityMediator;
		private var _bg:IMovieWrapper;
		private var _bg2:IMovieWrapper;
		
		private var _itemMTile:MTile;
		private var _cellMTile:MTile;
		private var _bossName:MAssetLabel;
		private var _atMap:MAssetLabel;
		private var _desciptionLabel:MAssetLabel;
		private var _spriteBtn:Sprite;
		private var _transferBtn:MBitmapButton;
		
		private var _cellList:Array;
		private var _currentItem:BossItemView;
		private var _liveInfo:MAssetLabel;
		private var _countDown:CountDownView;
		
		private var _pagePrevBtn:MAssetButton1;
		private var _pageNextBtn:MAssetButton1;
		private var _listBox:MSprite;
		private var _listMask:MSprite;
		private var _moveTo:int;
		
		private var _bgFace:Bitmap;
		private var _picPath:String;
		
		private var _tabs:Array;
		private var _currentIndex:int = -1;
		
		public function ActivityBossPanel(argMediator:ActivityMediator)
		{
			_mediator = argMediator;
			super(new MCacheTitle1("",new Bitmap(new WorldBossTitleAsset())),true,-1,true,true);
			
			BossInfoSocketHandler.send();
		}
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(629,417);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,613,383)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,29,605,309)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,338,605,66)),
			]);
			addContent(_bg as DisplayObject);
			
			_bgFace = new Bitmap();
			_bgFace.x = 14;
			_bgFace.y = 31;
			addContent(_bgFace);
			
			_bg2 = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(102,138,61,15),new Bitmap(new TagDLAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(30,83,61,15),new MAssetLabel(LanguageManager.getWord("ssztl.scene.belongMap")+"：",MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(30,103,61,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.currentState"),MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT)),
			]);
			addContent(_bg2 as DisplayObject);
			
			_tabs = [];
			var labels:Array = [LanguageManager.getWord("ssztl.common.activityBossTab1"),LanguageManager.getWord("ssztl.common.activityBossTab2")];
			for(var i:int=0; i<labels.length; i++)
			{
				_tabs[i] = new MCacheTabBtn1(0, 2, labels[i]);
				_tabs[i].move(15+69*i,0);
				addContent(_tabs[i]);
			}
			
			_listBox = new MSprite();
			_listBox.move(21,346);
			addContent(_listBox);
			
			_listMask = new MSprite();
			_listMask.graphics.beginFill(0x000000,1);
			_listMask.graphics.drawRect(0,0,324,50);
			_listMask.graphics.endFill();
			_listBox.addChild(_listMask);
			
			_moveTo = 0;
			_cellList = [];
			_itemMTile = new MTile(50,50);
			_itemMTile.itemGapW = 4;
			_itemMTile.setSize(50,50);
			_listBox.addChild(_itemMTile);
			_itemMTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_itemMTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_itemMTile.verticalScrollBar.lineScrollSize = 56;
			_itemMTile.mask = _listMask;
			
			_pagePrevBtn = new MAssetButton1(new BtnPageAsset() as MovieClip);
			_pagePrevBtn.move(6,336);
//			addContent(_pagePrevBtn);
			
			_pageNextBtn = new MAssetButton1(new BtnPageAsset() as MovieClip);
			_pageNextBtn.scaleX = -1;
			_pageNextBtn.move(623,336);
//			addContent(_pageNextBtn);
			
			_cellMTile = new MTile(38, 38, 5);
			_cellMTile.itemGapH = 3;
			_cellMTile.itemGapW = 4;
			_cellMTile.setSize(210, 119);
			_cellMTile.move(29,160);
			addContent(_cellMTile);
			_cellMTile.horizontalScrollPolicy = _cellMTile.verticalScrollPolicy = ScrollPolicy.OFF;
			
			_bossName = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT);
			_bossName.move(30,43);
			addContent(_bossName);
			
			_atMap = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT);
			_atMap.textColor = 0x66ff71;
			_atMap.move(90,83);
			addContent(_atMap);
			
			_spriteBtn = new Sprite();
			addContent(_spriteBtn);
			_spriteBtn.buttonMode = true;
			
			_transferBtn = new MBitmapButton(AssetSource.getTransferShoes());
			_transferBtn.move(_atMap.textWidth+_atMap.x+5,85);
			addContent(_transferBtn);
			
			_liveInfo = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT);
			_liveInfo.textColor = 0xff6600;
			_liveInfo.move(90,103);
			addContent(_liveInfo);
			
			_countDown = new CountDownView();
			_countDown.setLabelType(new TextFormat(LanguageManager.getWord('ssztl.common.wordType3'),12,0xff6600));
			_countDown.move(152,103);
			addContent(_countDown);
			
			_desciptionLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT);
			_desciptionLabel.setLabelType([new TextFormat("Microsoft Yahei",12,0xd5c58d),new GlowFilter(0x000000,1,2,2,6)]);
			_desciptionLabel.wordWrap = true;
			_desciptionLabel.mouseEnabled = _desciptionLabel.mouseWheelEnabled = false;
			_desciptionLabel.setSize(540,75);
			_desciptionLabel.move(27,296);
			addContent(_desciptionLabel);
			
			initTemplateData();
			initEvent();
			
			setIndex(0);
		}
		public function update(times:int,dt:Number = 0.04):void
		{
			if(Math.abs(_moveTo-_itemMTile.x) > 0.5)
			{
				_itemMTile.x += (_moveTo-_itemMTile.x)/5;
			}
			else
			{
				_itemMTile.x = _moveTo;
				GlobalAPI.tickManager.removeTick(this);
			}
		}
		private function initTemplateData():void
		{
			for each(var bossTemplateInfo:BossTemplateInfo in BossTemplateInfoList.list)
			{
				var itemView:BossItemView = new BossItemView(bossTemplateInfo);
				_itemMTile.appendItem(itemView);
			}
			
			_itemMTile.columns = itemViewList.length;
			_itemMTile.width = itemViewList.length*54;
			_itemMTile.sortOn(['sortFieldBossType', 'sortFieldBossLevel','sortFieldBossMapId' ],[Array.NUMERIC, Array.NUMERIC, Array.NUMERIC]);
			
			if(itemViewList.length > 0)
			{
				switchTo(itemViewList[0]);
			}
		}
		
		private function initEvent():void
		{
			for(var i:int = 0; i < itemViewList.length; i++)
			{
				BossItemView(itemViewList[i]).addEventListener(MouseEvent.CLICK,itemClickHandler);
			}
			for(i = 0; i < _tabs.length; i++)
			{
				_tabs[i].addEventListener(MouseEvent.CLICK,tabClickHandler);
			}
			_mediator.moduel.activityInfo.addEventListener(ActivityInfoEvents.UPDATE_BOSS_INFO, handleBossInfoUpdate);
			
			_spriteBtn.addEventListener(MouseEvent.CLICK,spriteBtnClickHandler);
			_transferBtn.addEventListener(MouseEvent.CLICK,transferClickHandler);
			_pagePrevBtn.addEventListener(MouseEvent.CLICK,prevClickHanlder);
			_pageNextBtn.addEventListener(MouseEvent.CLICK,nextClickHanlder);
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0; i < itemViewList.length; i++)
			{
				BossItemView(itemViewList[i]).removeEventListener(MouseEvent.CLICK,itemClickHandler);
			}
			for(i = 0; i < _tabs.length; i++)
			{
				_tabs[i].removeEventListener(MouseEvent.CLICK,tabClickHandler);
			}
			_mediator.moduel.activityInfo.removeEventListener(ActivityInfoEvents.UPDATE_BOSS_INFO, handleBossInfoUpdate);
			
			_spriteBtn.removeEventListener(MouseEvent.CLICK,spriteBtnClickHandler);
			_transferBtn.removeEventListener(MouseEvent.CLICK,transferClickHandler);
			_pagePrevBtn.removeEventListener(MouseEvent.CLICK,prevClickHanlder);
			_pageNextBtn.removeEventListener(MouseEvent.CLICK,nextClickHanlder);
		}
		
		private function spriteBtnClickHandler(evt:MouseEvent):void
		{
			if(GlobalData.copyEnterCountList.isInCopy || MapTemplateList.getIsInSpaMap() || MapTemplateList.getIsInVipMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
				return ;
			}
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.WALKTOPOINT, {sceneId:_currentItem.info.transportMapId, target:_currentItem.info.transportPosition}));
		}
		private function tabClickHandler(evt:MouseEvent):void
		{
			var index:int = _tabs.indexOf(evt.currentTarget);
			setIndex(index);
		}
		private function setIndex(value:int):void
		{
			if(_currentIndex == value) return;
			if(_currentIndex > -1 ) _tabs[_currentIndex].selected = false;
			_currentIndex = value;
			_tabs[_currentIndex].selected = true;
			if(_currentIndex == 0)
			{
				_itemMTile.x = 0;
				_listMask.width = 54*6;
				switchTo(itemViewList[0]);
			}else
			{
				_itemMTile.x = -324;
				_listMask.width = 54*8;
				switchTo(itemViewList[6]);
			}
		}
		private function transferClickHandler(evt:MouseEvent):void
		{
			if(!GlobalData.selfPlayer.canfly())
			{
				MAlert.show(LanguageManager.getWord("ssztl.common.transferNotEnough") ,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,transferCloseHandler);
			}
			else
			{
				var sceneId:int = _currentItem.info.transportMapId;
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER,{sceneId:sceneId,target:_currentItem.info.transportPosition}));
			}
		}
		private function transferCloseHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				BuyPanel.getInstance().show([CategoryType.TRANSFER],new ToStoreData(103));
			}
		}
		private function prevClickHanlder(e:MouseEvent):void
		{
			if(_moveTo<0) _moveTo = 0;
			GlobalAPI.tickManager.addTick(this);
		}
		private function nextClickHanlder(e:MouseEvent):void
		{
			if(_moveTo>-216) _moveTo = -216;
			GlobalAPI.tickManager.addTick(this);
		}
		
		private function handleBossInfoUpdate(e:Event):void
		{
			var item:BossItemView;
			var list:Dictionary = _mediator.moduel.activityInfo.bossList;
			for(var i:int = 0; i < itemViewList.length; i++)
			{
				item = itemViewList[i];
				item.bossItemInfo = list[item.info.id];
			}
			
			if(_currentItem.bossItemInfo)
			{
				if(_currentItem.bossItemInfo.isLive)
				{
					_liveInfo.setHtmlValue("<font color='#ffcc00'>" + LanguageManager.getWord('ssztl.common.live') + "</font>");
					_countDown.visible = false;
				}
				else
				{
					if(_currentItem.info.type == BossType.INTERVAL)//固定间隔时间刷新boss
					{
						_liveInfo.setHtmlValue(LanguageManager.getWord('ssztl.common.reliveCountDown'));
						_countDown.visible = true;
						_countDown.start(_currentItem.bossItemInfo.intervalRemaining);
					}
					else//固定时间点刷新
					{
						//几点时刷新
						_countDown.visible = false;
						_liveInfo.setHtmlValue(LanguageManager.getWord('ssztl.common.whenRelive', _currentItem.bossItemInfo.nextTime));
					}
				}
			}
		}
		
//		private function clearView():void
//		{
//			var item:BossItemView;
//			for(var i:int = 0; i < itemViewList.length; i++)
//			{
//				item = itemViewList[i];
//				item.bossItemInfo = null;
//			}
//		}
		
		private function switchTo(value:BossItemView):void
		{
			if(_currentItem)
			{
				_currentItem.selected = false;
			}
			_currentItem = value;
			_currentItem.selected = true;
			updateView();
			_picPath = GlobalAPI.pathManager.getWorldBossPath(_currentItem.info.id.toString());
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
		}
		private function loadAvatarComplete(data:BitmapData):void
		{
			_bgFace.bitmapData = data;
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			var target:BossItemView = evt.currentTarget as BossItemView;
			if(_currentItem == target) return;
			switchTo(target);
		}
		
		private function updateView():void
		{
			clearCells();
			
			var cell:AwardCell;
			var awards:Array = _currentItem.info.drop;
			for(var i:int = 0; i < awards.length; i++)
			{
				cell = new AwardCell();
				cell.info = ItemTemplateList.getTemplate(awards[i]);
				if(cell.info != null)
				{
					_cellList.push(cell);
					_cellMTile.appendItem(cell);
				}
			}
//			_cellMTile.columns = awards.length;
//			_cellMTile.width = 42*awards.length;
//			_cellMTile.x =  (429 - 42*awards.length)/2;
			_desciptionLabel.htmlText = _currentItem.info.description;
			_desciptionLabel.y = 327 - _desciptionLabel.textHeight;
			
			_bossName.setHtmlValue(
				"<font size='20' color='#fff000'><b>" + _currentItem.info.name + "</b></font> " +
				"<font size='16'>" + LanguageManager.getWord("ssztl.common.levelValue2",_currentItem.info.level) + "</font>"
				);
			_atMap.setHtmlValue("<u>" + MapTemplateList.getMapTemplate(_currentItem.info.mapId).name + "</u>");
			_spriteBtn.graphics.clear();
			_spriteBtn.graphics.beginFill(0,0);
			_spriteBtn.graphics.drawRect(_atMap.x,_atMap.y,_atMap.textWidth,_atMap.textHeight);
			_spriteBtn.graphics.endFill();
			_transferBtn.x = _atMap.textWidth+_atMap.x+5;
			
			if(_currentItem.bossItemInfo)
			{
				if(_currentItem.bossItemInfo.isLive)
				{
					_liveInfo.setHtmlValue("<font color='#ffcc00'>" + LanguageManager.getWord('ssztl.common.live') + "</font>");
					_countDown.visible = false;
				}
				else
				{
					if(_currentItem.info.type == BossType.INTERVAL)//固定间隔时间刷新boss
					{
						_liveInfo.setHtmlValue(LanguageManager.getWord('ssztl.common.reliveCountDown'));
						_countDown.visible = true;
						_countDown.start(_currentItem.bossItemInfo.intervalRemaining);
					}
					else//固定时间点刷新
					{
						//几点时刷新
						_countDown.visible = false;
						_liveInfo.setHtmlValue(LanguageManager.getWord('ssztl.common.whenRelive', _currentItem.bossItemInfo.nextTime));
					}
				}
			}
		}
		
		private function clearCells():void
		{
			if(_cellList.length <= 0) return;
			_cellMTile.disposeItems();
			_cellList = [];
		}
		
		public function get itemViewList():Array
		{
			return _itemMTile.getItems();
		}
		
		override public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bg2)
			{
				_bg2.dispose();
				_bg2 = null;
			}
			if(_bgFace)
			{
				_bgFace = null;
			}
			if(_itemMTile)
			{
				_itemMTile.disposeItems();
				_itemMTile.dispose();
				_itemMTile = null;
			}
			if(_cellMTile)
			{
				_cellMTile.disposeItems();
				_cellMTile.dispose();
				_cellMTile = null;
			}
			_desciptionLabel = null;
			_cellList = null;
			_currentItem = null;
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
			GlobalAPI.tickManager.removeTick(this);
			super.dispose();
		}
	}
}