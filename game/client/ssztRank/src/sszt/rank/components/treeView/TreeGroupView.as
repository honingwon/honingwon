package sszt.rank.components.treeView
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sszt.ui.container.MTile;
	
	import sszt.rank.components.treeView.data.TreeGroupData;
	import sszt.rank.components.treeView.data.TreeItemData;
	import sszt.rank.components.treeView.event.TreeItemEvent;
	import sszt.rank.mediator.RankMediator;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class TreeGroupView extends Sprite
	{
		public static const SELECT_CHANGE:String = "selectChange";
		public static const ITEM_SELECT_CHANGE:String = "itemSelectChange"
		
		private var _titleView:TreeTitleView;
		private var _tile:MTile;
		private var _title:String;
		private var _width:int;
		private var _showItemCount:int;
		private var _selected:Boolean;
		private var _currentItem:TreeItemView;
		private var _mediator:Mediator;
		
		private var _groupData:TreeGroupData;
		
		private var _itemViews:Array = [];
		
		public function get groupData():TreeGroupData
		{
			return _groupData;
		}
		
		public function TreeGroupView(argGroupData:TreeGroupData,argWidth:int,argShowItemCount:int,argMediator:Mediator)
		{
			_groupData = argGroupData;
			_width = argWidth;
			_showItemCount = argShowItemCount;
			_mediator = argMediator;
			initView();
			
			initEvents();
		}
		
		private function initView():void
		{
			_titleView = createTitleView(_groupData.title,_width);
			addChild(_titleView);
			
			_tile = new MTile(_width, 24);
			_tile.itemGapH = 0;
			_tile.move(0,_titleView.height+1);
			_tile.setSize(_width,0);
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			_tile.visible = false;
			createItemViews();
			
		}
		
		private function createItemViews():void
		{
			for each(var i:TreeItemData in _groupData.treeItemDataVector)
			{
				var item:TreeItemView = createItemView(i, _width);
				_tile.appendItem(item);
				_itemViews.push(item);
			}
			
			var showCount:int;
			if(_showItemCount == -1)
				showCount = _groupData.treeItemDataVector.length;
			else
				showCount = _groupData.treeItemDataVector.length <= _showItemCount ? _groupData.treeItemDataVector.length : _showItemCount;
			_tile.height = showCount * _tile.itemHeight;
		}
		
		protected function createTitleView(title:String,width:int):TreeTitleView
		{
			return new TreeTitleView(title,width);
		}
		
		protected function createItemView(info:TreeItemData,width:int):TreeItemView
		{
			return new TreeItemView(info,width);
		}
		
		private function initEvents():void
		{
			_titleView.addEventListener(MouseEvent.CLICK,titleClickHandler);
			
			for each(var itemView:TreeItemView in _itemViews)
			{
				itemView.addEventListener(MouseEvent.CLICK,itemClickHandler);
			}
		}
		
		private function removeEvents():void
		{
			_titleView.removeEventListener(MouseEvent.CLICK,titleClickHandler);
			
			for each(var itemView:TreeItemView in _itemViews)
			{
				itemView.removeEventListener(MouseEvent.CLICK,itemClickHandler);
			}
		}
		
		public function get title():String
		{
			return _title;
		}
		
		public function get itemViews():Array
		{
			return _itemViews;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			if(_selected == value)
				return;
			_selected = value;
			_titleView.selected = _selected;
			if(_selected)
			{
				if(_itemViews && _itemViews.length > 0)
				{
					currentItem = _itemViews[0];
				}
				_tile.visible = true;
			}
			else
			{
				if(_currentItem)
				{
					_currentItem.selected = false;
				}
				_tile.visible = false;
				
			}
		}
		
		public function set currentItem(itemView:TreeItemView):void
		{
			if(_currentItem)
			{
				_currentItem.selected = false;
			}
			_currentItem = itemView;
			_currentItem.selected = true;
			dispatchEvent(new TreeItemEvent(TreeItemEvent.ITEM_SELECT_CHANGE,_currentItem.info.itemId));
		}
		
		public function get currentItem():TreeItemView
		{
			return _currentItem;
		}
		
		override public function get height():Number
		{
			if(!_selected)return _titleView.height;
			return _titleView.height + _tile.height + 2;
		}
		
		/**---------------选中item出发------------------------**/
		private function itemClickHandler(evt:MouseEvent):void
		{	
			currentItem = evt.currentTarget as TreeItemView;
		}
		
		private function titleClickHandler(evt:Event):void
		{
			dispatchEvent(new TreeItemEvent(TreeItemEvent.GROUP_SELECT_CHANGE));
		}
		
		public function dispose():void
		{
			removeEvents();
			_mediator = null;
			if(_titleView)
			{
				_titleView.dispose();
				_titleView = null;
			}
			if(_tile)
			{
				_tile.disposeItems();
				_tile.dispose();
				_tile = null;
			}
			_title = null;
			_groupData = null;
			_currentItem = null;
			if(parent)parent.removeChild(this);
		}
	}
}