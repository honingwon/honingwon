package sszt.consign.components.searchItemTypeView
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mhsm.ui.AddBtnAsset;
	import mhsm.ui.BtnAsset4;
	import mhsm.ui.ReduceBtnAsset;
	
	import sszt.ui.mcache.btns.MCacheAssetBtn2;
	
	public class CAccordionTitleView extends Sprite
	{
		private var _title:String;
		private var _selected:Boolean;
		private var _width:int;
//		private var _bgBtn:BtnAsset4;
		private var _titleField:TextField;
		private var _addIcon:MCacheAssetBtn2;
		private var _reduceIcon:MCacheAssetBtn2;
		
		public function CAccordionTitleView(title:String,width:int)
		{
			_title = title;
			_width = width;
			init();
			initEvent();
			super();
		}
		
		private function init():void
		{
			buttonMode = true;
			//_addIcon = new Bitmap(new AddBtnAsset());
			_addIcon = new MCacheAssetBtn2(10);
			_addIcon.visible = true;
			_addIcon.x = 2;
			_addIcon.y = 2;
			addChild(_addIcon);
			//_reduceIcon = new Bitmap(new ReduceBtnAsset());
			_reduceIcon = new MCacheAssetBtn2(11);
			_reduceIcon.visible = false;
			_reduceIcon.x = 2;
			_reduceIcon.y = 2;
			addChild(_reduceIcon);
			
//			_bgBtn = new BtnAsset4();
//			_bgBtn.x = 5;
//			_bgBtn.y = 3;
//			_bgBtn.width = 156;
//			_bgBtn.height = 30;
//			addChild(_bgBtn);
			
			
			_titleField = new TextField();
			_titleField.mouseEnabled = false;
			_titleField.height = _addIcon.height;
			_titleField.x = _addIcon.x + _addIcon.width;
			_titleField.y = _addIcon.y-1;
			
//			_titleField.autoSize = TextFieldAutoSize.CENTER;
//			_titleField.height = 20;
//			_titleField.x = _bgBtn.x + (_bgBtn.width - _titleField.width)/2;
//			_titleField.y = 7;
			
			_titleField.text = _title;
			_titleField.textColor = 0xcc9933;
			_titleField.filters = [new GlowFilter(0x000000,1,2,2,4.10)];
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
				_titleField.textColor = 0xcc9933;
				_reduceIcon.visible = true;
				_addIcon.visible = false;
			}
			else
			{
				_titleField.textColor = 0xcc9933;
				_addIcon.visible = true;
				_reduceIcon.visible = false;
			}
			dispatchEvent(new Event(Event.SELECT));
		}
		
		public function dispose():void
		{
			_title = null;
			_addIcon = null;
			_reduceIcon = null;
			if(parent)parent.removeChild(this);
		}
	}
}