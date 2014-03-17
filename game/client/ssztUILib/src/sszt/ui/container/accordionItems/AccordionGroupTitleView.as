package sszt.ui.container.accordionItems
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
//	import mhsm.ui.BarAssetBd4;
	import mhsm.ui.BarAsset3;
	import sszt.ui.label.MAssetLabel;
	
	import mhsm.ui.BarAsset1;
	import mhsm.ui.SelectedAsset;
	import mhsm.ui.UnSelectedAsset;
	
	public class AccordionGroupTitleView extends Sprite
	{
		protected var _title:String;
		private var _selected:Boolean;
		protected var _selectedIcon:Bitmap;
		protected var _unselectedIcon:Bitmap;
		private var _bg:BarAsset1;
		protected var _titleField:TextField;
		protected var _width:int;
		private var _showBg:Boolean;
		
		public function AccordionGroupTitleView(title:String,width:int,showBg:Boolean = true)
		{
			_title = title;
			_width = width;
			_showBg = showBg;
			super();
			init();
			initEvent();
		}
		
		protected function init():void
		{
			buttonMode = true;
			if(_showBg)
			{
				_bg = new BarAsset1();
				addChild(_bg);
				_bg.width = _width;
				_bg.tabEnabled = false;
			}
			_selectedIcon = new Bitmap(new SelectedAsset());
			_selectedIcon.x = 4;
			_selectedIcon.y = 6;
			addChild(_selectedIcon);
			_unselectedIcon = new Bitmap(new UnSelectedAsset());
			_unselectedIcon.x = 7;
			_unselectedIcon.y = 3;
			addChild(_unselectedIcon);
			_selectedIcon.visible = false;
			_titleField = new TextField();
			_titleField.width = _width - 18;
			_titleField.height = 24;
			_titleField.mouseEnabled = false;
			_titleField.x = 21;
			_titleField.text = _title;
			_titleField.textColor = 0xB0E8DC;
			_titleField.filters = [new GlowFilter(0x0B4E40,1,1,1,10)];
			addChild(_titleField);
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
				_unselectedIcon.visible = false;
				_selectedIcon.visible = true;
			}
			else
			{
				_unselectedIcon.visible = true;
				_selectedIcon.visible = false;
			}
			dispatchEvent(new Event(Event.SELECT));
		}
		
		public function dispose():void
		{
			if(parent)parent.removeChild(this);
		}
	}
}