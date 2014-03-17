package sszt.common.wareHouse.component
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.common.wareHouse.WareHouseController;
	import sszt.common.wareHouse.event.WareHouseEvent;
	import sszt.constData.CategoryType;
	import sszt.constData.CommonBagType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.module.changeInfos.ToWareHouseData;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.scene.BaseSceneObjInfo;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.doubleClicks.DoubleClickManager;
	import sszt.core.doubleClicks.IDoubleClick;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.bag.ItemArrangeSocketHandler;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.selectBtns.MCacheSelectBtn;
	import sszt.ui.mcache.btns.selectBtns.MCacheSelectBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.labelField.MLabelField1Bg;
	import sszt.ui.mcache.labelField.MLabelField2Bg;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.SplitCompartLine2;
	
	public class WareHousePanel extends MPanel
	{
		private var _controller:WareHouseController;
		private var _bg:IMovieWrapper;
//		private var _depositBtn:MCacheAsset1Btn;
//		private var _getMoneyBtn:MCacheAsset1Btn;
		private var _arrangeBtn:MCacheAssetBtn1;
//		private var _pages:Vector.<String>;	
//		private var _pageBtns:Vector.<MCacheSelectBtn>;   //页数按钮
//		private var _cellList:Vector.<WareHouseCell>;
		private var _pages:Array;	
		private var _pageBtns:Array;   //页数按钮
		private var _cellList:Array;
		
		private var _tile:MTile;
		private var _currentPage:int = 0;
		private var _emptyCell:WarehouseEmptyCell;
		private static const PAGE_SIZE:int = 36;
		
		private var _toData:ToWareHouseData;
		private var _npcInfo:NpcTemplateInfo;
		
		
		public function WareHousePanel(controller:WareHouseController,data:Object = null)
		{
			var id:int;
			if(data) _toData = data as ToWareHouseData;
			if(_toData)
			{
				_npcInfo = NpcTemplateList.getNpc(_toData.npcId);
			}
			_controller = controller;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.WarehouseTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.WarehouseTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1,true,false);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(279,334);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,4,263,322)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(16,12,247,273)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,284,259,25),new Bitmap(new SplitCompartLine2())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,19,234,38),new Bitmap(CellCaches.getCellBgPanel61())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,58,234,38),new Bitmap(CellCaches.getCellBgPanel61())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,97,234,38),new Bitmap(CellCaches.getCellBgPanel61())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,136,234,38),new Bitmap(CellCaches.getCellBgPanel61())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,175,234,38),new Bitmap(CellCaches.getCellBgPanel61())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,214,234,38),new Bitmap(CellCaches.getCellBgPanel61()))
				]);
			addContent(_bg as DisplayObject);
				
			_emptyCell = new WarehouseEmptyCell();
			addContent(_emptyCell);
						
			_arrangeBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.tidy"));
			_arrangeBtn.move(104,292);
			addContent(_arrangeBtn);
			
//			_pages = Vector.<String>(["1","2","3"]);
//			_pageBtns = new Vector.<MCacheSelectBtn>();
			//241
			_pages = ["1","2","3"];
			_pageBtns = [];
			for(var i:int = 0;i<_pages.length;i++)
			{
				var btn:MCacheSelectBtn1 = new MCacheSelectBtn1(0,0, _pages[i]);
				btn.move(178+i*26,256);
				addContent(btn);
				_pageBtns.push(btn);
			}
			_pageBtns[0].selected = true;
			
			_tile = new MTile(38,38,6);
			_tile.itemGapW = _tile.itemGapH = 1;
			_tile.setSize(233,233);
			_tile.move(23,19);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			
//			_cellList = new Vector.<WareHouseCell>();
			_cellList = new Array();
			for(var j:int = 0;j < PAGE_SIZE; j++)
			{ 
				var cell:WareHouseCell = new WareHouseCell(_controller);
				_tile.appendItem(cell);
				_cellList.push(cell);
			}
			addContent(_tile);
					
			initView();
			move(300,62);
		}
		
		private function selfMoveHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			if(_npcInfo == null)return;
			var selfInfo:BaseSceneObjInfo = evt.currentTarget as BaseSceneObjInfo;
			var dis:Number = Math.sqrt(Math.pow(selfInfo.sceneX - _npcInfo.sceneX,2) + Math.pow(selfInfo.sceneY - _npcInfo.sceneY,2));
			if(dis > CommonConfig.NPC_PANEL_DISTANCE)
				dispose();
		}
				
		private function initEvent():void
		{
			GlobalData.selfScenePlayerInfo.addEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfMoveHandler);
			for(var i:int =0;i<_pageBtns.length;i++)
			{
				_pageBtns[i].addEventListener(MouseEvent.CLICK,pageClickHandler);
				_pageBtns[i].addEventListener(MouseEvent.MOUSE_OVER,pageBtnOverHandler);
			}
			for(i=0;i<_cellList.length;i++)
			{
				_cellList[i].addEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
				_cellList[i].addEventListener(MouseEvent.CLICK,cellClickHandler);
			}
//			_depositBtn.addEventListener(MouseEvent.CLICK,depositHandler);
//			_getMoneyBtn.addEventListener(MouseEvent.CLICK,getMoneyHandler);
			_arrangeBtn.addEventListener(MouseEvent.CLICK,arrangeHandler);
			_controller.module.wareHouseInfo.addEventListener(WareHouseEvent.UPDATE,updateView);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.BAG_EXTEND,extendHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.DRAG_COMPLETE,cellDragCompleteHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandler);
		}
		
		private function removeEvent():void
		{
			GlobalData.selfScenePlayerInfo.removeEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfMoveHandler);
			for(var i:int =0;i<_pageBtns.length;i++)
			{
				_pageBtns[i].removeEventListener(MouseEvent.CLICK,pageClickHandler);
				_pageBtns[i].removeEventListener(MouseEvent.MOUSE_OVER,pageBtnOverHandler);
			}
			for(i=0;i<_cellList.length;i++)
			{
				_cellList[i].removeEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
				_cellList[i].removeEventListener(MouseEvent.CLICK,cellClickHandler);
			}
//			_depositBtn.removeEventListener(MouseEvent.CLICK,depositHandler);
//			_getMoneyBtn.removeEventListener(MouseEvent.CLICK,getMoneyHandler);
			_arrangeBtn.removeEventListener(MouseEvent.CLICK,arrangeHandler);
			_controller.module.wareHouseInfo.removeEventListener(WareHouseEvent.UPDATE,updateView);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.BAG_EXTEND,extendHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.DRAG_COMPLETE,cellDragCompleteHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandler);
		}
		
		private function changeSceneHandler(e:SceneModuleEvent):void
		{
			dispose();
		}
		
		private function cellClickHandler(evt:MouseEvent):void
		{
			var cell:WareHouseCell = evt.currentTarget as WareHouseCell;
//			if(!cell.isOpen)
//			{
//				var list:Vector.<int> = new Vector.<int>();
//				list.push(CategoryType.WARE_EXTEND_S);
//				list.push(CategoryType.WARE_EXTEND_T);
//				BuyPanel.getInstance().show(list,new ToStoreData(1));
//			}
			_controller.module.wareHouseInfo.currentDrag = null;
			cell.tempPoint = new Point(evt.stageX,evt.stageY);
			DoubleClickManager.addClick(evt.currentTarget as IDoubleClick);
		}
		
		private function cellDragCompleteHandler(evt:CommonModuleEvent):void
		{
			_controller.module.wareHouseInfo.currentDrag = null;
		}
		
		private function extendHandler(evt:BagInfoUpdateEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var type:int = evt.data  as int;
			if(type == 1)
			{
				initView();
				var len:int = GlobalData.selfPlayer.wareHouseMaxCount - PAGE_SIZE * _currentPage;
				for(var i:int = 0 ;i < _cellList.length ;i++)
				{
					var place:int = _currentPage * PAGE_SIZE + i ;
					_cellList[i].itemInfo = _controller.module.wareHouseInfo.getItem(place);
				}
				QuickTips.show(LanguageManager.getWord("ssztl.common.wareHouseExtend"));
			}
		}
		
		private function initView():void
		{
			for(var i:int =0;i<PAGE_SIZE;i++)
			{
				var place:int = _currentPage*PAGE_SIZE + i;
				if(place >= GlobalData.selfPlayer.wareHouseMaxCount)
				{
					_cellList[i].isOpen = false;
				}else
				{
					_cellList[i].isOpen = true;
					_cellList[i].itemInfo = null;
				}
				_cellList[i].place = place;
			}
		}
		
		
		private function updateView(evt:WareHouseEvent):void
		{
//			var list:Vector.<int> = evt.data as Vector.<int>;
			var list:Array = evt.data as Array;
			for(var i:int = 0;i<list.length;i++)
			{
				if(list[i]<(_currentPage+1)*PAGE_SIZE && list[i] >= _currentPage*PAGE_SIZE)
				{
					_cellList[list[i]%PAGE_SIZE].itemInfo = _controller.module.wareHouseInfo.getItem(list[i]);
				}
			}
		}
		
		private function clearView():void
		{
			for(var i:int =0;i<_cellList.length;i++)
			{
				_cellList[i].itemInfo = null;
			}
		}
		
		private function cellDownHandler(evt:MouseEvent):void
		{
			var cell:WareHouseCell = evt.currentTarget as WareHouseCell;
			if(cell.itemInfo)
			{
				cell.dragStart();
				_controller.module.wareHouseInfo.currentDrag = cell.itemInfo;
			}
		}
			
		private function pageClickHandler(evt:MouseEvent):void
		{
			var index:int = _pageBtns.indexOf(evt.currentTarget);
			if(_currentPage == index) return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_pageBtns[_currentPage].selected = false;
			_currentPage = index;
			_pageBtns[_currentPage].selected = true;
			setCurrentPage();
		}
		private function pageBtnOverHandler(evt:MouseEvent):void
		{
			if(_controller.module.wareHouseInfo.currentDrag)
			{
				var index:int = _pageBtns.indexOf(evt.currentTarget);
				if(_currentPage == index) return;
				_pageBtns[_currentPage].selected = false;
				_currentPage = index;
				_pageBtns[_currentPage].selected = true;
				setCurrentPage();
			}
		}
		
		private function setCurrentPage():void
		{
			initView();
			for(var i:int =0;i<PAGE_SIZE;i++)
			{
				_cellList[i].itemInfo = _controller.module.wareHouseInfo.getItem(_cellList[i].place);
			}
		}
		
//		private function depositHandler(evt:MouseEvent):void
//		{
//			_controller.showPopUpPanel(0);
//		}
//		
//		private function getMoneyHandler(evt:MouseEvent):void
//		{
//			_controller.showPopUpPanel(1);
//		}
		
		private function arrangeHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			ItemArrangeSocketHandler.sendArrange(CommonBagType.WAREHOUSE);
		}
		
		override public function dispose():void
		{
			removeEvent();
			_controller = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_arrangeBtn)
			{
				_arrangeBtn.dispose();
				_arrangeBtn = null;
			}
			_pages = null;
			for(var i:int =0;i<_pageBtns.length;i++)
			{
				_pageBtns[i].dispose();
				_pageBtns[i] = null;
			}
			_pageBtns = null;
			if(_tile)
			{
				_tile.dispose();
			}
			if(_cellList)
			{
				for(i =0;i<_cellList.length;i++)
				{
					_cellList[i].dispose();
					_cellList[i] = null;
				}
				_cellList = null;
			}
			if(_emptyCell)
			{
				_emptyCell.dispose();
				_emptyCell = null;
			}
			super.dispose();
		}
		
		
	}
}