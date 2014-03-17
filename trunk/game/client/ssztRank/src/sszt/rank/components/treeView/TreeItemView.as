package sszt.rank.components.treeView
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mhsm.ui.BtnAsset4;
	
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.rank.components.treeView.data.TreeItemData;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.SelectedBorder;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.ui.BarAsset3;
	
	public class TreeItemView extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _info:TreeItemData;
		private var _selected:Boolean;
		private var _itemField:TextField;
		private var _width:int;
		private var _selectedBorder:Sprite;
		
		public function TreeItemView(argTreeItemData:TreeItemData,argWidth:int)
		{
			_width = argWidth;
			_info = argTreeItemData;
			init();
			initEvents();
			super();
		}
		
		private function init():void
		{
			buttonMode = true;
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(0, 24, _width, 2),new MCacheSplit2Line())
			]);
			addChild(_bg as DisplayObject);
			_bg.alpha = 0.5;
			
			_selectedBorder = MBackgroundLabel.getDisplayObject(new Rectangle(0,0,_width,24),new BarAsset3()) as Sprite;
			_selectedBorder.mouseEnabled = false;
			addChild(_selectedBorder);
			_selectedBorder.visible = false;
			
			_itemField = new TextField();
			_itemField.width = _width;
			_itemField.height = 20;
			_itemField.x = 0;
			_itemField.y = 4;
			_itemField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xfff4d3,null,null,null,null,null,TextFormatAlign.CENTER);
//			_itemField.autoSize = TextFieldAutoSize.CENTER;
			_itemField.text = _info.itemName;
//			_itemField.textColor = 0xffffff;
			
			_itemField.mouseEnabled = false;
			addChild(_itemField);
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
			if(!selected) _selectedBorder.visible = true;
		}
		private function onOutHandler(evt:MouseEvent):void
		{
			if(!selected) _selectedBorder.visible = false;
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
				_itemField.textColor = 0xff9900;
				_selectedBorder.visible = true;
			}
			else
			{
				_itemField.textColor = 0xfff4d3;
				_selectedBorder.visible = false;
			}
		}

		public function get info():TreeItemData
		{
			return _info;
		}

		public function set info(value:TreeItemData):void
		{
			_info = value;
		}
		
		public function dispose():void
		{
			removeEvents();
			_info = null;
			if(_itemField && _itemField.parent)
			{
				_itemField.parent.removeChild(_itemField);
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_selectedBorder && _selectedBorder.parent)
			{
				_selectedBorder.parent.removeChild(_selectedBorder);
				_selectedBorder = null;
			}
			_itemField = null;
			if(parent)
				parent.removeChild(this);
		}
	}
}