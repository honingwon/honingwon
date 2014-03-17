package sszt.ui.container
{
	import fl.controls.ScrollBarDirection;
	import fl.controls.ScrollPolicy;
	import fl.controls.UIScrollBar;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.events.ScrollEvent;
	import fl.managers.StyleManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class MTextArea extends UIComponent
	{
//		public static var DEFAULT_TEXTFORMAT:TextFormat = new TextFormat("宋体",12,0x000000);
		public static var DEFAULT_TEXTFORMAT:TextFormat = new TextFormat("Verdana",12,null,null,null,null,null,null,null,null,null,null,3);
		
		public var textField:TextField;
		
		protected var _horizontalScrollPolicy:String = ScrollPolicy.AUTO;
		protected var _verticalScrollPolicy:String = ScrollPolicy.AUTO;
		
		protected var _horizontalScrollBar:UIScrollBar;
		protected var _verticalScrollBar:UIScrollBar;
		
		protected var _editable:Boolean;
		
		private var _vscrollBarWidth:Number;
		private var _horizontalHeight:Number;
		private var _wordWrap:Boolean;
		
		private var _currentTextFormat:TextFormat;
				
		public function MTextArea()
		{
			super();
		}
		
		public function get horizontalScrollBar():UIScrollBar
		{ 
			return _horizontalScrollBar;
		}
		
		public function get verticalScrollBar():UIScrollBar 
		{ 
			return _verticalScrollBar;
		}
		
		public function get horizontalScrollPolicy():String 
		{
			return _horizontalScrollPolicy;
		}
		
		public function set horizontalScrollPolicy(value:String):void 
		{
			if(_horizontalScrollPolicy == value)return;
			_horizontalScrollPolicy = value;
			invalidate(InvalidationType.SIZE);
		}
		
		public function get verticalScrollPolicy():String 
		{
			return _verticalScrollPolicy;
		}
		
		public function set verticalScrollPolicy(value:String):void 
		{
			if(_verticalScrollPolicy == value)return;
			_verticalScrollPolicy = value;
			invalidate(InvalidationType.SIZE);
		}
		
		public function get horizontalScrollPosition():Number 
		{
			return textField.scrollH;
		}
		
		public function set horizontalScrollPosition(value:Number):void 
		{
			drawNow();
			textField.scrollH = value;
		}
		
		public function get verticalScrollPosition():Number 
		{
			return textField.scrollV;
		}
		
		public function set verticalScrollPosition(value:Number):void 
		{
			drawNow();
			textField.scrollV = value;
		}
		
		public function get textWidth():Number 
		{
			drawNow();
			return textField.textWidth;
		}
		
		public function get textHeight():Number 
		{
			drawNow();
			return textField.textHeight;
		}
		
		public function get text():String
		{
			return textField.text;
		}
		
		public function set text(value:String):void
		{
			textField.text = value;
			invalidate(InvalidationType.STYLES);
			invalidate(InvalidationType.DATA);
		}
		
		public function get htmlText():String 
		{
			return textField.htmlText;
		}
		
		public function set htmlText(value:String):void 
		{
			textField.htmlText = value;
			invalidate(InvalidationType.STYLES);
			invalidate(InvalidationType.DATA);
		}
		
		public function get maxHorizontalScrollPosition():int 
		{
			return textField.maxScrollH;
		}
		
		public function get maxVerticalScrollPosition():int 
		{
			return textField.maxScrollV;
		}
		
		public function get editable():Boolean 
		{
			return _editable;
		}
		
		public function set editable(value:Boolean):void 
		{
			_editable = value;
			invalidate(InvalidationType.STATE);
		}
		
		override public function set enabled(value:Boolean):void 
		{
			if(enabled == value)return;
			super.enabled = value;
			mouseChildren = enabled;  //Disables mouseWheel interaction.
			invalidate(InvalidationType.STATE);
		}
		
		public function appendText(text:String):void 
		{
			textField.appendText(text);
			invalidate(InvalidationType.STYLES);
			invalidate(InvalidationType.DATA);
		}
		
		public function setTextFormat(value:TextFormat):void
		{
			_currentTextFormat = value;
		}
		
		override protected function configUI():void 
		{
			super.configUI();
			
			_enabled = true;
			_editable = true;
			_wordWrap = true;
			_currentTextFormat = DEFAULT_TEXTFORMAT;
			_vscrollBarWidth = _horizontalHeight = 25;

			textField = new TextField();
			addChild(textField);
			updateTextFieldType();
			
			textField.addEventListener(Event.CHANGE, handleChange, false, 0, true);
			addEventListener(MouseEvent.MOUSE_WHEEL, handleWheel, false, 0, true);
		}
		
		private function getVerticalScrollBar():UIScrollBar
		{
			if(_verticalScrollBar == null)
			{
				_verticalScrollBar = new UIScrollBar();
				_verticalScrollBar.name = "V";
				_verticalScrollBar.visible = false;
				_verticalScrollBar.focusEnabled = false;
				_verticalScrollBar.scrollTarget = textField;
				_verticalScrollBar.width = _vscrollBarWidth;
				addChild(_verticalScrollBar);
			}
			return _verticalScrollBar;
		}
		
		private function getHorizontalScrollBar():UIScrollBar
		{
			if(_horizontalScrollBar == null)
			{
				_horizontalScrollBar = new UIScrollBar();
				_horizontalScrollBar.name = "H";
				_horizontalScrollBar.visible = false;
				_horizontalScrollBar.focusEnabled = false;
				_horizontalScrollBar.direction = ScrollBarDirection.HORIZONTAL;
				_horizontalHeight = _horizontalHeight;
				addChild(_horizontalScrollBar);
				_horizontalScrollBar.scrollTarget = textField;
			}
			return _horizontalScrollBar;
		}
		
		protected function updateTextFieldType():void 
		{
			textField.type = (enabled && _editable) ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			textField.selectable = enabled;
			textField.multiline = true;
			textField.wordWrap = _wordWrap;
		}
		
		protected function handleWheel(event:MouseEvent):void 
		{
			if (!enabled || !_verticalScrollBar || !_verticalScrollBar.visible) { return; }
			_verticalScrollBar.scrollPosition -= event.delta * _verticalScrollBar.lineScrollSize;
			dispatchEvent(new ScrollEvent(ScrollBarDirection.VERTICAL, event.delta * _verticalScrollBar.lineScrollSize, _verticalScrollBar.scrollPosition));
		}
		
		protected function handleChange(event:Event):void 
		{
			event.stopPropagation(); // so you don't get two change events
			dispatchEvent(new Event(Event.CHANGE, true));
			invalidate(InvalidationType.DATA);
		}
		
		public function set wordWrap(value:Boolean):void
		{
			if(_wordWrap == value)return;
			_wordWrap = value;
			invalidate(InvalidationType.STATE);
		}
		
		public function get wordWrap():Boolean
		{
			return _wordWrap;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
		}
		
		override protected function draw():void 
		{
			if (isInvalid(InvalidationType.STATE)) 
			{
				updateTextFieldType();
			}
			
			if (isInvalid(InvalidationType.STYLES) || isInvalid(InvalidationType.STATE)) 
			{
				drawTextFormat();
				invalidate(InvalidationType.SIZE, false);
			}
			
			if (isInvalid(InvalidationType.SIZE) || isInvalid(InvalidationType.DATA)) 
			{
				drawLayout();
			}
			
			
			super.draw();
		}
		
		protected function drawTextFormat():void 
		{
			textField.setTextFormat(_currentTextFormat);
			textField.defaultTextFormat = _currentTextFormat;
		}
		
		protected function drawLayout():void 
		{
			var availHeight:Number = height;
			var vScrollBar:Boolean = needVScroll();
			var availWidth:Number = width - (vScrollBar ? _vscrollBarWidth : 0);
			
			var hScrollBar:Boolean = needHScroll();
			if(hScrollBar)
			{
				availHeight -= _horizontalHeight;
			}
			setTextSize(availWidth,availHeight);
			
			if(hScrollBar && !vScrollBar && needVScroll())
			{
				vScrollBar = true;
				availWidth -= _vscrollBarWidth;
				setTextSize(availWidth,availHeight);
			}
			
			if(vScrollBar)
			{
				var vsb:UIScrollBar = getVerticalScrollBar();
				vsb.visible = true;
				vsb.x = width - _vscrollBarWidth;
				vsb.height = availHeight;
				vsb.enabled = enabled;
			}
			else
			{
				if(_verticalScrollBar)_verticalScrollBar.visible = false;
			}
			
			if(hScrollBar)
			{
				var hsb:UIScrollBar = getHorizontalScrollBar();
				hsb.y = height - _horizontalHeight;
				hsb.visible = true;
				hsb.width = availWidth;
				hsb.enabled = enabled;
			}
			else
			{
				if(_horizontalScrollBar)_horizontalScrollBar.visible = false;
			}
			
			updateScrollBars();	
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function updateScrollBars():void 
		{
			if(_horizontalScrollBar)
			{
				_horizontalScrollBar.update();
				_horizontalScrollBar.enabled = enabled;
				_horizontalScrollBar.drawNow();
			}
			if(_verticalScrollBar)
			{
				_verticalScrollBar.update();
				_verticalScrollBar.enabled = enabled;
				_verticalScrollBar.drawNow();
			}			
		}
		
		protected function needVScroll():Boolean 
		{
			if (_verticalScrollPolicy == ScrollPolicy.OFF) { return false; }
			if (_verticalScrollPolicy == ScrollPolicy.ON) { return true; }
			return (textField.maxScrollV > 1);
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function needHScroll():Boolean 
		{
			if (_horizontalScrollPolicy == ScrollPolicy.OFF) { return false; }
			if (_horizontalScrollPolicy == ScrollPolicy.ON) { return true; }
			return (textField.maxScrollH > 0);
		}
		
		protected function setTextSize(w:Number, h:Number):void 
		{
			if (w != textField.width) {
				textField.width = w;
			}
			if (h != textField.height) {
				textField.height = h;
			}			
		}
		
		public function dispose():void
		{
			if(parent)parent.removeChild(this);
			try
			{
				delete StyleManager.getInstance().classToInstancesDict[StyleManager.getClassDef(this)][this];
			}
			catch(e:Error){}
		}
	}
}