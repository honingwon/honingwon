package sszt.consign.components.searchItemTypeView
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mhsm.ui.BtnAsset4;
	
	import sszt.consign.components.searchItemTypeView.data.CAccordionItemData;
	import sszt.ui.container.SelectedBorder;
	
	public class CAccordionItemView extends Sprite
	{
		private var _info:CAccordionItemData;
		private var _selected:Boolean;
//		private var _itemBgBtn:BtnAsset4;
		private var _itemField:TextField;
		private var _width:int;
//		private var _selectShap:Shape;
		
		private var _selectBorder:Shape; //SelectedBorder;
		
		public function CAccordionItemView(argAccordionItemData:CAccordionItemData,argWidth:int)
		{
			_width = argWidth;
			_info = argAccordionItemData;
			init();
			initEvent();
			super();
		}
		
		private function init():void
		{
			buttonMode = true;
			
			_selectBorder = new Shape();	
			_selectBorder.graphics.beginFill(0x324636,1);
			_selectBorder.graphics.drawRect(0,0,_width,20);
			_selectBorder.visible = false;
			addChild(_selectBorder);
			
//			_itemBgBtn = new BtnAsset4();
//			_itemBgBtn.x = 13;
//			_itemBgBtn.width = 137;
//			_itemBgBtn.height = 23;
//			addChild(_itemBgBtn);
			
			_itemField = new TextField();
//			_itemField.autoSize = TextFieldAutoSize.CENTER;
			_itemField.width = 137;
			_itemField.height = 20;
			_itemField.x = 20;
//			_itemField.y = 1;
//			_itemField.x = _itemBgBtn.x + (_itemBgBtn.width - _itemField.width)/2;
			_itemField.text = _info.itemName;
			_itemField.textColor = 0xdcd0ab;
			_itemField.filters = [new GlowFilter(0x000000,1,2,2,10)];
			_itemField.mouseEnabled = false;
			addChild(_itemField);
			
//			_selectShap = new Shape();
//			_selectShap.graphics.lineStyle(1,0xFFFFFF);
//			_selectShap.graphics.drawRoundRect(0,0,_itemField.width-20,_itemField.textHeight,20,20);
//			_selectShap.visible = false;
//			addChild(_selectShap);
			
//			_selectBorder = new SelectedBorder();
//			_selectBorder.mouseEnabled = false;
//			_selectBorder.setSize(138, 24);
//			_selectBorder.visible = false;
//			_selectBorder.move(0,-2);
//			addChild(_selectBorder);						
			
		}
		
		private function initEvent():void
		{
			
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			if(_selected)
			{
				_itemField.textColor = 0xFFFDA5;
//				_selectShap.visible = true;
				_selectBorder.visible = true;
			}
			else
			{
				_itemField.textColor = 0xFFFFFF;
//				_selectShap.visible = false;
				_selectBorder.visible = false;
			}
			dispatchEvent(new Event(Event.SELECT));
			
		}

		public function get info():CAccordionItemData
		{
			return _info;
		}

		public function set info(value:CAccordionItemData):void
		{
			_info = value;
		}
		
		public function dispose():void
		{
			_info = null;
			_itemField = null;
//			_selectShap = null;
			_selectBorder = null;
			if(parent)parent.removeChild(this);
		}
	}
}