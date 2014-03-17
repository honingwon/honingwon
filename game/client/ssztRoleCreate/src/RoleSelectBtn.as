package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class RoleSelectBtn extends Sprite
	{		
		private var _selected:Boolean;
		private var _career:int;
		private var _sex:int;
		private var _source:Object;
		private var _asset:MovieClip;
		
		public function RoleSelectBtn(career:int,sex:int,source:Object)
		{
			_career = career;
			_sex = sex;
			_source = source;
			super();
			init();
		}
		
		private function init():void
		{
			buttonMode = true;
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,70,80);
			graphics.endFill();

			if(_source is Class) _asset = new _source() as MovieClip;
			else if(_source is MovieClip) _asset = _source as MovieClip;
			_asset.gotoAndStop(1);
			addChild(_asset);
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
				//addChild(_selectedEffect);
				_asset.gotoAndStop(3);
			}
			else
			{
				_asset.gotoAndStop(1);
//				if(_selectedEffect.parent)
//					_selectedEffect.parent.removeChild(_selectedEffect);
			}
		}
		public function set over(value:Boolean):void
		{
			if(_selected == value) return;
			if(value) _asset.gotoAndStop(2);
			else _asset.gotoAndStop(1);
		}
		
		public function get career():int
		{
			return _career;
		}
		public function get sex():Boolean
		{
			return _sex == 0;
		}
		
		public function dispose():void
		{
			if(parent)parent.removeChild(this);
		}
	}
}