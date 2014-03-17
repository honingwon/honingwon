package sszt.rank.components.treeView
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	
	import ssztui.ui.BtnStairOverAsset;
	import ssztui.ui.BtnStairSelectedAsset;
	import ssztui.ui.BtnStairUpAsset;
	
	public class TreeTitleView extends Sprite
	{
		private var _title:String;
		private var _bg:MovieClip;
		private var _selected:Boolean;
		private var _width:int;
		private var _titleField:TextField;
		
		public function TreeTitleView(title:String,width:int)
		{
			_title = title;
			_width = width;
			init();
			initEvents();
			super();
		}
		
		private function init():void
		{
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,_width,30);
			graphics.endFill();
			
			buttonMode = true;
			
			btnStyle(0);
			
			_titleField = new TextField();
			_titleField.mouseEnabled = false;
			
			_titleField.height = 20;
			_titleField.width = _width;
			_titleField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xdccda0,null,null,null,null,null,null,null,null,0,0);
			_titleField.x = 0;
			_titleField.y = 7;
			_titleField.autoSize = TextFieldAutoSize.CENTER;
			_titleField.text = _title;
			_titleField.filters = [new GlowFilter(0x4b3910,1,2,2,10)];
			addChild(_titleField);
			
		}
		
		private function initEvents():void
		{
			addEventListener(MouseEvent.CLICK, onClickHandler);
			addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
		}
		
		private function removeEvents():void
		{
			removeEventListener(MouseEvent.CLICK, onClickHandler);
			removeEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
		}
		
		private function onClickHandler(evt:MouseEvent):void
		{
			
		}
		private function onOverHandler(evt:MouseEvent):void
		{
			if(!selected) btnStyle(1);
		}
		private function onOutHandler(evt:MouseEvent):void
		{
			if(!selected) btnStyle(0);
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
				btnStyle(2);
				_titleField.textColor = 0xfffccc;
			}
			else
			{
				btnStyle(0);
				_titleField.textColor = 0xdccda0;
			}
		}
		private function btnStyle(m:int = 0):void
		{
			if(_bg && _bg.parent) _bg.parent.removeChild(_bg);
			_bg = null;
			switch(m)
			{
				case 0:
					_bg = new BtnStairUpAsset();
					break;
				case 1:
					_bg = new BtnStairOverAsset();
					break;
				case 2:
					_bg = new BtnStairSelectedAsset();
					break;
			}
			_bg.width = _width;
			_bg.height = 30;
			addChildAt(_bg,0);
			_bg.mouseEnabled = false;
		}
		
		public function dispose():void
		{
			removeEvents();
			_title = null;
			if(_titleField && _titleField.parent)
			{
				_titleField.parent.removeChild(_titleField);
			}
			_titleField = null;
			if(_bg && _bg.parent)
			{
				_bg.parent.removeChild(_bg);;
				_bg = null;
			}
			if(parent)
				parent.removeChild(this);
		}
	}
}