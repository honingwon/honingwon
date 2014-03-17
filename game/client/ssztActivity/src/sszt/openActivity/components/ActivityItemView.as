package sszt.openActivity.components
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.panel.IPanel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	/**
	 * 领取活动奖励项 
	 * @author chendong
	 * 
	 */	
	public class ActivityItemView extends Sprite implements IPanel
	{
		
		private var _cell:Cell;
		private var _getReward:MCacheAssetBtn1;
		
		public function ActivityItemView()
		{
			super();
			initView();
			initEvent();
			initData();
		}
		
		public function clearData():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function initData():void
		{
			// TODO Auto Generated method stub
			var itemInfo:ItemInfo = new ItemInfo();
//			itemInfo.templateId = _selecteditem.awardsId;
//			itemInfo.count = _selecteditem.awardsNum;
			cell.itemInfo = itemInfo;
		}
		
		public function initEvent():void
		{
			// TODO Auto Generated method stub
			getReward.addEventListener(MouseEvent.CLICK,getRewardClick);
		}
		
		public function initView():void
		{
			// TODO Auto Generated method stub
			cell = new Cell();
			cell.move(0,0);
			addChild(cell);
			
			
			getReward = new MCacheAssetBtn1(0,1,LanguageManager.getWord("ssztl.common.getLabel"));
			getReward.move(0,0);
			addChild(getReward); 
		}
		
		private function getRewardClick(evt:MouseEvent):void
		{
			
		}
		
		public function move(x:Number, y:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function removeEvent():void
		{
			// TODO Auto Generated method stub
			getReward.removeEventListener(MouseEvent.CLICK,getRewardClick);
		}
		
		public function get cell():Cell
		{
			return _cell;
		}

		public function set cell(value:Cell):void
		{
			_cell = value;
		}

		public function get getReward():MCacheAssetBtn1
		{
			return _getReward;
		}

		public function set getReward(value:MCacheAssetBtn1):void
		{
			_getReward = value;
		}
	}
}