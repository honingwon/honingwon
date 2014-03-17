package sszt.ui.container.accordionItems
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mhsm.ui.BarAsset6;
	
	import sszt.ui.label.MAssetLabel;
	
	public class AccordionGroupItemView extends Sprite
	{
		protected var _info:IAccordionItemData;
		private var _selected:Boolean;
		private var _itemField:TextField;
		protected var _width:int;
		protected var _selectedBg:DisplayObject;
		protected var _showItemSelectedBg:Boolean;
		protected var _accordionItem:DisplayObject;
		
		public function AccordionGroupItemView(info:IAccordionItemData,width:int,showItemSelectedBg:Boolean = true)
		{
			_width = width;
			_info = info;
			_showItemSelectedBg = showItemSelectedBg;
			super();
			init();
			initEvent();
		}
		
		protected function init():void
		{
			buttonMode = true;
			
			if(_showItemSelectedBg)
			{
				_selectedBg = new BarAsset6();
				_selectedBg.width = _width - 2;
				_selectedBg.height = 20;
				_selectedBg.x = 1;
				addChild(_selectedBg);
				_selectedBg.visible = false;
			}
			
			_accordionItem = _info.getAccordionItem(_width);
			_accordionItem.x = 20;
			addChild(_accordionItem);
			
//			_itemField = new TextField();
//			_itemField.defaultTextFormat = new TextFormat("宋体",12,0xFFFFFF);
//			_itemField.filters = [new GlowFilter(0x17380F,1,2,2,10)];
//			_itemField.width = _width;
//			_itemField.height = 20;
//			_itemField.mouseEnabled = false;
//			_itemField.x = 20;
//			_itemField.htmlText = _info.getAccordionItemValue();
//			addChild(_itemField);
		}
		
		private function initEvent():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER,overHanlder);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHanlder);
		}
		private function overHanlder(e:MouseEvent):void
		{
			if(selected || !_showItemSelectedBg) return;
			_selectedBg.visible = true;
		}
		private function outHanlder(e:MouseEvent):void
		{
			if(selected || !_showItemSelectedBg) return;
			_selectedBg.visible = false;
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			if(_showItemSelectedBg)_selectedBg.visible = _selected;
//			dispatchEvent(new Event(Event.SELECT));
		}
		
		public function get itemData():IAccordionItemData
		{
			return _info;
		}
		
		public function dispose():void
		{
			_info = null;
			_itemField = null;
			if(parent)parent.removeChild(this);
			this.removeEventListener(MouseEvent.MOUSE_OVER,overHanlder);
			this.removeEventListener(MouseEvent.MOUSE_OUT,outHanlder);
		}
	}
}