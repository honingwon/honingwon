package
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import ssztui.createRole.TipAsset;
	
	public class BaseTip extends Sprite
	{
		protected var _bg:TipAsset;
		protected var _text:TextField;
		private var _disposeTime:int;
		
		protected const LEADING:int = 6;
		protected const OFFSET:int = 6;
		private var _container:Sprite;
		
		public function BaseTip(container:Sprite)
		{
			super();
			_container = container;
			init();
		}
		
		protected function init():void
		{
			mouseChildren = mouseEnabled = false;
			_bg = new TipAsset();
			addChild(_bg);
			
			_text = new TextField();
			_text.defaultTextFormat = new TextFormat("宋体",12,0xFFFFFF,null,null,null,null,null,null,null,null,null,3);
			_text.filters = [new GlowFilter(0x281B1A,1,2,2,4.5)];
			_text.wordWrap = _text.multiline = true;
			_text.mouseEnabled = _text.mouseWheelEnabled = _text.selectable = false;
			_text.width = 180;
			_text.x = 6;
			_text.y = OFFSET;
			addChild(_text);
		}
		
		protected function clear():void
		{
			_text.text = "";
		}
		
		public function setTips(mes:String):void
		{
			_text.setTextFormat(new TextFormat("宋体",12,0xFFFFFF,null,null,null,null,null,null,null,null,null,3));
			_text.htmlText = mes;
//			_text.setTextFormat(new TextFormat("宋体",12,0xFFFFFF,null,null,null,null,null,null,null,null,null,3));
			_text.width = _text.textWidth + 6;
		}
		
		public function show():void
		{
			_text.height = _text.textHeight + LEADING;
			_bg.width = _text.width + OFFSET * 2;
			_bg.height = _text.height + LEADING * 2;
			
			this.visible = true;
			if(parent == null)
				_container.addChild(this);
		}
		
		public function hide():void
		{
			this.visible = false;
		}
		
		override public function get width():Number
		{
			return _bg.width;
		}
		
		override public function get height():Number
		{
			return _bg.height;
		}
		
		public function dispose():void
		{
			if(parent)parent.removeChild(this);
			_container = null;
		}
	}
}