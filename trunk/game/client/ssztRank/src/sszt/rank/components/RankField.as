package sszt.rank.components
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.core.manager.LanguageManager;
	
	public class RankField extends Sprite
	{
		private var _type:int;
		private var _selected:Boolean = false;
		private var _label:TextField;
		
		public function RankField(type:int, label:String)
		{
			buttonMode = true;
			_type = type;
			_label = new TextField();
			_label.selectable = false;
			_label.textColor = 0xffffff;
//			_label.htmlText = "<u>"+label+ "</u>";
			_label.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xfffccc,false,null,true,null,null,null,null,null,null,8);
			_label.text = label;
			_label.mouseEnabled = false;
			addChild(_label);
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set select(selected:Boolean):void
		{
			_selected = selected;
			if(_selected)
			{
				_label.textColor = 0x00ff0c;
			}
			else
			{
				_label.textColor = 0xffffff;
			}
		}
		
		public function get select():Boolean
		{
			return _selected;
		}
		
		public function move(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function setSize(w:int, h:int):void
		{
			_label.width = w;
			_label.height = h;
		}
		
		public function dispose():void
		{
			if(_label && _label.parent)
			{
				_label.parent.removeChild(_label);
			}
			_label = null;
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}