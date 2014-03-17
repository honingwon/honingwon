package sszt.scene.components.bossWar
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTab1Btn;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.bossWar.BossWarTemplateInfo;
	import sszt.core.data.bossWar.BossWarTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.bossWar.BossWarInfo;
	import sszt.scene.events.SceneBossWarUpdateEvent;
	import sszt.scene.mediators.BossWarMediator;
	
	public class BossWarMainPanel extends MPanel
	{
		private var _mediator:BossWarMediator;
		private var _bg:IMovieWrapper;
		private var _btns:Array;
		private var _currentIndex:int = -1;
		private var _mTile:MTile;
		private var _itemList:Array;
		private var _mTile2:MTile;
		private var _currentSelect:int = -1;
		private var _bossInfoPanel:BossInfoPanel;
		
		public function BossWarMainPanel(argMediator:BossWarMediator)
		{
			_mediator = argMediator;
			
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("sszt.scene.BossWarTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("sszt.scene.BossWarTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
			initEvents();
			_mediator.sendMainInfo(1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(641,431);
			
			_bg = BackgroundUtils.setBackground([
																				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,641,431)),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,30,632,5),new MCacheSplit1Line()),
																				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(5,34,397,391)),
																				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(405,34,232,391)),
																				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(9,38,390,22)),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(73,40,11,17),new MCacheSplit3Line()),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(115,40,11,17),new MCacheSplit3Line()),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(191,40,11,17),new MCacheSplit3Line()),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(268,40,11,17),new MCacheSplit3Line()),
																				
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,90,364,2),new MCacheSplit2Line()),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,123,364,2),new MCacheSplit2Line()),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,156,364,2),new MCacheSplit2Line()),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,189,364,2),new MCacheSplit2Line()),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,222,364,2),new MCacheSplit2Line()),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,255,364,2),new MCacheSplit2Line()),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,288,364,2),new MCacheSplit2Line()),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,321,364,2),new MCacheSplit2Line()),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,354,364,2),new MCacheSplit2Line()),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,387,364,2),new MCacheSplit2Line()),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,420,364,2),new MCacheSplit2Line()),
//																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(410,190,223,2),new MCacheSplit2Line()),																
			]);
			addContent(_bg as DisplayObject);
			
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.bossName"),MAssetLabel.LABELTYPE14);
			label1.move(18,40);
			addContent(label1);
			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.level2"),MAssetLabel.LABELTYPE14);
			label2.move(87,40);
			addContent(label2);
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.state"),MAssetLabel.LABELTYPE14);
			label3.move(144,40);
			addContent(label3);
			var label4:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.belongMap"),MAssetLabel.LABELTYPE14);
			label4.move(209,40);
			addContent(label4);
			var label5:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.operation"),MAssetLabel.LABELTYPE14);
			label5.move(309,40);
			addContent(label5);
			
			var label7:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.suggestTeam"),MAssetLabel.LABELTYPE1);
			label7.move(173,11);
			addContent(label7);
			
			var labels:Array = [LanguageManager.getWord("ssztl.scene.jingYingBoss"),LanguageManager.getWord("ssztl.scene.worldBoss")];
			var poses:Array = [new Point(12,8),new Point(82,9)];
			_btns = [];
			for(var i:int = 0;i <labels.length;i++)
			{
				var tmpBtn:MCacheTab1Btn = new MCacheTab1Btn(0,1,labels[i]);
				tmpBtn.move(poses[i].x,poses[i].y);
				_btns.push(tmpBtn);
				tmpBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
				addContent(tmpBtn);
			}
			
			_itemList = [];
			
			_mTile = new MTile(390,33);
			_mTile.itemGapH = _mTile.itemGapW = 0;
			_mTile.setSize(390,363);
			_mTile.move(10,60);
			addContent(_mTile);
			
			_mTile2 = new MTile(390,33);
			_mTile2.itemGapH = _mTile.itemGapW = 0;
			_mTile2.setSize(390,363);
			_mTile2.move(10,60);
			addContent(_mTile2);
			
			_bossInfoPanel = new BossInfoPanel();
			addContent(_bossInfoPanel);
			_bossInfoPanel.move(412,40);
			
			
			for each(var j:BossWarTemplateInfo in BossWarTemplateList.list)
			{
				var tmpItem:BossItemView = new BossItemView(j,_mediator);
				_itemList.push(tmpItem);
				if(j.type == 1)
				{
					_mTile.appendItem(tmpItem);
				}
				else if(j.type == 2)
				{
					_mTile2.appendItem(tmpItem);
				}
				tmpItem.addEventListener(MouseEvent.CLICK,itemSelectHandler);
			}
			//初始化选中
			setIndex(1);
			
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
			_bossInfoPanel.info = _itemList[_currentSelect].info;
		}

		
		private function btnClickHandler(e:MouseEvent):void
		{
			var index:int = _btns.indexOf(e.currentTarget);
			setIndex(index);
		}
		
		private function setIndex(argIndex:int):void
		{
			if(_currentIndex == argIndex)return;
			if(_currentIndex != -1)
			{
				_btns[_currentIndex].selected = false;
			}
			_currentIndex = argIndex;
			_btns[_currentIndex].selected = true;
			changeData();
		}
		
		private function changeData():void
		{
			if(_currentIndex == 0)
			{
				_mTile.visible = true;
				_mTile2.visible =false;
				setSelectIndex(_itemList.indexOf(_mTile.getItemAt(0) as BossItemView));
			}
			else
			{
				_mTile2.visible = true;
				_mTile.visible =false;
				setSelectIndex(_itemList.indexOf(_mTile2.getItemAt(0) as BossItemView));
			}
		}
		
		private function clearList():void
		{
			_itemList.length = 0;
			_mTile.disposeItems();
		}
		
		private function initEvents():void
		{
			bossInfo.addEventListener(SceneBossWarUpdateEvent.BOSS_WAR_MAIN_INFO_UPDATE,setDataHandler);
		}
		
		private function removeEvents():void
		{
			bossInfo.removeEventListener(SceneBossWarUpdateEvent.BOSS_WAR_MAIN_INFO_UPDATE,setDataHandler);
		}
		
		private function setDataHandler(e:SceneBossWarUpdateEvent):void
		{
			var ids:Array = e.data as Array;
			for(var i:int = 0;i < ids.length;i++)
			{
				var tmpItem:BossItemView = getItem(ids[i]);
				if(!tmpItem)continue;
				tmpItem.updateTime(bossInfo.getTime(ids[i]));
			}
		}
		
		public function getItem(argId:int):BossItemView
		{
			var tmpItemView:BossItemView;
			for each(var i:BossItemView in _itemList)
			{
				if(i.info.id == argId)
				{
					tmpItemView = i;
				}
			}
			return tmpItemView;
		}
		
		private function get bossInfo():BossWarInfo
		{
			return _mediator.bossWarInfo;
		}
			
		
		override public function dispose():void
		{
			removeEvents();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			for each(var i:MCacheTab1Btn in _btns)
			{
				if(i)
				{
					i.removeEventListener(MouseEvent.CLICK,btnClickHandler);
					i = null;
				}
			}
			_btns = null;
			if(_mTile)
			{
				_mTile.dispose();
				_mTile = null;
			}
			if(_mTile2)
			{
				_mTile2.dispose();
				_mTile2 = null;
			}
			for each(var j:BossItemView in _itemList)
			{
				if(j)
				{
					j.dispose();
					j = null;
				}
			}
			_itemList = null;
			super.dispose();
			if(parent)parent.removeChild(this);
		}
	}
}