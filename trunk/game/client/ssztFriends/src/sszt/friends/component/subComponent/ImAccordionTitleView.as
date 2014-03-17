package sszt.friends.component.subComponent
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalAPI;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	
//	import ssztui.friends.SelectedAsset;
//	import ssztui.friends.UnSelectedAsset;
	import ssztui.ui.TreeIconAddAsset;
	import ssztui.ui.TreeIconLowAsset;
	
	public class ImAccordionTitleView extends Sprite implements ITick
	{
		private var _title:String;
		private var _selected:Boolean;
		private var _selectedIcon:Bitmap;
		private var _unselectedIcon:Bitmap;
		private var _bg:IMovieWrapper;
		private var _titleField:MAssetLabel;
		private var _stateField:MAssetLabel;
		private var _width:int;
		private var _onlineNumber:int;
		private var _totalNumber:int;
		
		public function ImAccordionTitleView(title:String,width:int,onlineNumber:int,totalNumber:int)
		{
			_title = title;
			_width = width;
			_onlineNumber = onlineNumber;
			_totalNumber = totalNumber;
			super();
			init();
		}
		
		public function changeTitle(title:String):void
		{
			_title = title;
			_titleField.text = _title;
		}
		
		public function changeState(onAdd:int=0,totalAdd:int=0):void
		{	
			_onlineNumber = _onlineNumber + onAdd;
			_totalNumber  = _totalNumber + totalAdd;
//			_titleField.text = "["+_onlineNumber+"/"+_totalNumber+"]";
			_titleField.setHtmlValue(_title +"<font color='#fffccc'> ("+_onlineNumber+"/"+_totalNumber+")</font>");
		}
		
		public function set flash(value:Boolean):void
		{
			if(value)
			{
				GlobalAPI.tickManager.addTick(this);
			}
			else
			{
				GlobalAPI.tickManager.removeTick(this);
				_titleField.alpha = 1;
			}
		}
		
		private var _up:Boolean;
		private var _currentIndex:int = 0;
		public function update(times:int,dt:Number = 0.04):void
		{
			if(_currentIndex <12)
			{
				_titleField.alpha -= 0.08;
			}else
			{
				_titleField.alpha += 0.08;
			}
			_currentIndex++;
			if(_currentIndex >= 25)
			{
				_titleField.alpha = 1;
				_currentIndex = 0;
			} 
		}
				
		private function init():void
		{
			buttonMode = true;
			
//			_bg = BackgroundUtils.setBackground([
//				
//				new BackgroundInfo(BackgroundType.BAR_5, new Rectangle(0, 0, _width, 26))
//			]);
//			addChild(_bg as DisplayObject);
			
			_selectedIcon = new Bitmap(new TreeIconLowAsset());
			_selectedIcon.x = 2;
			_selectedIcon.y = 2;
			addChild(_selectedIcon);
			_unselectedIcon = new Bitmap(new TreeIconAddAsset());
			_unselectedIcon.x = 2;
			_unselectedIcon.y = 2;
			addChild(_unselectedIcon);
			_selectedIcon.visible = false;
			
			_titleField = new MAssetLabel(_title, MAssetLabel.LABEL_TYPE_TAG, TextFormatAlign.LEFT);
//			_titleField.width = _bg.width - 18;
//			_titleField.height = _bg.height - 5;
			_titleField.mouseEnabled = false;
			_titleField.x = 24;
			_titleField.y = 3;
			addChild(_titleField);
			
			_titleField.setHtmlValue(_title +"<font color='#fffccc'> ("+_onlineNumber+"/"+_totalNumber+")</font>");
			
//			_stateField = new MAssetLabel("",MAssetLabel.LABEL_TYPE21,TextFormatAlign.RIGHT);
//			_stateField.mouseEnabled = false;
//			_stateField.x = 169;
//			_stateField.y = 4;
//			_stateField.text = "("+_onlineNumber+"/"+_totalNumber+")";
//			addChild(_stateField);	
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
			GlobalAPI.tickManager.removeTick(this);
			_selectedIcon = null;
			_unselectedIcon = null;
			_bg = null;
			_titleField = null;
			_stateField = null;	
			if(parent) parent.removeChild(this);
		}
	}
}