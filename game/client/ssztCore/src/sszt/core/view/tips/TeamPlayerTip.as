package sszt.core.view.tips
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.ui.container.MSprite;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.LanguageManager;
	import ssztui.ui.BorderAsset4;
	
	public class TeamPlayerTip extends MSprite
	{
		private var _textfield:TextField;
		private var _bg:BorderAsset4;
		
		private static var instance:TeamPlayerTip;
		public static function getInstance():TeamPlayerTip
		{
			if(instance == null)
			{
				instance = new TeamPlayerTip();
			}
			return instance;
		}
		
		public function TeamPlayerTip()
		{
			super();
			init();
		}
		
		private function init():void
		{
			mouseChildren = mouseEnabled = false;
			_bg = new BorderAsset4();
			addChild(_bg);
			
			_textfield = new TextField();
			_textfield.wordWrap = _textfield.multiline = true;
			_textfield.mouseEnabled = _textfield.mouseWheelEnabled = _textfield.selectable = false;
			_textfield.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,null,null,null,null,3)
			_textfield.width = 150;
			_textfield.x = 6;
			_textfield.y = 6;
			addChild(_textfield);
		}
		
		public function show(mes:String,point:Point):void
		{
			_textfield.htmlText = mes;
			_textfield.height = _textfield.textHeight + 4;
			_bg.width = _textfield.width + 6 * 2;
			_bg.height = _textfield.height + 6 * 2;
			
			this.x = point.x;
			this.y = point.y;
			GlobalAPI.layerManager.getTipLayer().addChild(this);
		}
		
		public function hide():void
		{
			if(parent)this.parent.removeChild(this);
		}
	}
}