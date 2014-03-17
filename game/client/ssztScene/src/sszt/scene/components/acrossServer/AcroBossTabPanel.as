package sszt.scene.components.acrossServer
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	
	import sszt.core.data.bossWar.BossWarTemplateInfo;
	import sszt.core.data.bossWar.BossWarTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.bossWar.BossWarInfo;
	import sszt.scene.events.SceneAcroSerUpdateEvent;
	import sszt.scene.events.SceneBossWarUpdateEvent;
	import sszt.scene.mediators.AcroSerMediator;
	import sszt.scene.socketHandlers.bossWar.BossWarMainInfoUpdateSocketHandler;
	
	public class AcroBossTabPanel extends Sprite implements IAcroSerTabPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:AcroSerMediator;
		private var _mTile:MTile;
		private var _itemList:Array;
		private var _currentSelect:int = -1;
		private var _acroBossInfoPanel:AcroBossInfoPanel;
		
		public function AcroBossTabPanel(argMediator:AcroSerMediator)
		{
			super();
			_mediator = argMediator;
			initView();
			initEvents();
			BossWarMainInfoUpdateSocketHandler.send(3);
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
												new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,0,397,391)),
												new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(400,0,232,391)),
												new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(4,4,390,22)),
//												new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(404,4,224,22)),
												
												new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(68,6,11,17),new MCacheSplit3Line()),
												new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(110,6,11,17),new MCacheSplit3Line()),
												new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(186,6,11,17),new MCacheSplit3Line()),
												new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(263,6,11,17),new MCacheSplit3Line()),
												
												
												new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,56,364,2),new MCacheSplit2Line()),
												new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,89,364,2),new MCacheSplit2Line()),
												new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,122,364,2),new MCacheSplit2Line()),
												new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,155,364,2),new MCacheSplit2Line()),
												new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,188,364,2),new MCacheSplit2Line()),
												new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,221,364,2),new MCacheSplit2Line()),
												new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,254,364,2),new MCacheSplit2Line()),
												new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,287,364,2),new MCacheSplit2Line()),
												new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,320,364,2),new MCacheSplit2Line()),
												new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,353,364,2),new MCacheSplit2Line()),
												new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,386,364,2),new MCacheSplit2Line()),
			]);
			addChild(_bg as DisplayObject);
			
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.bossName"),MAssetLabel.LABELTYPE14);
			label1.move(13,6);
			addChild(label1);
			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.level2"),MAssetLabel.LABELTYPE14);
			label2.move(82,6);
			addChild(label2);
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.state"),MAssetLabel.LABELTYPE14);
			label3.move(139,6);
			addChild(label3);
			var label4:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.activityPlace"),MAssetLabel.LABELTYPE14);
			label4.move(204,6);
			addChild(label4);
			var label5:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.operation"),MAssetLabel.LABELTYPE14);
			label5.move(304,6);
			addChild(label5);
			
			_itemList = [];
			
			_mTile = new MTile(390,33);
			_mTile.itemGapH = _mTile.itemGapW = 0;
			_mTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mTile.verticalScrollBar.lineScrollSize = 33;
			_mTile.setSize(390,363);
			_mTile.move(5,26);
			addChild(_mTile);
			
			_acroBossInfoPanel = new AcroBossInfoPanel();
			addChild(_acroBossInfoPanel);
			_acroBossInfoPanel.move(407,5);
			
			for each(var j:BossWarTemplateInfo in BossWarTemplateList.list)
			{
				var tmpItem:AcroBossItemView = new AcroBossItemView(j,_mediator);
				if(j.type == 3)
				{
					_itemList.push(tmpItem);
					_mTile.appendItem(tmpItem);
				}
				tmpItem.addEventListener(MouseEvent.CLICK,itemSelectHandler);
			}
			
			setSelectIndex(0);
		}
		
		
		private function itemSelectHandler(e:MouseEvent):void
		{
			var index:int = _itemList.indexOf(e.currentTarget);
			setSelectIndex(index);
		}
		
		private function setSelectIndex(argIndex:int):void
		{
			if(_currentSelect == argIndex)return;
			if(_currentSelect != -1)
			{
				_itemList[_currentSelect].select = false;
			}
			_currentSelect = argIndex;
			_itemList[_currentSelect].select = true;
			updateInfoPanel();
		}
		
		private function updateInfoPanel():void
		{
			_acroBossInfoPanel.info = _itemList[_currentSelect].info;
		}
		
		private function initEvents():void
		{
			bossWarInfo.addEventListener(SceneAcroSerUpdateEvent.ACROSER_BOSS_WAR_MAIN_INFO_UPDATE,setDataHandler);
		}
		
		private function removeEvents():void
		{
			bossWarInfo.removeEventListener(SceneAcroSerUpdateEvent.ACROSER_BOSS_WAR_MAIN_INFO_UPDATE,setDataHandler);
		}
		
		private function setDataHandler(e:SceneAcroSerUpdateEvent):void
		{
			var ids:Array = e.data as Array;
			for(var i:int = 0;i < ids.length;i++)
			{
				var tmpItem:AcroBossItemView = getItem(ids[i]);
				if(!tmpItem)continue;
				tmpItem.updateTime(bossWarInfo.getAcrossBossTime(ids[i]));
			}
		}
		
		public function getItem(argId:int):AcroBossItemView
		{
			var tmpItemView:AcroBossItemView;
			for each(var i:AcroBossItemView in _itemList)
			{
				if(i.info.id == argId)
				{
					tmpItemView = i;
				}
			}
			return tmpItemView;
		}
		
		private function get bossWarInfo():BossWarInfo
		{
			return _mediator.bossWarInfo;
		}
		
		public function move(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function show():void
		{
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			if(_mTile)
			{
				_mTile.dispose();
				_mTile = null;
			}
			for each(var i:AcroBossItemView in _itemList)
			{
				if(i)
				{
					i.removeEventListener(MouseEvent.CLICK,itemSelectHandler);
					i.dispose();
					i = null;
				}
			}
			_itemList = null;
			if(_acroBossInfoPanel)
			{
				_acroBossInfoPanel.dispose();
				_acroBossInfoPanel = null;
			}
			if(parent)parent.removeChild(this);
		}
	}
}