package sszt.ui.container.accordionItems
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sszt.ui.container.MTile;
	
	public class AccordionGroup extends Sprite
	{
		public static const SELECT_CHANGE:String = "selectChange";
		public static const ITEM_SELECT_CHANGE:String = "itemSelectChange";
		
		private var _titleView:AccordionGroupTitleView;
		private var _tile:MTile;
		private var _title:String;
		private var _itemValues:Array;		
		private var _width:int;
		private var _showItemCount:int;
		private var _showTitleBg:Boolean;
		protected var _showItemSelectedBg:Boolean;
		private var _selected:Boolean;
		private var _currentItem:AccordionGroupItemView;
//		private var _itemList:Vector.<AccordionGroupItemView>;
		private var _itemList:Array;
		
		public function AccordionGroup(title:String, itemValues:Array, width:int, showItemCount:int, showTitleBg:Boolean = true, showItemSelectedBg:Boolean = true)
		{
			_title = title;
			_itemValues = itemValues;
			_width = width;
			_showItemCount = showItemCount;
			_showTitleBg = showTitleBg;
			_showItemSelectedBg = showItemSelectedBg;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_titleView = createTitleView(_title,_width,_showTitleBg);
			addChild(_titleView);
			_tile = new MTile(_width,22);
			_tile.move(0,_titleView.height);
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.setSize(_width,300);
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			_tile.visible = false;
			
//			_itemList = new Vector.<AccordionGroupItemView>();
			_itemList = [];
			initTile();
		}
		
		private function initTile():void
		{
			for each(var itemData:IAccordionItemData in _itemValues)
			{
				var item:AccordionGroupItemView = createItemView(itemData, _width);
				_tile.appendItem(item);
				item.addEventListener(MouseEvent.CLICK,itemClickHandler);
				_itemList.push(item);
			}
			updateHeight();
			if(_itemList.length > 0) _currentItem = _itemList[0];
				
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			if(_currentItem)_currentItem.selected = false;
			_currentItem = evt.currentTarget as AccordionGroupItemView;
			_currentItem.selected = true;
			dispatchEvent(new Event(ITEM_SELECT_CHANGE));
		}
		
		public function appendItem(data:IAccordionItemData):void
		{
			var item:AccordionGroupItemView = createItemView(data,_width);
			_tile.appendItem(item);
			item.addEventListener(MouseEvent.CLICK,itemClickHandler);
			_itemList.push(item);
			updateHeight();
		}
		
		public function removeItem(item:AccordionGroupItemView):void
		{
			_tile.removeItem(item);
			if(item)
			{
				item.removeEventListener(MouseEvent.CLICK,itemClickHandler);
				item.dispose();
				item = null;
			}
			_itemList.splice(_itemList.indexOf(item),1);
			updateHeight();
		}
		
		public function clearItems():void
		{
			_tile.clearItems();
			for each(var item:AccordionGroupItemView in _itemList)
			{
				if(item)
				{
					item.removeEventListener(MouseEvent.CLICK,itemClickHandler);
					item.dispose();
					item = null;
				}
			}
			_itemList.length = 0;
			updateHeight();
		}
		
		protected function createTitleView(title:String,width:int,showBg:Boolean):AccordionGroupTitleView
		{
			return new AccordionGroupTitleView(title,width,showBg);
		}
		
		protected function createItemView(info:IAccordionItemData,width:int):AccordionGroupItemView
		{
			return new AccordionGroupItemView(info,width,_showItemSelectedBg);
		}
		
		private function initEvent():void
		{
			_titleView.addEventListener(MouseEvent.CLICK,titleClickHandler);
		}
		
		private function removeEvent():void
		{
			_titleView.removeEventListener(MouseEvent.CLICK,titleClickHandler);
		}
		
		private function titleClickHandler(evt:Event):void
		{
			dispatchEvent(new Event(SELECT_CHANGE));
		}
		
		public function get selectedItemData():IAccordionItemData
		{
			return _currentItem.itemData;
		}
		
		public function get selectedItem():AccordionGroupItemView
		{
			return _currentItem;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			_titleView.selected = _selected;
			if(_selected)
			{
				_tile.visible = true;
			}
			else
			{
				_tile.visible = false;
			}
		}
		
		public function setCurrentItemSelected(value:Boolean):void
		{
			if(_currentItem)
			{
				_currentItem.selected = value;
				dispatchEvent(new Event(ITEM_SELECT_CHANGE));
			}
		}
		
		private function updateHeight():void
		{
			var showCount:int;
			if(_showItemCount == -1)
				showCount = _itemList.length;
			else
				showCount = _itemList.length <= _showItemCount ? _itemList.length : _showItemCount;
			_tile.height = showCount * (20 + 2);
		}
		
		override public function get height():Number
		{
			if(!_selected)return _titleView.height;
			return _titleView.height + _tile.height;
		}
		
		public function dispose():void
		{
			if(_titleView)
			{
				_titleView.dispose();
				_titleView = null;
			}
			if(_itemList)
			{
				for(var i:int = 0; i < _itemList.length; i++)
				{
					_itemList[i].removeEventListener(MouseEvent.CLICK,itemClickHandler);
					_itemList[i].dispose();
				}
			}
			_itemList = null;
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			_currentItem = null;
			_itemValues = null;
		}
	}
}