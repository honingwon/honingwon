package sszt.core.view.tips
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.furnace.parametersList.RebuildInfo;
	
	import ssztui.ui.BorderAsset5;
	import ssztui.ui.MenuIconOKAsset;
	
	public class MenuItem extends Sprite
	{
//		private var _shape:Shape;
		private var _shape:Bitmap;
		private var _selectBg:Bitmap;
		private var _selected:Boolean;
		private var _textLabel:TextField;
		private var _label:String;
		public static const XOFFSET:int = 2;
		public static const YOFFSET:int = 1;
		
		public var id:int;
		
		public function MenuItem(label:String,id:int)
		{
			super();
			_label = label;
			this.id = id;
			initView();
			initEvent();
		}
		
		private function initView():void
		{
//			mouseEnabled = true;
			this.buttonMode = true;
			
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,72,18);
			graphics.endFill();
			
//			_shape = new Shape();
//			_shape.graphics.beginFill(0xFFCA79,0.4);
//			_shape.graphics.drawRect(0,0,62+XOFFSET,20);
//			_shape.graphics.endFill();
//			_shape = new Bitmap(new BitmapData(62,20));
//			_shape.bitmapData.fillRect(new Rectangle(0,0,62,20),0x60FFCA79);
			_shape = new Bitmap(new BorderAsset5 as BitmapData);
			addChild(_shape);
			_shape.visible = false;
			
			_textLabel = new TextField();
			_textLabel.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc);
			_textLabel.height = 16;
			_textLabel.width = 72;
			_textLabel.x = 0;
			_textLabel.y = YOFFSET;
			_textLabel.autoSize = TextFormatAlign.CENTER;
			_textLabel.text = _label;
			_textLabel.mouseEnabled = false;
			addChild(_textLabel);
		}
		
		public function set color(value:int):void
		{
			_textLabel.textColor = value;
		}
		
		public function set enabled(value:Boolean):void
		{
			if(value == false)
			{
				_textLabel.textColor = 0x72777b;
				this.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
				this.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
				this.buttonMode = false;
			}
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(_selected)
			{
				if(_selectBg == null) _selectBg = new Bitmap(new MenuIconOKAsset() as BitmapData);
				addChild(_selectBg);
				_selectBg.x = 4;
				_selectBg.y = 4;
				_textLabel.autoSize = TextFormatAlign.LEFT;
				_textLabel.x = 16;
			}else
			{
				if(_selectBg && _selectBg.parent) _selectBg.parent.removeChild(_selectBg);
				_textLabel.autoSize = TextFormatAlign.CENTER;
				_textLabel.x = 0;
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function get label():String
		{
			return _label;
		}
		
		private function initEvent():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);	
		}
		
		private function removeEvent():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		private function overHandler(evt:MouseEvent):void
		{
			_shape.visible = true;
		}
		
		private function outHandler(evt:MouseEvent):void
		{
			_shape.visible = false;	
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			_shape = null;
			_textLabel = null;
			if(parent) parent.removeChild(this);
		}		
	}
}