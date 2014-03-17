package sszt.rank.components.treeView
{
	import fl.controls.ScrollPolicy;
	import fl.core.InvalidationType;
	
	import flash.display.DisplayObject;
	
	import sszt.ui.container.MScrollPanel;
	
	import sszt.core.manager.SoundManager;
	import sszt.rank.components.treeView.data.TreeGroupData;
	import sszt.rank.components.treeView.event.TreeItemEvent;
	import sszt.rank.data.RankType;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class TreePanel extends MScrollPanel
	{
		private var _showMutil:Boolean;
//		private var _groups:Vector.<CAccordionGroupView>;
//		private var _groups:Array;
		/**
		 * IAccordionGroupData
		 */		
		protected var _groupDatas:Array;
		private var _tmpWidth:int;
		private var _showItemCount:int;
		private var _currentGroup:TreeGroupView;
		
		private var _groupSpace:int = 1;
		private var _mediator:Mediator;
		
		private var _groupViews:Array = [];
		public function TreePanel(data:Array,argMediator:Mediator,width:int,showItemCount:int = 5,showMutil:Boolean = false)
		{
			_showMutil = showMutil;
			_groupDatas = data;
			_tmpWidth = width;
			_showItemCount = showItemCount;
//			_groupSpace = 2;
			_mediator = argMediator;
			super();
			initEvents();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
//			_groups = [];
			for each(var i:TreeGroupData in _groupDatas)
			{
				var group:TreeGroupView = createGroup(i);
//				_groups.push(group);
				getContainer().addChild(group as DisplayObject);
				_groupViews.push(group);
			}
		}
		
		protected function createGroup(data:TreeGroupData):TreeGroupView
		{
			return new TreeGroupView(data,_tmpWidth,_showItemCount,_mediator);
		}
		
		private function initEvents():void
		{
			for each(var groupView:TreeGroupView in _groupViews)
			{
				groupView.addEventListener(TreeItemEvent.GROUP_SELECT_CHANGE,groupSelectedChangeHandler);
				groupView.addEventListener(TreeItemEvent.ITEM_SELECT_CHANGE,itemSelectedChangeHandler);
			}	
		}
		
		private function removeEvents():void
		{
			for each(var groupView:TreeGroupView in _groupViews)
			{
				groupView.removeEventListener(TreeItemEvent.GROUP_SELECT_CHANGE,groupSelectedChangeHandler);
				groupView.removeEventListener(TreeItemEvent.ITEM_SELECT_CHANGE,itemSelectedChangeHandler);
			}
		}
		
		public function get groupViews():Array
		{
			return _groupViews;
		}
		
		public function set currentGroup(tmpView:TreeGroupView):void
		{
			if(!_showMutil)
			{
				if(_currentGroup)
				{
					if(tmpView == _currentGroup)
					{
						_currentGroup.selected = !_currentGroup.selected;
					}
					else
					{
						_currentGroup.selected = false;
						_currentGroup = tmpView;
						_currentGroup.selected = true;
					}
				}
				else
				{
					_currentGroup = tmpView;
					_currentGroup.selected = true;
				}
			}
			else
			{
				_currentGroup = tmpView;
				_currentGroup.selected = !_currentGroup.selected;
			}
			invalidate(InvalidationType.STATE);
			
			dispatchEvent(new TreeItemEvent(TreeItemEvent.GROUP_SELECT_CHANGE,_currentGroup.groupData.titleId));
		}
		
		public function get currentGroup():TreeGroupView
		{
			return _currentGroup;
		}
		
		private function groupSelectedChangeHandler(evt:TreeItemEvent):void
		{	
			currentGroup = evt.currentTarget as TreeGroupView;
		}
		
		private function itemSelectedChangeHandler(evt:TreeItemEvent):void
		{	
			var tmpView:TreeGroupView = evt.currentTarget as TreeGroupView;
			_currentGroup = tmpView;
			for each(var i:TreeGroupView in _groupViews)
			{
				if(i != tmpView && i.currentItem)
				{
					i.currentItem.selected = false;
				}
			}
			dispatchEvent(new TreeItemEvent(TreeItemEvent.ITEM_SELECT_CHANGE,_currentGroup.currentItem.info.itemId));
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STATE))
			{
				var currentHeight:int = 0;
				for each(var i:TreeGroupView in _groupViews)
				{
					i.y = currentHeight;
					currentHeight += i.height + _groupSpace;
				}
				update(_width,currentHeight + 10);
			}
			super.draw();
		}
		
		override public function dispose():void
		{
			removeEvents();
			
			if(_groupViews)
			{
				for each(var i:TreeGroupView  in _groupViews)
				{
					i.dispose();
					i = null;
				}
				_groupViews = null;
			}
			_currentGroup = null;
			_groupDatas = null;
			_mediator = null;
			super.dispose();
		}
	}
}