package sszt.target.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToTargetData;
	import sszt.core.data.target.TargetData;
	import sszt.core.data.target.TargetTemplatInfo;
	import sszt.core.data.target.TargetTemplateList;
	import sszt.core.data.target.TargetUtils;
	import sszt.events.ModuleEvent;
	import sszt.events.TargetMediaEvents;
	import sszt.interfaces.panel.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MTile;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.page.PageEvent;

	
	public class AchMiddle extends Sprite implements IPanel
	{
		
		private var _cellList:Array;
		private var _tile:MTile;
		private var _PAGESIZE:int = 5;
		
		private var _currentType:int = 1;
		private var _achList:Array;
		
		private var _currentPage:int;
		private var _pageView:PageView;
		public function AchMiddle()
		{
			super();
			initView();
			initEvent();
			initData();
		}
		
		public function get currentType():int
		{
			return _currentType;
		}

		public function set currentType(value:int):void
		{
			_currentType = value;
			_pageView.currentPage = 1;
			initData();
		}

		public function initView():void
		{
			_tile = new MTile(479,66,1);
			_tile.itemGapW = 0;
			_tile.itemGapH = 2;
			_tile.setSize(479,342);
			_tile.move(7,7);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			_pageView = new PageView(_PAGESIZE,false,100);
			_pageView.move(192, 352);
			addChild(_pageView);

			_cellList = [];
		}
		
		public function initEvent():void
		{
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.UPDATE_TARGET_LIST,updateTargetListTAch);
		}
		
		public function initData():void
		{
			_pageView.totalRecord = TargetUtils.getAchTypeNum(currentType);
			_currentPage = _pageView.currentPage;
			clearData();
			initTemplateData();
			initPlayerData();
		}
		
		//初始模版数据
		private function initTemplateData():void
		{
			var achArray:Array = getAchArray(_currentType);
			var currFirst:int = (_currentPage - 1) * _PAGESIZE;
			var currLast:int = currFirst + _PAGESIZE - 1;
			var achView:AchItemView;
			var i:int = 0;
			for(i = currFirst; i <= currLast; i++)
			{
				if(achArray[i])
				{
					achView = new AchItemView(achArray[i]);
					_tile.appendItem(achView);
					_cellList.push(achView);
				}
			}
		}
		
		//初始化玩家数据
		private function initPlayerData():void
		{
			
		}
		
		private function getAchArray(curType:int):Array
		{
			var achArray:Array = [];
			var achInfo:TargetTemplatInfo;
			var achTemplateArray:Array = TargetUtils.getAchTemplateData(curType);
			var targetData:TargetData = null;
			//完成未领取
			for each (achInfo in achTemplateArray)
			{
				targetData = GlobalData.targetInfo.achByIdDic[achInfo.target_id];
				if(targetData && targetData.isFinish && !targetData.isReceive)
				{
					achArray.push(achInfo);
				}
			}
			
			//在完成过程当中
			for each (achInfo in achTemplateArray)
			{
				targetData = GlobalData.targetInfo.achByIdDic[achInfo.target_id];
				if(targetData && !targetData.isFinish && !targetData.isReceive)
				{
					achArray.push(achInfo);
				}
			}
			
			//未完成未领取
			for each (achInfo in achTemplateArray)
			{
				targetData = GlobalData.targetInfo.achByIdDic[achInfo.target_id];
				if(!targetData)
				{
					achArray.push(achInfo);
				}
			}
			
			//完成已领取
			for each (achInfo in achTemplateArray)
			{
				targetData = GlobalData.targetInfo.achByIdDic[achInfo.target_id];
				if(targetData && targetData.isFinish && targetData.isReceive)
				{
					achArray.push(achInfo);
				}
			}
			return achArray;
		}
		
		
		private function pageChangeHandler(event:Event):void
		{
			initData();
		}
		
		private function updateTargetListTAch(evt:ModuleEvent):void
		{
			initData();
		}
		
		public function clearData():void
		{
			var i:int = 0;
			if (_cellList)
			{
				i = 0;
				while (i < _cellList.length)
				{
					
					_cellList[i].dispose();
					i++;
				}
				_cellList = [];
			}
			if(_tile)
			{
				_tile.disposeItems()
			}
		}
		
		public function removeEvent():void
		{
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.UPDATE_TARGET_LIST,updateTargetListTAch);
		}
		
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			clearData();
			removeEvent();
		}
		
		public function assetsCompleteHandler():void
		{
		}
	}
}