package sszt.role.components.itemView
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.titles.TitleTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.ui.BarAsset3;
	import ssztui.ui.IconAsset1;
	
	public class TitleItemView extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _bgMouse:Sprite;
		
		private var _titleIfo:Object;
		private var _nameLabel:MAssetLabel;
		private var _isOwnLabel:MAssetLabel;
		private var _selected:Boolean;
		private var _enabled:Boolean;
		
		public function TitleItemView(info:Object)
		{
			super();
			_titleIfo = info;
			initView();
			setData();
			initEvents();
		}
		
		private function initView():void
		{
			this.buttonMode = this.mouseChildren = true;
			
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,185,27);
			graphics.endFill();
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,25,185,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,8,6,7),new Bitmap(new IconAsset1())),
			]); 
			addChild(_bg as DisplayObject);
			
			_nameLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_nameLabel.move(15,4);
			addChild(_nameLabel);
			_nameLabel.setValue(_titleIfo.name);
			_nameLabel.textColor = CategoryType.getQualityColor(_titleIfo.quality);
			
			var str:String = "";
			str = _titleIfo.name;
			for each(var title:TitleTemplateInfo in GlobalData.titleInfo.allTitles)
			{
				if(title.id == _titleIfo.id)
				{
					_enabled = true ;
					
				}
			}
			_isOwnLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_isOwnLabel.move(116,4);
			addChild(_isOwnLabel);
			if(_enabled)
			{
				_isOwnLabel.textColor = 0x2bcc2b;
				_isOwnLabel.setValue(LanguageManager.getWord("ssztl.role.haventTitle"));
			}
			else
			{
				_isOwnLabel.textColor = 0xd74c00;
				_isOwnLabel.setValue(LanguageManager.getWord("ssztl.role.notHaventTitle"));
			}
				
			
		}
		
		private function setData():void
		{

		}
		
	
		
		private function initEvents():void
		{
//			addEventListener(MouseEvent.CLICK, onClickHandler);
			addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
		}
		
		private function removeEvents():void
		{
//			removeEventListener(MouseEvent.CLICK, onClickHandler);
			removeEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
		}
		
		private function onClickHandler(evt:MouseEvent):void
		{
			
		}
		private function onOverHandler(evt:MouseEvent):void
		{
			if(!selected) btnStyle(true);
		}
		private function onOutHandler(evt:MouseEvent):void
		{
			if(!selected) btnStyle(false);
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
				btnStyle(true);
			}
			else
			{
				btnStyle(false);
			}
		}
		private function btnStyle(show:Boolean = true):void
		{
			if(_bgMouse && _bgMouse.parent) _bgMouse.parent.removeChild(_bgMouse);
			_bgMouse = null;
			if(show)
			{
				_bgMouse = MBackgroundLabel.getDisplayObject(new Rectangle(0,0,185,26),new BarAsset3()) as Sprite;
				addChildAt(_bgMouse,0);
				_bgMouse.mouseEnabled = false;
			}
		}
		
		public function get titleIfo():Object
		{
			return _titleIfo;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			
		}
		
		public function dispose():void
		{
			_nameLabel = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(parent) parent.removeChild(this);
			removeEvents();
		}
	}
}