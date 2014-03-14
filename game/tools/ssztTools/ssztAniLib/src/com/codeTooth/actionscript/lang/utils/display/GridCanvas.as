package com.codeTooth.actionscript.lang.utils.display
{
	import flash.display.Sprite;
	
	public class GridCanvas extends Sprite
	{
		
		public function GridCanvas() 
		{
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		public function draw(width:int, height:int, gridSize:int):void
		{
			graphics.clear();
			graphics.lineStyle(1, 0x737373);
			
			var tx:int = 0;
			while (tx <= width)
			{
				graphics.moveTo(tx, 0);
				graphics.lineTo(tx, height);
				
				tx += gridSize;
			}
			
			var ty:int = 0;
			while (ty <= height)
			{
				graphics.moveTo(0, ty);
				graphics.lineTo(width, ty);
				
				ty += gridSize;
			}
		}
	}
}