package sszt.target.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.target.TargetData;
	import sszt.core.data.target.TargetTemplatInfo;
	import sszt.core.data.target.TargetTemplateList;
	import sszt.core.data.target.TargetUtils;
	import sszt.core.socketHandlers.target.TargetHistoryUpdateSocketHandler;
	import sszt.events.ModuleEvent;
	import sszt.events.TargetMediaEvents;
	import sszt.interfaces.panel.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MTile;
	
	/**
	 * 最近获得成就  
	 * @author chendong
	 * 
	 */	
	public class AchRight extends Sprite implements IPanel
	{
		private var _cellList:Array;
		private var _tile:MTile;
		
		public function AchRight()
		{
			super();
			initView();
			initEvent();
//			initData();
			initSetData();
		}
		
		public function initView():void
		{
			_tile = new MTile(177,30,1);
			_tile.itemGapW = _tile.itemGapH = 0;
			_tile.setSize(177,335);
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.verticalScrollPolicy = ScrollPolicy.AUTO;
			addChild(_tile);
			_cellList = [];
		}
		
		public function initEvent():void
		{
			var i:int=0;
			for(;i<_cellList.length;i++)
			{
				_cellList[i].addEventListener(MouseEvent.CLICK,handleClick);
			}
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getAchAwardAchRi);
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.TARGET_HISTORY,updateAchRight);
		}
		
		public function initData():void
		{
//			TargetHistoryUpdateSocketHandler.send(); 
		}
		
		public function initSetData():void
		{
			clearData();
			var achArray:Array = [];
			var achInfo:TargetTemplatInfo;
			var getAchItemView:GetAchItemView;
//			for(var i:int = 1;i<= TargetUtils.ACH_TYPE_NUM;i++)
//			{
//				achArray = getAchArray(i);
//				for each (achInfo in achArray)
//				{
//					getAchItemView = new GetAchItemView(achInfo);
//					_tile.appendItem(getAchItemView);
//					_cellList.push(getAchItemView);
//				}
//			}
			achArray = getFinishArray();
			for each (achInfo in achArray)
			{
				getAchItemView = new GetAchItemView(achInfo);
				_tile.appendItem(getAchItemView);
				_cellList.push(getAchItemView);
			}
		}
		
		private function getAchArray(currentType:int):Array
		{
			var achArray:Array = [];
			var achInfo:TargetTemplatInfo;
			var achTemplateArray:Array = TargetUtils.getAchTemplateData(currentType);
			var targetData:TargetData = null;
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
		
		private function getFinishArray():Array
		{
			var achArray:Array = [];
			var finishArray:Array = GlobalData.targetInfo.historyArray;
			var achInfo:TargetTemplatInfo;
			var i:int = finishArray.length - 1;
			for(;i >=0;i--)
			{
				achInfo = TargetTemplateList.getTargetByIdTemplate(finishArray[i]);
				achArray.push(achInfo);
			}
			return achArray;
		}
		
		private function handleClick(evt:MouseEvent):void
		{
			
		}
		
		private function getAchAwardAchRi(evt:ModuleEvent):void
		{
			initSetData();
		}
		
		private function updateAchRight(evt:ModuleEvent):void
		{
			initSetData();
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
			var i:int=0;
			for(;i<_cellList.length;i++)
			{
				_cellList[i].removeEventListener(MouseEvent.CLICK,handleClick);
			}
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getAchAwardAchRi);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.TARGET_HISTORY,updateAchRight);
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	}
}