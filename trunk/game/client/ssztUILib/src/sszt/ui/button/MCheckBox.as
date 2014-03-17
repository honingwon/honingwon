/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-9-5 下午5:43:12 
 * 
 */ 
package sszt.ui.button 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import sszt.ui.LabelCreator;
	
	public class MCheckBox extends MSelectButton {
		
		public static const SELECTED_TEXTFORMAT:TextFormat = new TextFormat("宋体", 12, 0xFFFFFF);
//		public static const UP_ICON:BitmapData = new CheckBoxUpAsset();
//		public static const SELECT_UP_ICON:BitmapData = new CheckBoxUpSelectAsset();
		
		private var _settedFormat:TextFormat = null;
		private var _bitmapWidth:int = 16;
		private var _bitmap:Bitmap;
		
		public function MCheckBox(label:String=""){
			super(null, label, -1, -1, 1, 1, null, true);
			selectedTextformat = (unselectedTextformat = SELECTED_TEXTFORMAT);
			selectedFilter = [new GlowFilter(0, 1, 2, 2, 2)];
		}
		override protected function createAsset():DisplayObject{
			_bitmap = new Bitmap();
			return (_bitmap);
		}
		override protected function createLabel(str:String):TextField{
			var t:TextField;
			if (str == null){
				return (null);
			}
			if (_label == null){
				t = LabelCreator.getLabel(str, null, null, false, TextFieldAutoSize.LEFT);
			} else {
				_label.text = str;
				t = _label;
				t.width = (t.textWidth + 20);
				t.height = t.textHeight;
			}
			t.x = (_bitmapWidth + _labelXOffset);
			t.y = _labelYOffset;
			_labelX = t.x;
			_labelY = t.y;
			return (t);
		}
		override public function updateStyle():void{
			super.updateStyle();
//			if (_selected){
//				_bitmap.bitmapData = SELECT_UP_ICON;
//				if (_label){
//					if (_settedFormat){
//						_label.setTextFormat(_settedFormat);
//					} else {
//						_label.setTextFormat(selectedTextformat);
//					}
//					_label.filters = selectedFilter;
//				}
//			} else{
//				_bitmap.bitmapData = UP_ICON;
//				if (_label){
//					if (_settedFormat){
//						_label.setTextFormat(_settedFormat);
//					} else {
//						_label.setTextFormat(unselectedTextformat);
//					};
//					_label.filters = selectedFilter;
//				}
//			}
		}
		override protected function clickHandler(evt:MouseEvent):void{
			super.clickHandler(evt);
			dispatchEvent(new Event(Event.CHANGE));
		}
		override public function set label(value:String):void{
			_label.text = value;
			_label.x = (_bitmapWidth + _labelXOffset);
			_label.y = _labelYOffset;
			_labelX = _label.x;
			_labelY = _label.y;
		}
		override protected function init():void{
			_enabled = true;
			buttonMode = false;
		}
		public function setTextFormat(format:TextFormat):void{
			_settedFormat = format;
		}
		
	}
}
