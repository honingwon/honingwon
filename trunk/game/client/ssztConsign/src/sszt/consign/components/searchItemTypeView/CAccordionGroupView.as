package sszt.consign.components.searchItemTypeView
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sszt.ui.container.MTile;
	
	import sszt.consign.components.searchItemTypeView.data.CAccordionItemData;
	import sszt.consign.mediator.ConsignMediator;
	
	public class CAccordionGroupView extends Sprite
	{
		public static const SELECT_CHANGE:String = "selectChange";
		public static const ITEM_SELECT_CHANGE:String = "itemSelectChange"
		
		private var _titleView:CAccordionTitleView;
		private var _tile:MTile;
		private var _title:String;
//		private var _itemVectorValues:Vector.<CAccordionItemData>;		
		private var _itemVectorValues:Array;
		private var _width:int;
		private var _showItemCount:int;
		private var _selected:Boolean;
		private var _currentItem:CAccordionItemView;
		private var _consignMediator:ConsignMediator;
//		public function CAccordionGroupView(argTitle:String,argAccordionItemDataVector:Vector.<CAccordionItemData>,argWidth:int,argShowItemCount:int,argConsignMediator:ConsignMediator)
		public function CAccordionGroupView(argTitle:String,argAccordionItemDataVector:Array,argWidth:int,argShowItemCount:int,argConsignMediator:ConsignMediator)
		{
			_consignMediator = argConsignMediator;
			_title = argTitle;
			_itemVectorValues = argAccordionItemDataVector;
			_width = argWidth;
			_showItemCount = argAccordionItemDataVector.length;
			init();
			initEvent();
			super();
		}
		
		private function init():void
		{
			_titleView = createTitleView(_title,_width);
			addChild(_titleView);
			_tile = new MTile(_width,20);
			_tile.move(0,22);
			_tile.setSize(_width,0);
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			_tile.visible = false;
			initTile();
		}
		
		private function initTile():void
		{
			for each(var i:CAccordionItemData in _itemVectorValues)
			{
				var item:CAccordionItemView = createItemView(i,_width);
				_tile.appendItem(item);
				item.addEventListener(MouseEvent.CLICK,itemClickHandler);
			}
			
			/**--------------伸缩显示长度------------------**/
			var showCount:int;
			if(_showItemCount == -1)
				showCount = _itemVectorValues.length;
			else
				showCount = _itemVectorValues.length <= _showItemCount ? _itemVectorValues.length : _showItemCount;
			_tile.height = showCount * (_tile.itemHeight +2);
		}
		
		/**---------------选中道具出发------------------------**/
		private function itemClickHandler(evt:MouseEvent):void
		{
			if(_currentItem)_currentItem.selected = false;
			_currentItem = evt.currentTarget as CAccordionItemView;
			_currentItem.selected = true;
			dispatchEvent(new Event(ITEM_SELECT_CHANGE));
//			_bigMapMediator.sceneModule.sceneInit.walkToNpc(_currentItem.info._npcRoleInfo.template.templateId);
		}
		
		protected function createTitleView(title:String,width:int):CAccordionTitleView
		{
			return new CAccordionTitleView(title,width);
		}
		
		protected function createItemView(info:CAccordionItemData,width:int):CAccordionItemView
		{
			return new CAccordionItemView(info,width);
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
//				if(_currentItem)
//				{
//					_currentItem.selected = false;
//				}
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
		
		override public function get height():Number
		{
			if(!_selected)return _titleView.height;
			return _titleView.height + _tile.height;
		}
		
		public function get currentItem():CAccordionItemView
		{
			return _currentItem;
		}
		
		public function dispose():void
		{
			_consignMediator = null;
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
			_itemVectorValues = null;
			_currentItem = null;
			if(parent)parent.removeChild(this);
		}
	}
}