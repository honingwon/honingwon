package sszt.ui.container
{
	import fl.containers.BaseScrollPane;
	import fl.controls.ScrollPolicy;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.managers.StyleManager;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import sszt.ui.interfaces.ISelectable;
	
	public class MTile extends BaseScrollPane
	{
		private var _marginW:Number = 0;
		private var _marginH:Number = 0;
		private var _itemGapW:Number = 2;
		private var _itemGapH:Number = 2;
		
		protected var _items:Array;
		private var _columns:int;
		private var _itemWidth:Number;
		private var _itemHeight:Number;
		private var _selectedItem:ISelectable;
		private var _reverseWidth:Boolean;
		
		private var _container:UIComponent;
		
		private static var defaultStyles:Object = {skin:new Shape()};
		
		public function MTile(itemWidth:Number,itemHeight:Number,columns:int = 1,reverseWidth:Boolean = false)
		{
			_itemWidth = itemWidth;
			_itemHeight = itemHeight;
			_columns = columns;
			_items = [];
			_reverseWidth = reverseWidth;
			super();
		}
		
		public function get itemWidth():Number
		{
			return _itemWidth;
		}
		public function set itemWidth(value:Number):void
		{
			if(_itemWidth == value)return;
			_itemWidth = value;
			invalidate(InvalidationType.SIZE);
		}
		
		public function get itemHeight():Number
		{
			return _itemHeight;
		}
		public function set itemHeight(value:Number):void
		{
			if(_itemHeight == value)return;
			_itemHeight = value;
			invalidate(InvalidationType.SIZE);
		}
		
		public function get columns():int
		{
			return _columns;
		}
		public function set columns(value:int):void
		{
			if(_columns == value)return;
			_columns = value;
			invalidate(InvalidationType.SIZE);
		}
		
		public function get marginWidth():Number
		{
			return _marginW;
		}
		public function set marginWidth(value:Number):void
		{
			if(_marginW == value)return;
			_marginW = value;
			invalidate(InvalidationType.SIZE);
		}
		
		public function get marginHeight():Number
		{
			return _marginH;
		}
		public function set marginHeight(value:Number):void
		{
			if(_marginH == value)return;
			_marginH = value;
			invalidate(InvalidationType.SIZE);
		}
		
		public function get itemGapW():Number
		{
			return _itemGapW;
		}
		public function set itemGapW(value:Number):void
		{
			if(_itemGapW == value)return;
			_itemGapW = value;
			invalidate(InvalidationType.SIZE);
		}
		
		public function get itemGapH():Number
		{
			return _itemGapH;
		}
		public function set itemGapH(value:Number):void
		{
			if(_itemGapH == value)return;
			_itemGapH = value;
			invalidate(InvalidationType.SIZE);
		}
		
		public function get selectedItem():ISelectable
		{
			return _selectedItem;
		}
		public function set selectedItem(item:ISelectable):void
		{
			for each(var i:ISelectable in _items)
			{
				if(i == null)continue;
				i.selected = false;
			}
			item.selected = true;
		}
		
		public function getItems():Array
		{
			return _items;
		}
		public function getItemCount():int
		{
			return _items.length;
		}
		
		public function getItemAt(n:int):Object
		{
			if(n < 0 || n >= _items.length)return null;
			return _items[n];
		}
		
		public function getItemByProperty(propertyName:String,value:Object):DisplayObject
		{
			for each(var i:DisplayObject in _items)
			{
				if(i.hasOwnProperty(propertyName))
				{
					if(i[propertyName] == value)return i;
				}
			}
			return null;
		}
		
		public function appendItem(item:DisplayObject):void
		{
			if(item.parent == _container)return;
//			item.x = item.y = 1000;
//			_container.addChild(item);
			_items.push(item);
			invalidate(InvalidationType.SIZE);
		}
		public function appendItemAt(item:DisplayObject,index:int):void
		{
			if(item.parent == _container)return;
//			item.x = item.y = 1000;
//			_container.addChildAt(item,index);
			_items.splice(index,0,item);
			invalidate(InvalidationType.SIZE);
		}
		public function removeItem(item:DisplayObject):void
		{
			if(item == null)return;
//			if(item.parent != _container)return;
//			_container.removeChild(item);
			if(item.parent == _container)
				_container.removeChild(item);
			_items.splice(_items.indexOf(item),1);
			invalidate(InvalidationType.SIZE);
		}
		public function removeItemAt(index:int):void
		{
			if(index < 0 || index >= _items.length)return;
			_container.removeChildAt(index);
			_items.splice(index,1);
			invalidate(InvalidationType.SIZE);
		}
		
		public function containItem(d:DisplayObject):Boolean
		{
			return _items.indexOf(d) != -1;
		}
		public function clearItems():void
		{
			var len:int = _container.numChildren;
			var n:int = 0;
			while(n++ < len)
			{
				_container.removeChildAt(0);
			}
			_items = [];
			invalidate(InvalidationType.SIZE);
		}
		
		public function disposeItems():void
		{
			for each(var i:Object in _items)
			{
				i["dispose"]();
			}
			clearItems();
		}
		
		public function sortOn(fields:Array,options:Array):void
		{
			_items.sortOn(fields,options);
			invalidate(InvalidationType.SIZE);
		}
		
		public function moveItemTo(propertyName:String,value:Object,index:int):void
		{
			var n:int = -1;
			for(var i:int = 0; i < _items.length; i++)
			{
				if(_items[i][propertyName] == value)
				{
					n = i;break;
				}
			}
			if(n != -1)
			{
				var t:Object = _items.splice(n,1)[0];
				_items.splice(index,0,t);
			}
			invalidate(InvalidationType.SIZE);
		}
		
		override protected function setVerticalScrollPosition(scroll:Number, fireEvent:Boolean=false):void
		{
			var rect:Rectangle = _container.scrollRect;
			var m:Number = Math.min(Math.ceil((scroll) / verticalScrollBar.lineScrollSize) * verticalScrollBar.lineScrollSize,verticalScrollBar.maxScrollPosition);
			rect.y = Math.max(m,0);
			_container.scrollRect = rect;
		}
		override protected function setHorizontalScrollPosition(scroll:Number, fireEvent:Boolean=false):void
		{
			var rect:Rectangle = _container.scrollRect;
			rect.x = scroll;
			_container.scrollRect = rect;
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.DATA,InvalidationType.SIZE))
			{
				drawChildren();
				invalidate(InvalidationType.SIZE,false);
			}
			super.draw();
		}
		override protected function drawLayout():void
		{
			super.drawLayout();
			contentScrollRect = _container.scrollRect;
			contentScrollRect.width = availableWidth;
			contentScrollRect.height = availableHeight;
			_container.scrollRect = contentScrollRect;
		}
		protected function drawChildren():void
		{
			contentHeight = contentWidth = 0;
			var itemlen:int = _items.length;
			var item:DisplayObject;
			for(var i:int = 0; i < itemlen; i++)
			{
				item = _items[i];
				if(item.parent != _container)
				{
					_container.addChild(item);
				}
				if(!_reverseWidth)
				{
					item.x = _marginW + i % _columns * (_itemGapW + _itemWidth);
				}
				else 
				{
					item.x = _marginW + (_columns - i % _columns) * (_itemGapW + _itemWidth);
				}
				item.y = _marginH + Math.floor(i / columns) * (_itemGapH + _itemHeight);
				if(contentWidth < item.x + _itemWidth)contentWidth = item.x + _itemWidth;
				if(contentHeight < item.y + _itemHeight)contentHeight = item.y + _itemHeight;
			}
			contentWidth = contentWidth + _marginW;
			contentHeight = contentHeight + _marginH;
		}
		override protected function configUI():void
		{
			super.configUI();
			_container = new UIComponent();
			_container.scrollRect = contentScrollRect;
			_horizontalScrollPolicy = ScrollPolicy.AUTO;
			_verticalScrollPolicy = ScrollPolicy.AUTO;
			addChild(_container);
		}
		
		public function dispose():void
		{
			_items = [];
			if(parent)parent.removeChild(this);
			
			try
			{
				delete StyleManager.getInstance().classToInstancesDict[StyleManager.getClassDef(this)][this];
			}
			catch(e:Error){}
		}
		
		public static function getStyleDefinition():Object
		{
			return mergeStyles(defaultStyles,BaseScrollPane.getStyleDefinition());
		}
	}
}