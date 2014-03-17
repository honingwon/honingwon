package sszt.personal.components
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	import sszt.core.caches.PlayerIconCaches;
	
	public class PersonalHeadCell extends Sprite
	{
		private var _pic:Bitmap;
		private var _selected:Boolean;
		public function PersonalHeadCell()
		{
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,43,43);
			graphics.endFill();
			super();
		}
		
		public function updateHead(argSex:Boolean,argIndex:int):void
		{
			if(argSex)
			{
				if(argIndex == 0)
				{
					_pic = new Bitmap(PlayerIconCaches.getIcon(PlayerIconCaches.BIG,1));
				}
				else if(argIndex == 1)
				{
					_pic = new Bitmap(PlayerIconCaches.getIcon(PlayerIconCaches.BIG,3));
				}
				else
				{
					_pic = new Bitmap(PlayerIconCaches.getIcon(PlayerIconCaches.BIG,5));
				}
			}
			else
			{
				if(argIndex == 0)
				{
					_pic = new Bitmap(PlayerIconCaches.getIcon(PlayerIconCaches.BIG,2));
				}
				else if(argIndex == 1)
				{
					_pic = new Bitmap(PlayerIconCaches.getIcon(PlayerIconCaches.BIG,4));
				}
				else
				{
					_pic = new Bitmap(PlayerIconCaches.getIcon(PlayerIconCaches.BIG,6));
				}
			}
			addChild(_pic);
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(_selected)
			{
				_pic.filters = [new GlowFilter(0x1bd666,1,4,4,4,1)];
			}
			else
			{
				_pic.filters = null;
			}
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			_pic = null;
		}
	}
}